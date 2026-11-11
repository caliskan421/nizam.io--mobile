import 'dart:async';
import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../tasks/tasks.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
import 'chat_room_controller.dart';
import 'messages_providers.dart';

part 'chat_actions_controller.g.dart';

const _actionsZone = #chatActionsEpoch;

/// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
/// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
/// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
/// istek gitmez (yazma kovası 60/dk). Mesaj başına uçuşta en çok bir yazma vardır: doğrulanmış
/// (sunucu) ve istenen durum ayrı tutulur; uçuş sırasındaki dokunuşlar yalnız istenen durumu
/// değiştirir, uçuş bitince istenen ≠ doğrulanmışsa tek istek daha gider. Geri alma kararı
/// dokunuş nesline bağlıdır: hata, istek gittikten sonra yeni dokunuş yoksa doğrulanmış duruma
/// geri döndürür; varsa son istenen durum korunur ve (hatalı sonucun sunucu durumu belirsiz
/// olduğundan) değeri ne olursa olsun tek istekle gönderilir. Hatalı isteği bekleyen
/// dokunuşların Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
/// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.
@riverpod
class ChatActionsController extends _$ChatActionsController {
  /// Birleştirme penceresi (çift dokunuş tek istek).
  static const settle = Duration(milliseconds: 400);

  final _reactions = HashMap<String, _Flight<ChatReaction?>>();
  final _votes = HashMap<String, _Flight<Set<int>>>();
  final _pinning = <String>{};
  final _owner = CacheOwnership();
  var _epoch = 0;

  @override
  int build(String chatId) {
    _owner.markLoaded(ref, _owner.watch(ref));
    _epoch++;
    _reactions.clear();
    _votes.clear();
    _pinning.clear();
    ref.onDispose(() {
      for (final p in [..._reactions.values, ..._votes.values]) {
        p.cancel();
      }
    });
    return 0;
  }

  bool get _active =>
      ref.mounted &&
      _owner.owns(ref) &&
      (Zone.current[_actionsZone] == null ||
          Zone.current[_actionsZone] == _epoch);
  void _ensureCurrent() {
    if (!_active) throw ApiError(ClientErrorCode.sessionEnded);
  }

  Future<T> _inScope<T>(Future<T> Function() op) {
    _ensureCurrent();
    return runZoned(op, zoneValues: {_actionsZone: _epoch});
  }

  ChatRepository get _repo {
    _ensureCurrent();
    return ref.read(chatRepositoryProvider);
  }

  ChatRoomController get _room {
    _ensureCurrent();
    return ref.read(chatRoomControllerProvider(chatId).notifier);
  }

  ChatRoom? get _state {
    _ensureCurrent();
    return ref.read(chatRoomControllerProvider(chatId)).value;
  }

  /// Tepkiye dokunuş: aynı tür kaldırır, başka tür yerine geçer (kişi başına tek tepki).
  Future<void> react(String messageId, ChatReaction kind) =>
      _inScope(() => _react(messageId, kind));

  Future<void> _react(String messageId, ChatReaction kind) {
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
  Future<void> vote(String messageId, int option) =>
      _inScope(() => _vote(messageId, option));

  Future<void> _vote(String messageId, int option) {
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
  Future<void> closePoll(String messageId) =>
      _inScope(() => _closePoll(messageId));

  Future<void> _closePoll(String messageId) async {
    try {
      await _write(() => _repo.closePoll(chatId, messageId));
      if (_active) _closedLocally(messageId);
    } on ApiError catch (e) {
      if (_active && e.code == _pollClosed) _closedLocally(messageId);
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
  Future<void> togglePin(String messageId) =>
      _inScope(() => _togglePin(messageId));

  Future<void> _togglePin(String messageId) async {
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
      if (_active) {
        _room.patch(messageId, (x) => x.copyWith(pinnedAt: () => was));
      }
      rethrow;
    } finally {
      if (_active) {
        _pinning.remove(messageId);
        await _room.reloadPins();
      }
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
    _ensureCurrent();
    state++;
    try {
      await op();
    } finally {
      if (_active) state--;
    }
  }

  /// [desired] durumu [settle] sonra gönderir; arada gelen dokunuş yalnız istenen durumu
  /// değiştirir. [confirmed] defter yokken (uçuş ya da bekleyen dokunuş yok) ekrandaki, yani
  /// sunucuda doğrulanmış durumdur.
  Future<void> _queue<T>(
    HashMap<String, _Flight<T>> book,
    String messageId, {
    required T confirmed,
    required T desired,
    required bool Function(T a, T b) same,
    required Future<void> Function(T value) send,
    required void Function(T value) revert,
    void Function(ApiError e)? onError,
  }) {
    final f = book.putIfAbsent(messageId, () => _Flight<T>(confirmed))
      ..desired = desired
      ..gen += 1;
    final w = Completer<void>();
    f.waiters.add(w);
    if (!f.busy) {
      f.timer?.cancel();
      f.timer = Timer(settle, () async {
        f.timer = null;
        f.busy = true;
        try {
          await _fly(
            f,
            same: same,
            send: send,
            revert: revert,
            onError: onError,
          );
        } finally {
          f.busy = false;
          if (identical(book[messageId], f) && f.waiters.isEmpty) {
            book.remove(messageId);
          }
        }
      });
    }
    return w.future;
  }

  /// Uçuş döngüsü: her turda istenen durum doğrulanmıştan farklıysa TEK istek gider; tur
  /// sırasında gelen dokunuşlar sonraki turu bekler. Önceki tur hatayla bittiyse ve arada
  /// dokunuş geldiyse ([uncertain]) istek eşitlikten bağımsız gider: bekleyenler istek
  /// gönderilmeden başarı sayılmaz.
  Future<void> _fly<T>(
    _Flight<T> f, {
    required bool Function(T a, T b) same,
    required Future<void> Function(T value) send,
    required void Function(T value) revert,
    void Function(ApiError e)? onError,
  }) async {
    var uncertain = false;
    while (_active && f.waiters.isNotEmpty) {
      final waiters = f.waiters;
      f.waiters = [];
      final sending = f.desired;
      final gen = f.gen;
      if (!uncertain && same(sending, f.confirmed)) {
        for (final w in waiters) {
          w.complete();
        }
        continue;
      }
      uncertain = false;
      try {
        await _write(() => send(sending));
        f.confirmed = sending;
        for (final w in waiters) {
          w.complete();
        }
      } on Object catch (e) {
        // Geri alma yalnız istekten sonra dokunuş yoksa; varsa son istenen durum kalır.
        if (f.gen != gen) {
          uncertain = true;
        } else if (_active) {
          f.desired = f.confirmed;
          revert(f.confirmed);
        }
        if (_active && e is ApiError) onError?.call(e);
        for (final w in waiters) {
          w.completeError(e);
        }
      }
    }
    if (!_active) f.cancel();
  }

  static const _pollClosed = 'messaging.poll_closed';
}

/// Mesaj başına tepki/oy defteri: doğrulanmış ve istenen durum, uçuş bayrağı, bekleyenler.
final class _Flight<T> {
  _Flight(this.confirmed) : desired = confirmed;

  /// Sunucuda doğrulanmış durum (geri alma hedefi).
  T confirmed;

  /// Kullanıcının son istediği durum (ekrandaki).
  T desired;

  /// Dokunuş nesli: her dokunuşta artar (geri alma kararı değer eşitliğine değil buna bağlı).
  int gen = 0;
  bool busy = false;
  Timer? timer;

  /// Sonraki istekte gidecek dokunuşların Future'ları.
  var waiters = <Completer<void>>[];

  void cancel() {
    timer?.cancel();
    for (final w in waiters) {
      if (!w.isCompleted) w.complete();
    }
    waiters = [];
  }
}
