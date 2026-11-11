part of 'chat_room_controller.dart';

// Her asenkron zincir başladığı sohbet neslini taşır. Yeniden kurulan notifier'ın
// ref'i hâlâ mounted olsa da eski yanıt yeni program/oturumun durumunu değiştiremez.
// Repository getter'ı sonraki HTTP adımını da keser; değişen kapsam başlığıyla
// eski uzlaştırmanın ikinci isteği gönderilmez.
const _scopeZone = #chatRoomEpoch;

extension _RoomOwnership on ChatRoomController {
  void _ensureScope() {
    if (!_alive) throw ApiError(ClientErrorCode.sessionEnded);
  }

  Future<T> _inScope<T>(Future<T> Function() op) {
    _ensureScope();
    return runZoned(op, zoneValues: {_scopeZone: _epoch});
  }
}
