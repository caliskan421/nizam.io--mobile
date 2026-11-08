// Toplantı kartı yüksekliği sabit: koordinatörlük sayısı (tek satır şerit, en çok 4 + "+N"),
// başlık uzunluğu (tek satır) ve sayaç durumu (yüklendi / okunamadı) değiştirmez.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/features/meetings/domain/meeting.dart';
import 'package:nizamio/features/meetings/presentation/meeting_card.dart';
import 'package:nizamio/features/meetings/presentation/meeting_parts.dart';

import '../../pilot_support.dart';
import '../meetings_server.dart';

Meeting _m(String id, int depts, String title) => Meeting(
  id: id,
  programId: 'prog-1',
  ownerDepartmentId: 'd0',
  title: title,
  meetingDate: DateTime(2030, 1, 10, 10),
  membersIncluded: false,
  createdByAccountId: 'acc-1',
  createdByRole: MeetingRole.admin,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
  departments: [
    for (var i = 0; i < depts; i++)
      MeetingDepartment(id: 'd$i', name: 'Koordinatörlük $i'),
  ],
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('chipsThatFit', () {
    double plus(int _) => 30;
    test('sığdığı kadar, en çok 4; kalan için "+N" yeri ayrılır', () {
      expect(chipsThatFit([50, 50], avail: 200, gap: 6, plus: plus), 2);
      expect(
        chipsThatFit([50, 50, 50, 50, 50, 50], avail: 400, gap: 6, plus: plus),
        4,
      );
      // 3 çip + "+3" (50*3 + 6*2 + 6 + 30 = 198) sığar, 4 + "+2" (260) sığmaz.
      expect(
        chipsThatFit([50, 50, 50, 50, 50, 50], avail: 200, gap: 6, plus: plus),
        3,
      );
      expect(chipsThatFit([300, 50], avail: 200, gap: 6, plus: plus), 1);
    });
  });

  for (final (width, scale) in [(390.0, 1.0), (360.0, 2.0)]) {
    testWidgets('kart yüksekliği sabit ${width.toInt()} × $scale', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 2000);
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final (h, _) = await real(tester, () => openMeetings(MeetingsServer()));
      final cards = [
        // m1 sayaçları yüklenir; diğerleri okunamaz (yer yine tutulur).
        _m('m1', 1, 'Kısa'),
        _m(
          'm2',
          3,
          'Hidrofor teslim kontrolü ve basınç testi sonuçlarının değerlendirilmesi',
        ),
        _m('m3', 6, 'Altı koordinatörlüklü toplantı'),
      ];
      await pumpScreen(
        tester,
        h,
        SingleChildScrollView(
          child: Column(
            children: [
              for (final m in cards)
                MeetingCard(
                  key: ValueKey(m.id),
                  meeting: m,
                  catalog: null,
                  onTap: () {},
                ),
            ],
          ),
        ),
      );
      await settle(tester);
      expect(tester.takeException(), isNull);
      final heights = {
        for (final m in cards)
          tester.getSize(find.byKey(ValueKey(m.id))).height,
      };
      expect(heights, hasLength(1), reason: '$heights');
      final m3 = find.byKey(const ValueKey('m3'));
      final plus = find.descendant(
        of: m3,
        matching: find.textContaining(RegExp(r'^\+\d+$')),
      );
      expect(plus, findsOneWidget, reason: 'kalanlar tek "+N" çipinde');
      final shown = find.descendant(
        of: m3,
        matching: find.textContaining('Koordinatörlük'),
      );
      expect(shown.evaluate().length, inInclusiveRange(1, 4));
    });
  }
}
