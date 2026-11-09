// Sohbet penceresinin saf kuralları: mesaj yerleştirme (çift mesaj yok), pencere uzlaştırma
// sayfası (§10.5), tik kuralı (§10.4) ve okunmamış ayırıcısı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/domain/chat_room.dart';

import '../fake_chat_repository.dart';

ChatMessage _pending(
  String clientId, {
  ChatSendState s = ChatSendState.sending,
}) => ChatMessage(
  id: 'local:$clientId',
  clientId: clientId,
  senderId: me,
  at: at(30),
  text: 'yeni',
  state: s,
);

List<String> _ids(List<ChatMessage> l) => [for (final m in l) m.id];

void main() {
  group('mergeMessages', () {
    test('seq sırası; aynı kimlik güncellenir; bekleyen sonda', () {
      final out = mergeMessages(
        [msg(3), _pending('x'), msg(1)],
        [msg(2), msg(3, text: 'düzenlendi')],
      );
      expect(_ids(out), ['m1', 'm2', 'm3', 'local:x']);
      expect(out[2].text, 'düzenlendi');
    });

    test(
      'bekleyen kendi mesajım sunucu kopyasıyla yer değiştirir (çift yok)',
      () {
        final local = [msg(1), _pending('k1')];
        final server = msg(2, sender: me, clientId: 'k1');
        final once = mergeMessages(local, [server]);
        expect(_ids(once), ['m1', 'm2']);
        // Akıştan gelen kopya ve gönderim yanıtı ikisi de uygulansa tek balon kalır.
        expect(_ids(mergeMessages(once, [server])), ['m1', 'm2']);
      },
    );

    test('başkasının aynı istemci kimliği bekleyenimi silmez', () {
      final out = mergeMessages([_pending('k1')], [msg(5, clientId: 'k1')]);
      expect(_ids(out), ['m5', 'local:k1']);
    });
  });

  group('applyWindowPage', () {
    final local = [for (var s = 1; s <= 6; s++) msg(s), _pending('p')];

    test('dolu sayfa: kapsanan aralıkta dönmeyen yerel kayıt silinir', () {
      // before=7, limit=3 → dönen 4,6 (5 silinmiş); aralık [4,6].
      final out = applyWindowPage(
        local,
        [msg(3), msg(4), msg(6)],
        cursor: 7,
        limit: 3,
      );
      expect(_ids(out), ['m1', 'm2', 'm3', 'm4', 'm6', 'local:p']);
    });

    test('eksik sayfa: aralığın altı açık', () {
      final out = applyWindowPage(
        local,
        [msg(2), msg(6)],
        cursor: 7,
        limit: 50,
      );
      expect(_ids(out), ['m2', 'm6', 'local:p']);
    });

    test('boş sayfa: imlecin altındaki bütün mesajlar silinmiş', () {
      final out = applyWindowPage(local, const [], cursor: 5, limit: 50);
      expect(_ids(out), ['m5', 'm6', 'local:p']);
    });

    test('pencere bitti mi', () {
      expect(windowDone(const [], limit: 3, windowLow: 1), isTrue);
      expect(windowDone([msg(4), msg(5)], limit: 3, windowLow: 1), isTrue);
      expect(
        windowDone([msg(4), msg(5), msg(6)], limit: 3, windowLow: 1),
        isFalse,
      );
      expect(
        windowDone([msg(1), msg(2), msg(3)], limit: 3, windowLow: 2),
        isTrue,
      );
    });
  });

  test(
    'tik: birebirde peer_read_seq; grupta renkli tik yok; başkasında yok',
    () {
      ChatRoom room({bool group = false, int? peerRead = 2}) => ChatRoom(
        chat: chat('c', group: group),
        messages: const [],
        peerReadSeq: peerRead,
      );
      expect(
        tickOf(
          msg(2, sender: me),
          me: me,
          room: room(),
        ),
        ChatTick.read,
      );
      expect(
        tickOf(
          msg(3, sender: me),
          me: me,
          room: room(),
        ),
        ChatTick.sent,
      );
      expect(
        tickOf(
          msg(1, sender: me),
          me: me,
          room: room(group: true),
        ),
        ChatTick.sent,
      );
      expect(tickOf(msg(1), me: me, room: room()), ChatTick.none);
      expect(tickOf(_pending('a'), me: me, room: room()), ChatTick.sending);
      expect(
        tickOf(
          _pending('a', s: ChatSendState.failed),
          me: me,
          room: room(),
        ),
        ChatTick.failed,
      );
    },
  );

  test('okunmamış ayırıcısı: başkalarının son N mesajının ilki', () {
    final l = [msg(1), msg(2, sender: me), msg(3), msg(4)];
    expect(unreadMarkerOf(l, 2, me), 'm3');
    expect(unreadMarkerOf(l, 9, me), 'm1');
    expect(unreadMarkerOf(l, 0, me), isNull);
  });
}
