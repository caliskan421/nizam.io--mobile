// Sohbet kuralları: akış öğeleri.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/data/sample/sample_chat_repository.dart';
import 'package:nizamio/features/messages/domain/chat_logic.dart';

void main() {
  test('akış: gün hapları, okunmamış ayırıcısı, ardışık gruplar', () async {
    final box = await const SampleChatRepository().load();
    final gen = box.chat('gen')!;
    final opened = gen.copyWith(unreadMarker: () => unreadMarkerOf(gen));
    final items = timeline(opened);
    expect(items.whereType<ChatDayItem>(), hasLength(2));
    final iNew = items.indexWhere((i) => i is ChatNewItem);
    expect((items[iNew + 1] as ChatMessageItem).message.id, 'm3');
    final m4 = items.whereType<ChatMessageItem>().firstWhere(
      (i) => i.message.id == 'm4',
    );
    final m5 = items.whereType<ChatMessageItem>().firstWhere(
      (i) => i.message.id == 'm5',
    );
    expect((m4.first, m4.last, m5.first, m5.last), (true, false, false, true));
    expect(unreadMarkerOf(box.chat('hid')!), 'h2');
    expect(unreadMarkerOf(box.chat('sis')!), isNull);
  });
}
