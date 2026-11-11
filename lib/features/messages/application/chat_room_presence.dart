part of 'chat_room_controller.dart';

extension _RoomPresence on ChatRoomController {
  void _typingFrom(String actor) {
    final room = _current;
    if (room == null || actor == _me) return;
    // Grupta ad üye listesinden, yoksa yüklü mesajlardan; çözülemeyen kişi gösterilmez.
    final name = room.chat.group
        ? _memberName(actor) ??
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
    if (!_alive) return;
    _typingOff?.cancel();
    _typingOff = null;
    _update((r) => r.copyWith(typing: () => null));
  }

  Future<void> _typingSignal() async {
    try {
      await _repo.typing(id);
    } on Object {
      // Yazıyor en iyi çabadır.
    }
  }
}
