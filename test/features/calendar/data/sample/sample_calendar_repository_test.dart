// Örnek takvim kaynağı: prototip `RP_CAL` sayıları, tarih aralığı ve sohbet kimlikleri.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/calendar/data/sample/sample_calendar_repository.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';

void main() {
  test(
    'sezon 8, toplantı 12, talep 9, tablo kaydı 8; görev başlangıç sınırı',
    () async {
      final s = await const SampleCalendarRepository().load();
      expect(s.seasons, hasLength(8));
      expect(s.meetings, hasLength(12));
      expect(s.requests, hasLength(9));
      expect(s.sheets, hasLength(8));
      expect(s.taskStartsFrom, DateTime(2026, 9));
    },
  );

  test(
    'tüm koordinatörlükler toplantısı boş kod listesiyle; sohbet kimlikleri',
    () async {
      final s = await const SampleCalendarRepository().load();
      final weekly = s.meetings.where(
        (m) => m.title == 'Haftalık koordinasyon',
      );
      expect(weekly, hasLength(3));
      expect(weekly.every((m) => m.allCoordinatorships), isTrue);
      expect(s.meetings.map((m) => m.chatId).toSet(), {
        'koord',
        'hid',
        'gen',
        'fuar',
        'sis',
      });
    },
  );

  test('teklif talebinde tutar yok; bağlı görevsiz talepler', () async {
    final s = await const SampleCalendarRepository().load();
    final quotes = s.requests.where((r) => r.type == RequestType.quote);
    expect(quotes.every((r) => r.amount == 0), isTrue);
    expect(s.requests.where((r) => r.taskCode == null).map((r) => r.id), [
      'ST-120',
      'ST-121',
    ]);
  });
}
