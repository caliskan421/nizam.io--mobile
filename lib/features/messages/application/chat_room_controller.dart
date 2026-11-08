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
/// `around` ile, sabit şeridi `listChatPins` ile yeniden okunur. Otomatik yeniden deneme yoktur.
@riverpod
class ChatRoomController extends _$ChatRoomController {
  /// Geçmiş sayfa boyu.
  static const pageSize = 50;

  /// Tek uzlaştırmada okunan en çok sayfa (pencere ve yeni mesajlar ayrı ayrı).
  static const maxPages = 20;

  Timer? _flush;
  Timer? _typingOff;
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
    });
    _readSeq = 0;
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
    Timer.run(() => ref.mounted ? unawaited(_markRead()) : null);
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

  /// Yeniden bağlanma protokolü adım 3 (§10.5): sohbet bilgisi, yeni mesajlar (`after`) ve
  /// görünür pencerenin `before` ile baştan okunması (düzenleme ve silme uzlaşır).
  Future<void> _reconcile() async {
    final room = state.value;
    if (room == null || room.gone) return;
    final low = room.lowSeq;
    final high = room.highSeq;
    await _refreshInfo();
    await _fetchNewer();
    await reloadPins();
    if (low == null || high == null) return;
    var cursor = high + 1;
    for (var i = 0; i < maxPages; i++) {
      final page = await _repo.listMessages(
        id,
        before: cursor,
        limit: pageSize,
      );
      final c = cursor;
      _update(
        (r) => r.copyWith(
          messages: applyWindowPage(
            r.messages,
            page.messages,
            cursor: c,
            limit: pageSize,
          ),
          peerReadSeq: () => page.peerReadSeq,
        ),
      );
      if (windowDone(page.messages, limit: pageSize, windowLow: low)) break;
      cursor = page.messages.first.seq!;
    }
    await _markRead();
  }

  Future<void> _refreshInfo() async {
    try {
      final chat = await _repo.getChat(id);
      _update(
        (r) => r.copyWith(
          chat: chat.copyWith(unread: r.chat.unread, mention: r.chat.mention),
        ),
      );
    } on ApiError catch (e) {
      // Sohbetten düştüm ya da sohbet silindi: sohbet kapanır (sonraki olaylar gelmez).
      if (e.status == 404 || e.status == 403) {
        _update((r) => r.copyWith(gone: true));
      }
    }
  }

  /// `after=<yerel üst seq>`, sayfa dolu döndükçe son dönen `seq` ile tekrar.
  Future<void> _fetchNewer() async {
    var cursor = state.value?.highSeq;
    if (cursor == null) return _reloadLatest();
    for (var i = 0; i < maxPages; i++) {
      final ChatHistoryPage page;
      try {
        page = await _repo.listMessages(id, after: cursor, limit: pageSize);
      } on ApiError catch (e) {
        if (e.code == _invalidCursor) return _reloadLatest();
        rethrow;
      }
      _merge(page);
      if (page.messages.length < pageSize) return;
      cursor = page.messages.last.seq;
    }
  }

  /// Geçersiz imleç (422 `invalid_cursor`) ya da boş pencere: son sayfadan başlanır.
  Future<void> _reloadLatest() async {
    final page = await _repo.listMessages(id, limit: pageSize);
    _update(
      (r) => r.copyWith(
        messages: mergeMessages([
          for (final m in r.messages)
            if (!m.onServer) m,
        ], page.messages),
        peerReadSeq: () => page.peerReadSeq,
        hasOlder: page.messages.length >= pageSize,
      ),
    );
  }

  Future<void> _refreshAround(String messageId) async {
    final seq = state.value?.message(messageId)?.seq;
    if (seq == null) return;
    _merge(await _repo.listMessages(id, around: seq, limit: 5));
  }

  void _merge(ChatHistoryPage page) => _update(
    (r) => r.copyWith(
      messages: mergeMessages(r.messages, page.messages),
      peerReadSeq: () => page.peerReadSeq,
    ),
  );

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

  /// Daha eski mesajları (`before=<en küçük seq>`) pencerenin başına ekler.
  Future<void> loadOlder() => _enqueue(() async {
    final room = state.value;
    final low = room?.lowSeq;
    if (room == null || low == null || !room.hasOlder) return;
    final ChatHistoryPage page;
    try {
      page = await _repo.listMessages(id, before: low, limit: pageSize);
    } on ApiError catch (e) {
      if (e.code == _invalidCursor) return _reloadLatest();
      rethrow;
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
        case 'messaging.file_too_large' || 'messaging.file_rejected'
            when upload != null:
          // Dosya kabul edilmez: tekrar anlamsız, balon kalkar ve hata ekrana iletilir.
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

  /// Kendi mesajımı düzenler (`expected_revision` = okunan sürüm). Bayat sürümde (409
  /// `edit_conflict`) mesaj sunucudan yeniden okunur ve hata ekrana iletilir.
  Future<void> edit(String messageId, String text) async {
    final m = state.value?.message(messageId);
    if (m == null || !m.onServer) {
      throw ApiError('messaging.message_not_found');
    }
    try {
      final updated = await _repo.edit(
        id,
        messageId,
        text: text,
        expectedRevision: m.revision,
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

  /// "Yazıyor" sinyali: en az 3 sn aralıkla (ucuz sinyal kovası); hata yutulur.
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
