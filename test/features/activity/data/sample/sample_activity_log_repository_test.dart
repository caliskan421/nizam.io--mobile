// SampleActivityLogRepository: 38 kayıt, yeniden eskiye, dört gün; filtre önerileri.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/activity/data/sample/sample_activity_log_repository.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';

void main() {
  test('örnek kaynak sözleşmeyi uygular', () async {
    final log = await SampleActivityLogRepository().load();
    expect(log.entries, hasLength(38));
    for (var i = 1; i < log.entries.length; i++) {
      expect(
        log.entries[i].at.isAfter(log.entries[i - 1].at),
        isFalse,
        reason: 'yeniden eskiye',
      );
    }
    expect(log.entries.first.at, DateTime(2026, 10, 21, 14, 27));
    expect(
      log.entries.map((e) => DateTime(e.at.year, e.at.month, e.at.day)).toSet(),
      hasLength(4),
    );
    expect(
      log.entries.where((e) => e.kind == ActivityKind.account),
      isNotEmpty,
    );
    expect(log.people, hasLength(5));
    expect(log.coordinatorships, hasLength(5));
  });
}
