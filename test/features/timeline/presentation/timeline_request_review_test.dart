import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/tasks.dart';
import 'package:nizamio/features/timeline/application/gantt_provider.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_selection_card.dart';

import '../../../support/fake_backend.dart';
import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

void main() {
  for (final admin in [false, true]) {
    for (final reject in admin ? [false, true] : [false]) {
      testWidgets(
        'çizelge talep gerekçesi ve karar kapısı (admin=$admin, ret=$reject)',
        (t) async {
          t.view.devicePixelRatio = 1;
          t.view.physicalSize = const Size(390, 844);
          addTearDown(t.view.reset);
          final backend = CoordBackend()..admin = admin;
          final item = backend.workItems.firstWhere(
            (w) => w['work_item_id'] == tAltLate12,
          );
          item['pending_date_request'] = {
            'request_id': 'request',
            'new_start_on': item['start_on'],
            'new_end_on': '2026-11-24',
          };
          final h = await real(t, () => pilotHarness(backend, signedIn: true));
          Map<String, Object?>? decision;
          h.backend.handler = (r) async {
            if (r.path == '/v1/date-change-requests/request/review') {
              decision = Map<String, Object?>.from(r.body! as Map);
              if (decision!['decision'] == 'approved') {
                item['end_on'] = '2026-11-24';
              }
              item['pending_date_request'] = null;
              return jsonResponse(200, {'affected_tasks_count': 1});
            }
            if (r.path == '/v1/date-change-requests' ||
                r.path == '/v1/date-change-requests/mine') {
              return jsonResponse(200, {
                'requests': [
                  if (item['pending_date_request'] != null)
                    {
                      'request_id': 'request',
                      'work_item_id': tAltLate12,
                      'status': 'pending',
                      'old_start_on': item['start_on'],
                      'new_start_on': item['start_on'],
                      'old_end_on': item['end_on'],
                      'new_end_on': '2026-11-24',
                      'reason': 'Malzeme tedariki gecikti',
                    },
                ],
                'total': item['pending_date_request'] != null ? 1 : 0,
              });
            }
            return backend.handle(r);
          };
          h.read(scopeControllerProvider).selectProgram(coordProgram);
          await real(t, () async {
            h.container.listen(timelineCatalogProvider, (_, _) {});
            await h.read(taskCatalogControllerProvider.future);
            await h.read(ganttScheduleProvider.future);
          });
          final selection = buildGanttView(
            h.read(timelineCatalogProvider).requireValue,
            const GanttState(selected: tAltLate12),
          ).selection!;
          await pumpScreen(
            t,
            h,
            Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 390,
                  child: GanttSelectionCard(
                    selection: selection,
                    year: 2026,
                    onOpen: () {},
                    onClose: () {},
                  ),
                ),
              ),
            ),
          );
          await settle(t);
          await t.tap(find.text('Tarih talebi'));
          await settle(t);
          expect(find.text('“Malzeme tedariki gecikti”'), findsOneWidget);
          if (!admin) {
            expect(find.text('Onayla'), findsNothing);
            expect(find.text('Reddet'), findsNothing);
            expect(decision, isNull);
            return;
          }
          if (reject) {
            await t.tap(find.text('Reddet'));
            await settle(t);
            await t.enterText(
              find.byType(TextField),
              'Yeni plan gerekçesi yetersiz',
            );
            await t.tap(find.text('Reddet').last);
          } else {
            await t.tap(find.text('Onayla'));
          }
          await settle(t);
          expect(decision?['decision'], reject ? 'rejected' : 'approved');
          if (reject) {
            expect(decision?['reason'], 'Yeni plan gerekçesi yetersiz');
          }
          expect(
            h.backend.count('POST', '/v1/date-change-requests/request/review'),
            1,
          );
          expect(t.takeException(), isNull);
        },
      );
    }
  }
}
