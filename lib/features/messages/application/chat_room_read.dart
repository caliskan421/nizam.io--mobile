part of 'chat_room_controller.dart';

/// Okundu imleci: sunucudaki son mesaja ilerler (yalnız ön planda; geri gitmez).
extension _RoomRead on ChatRoomController {
  Future<void> _markRead() async {
    final room = _current;
    final last = room?.lastOnServer;
    if (room == null || room.gone || last == null) return;
    if (last.seq! <= _readSeq || !_ref.read(chatForegroundProvider)) return;
    // Ucuz sinyal kovası doluysa imleç ilerlemez; yer açılınca TEK gönderim planlanır. Hedef
    // ateşlemede yüklü en yeni sunucu mesajıdır (bekleyen hedefler en büyük seq'te birleşir);
    // sohbet kapanınca zamanlayıcı iptal olur, ateşlemede arka plandaysa gitmez (ön plana
    // dönüşte akış açılışının uzlaştırması dener).
    final budget = _ref.read(chatSignalBudgetProvider);
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
      if (_alive) {
        _ref.read(chatsControllerProvider.notifier).markedRead(id);
      }
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.messages);
      if (_alive) _readSeq = previous;
    }
  }
}
