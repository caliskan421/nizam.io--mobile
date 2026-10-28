// ActivityQueryController + activityView: tür, arama, kişi, koordinatörlük süzgeçleri; gün
// grupları ve sayaçlar; "daha fazla göster"; temizleme.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/activity/application/activity_query_controller.dart';
import 'package:nizamio/features/activity/domain/activity_log.dart';
import 'package:nizamio/features/activity/domain/activity_query.dart';

import '../../pilot_support.dart';

Future<(ProviderContainer, ActivityQueryController)> _open() async {
  final h = await pilotHarness(PilotBackend());
  final c = h.container;
  c.listen(activityViewProvider, (_, _) {});
  return (c, c.read(activityQueryControllerProvider.notifier));
}

void main() {
  test(
    'başlangıç: 30 gösterilir, 38 toplam, gün grupları, tür sayıları',
    () async {
      final (c, q) = await _open();
      var v = await c.read(activityViewProvider.future);
      expect((v.shown, v.total, v.allCount), (30, 38, 38));
      expect(v.canShowMore, isTrue);
      expect(v.days.first.day, DateTime(2026, 10, 21));
      expect(v.days.first.count, 24);
      expect(
        v.days.map((d) => d.entries.length).fold<int>(0, (a, b) => a + b),
        30,
      );
      expect(v.kindCounts[ActivityKind.meeting], greaterThan(0));
      expect(v.kindCounts.values.fold<int>(0, (a, b) => a + b), 38);
      q.showMore();
      v = await c.read(activityViewProvider.future);
      expect((v.shown, v.canShowMore), (38, false));
      expect(v.days, hasLength(4));
    },
  );

  test('tür, kişi, koordinatörlük ve arama süzer; temizleme', () async {
    final (c, q) = await _open();
    q.selectKind(ActivityKind.task);
    var v = await c.read(activityViewProvider.future);
    expect(v.total, v.kindCounts[ActivityKind.task]);
    expect(v.allCount, 38, reason: 'tür sayıları tür süzgecinden bağımsız');

    q
      ..selectKind(null)
      ..togglePerson('ko');
    v = await c.read(activityViewProvider.future);
    expect(
      v.days.expand((d) => d.entries).every((e) => e.actorId == 'ko'),
      isTrue,
    );
    expect(c.read(activityQueryControllerProvider).hasExtra, isTrue);

    q
      ..togglePerson('ko')
      ..toggleCoordinatorship('EĞİ');
    v = await c.read(activityViewProvider.future);
    expect(v.days.expand((d) => d.entries).map((e) => e.actorId).toSet(), {
      'mk',
      'gn',
      'mey',
    });
    q.toggleCoordinatorship('EĞİ');
    expect(c.read(activityQueryControllerProvider).coordinatorship, isNull);

    q.search('hidrofor');
    v = await c.read(activityViewProvider.future);
    expect(v.total, greaterThan(0));
    expect(v.total, lessThan(38));

    q
      ..search('')
      ..selectKind(ActivityKind.file)
      ..togglePerson('bk')
      ..clearAll();
    expect(c.read(activityQueryControllerProvider).isEmpty, isTrue);

    q
      ..togglePerson('bk')
      ..toggleCoordinatorship('İDA')
      ..clearExtra();
    expect(c.read(activityQueryControllerProvider).hasExtra, isFalse);
  });

  test('görev hedefli kayıt kodu çözülür', () {
    ActivityEntry e(String target) => ActivityEntry(
      at: DateTime(2026),
      kind: ActivityKind.task,
      action: '',
      detail: '',
      target: target,
      actorId: 'ko',
      actorName: 'Kerem Özdal',
    );
    expect(taskCodeOf(e('ALT-16 · Hidrofor montaj')), 'ALT-16');
    expect(taskCodeOf(e('İDA-9')), 'İDA-9');
    expect(taskCodeOf(e('Haftalık koordinasyon toplantısı')), isNull);
  });
}
