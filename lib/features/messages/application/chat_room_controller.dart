import 'dart:async';
import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
import '../domain/chat_stream_policy.dart';
import 'chat_members_controller.dart';
import 'chats_controller.dart';
import 'messages_providers.dart';

part 'chat_room_controller.g.dart';
part 'chat_room_reconcile.dart';

/// Gönderimin ekrana dönen sonucu.
enum ChatSendOutcome {
  sent,

  /// Sonuç bilinmiyor ya da reddedildi; balon "gönderilemedi", dokununca aynı kimlikle tekrar.
  failed,

  /// Aynı istemci kimliği farklı gönderimle kullanılmış (409 `idempotency_key_reused`):
  /// tekrar yok, yeni içerik yeni mesajdır.
  rejected,

  /// Bu kimlikle gönderilmiş mesaj silinmiş (409 `message_deleted`): balon kalkar, metin
  /// taslağa döner; yeni kimlikle kendiliğinden gönderilmez.
  deleted,

  /// Birebirde karşı taraf programda değil (403 `not_authorized`): yazma alanı kapanır.
  blocked,
}

/// Açık sohbet: bilgi + mesaj penceresi, gönderim/düzenleme/silme, okundu imleci ve akıştan
/// gelen olayların uzlaştırılması (istemci akışları §10.2–§10.5), ek gönderimi ve sabit şeridi
/// (§10.10). Olaylar en az 1 sn birleştirilip tek okumayla uygulanır; silme olayı okumasız
/// uygulanır. Tepki, sabit, oy ve anket bitirme `message.updated` yayar: yerelde olan mesaj
/// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Açılış okumaları sürerken gelen
/// sinyaller kaybolmaz: açılış bitince uzlaştırma bir kez koşar. Geçmiş uzlaştırması
/// `chat_room_reconcile.dart`'tadır. Otomatik yeniden deneme yoktur.
@riverpod
class ChatRoomController extends _$ChatRoomController {
  /// Geçmiş sayfa boyu.
  static const pageSize = 50;

  /// Tek uzlaştırmada okunan en çok sayfa (pencere ve yeni mesajlar ayrı ayrı).
  static const maxPages = 20;

  Timer? _flush;
  Timer? _typingOff;

  /// Kova reddinden sonra okundu devamı (tek zamanlayıcı; bkz. [_markRead]).
  Timer? _readLater;

  /// Açılış okumaları sürüyor; bu arada gelen sinyal [_missed]'i kirletir.
  var _booting = true;
  var _missed = false;
  var _dirtyAfter = false;
  var _dirtyInfo = false;
  var _dirtyPins = false;
  final _dirtyIds = <String>{};

  /// Gönderilmekte olan eklerin dosyası (tekrar AYNI istemci kimliği ve aynı dosyayla).
  final _uploads = HashMap<String, ChatUpload>();
  final _outgoing = HashMap<String, OutgoingMessage>();
  Future<void> _queue = Future<void>.value();
  var _readSeq = 0;
  DateTime? _lastTyping;

  @override
  Future<ChatRoom> build(String id) async {
    final me = ref.watch(chatMeProvider);
    final sub = ref.watch(chatSignalBusProvider).stream.listen(_onSignal);
    ref.onDispose(() {
      unawaited(sub.cancel());
      _flush?.cancel();
      _typingOff?.cancel();
      _readLater?.cancel();
      _readLater = null;
    });
    _readSeq = 0;
    _booting = true;
    _missed = false;
    // Okunmamış sayısı (ayırıcı) liste satırından gelir; liste okunamazsa ayırıcı yok.
    final inbox = ref
        .read(chatsControllerProvider.future)
        .then<ChatInbox?>((v) => v, onError: (Object _) => null);
    // Sabit şeridi okunamazsa şerit boş açılır (sonraki olay ya da yeniden bağlanma tazeler).
    final pins = _repo
        .pins(id)
        .then<List<ChatMessage>>(
          (v) => v,
          onError: (Object _) => const <ChatMessage>[],
        );
    final r = await Future.wait<Object?>([
      _repo.getChat(id),
      _repo.listMessages(id, limit: pageSize),
      inbox,
      pins,
    ], eagerError: true);
    final detail = r[0]! as Chat;
    final page = r[1]! as ChatHistoryPage;
    final row = (r[2] as ChatInbox?)?.chat(id);
    Timer.run(_booted);
    return ChatRoom(
      chat: row == null
          ? detail
          : detail.copyWith(unread: row.unread, mention: row.mention),
      messages: page.messages,
      peerReadSeq: page.peerReadSeq,
      hasOlder: page.messages.length >= pageSize,
      unreadMarker: unreadMarkerOf(page.messages, row?.unread ?? 0, me),
      pins: r[3]! as List<ChatMessage>,
    );
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);
  ChatRoom? get _current => state.value;

  /// Açılış bitti: okumalar sürerken sinyal geldiyse uzlaştırma bir kez koşar (oluşturma ve
  /// silme kaçmaz; okundu imleci uzlaştırmanın sonunda ilerler), gelmediyse okundu imleci ilerler.
  void _booted() {
    if (!ref.mounted) return;
    _booting = false;
    if (!_missed) return unawaited(_markRead());
    _missed = false;
    unawaited(_enqueue(_reconcile));
  }

  void _update(ChatRoom Function(ChatRoom) f) {
    final v = state.value;
    if (v != null && ref.mounted) state = AsyncData(f(v));
  }

  /// Ağ okumaları sırayla (uzlaştırma, eski sayfa); hata yutulur, görünür veri kalır.
  Future<void> _enqueue(Future<void> Function() op) {
    final next = _queue.then((_) async {
      if (!ref.mounted || state.value == null) return;
      try {
        await op();
      } on Object {
        // Sonraki olay ya da yeniden bağlanma tazeler.
      }
    });
    return _queue = next;
  }

  // --- Akış ---------------------------------------------------------------------------------

  void _onSignal(ChatSignal s) {
    if (_booting) {
      _missed |= switch (s) {
        ChatStreamOpened() => true,
        ChatEvent(:final chatId, :final kind) =>
          chatId == id && kind != ChatEventKind.typing,
      };
      return;
    }
    if (state.value == null) return;
    switch (s) {
      case ChatStreamOpened():
        unawaited(_enqueue(_reconcile));
      case ChatEvent(:final chatId) when chatId != id:
        return;
      case ChatEvent(kind: ChatEventKind.messageDeleted, :final messageId):
        if (messageId != null) _remove(messageId);
      case ChatEvent(kind: ChatEventKind.typing, :final actorId):
        _typingFrom(actorId);
      case ChatEvent(
        kind: ChatEventKind.messageCreated || ChatEventKind.readUpdated,
        :final actorId,
      ):
        if (state.value?.typing != null &&
            actorId != ref.read(chatMeProvider)) {
          _clearTyping();
        }
        _dirtyAfter = true;
        _schedule();
      case ChatEvent(kind: ChatEventKind.messageUpdated, :final messageId):
        // Düzenleme `seq`'i değiştirmez: yerelde olan mesaj `around` ile yeniden okunur.
        // Sabitleme de bu olayla gelir (pencere dışındaki mesaj dahil): şerit yeniden okunur.
        if (messageId != null && state.value?.message(messageId) != null) {
          _dirtyIds.add(messageId);
        }
        _dirtyPins = true;
        _schedule();
      case ChatEvent(
        kind: ChatEventKind.memberChanged || ChatEventKind.chatChanged,
      ):
        _dirtyInfo = true;
        _schedule();
    }
  }

  void _schedule() => _flush ??= Timer(ChatStreamPolicy.coalesce, () {
    _flush = null;
    unawaited(_enqueue(_applyDirty));
  });

  Future<void> _applyDirty() async {
    final info = _dirtyInfo;
    final after = _dirtyAfter;
    final pins = _dirtyPins;
    final ids = {..._dirtyIds};
    _dirtyInfo = _dirtyAfter = _dirtyPins = false;
    _dirtyIds.clear();
    if (info) await _refreshInfo();
    if (after) await _fetchNewer();
    for (final m in ids) {
      await _refreshAround(m);
    }
    if (pins) await reloadPins();
    await _markRead();
  }

  /// Sabit şeridini sunucudan yeniden okur (hata yutulur: eski şerit kalır).
  Future<void> reloadPins() async {
    try {
      final pins = await _repo.pins(id);
      _update((r) => r.copyWith(pins: pins));
    } on Object {
      // Sonraki olay ya da yeniden bağlanma tazeler.
    }
  }

  void _remove(String messageId) => _update(
    (r) => r.copyWith(
      messages: [
        for (final m in r.messages)
          if (m.id != messageId) m,
      ],
    ),
  );

  void _typingFrom(String actor) {
    final room = state.value;
    if (room == null || actor == ref.read(chatMeProvider)) return;
    // Grupta ad üye listesinden (§10.10), yoksa yüklü mesajlardan; çözülemeyen kişi gösterilmez.
    final name = room.chat.group
        ? ref.read(chatMembersControllerProvider(id)).value?.name(actor) ??
              room.messages
                  .where((m) => m.senderId == actor && m.senderName != null)
                  .lastOrNull
                  ?.senderName
        : room.chat.name;
    if (name == null || name.isEmpty) return;
    _update((r) => r.copyWith(typing: () => name));
    _typingOff?.cancel();
    _typingOff = Timer(ChatStreamPolicy.typingShownFor, _clearTyping);
  }

  void _clearTyping() {
    _typingOff?.cancel();
    _typingOff = null;
    _update((r) => r.copyWith(typing: () => null));
  }

  /// Okundu imlecini sunucudaki son mesaja ilerletir (yalnız ön planda; geri gitmez).
  Future<void> _markRead() async {
    final room = state.value;
    final last = room?.lastOnServer;
    if (room == null || room.gone || last == null) return;
    if (last.seq! <= _readSeq || !ref.read(chatForegroundProvider)) return;
    // Ucuz sinyal kovası doluysa imleç ilerlemez; yer açılınca TEK gönderim planlanır. Hedef
    // ateşlemede yüklü en yeni sunucu mesajıdır (bekleyen hedefler en büyük seq'te birleşir);
    // sohbet kapanınca zamanlayıcı iptal olur, ateşlemede arka plandaysa gitmez (ön plana
    // dönüşte akış açılışının uzlaştırması dener).
    final budget = ref.read(chatSignalBudgetProvider);
    final now = DateTime.now();
    if (!budget.take(now)) {
      _readLater ??= Timer(budget.retryIn(now), () {
        _readLater = null;
        unawaited(_enqueue(_markRead));
      });
      return;
    }
    final previous = _readSeq;
    _readSeq = last.seq!;
    try {
      await _repo.markRead(id, last.id);
      if (ref.mounted) {
        ref.read(chatsControllerProvider.notifier).markedRead(id);
      }
    } on Object {
      _readSeq = previous;
    }
  }

  // --- Komutlar -----------------------------------------------------------------------------

  /// Yeniden seçim (`S_chat.load`): okunmamış ayırıcısı kalkar; mesajlar kalır.
  void reopen() => _update((r) => r.copyWith(unreadMarker: () => null));

  /// Mesajı sunucudan yeniden okur (`around`; sıradaki okumalarla birlikte, hata yutulur).
  Future<void> refreshMessage(String messageId) =>
      _enqueue(() => _refreshAround(messageId));

  /// Sunucudan gelen güncel mesajı pencereye yerleştirir (mesajdan görev, eylem yanıtı).
  void apply(ChatMessage m) =>
      _update((r) => r.copyWith(messages: mergeMessages(r.messages, [m])));

  /// Mesajı yerinde değiştirir (iyimser güncelleme ve geri alma).
  void patch(String messageId, ChatMessage Function(ChatMessage) f) =>
      _update((r) => r.patch(messageId, f));

  /// Sohbet bilgisini değiştirir (ad değişimi); okunmamış sayısı korunur.
  void setChat(Chat chat) => _update(
    (r) => r.copyWith(
      chat: chat.copyWith(unread: r.chat.unread, mention: r.chat.mention),
    ),
  );

  /// Mesajı (sabit, arama sonucu) pencereye getirir: pencerede yoksa `before` sayfalarıyla
  /// [seq]'e kadar eskiye inilir (en çok [maxPages]); bulunamazsa false.
  Future<bool> reveal(String messageId, int seq) async {
    await _enqueue(() async {
      for (var i = 0; i < maxPages; i++) {
        final room = state.value;
        final low = room?.lowSeq;
        if (room == null || room.message(messageId) != null) return;
        if (low == null || low <= seq || !room.hasOlder) return;
        final page = await _repo.listMessages(id, before: low, limit: pageSize);
        _update(
          (r) => r.copyWith(
            messages: mergeMessages(r.messages, page.messages),
            hasOlder: page.messages.length >= pageSize,
          ),
        );
      }
    });
    return state.value?.message(messageId) != null;
  }

  /// Daha eski mesajları (`before=<en küçük seq>`) pencerenin başına ekler. Okundu
  /// tetiklemez: imleç yalnız en yeni sunucu mesajına ilerler, eski sayfa onu değiştirmez.
  Future<void> loadOlder() => _enqueue(() async {
    final room = state.value;
    final low = room?.lowSeq;
    if (room == null || low == null || !room.hasOlder) return;
    final ChatHistoryPage page;
    try {
      page = await _repo.listMessages(id, before: low, limit: pageSize);
    } on ApiError catch (e) {
      if (e.code != _invalidCursor) rethrow;
      await _reloadLatest();
      return;
    }
    _update(
      (r) => r.copyWith(
        messages: mergeMessages(r.messages, page.messages),
        hasOlder: page.messages.length >= pageSize,
      ),
    );
  });

  /// Yeni mesaj: istemci kimliği bir kez üretilir, balon "gönderiliyor" olarak hemen eklenir.
  /// [mentions] yapılandırılmış bahsetmeler (§10.8); [poll] doluysa mesaj ankettir (soru [text]).
  Future<ChatSendOutcome> send(
    String text, {
    String? replyTo,
    List<ChatMention> mentions = const [],
    PollDraft? poll,
  }) => _post(text: text, replyTo: replyTo, mentions: mentions, poll: poll);

  /// Ek mesajı (tek dosya): gönderim kuralları [send] ile aynıdır (aynı kimlikle tekrar).
  Future<ChatSendOutcome> sendAttachment(ChatUpload file, {String? replyTo}) =>
      _post(text: '', replyTo: replyTo, upload: file);

  Future<ChatSendOutcome> _post({
    required String text,
    String? replyTo,
    List<ChatMention> mentions = const [],
    PollDraft? poll,
    ChatUpload? upload,
  }) {
    final me = ref.read(chatMeProvider);
    final room = state.value;
    if (me == null || room == null) {
      throw ApiError(ClientErrorCode.notSignedIn);
    }
    final clientId = newRequestKey();
    if (upload != null) _uploads[clientId] = upload;
    final out = OutgoingMessage(
      clientId: clientId,
      text: text,
      replyTo: replyTo,
      mentions: mentions,
      poll: poll,
    );
    _outgoing[clientId] = out;
    final local = pendingMessage(
      out,
      me: me,
      quoted: replyTo == null ? null : room.message(replyTo),
      upload: upload,
    );
    _update(
      (r) => r.copyWith(
        messages: [...r.messages, local],
        unreadMarker: () => null,
      ),
    );
    return _deliver(local);
  }

  /// Gönderilemeyen mesajı AYNI istemci kimliği ve AYNI gövdeyle yeniden gönderir.
  Future<ChatSendOutcome> retry(String clientId) {
    final m = _pending(clientId);
    if (m == null || m.state != ChatSendState.failed) {
      return Future.value(ChatSendOutcome.failed);
    }
    _setPending(clientId, ChatSendState.sending, null);
    return _deliver(m);
  }

  /// Gönderilemeyen mesajı listeden atar.
  void discard(String clientId) {
    _uploads.remove(clientId);
    _outgoing.remove(clientId);
    _update(
      (r) => r.copyWith(
        messages: [
          for (final m in r.messages)
            if (m.onServer || m.clientId != clientId) m,
        ],
      ),
    );
  }

  ChatMessage? _pending(String clientId) => state.value?.messages
      .where((m) => !m.onServer && m.clientId == clientId)
      .firstOrNull;

  void _setPending(String clientId, ChatSendState s, String? failure) =>
      _update(
        (r) => r.copyWith(
          messages: [
            for (final m in r.messages)
              !m.onServer && m.clientId == clientId
                  ? m.copyWith(state: s, failure: () => failure)
                  : m,
          ],
        ),
      );

  /// Gönderim (tekrarda AYNI gövde: metin, yanıt, bahsetme, anket ya da aynı dosya).
  Future<ChatSendOutcome> _deliver(ChatMessage local) async {
    final upload = _uploads[local.clientId];
    try {
      final sent = upload != null
          ? await _repo.sendAttachment(
              id,
              local.clientId,
              upload,
              replyTo: local.replyTo?.messageId,
            )
          : await _repo.send(id, _outgoing[local.clientId]!);
      _uploads.remove(local.clientId);
      _outgoing.remove(local.clientId);
      _update((r) => r.copyWith(messages: mergeMessages(r.messages, [sent])));
      return ChatSendOutcome.sent;
    } on ApiError catch (e) {
      switch (e.code) {
        case 'messaging.message_deleted':
          discard(local.clientId);
          return ChatSendOutcome.deleted;
        case 'messaging.file_too_large' ||
                'messaging.file_rejected' ||
                ClientErrorCode.fileUnreadable
            when upload != null:
          // Dosya kabul edilmez ya da okunamaz (silinmiş): tekrar anlamsız, balon kalkar ve
          // hata ekrana iletilir.
          discard(local.clientId);
          rethrow;
        case 'messaging.idempotency_key_reused':
          _setPending(local.clientId, ChatSendState.failed, e.code);
          return ChatSendOutcome.rejected;
        case 'messaging.not_authorized' when state.value?.chat.group == false:
          _setPending(local.clientId, ChatSendState.failed, e.code);
          _update((r) => r.copyWith(blocked: true));
          return ChatSendOutcome.blocked;
        default:
          _setPending(local.clientId, ChatSendState.failed, e.code);
          return ChatSendOutcome.failed;
      }
    }
  }

  /// Kendi mesajımı düzenler. [expectedRevision] taslak AÇILIRKEN okunan `edit_revision`'dır
  /// (gönderim anındaki canlı sürüm değil): arada akışla gelen başka düzenleme 409
  /// `edit_conflict` üretir, sessizce ezilmez. Çakışmada mesaj yeniden okunur ve hata iletilir.
  Future<void> edit(
    String messageId,
    String text, {
    required int expectedRevision,
  }) async {
    final m = state.value?.message(messageId);
    if (m == null || !m.onServer) {
      throw ApiError('messaging.message_not_found');
    }
    try {
      final updated = await _repo.edit(
        id,
        messageId,
        text: text,
        expectedRevision: expectedRevision,
      );
      _update(
        (r) => r.copyWith(messages: mergeMessages(r.messages, [updated])),
      );
    } on ApiError catch (e) {
      if (e.code == 'messaging.edit_conflict') await refreshMessage(messageId);
      rethrow;
    }
  }

  /// Mesajı siler (gönderen; grupta yönetici). Zaten silinmişse yerelden kalkar.
  Future<void> delete(String messageId) async {
    try {
      await _repo.delete(id, messageId);
    } on ApiError catch (e) {
      if (e.code != 'messaging.message_not_found') rethrow;
    }
    _remove(messageId);
  }

  /// "Yazıyor" sinyali: en az 3 sn aralıkla ve ucuz sinyal kovası izin verdikçe; hata yutulur.
  void typing() {
    final room = state.value;
    if (room == null || room.blocked || room.gone) return;
    final now = DateTime.now();
    final last = _lastTyping;
    if (last != null &&
        now.difference(last) < ChatStreamPolicy.typingInterval) {
      return;
    }
    _lastTyping = now;
    if (!ref.read(chatSignalBudgetProvider).take(now)) return;
    unawaited(_typingSignal());
  }

  Future<void> _typingSignal() async {
    try {
      await _repo.typing(id);
    } on Object {
      // Yazıyor en iyi çabadır.
    }
  }

  static const _invalidCursor = 'messaging.invalid_cursor';
}
