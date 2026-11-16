import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tables/application/tables_server.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/presentation/table_library_card.dart';

import '../../../app/router/tables_backend_flow_test.dart' show choices;
import '../../../app/router/users_tables_flow_test.dart' show sheetPng;
import '../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  setUpFonts();
  for (final width in [390.0, 1180.0]) {
    testWidgets('eksik önizleme satırlarında taşma yok: $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 820);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final docs = [
        for (final count in [0, 1, 3])
          TableDocument(
            id: 'demo-$count',
            title: 'Fuar etkinlik programı',
            area: TableArea.personal,
            fields: const [
              TableField(id: 'event', name: 'Etkinlik'),
              TableField(id: 'date', name: 'Tarih'),
              TableField(id: 'place', name: 'Yer'),
            ],
            rows: [
              for (var i = 0; i < count; i++)
                TableRecord(
                  id: '$i',
                  cells: {
                    const TableFieldId('event'): 'Açılış töreni',
                    const TableFieldId('date'): '27.10',
                    const TableFieldId('place'): 'Ana sahne',
                  },
                ),
            ],
          ),
      ];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tablesRepositoryProvider.overrideWithValue(null),
            sessionGenerationProvider.overrideWith((ref) => 1),
            scopeStateProvider.overrideWith(
              (ref) => const ScopeSelection(programId: 'p1'),
            ),
            tableSharingChoicesProvider.overrideWith((ref) async => choices),
          ],
          child: testApp(
            Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final doc in docs)
                        SizedBox(
                          width: width >= 800 ? (width - 56) / 3 : width - 32,
                          child: TableLibraryCard(document: doc, onOpen: () {}),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      File('/tmp/nizam-table-cards-${width.toInt()}.png')
          .writeAsBytesSync(await sheetPng(tester));
    });
  }
}
