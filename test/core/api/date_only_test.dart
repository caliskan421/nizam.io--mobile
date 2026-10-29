import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/api/generated/date_only.dart';
import 'package:nizamio/core/api/generated/models/completion_request.dart';
import 'package:nizamio/core/api/generated/models/update_work_item_request.dart';

void main() {
  const c = DateOnlyConverter();

  group('DateOnlyConverter', () {
    test('yazım yalnız YYYY-MM-DD (saat taşınmaz)', () {
      expect(c.toJson(DateTime(2026, 11, 3, 23, 59)), '2026-11-03');
      expect(c.toJson(DateTime.utc(2026, 1, 9)), '2026-01-09');
    });

    test('okuma yerel gece yarısı; tam zaman damgasının gün öneki alınır', () {
      expect(c.fromJson('2026-11-03'), DateTime(2026, 11, 3));
      expect(c.fromJson('2026-11-03T21:00:00Z'), DateTime(2026, 11, 3));
    });

    test('biçim dışı değer FormatException', () {
      expect(() => c.fromJson('03.11.2026'), throwsFormatException);
    });
  });

  group('üretilmiş modeller (tool/gen/wire_types.dart)', () {
    test('zorunlu gün alanı', () {
      final json = CompletionRequest(completedOn: DateTime(2026, 11, 3, 15))
          .toJson();
      expect(json['completed_on'], '2026-11-03');
    });

    test('isteğe bağlı gün alanı: değer yazılır, null gönderilmez/korunur', () {
      final json = UpdateWorkItemRequest(startOn: DateTime(2026, 2, 1))
          .toJson();
      expect(json['start_on'], '2026-02-01');
      expect(json['end_on'], isNull);
    });
  });
}
