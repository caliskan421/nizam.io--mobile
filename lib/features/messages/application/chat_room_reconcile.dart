part of 'chat_room_controller.dart';

// Açık sohbetin geçmiş uzlaştırması (istemci akışları §10.3, §10.5): yeni mesajlar (`after`),
// görünür pencerenin `before` sayfalarıyla baştan okunması, `around` ile tekil tazeleme ve
// son sayfadan yeniden kurulum. Okuma tavanı aşılırsa eksik kalan pencere başarı sayılmaz:
// pencere atılır ve en yeni sayfadan yeniden kurulur (eski geçmiş "daha eski" ile okunur).

extension _RoomHistory on ChatRoomController {
  /// Yeniden bağlanma protokolü adım 3 (§10.5): sohbet bilgisi, yeni mesajlar (`after`) ve
  /// görünür pencerenin `before` ile baştan okunması (düzenleme ve silme uzlaşır).
  Future<void> _reconcile() async {
    final room = _current;
    if (room == null || room.gone) return;
    final low = room.lowSeq;
    final high = room.highSeq;
    await _refreshInfo();
    final rebuilt = await _fetchNewer();
    await reloadPins();
    if (!rebuilt && low != null && high != null) {
      if (!await _rereadWindow(low, high)) await _reloadLatest();
    }
    await _markRead();
  }

  /// Pencere `Ü + 1`'den aşağı `before` sayfalarıyla baştan okunur; [ChatRoomController.maxPages]
  /// sayfada bitmezse false (pencere eksik uzlaşmıştır).
  Future<bool> _rereadWindow(int low, int high) async {
    const limit = ChatRoomController.pageSize;
    var cursor = high + 1;
    for (var i = 0; i < ChatRoomController.maxPages; i++) {
      final page = await _repo.listMessages(id, before: cursor, limit: limit);
      final c = cursor;
      _update(
        (r) => r.copyWith(
          messages: applyWindowPage(
            r.messages,
            page.messages,
            cursor: c,
            limit: limit,
          ),
          peerReadSeq: () => page.peerReadSeq,
        ),
      );
      if (windowDone(page.messages, limit: limit, windowLow: low)) return true;
      cursor = page.messages.first.seq!;
    }
    return false;
  }

  Future<void> _refreshInfo() async {
    try {
      final chat = await _repo.getChat(id);
      _update(
        (r) => r.copyWith(
          chat: chat.copyWith(unread: r.chat.unread, mention: r.chat.mention),
        ),
      );
    } on ApiError catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.messages);
      // Sohbetten düştüm ya da sohbet silindi: sohbet kapanır (sonraki olaylar gelmez).
      if (e.status == 404 || e.status == 403) {
        _update((r) => r.copyWith(gone: true));
      }
    }
  }

  /// `after=<yerel üst seq>`, sayfa dolu döndükçe son dönen `seq` ile tekrar. Pencere yeniden
  /// kurulduysa (boş pencere, geçersiz imleç ya da okuma tavanı) true.
  Future<bool> _fetchNewer() async {
    const limit = ChatRoomController.pageSize;
    var cursor = _current?.highSeq;
    if (cursor == null) return _reloadLatest();
    for (var i = 0; i < ChatRoomController.maxPages; i++) {
      final ChatHistoryPage page;
      try {
        page = await _repo.listMessages(id, after: cursor, limit: limit);
      } on ApiError catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.messages);
        if (e.code == ChatRoomController._invalidCursor) return _reloadLatest();
        rethrow;
      }
      _merge(page);
      if (page.messages.length < limit) return false;
      cursor = page.messages.last.seq;
    }
    // Tavanda hâlâ dolu sayfa var: arada boşluk kalmasın, pencere en yeni sayfadan kurulur.
    return _reloadLatest();
  }

  /// Pencereyi atıp son sayfadan kurar (geçersiz imleç, boş pencere, okuma tavanı); bekleyen
  /// kendi mesajlarım kalır. Her zaman true (pencere yeniden kuruldu).
  Future<bool> _reloadLatest() async {
    final page = await _repo.listMessages(
      id,
      limit: ChatRoomController.pageSize,
    );
    _update(
      (r) => r.copyWith(
        messages: mergeMessages([
          for (final m in r.messages)
            if (!m.onServer) m,
        ], page.messages),
        peerReadSeq: () => page.peerReadSeq,
        hasOlder: page.messages.length >= ChatRoomController.pageSize,
      ),
    );
    return true;
  }

  Future<void> _refreshAround(String messageId) async {
    final seq = _current?.message(messageId)?.seq;
    if (seq == null) return;
    _merge(await _repo.listMessages(id, around: seq, limit: 5));
  }

  void _merge(ChatHistoryPage page) => _update(
    (r) => r.copyWith(
      messages: mergeMessages(r.messages, page.messages),
      peerReadSeq: () => page.peerReadSeq,
    ),
  );
}
