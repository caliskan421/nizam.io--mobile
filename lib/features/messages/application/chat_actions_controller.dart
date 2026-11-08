import 'dart:async';
import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../tasks/tasks.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
import 'chat_room_controller.dart';
import 'messages_providers.dart';

part 'chat_actions_controller.g.dart';

/// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
/// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
/// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
/// istek gitmez (yazma kovası 60/dk). Hata önceki (sunucuda doğrulanmış) duruma geri alır ve
/// dokunuşun Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
/// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.
@riverpod
class ChatActionsController extends _$ChatActionsController {
  /// Birleştirme penceresi (çift dokunuş tek istek).
  static const settle = Duration(milliseconds: 400);

  final _reactions = HashMap<String, _Pending<ChatReaction?>>();
  final _votes = HashMap<String, _Pending<Set<int>>>();
  final _pinning = <String>{};

  @override
  int build(String chatId) {
    ref.onDispose(() {
      for (final p in [..._reactions.values, ..._votes.values]) {
        p.cancel();
      }
    });
    return 0;
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);
  ChatRoomController get _room =>
      ref.read(chatRoomControllerProvider(chatId).notifier);
  ChatRoom? get _state => ref.read(chatRoomControllerProvider(chatId)).value;

  /// Tepkiye dokunuş: aynı tür kaldırır, başka tür yerine geçer (kişi başına tek tepki).
  Future<void> react(String messageId, ChatReaction kind) {
    final m = _state?.message(messageId);
    if (m == null || !m.onServer) return Future.value();
    final current = m.reactions.where((r) => r.mine).firstOrNull?.kind;
    final to = current == kind ? null : kind;
    _room.patch(
      messageId,
      (x) => x.copyWith(reactions: withMyReaction(x.reactions, to)),
    );
    return _queue(
      _reactions,
      messageId,
      confirmed: current,
      desired: to,
      same: (a, b) => a == b,
      send: (v) => v == null
          ? _repo.clearReaction(chatId, messageId)
          : _repo.setReaction(chatId, messageId, v),
      revert: (v) => _room.patch(
        messageId,
        (x) => x.copyWith(reactions: withMyReaction(x.reactions, v)),
      ),
    );
  }

  /// Anket seçeneğine dokunuş ([ChatPoll.toggled]); kapanmış ankete istek gitmez. 409
  /// `poll_closed`: anket kapandı gösterilir ve mesaj yeniden okunur.
  Future<void> vote(String messageId, int option) {
    final me = ref.read(chatMeProvider);
    final m = _state?.message(messageId);
    final poll = m?.poll;
    if (me == null || m == null || poll == null || !m.onServer) {
      return Future.value();
    }
    if (poll.isClosed(DateTime.now())) return Future.value();
    final current = poll.mine(me);
    final to = poll.toggled(current, option);
    final voter = (
      accountId: me,
      name:
          poll.options
              .expand((o) => o.voters)
              .where((v) => v.accountId == me)
              .firstOrNull
              ?.name ??
          '',
    );
    void show(Set<int> picks) => _room.patch(
      messageId,
      (x) => x.poll == null
          ? x
          : x.copyWith(poll: x.poll!.withVotes(voter, picks)),
    );
    show(to);
    return _queue(
      _votes,
      messageId,
      confirmed: current,
      desired: to,
      same: (a, b) => a.length == b.length && a.containsAll(b),
      send: (v) => _repo.vote(chatId, messageId, v),
      revert: show,
      onError: (e) {
        if (e.code == _pollClosed) _closedLocally(messageId);
      },
    );
  }

  /// Anketi bitirir (yalnız açan).
  Future<void> closePoll(String messageId) async {
    try {
      await _write(() => _repo.closePoll(chatId, messageId));
      _closedLocally(messageId);
    } on ApiError catch (e) {
      if (e.code == _pollClosed) _closedLocally(messageId);
      rethrow;
    }
  }

  void _closedLocally(String messageId) {
    _room.patch(
      messageId,
      (x) => x.poll == null ? x : x.copyWith(poll: x.poll!.asClosed()),
    );
    unawaited(_room.refreshMessage(messageId));
  }

  /// Sabitler ya da kaldırır (birebirde iki taraf; grupta yönetici ya da kurucu). Uçuştayken
  /// ikinci dokunuş istek göndermez.
  Future<void> togglePin(String messageId) async {
    final m = _state?.message(messageId);
    if (m == null || !m.onServer || !_pinning.add(messageId)) return;
    final was = m.pinnedAt;
    _room.patch(
      messageId,
      (x) => x.copyWith(pinnedAt: () => was == null ? DateTime.now() : null),
    );
    try {
      await _write(
        () => was == null
            ? _repo.pin(chatId, messageId)
            : _repo.unpin(chatId, messageId),
      );
    } on Object {
      _room.patch(messageId, (x) => x.copyWith(pinnedAt: () => was));
      rethrow;
    } finally {
      _pinning.remove(messageId);
      await _room.reloadPins();
    }
  }

  /// Eki indirir ve kaydeder (akışla; belleğe toplanmaz); kaydedilen yol döner.
  Future<String> downloadAttachment(ChatAttachment a) async => ref
      .read(downloadSinkProvider)
      .save(a.fileName, await _repo.downloadAttachment(a.id));

  /// Paylaşılan dosyayı indirir ve kaydeder.
  Future<String> downloadShared(String refId, String name) async => ref
      .read(downloadSinkProvider)
      .save(name, await _repo.downloadSharedFile(refId));

  Future<void> _write(Future<void> Function() op) async {
    state++;
    try {
      await op();
    } finally {
      if (ref.mounted) state--;
    }
  }

  /// [desired] durumu [settle] sonra gönderir; arada gelen dokunuş yalnız istenen durumu
  /// değiştirir. [confirmed] ilk dokunuştaki sunucu durumudur (geri alma hedefi).
  Future<void> _queue<T>(
    HashMap<String, _Pending<T>> book,
    String messageId, {
    required T confirmed,
    required T desired,
    required bool Function(T a, T b) same,
    required Future<void> Function(T value) send,
    required void Function(T value) revert,
    void Function(ApiError e)? onError,
  }) {
    final p = book.putIfAbsent(messageId, () => _Pending<T>(confirmed))
      ..desired = desired;
    p.timer?.cancel();
    p.timer = Timer(settle, () async {
      book.remove(messageId);
      if (same(p.desired, p.confirmed)) return p.done.complete();
      try {
        await _write(() => send(p.desired));
        p.done.complete();
      } on ApiError catch (e) {
        if (ref.mounted) {
          revert(p.confirmed);
          onError?.call(e);
        }
        p.done.completeError(e);
      }
    });
    return p.done.future;
  }

  static const _pollClosed = 'messaging.poll_closed';
}

/// Birleştirilen eylemin defter kaydı.
final class _Pending<T> {
  _Pending(this.confirmed);

  final T confirmed;
  late T desired;
  Timer? timer;
  final done = Completer<void>();

  void cancel() {
    timer?.cancel();
    if (!done.isCompleted) done.complete();
  }
}
