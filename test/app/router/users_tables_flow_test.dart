import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_search_field.dart';
import 'package:nizamio/features/tables/application/tables_controller.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/presentation/table_page.dart';
import 'package:nizamio/features/tables/presentation/tables_page.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../support/tablet_harness.dart' show hostPng;
import 'router_test_support.dart';

void main() {
  setUpFonts();
  for (final size in const [Size(390, 844), Size(1180, 820)]) {
    testWidgets('Tablolar liste, salt okunur ve geri: $size', (tester) async {
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      final router = await pumpRouter(
        tester,
        phase,
        width: size.width,
        height: size.height,
      );
      router.go('/tables');
      await settle(tester);
      expect(find.byType(TablesPage), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(TablesPage)),
      );
      final shared = container
          .read(tablesControllerProvider)
          .documents
          .firstWhere((d) => !d.editable);
      router.go('/tables/${shared.id}');
      await settle(tester);
      expect(find.byType(TablePage), findsOneWidget);
      expect(find.text('Yalnızca görüntüleme'), findsOneWidget);
      if (const bool.fromEnvironment('NIZAMIO_TABLET_HOST_SHOTS')) {
        File('/tmp/nizam-tables-${size.width.toInt()}.png')
            .writeAsBytesSync(await hostPng(tester));
      }
      expect(find.text('Satır ekle'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.binding.handlePopRoute();
      await settle(tester);
      expect(locationOf(router), '/tables');
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Tabloda satır ve hücre düzenleme', (tester) async {
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    final router = await pumpRouter(tester, phase, width: 390, height: 844);
    router.go('/tables');
    await settle(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(TablesPage)),
    );
    final controller = container.read(tablesControllerProvider.notifier);
    final id = controller.create(
      title: 'Deneme',
      area: TableArea.personal,
      fields: const [TableField(id: 'name', name: 'Ad')],
    )!;
    router.go('/tables/$id');
    await settle(tester);
    await tester.tap(find.text('Satır ekle'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'Yeni değer');
    await tester.tap(find.text('Kaydet'));
    await settle(tester);
    expect(
      container
          .read(tablesControllerProvider)
          .document(id)!
          .rows
          .single
          .cells[const TableFieldId('name')],
      'Yeni değer',
    );
    expect(find.text('Yeni değer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final size in const [Size(390, 844), Size(1180, 820)]) {
    testWidgets('Tablo detayı araması filtreyi temizler ve kapanır: $size', (
      tester,
    ) async {
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      final router = await pumpRouter(
        tester,
        phase,
        width: size.width,
        height: size.height,
      );
      router.go('/tables');
      await settle(tester);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(TablesPage)),
      );
      final controller = container.read(tablesControllerProvider.notifier);
      final id = controller.create(
        title: 'Arama tablosu',
        area: TableArea.personal,
        fields: const [TableField(id: 'name', name: 'Ad')],
      )!;
      final first = controller.addRow(id)!;
      final second = controller.addRow(id)!;
      controller.cell(id, first, 'name', 'Elma');
      controller.cell(id, second, 'name', 'Armut');
      router.go('/tables/$id');
      await settle(tester);
      await tester.tap(find.bySemanticsLabel('Tablolarda ara').first);
      await settle(tester);
      final field = find.descendant(
        of: find.byType(NzSearchField),
        matching: find.byType(TextField),
      );
      expect(tester.widget<TextField>(field).focusNode!.hasFocus, isTrue);
      await tester.enterText(field, 'Elma');
      await settle(tester);
      expect(
        find.byWidgetPredicate((w) => w is Text && w.data == 'Elma'),
        findsOneWidget,
      );
      expect(find.text('Armut'), findsNothing);
      await tester.tap(find.byTooltip('Aramayı temizle'));
      await settle(tester);
      expect(find.text('Armut'), findsOneWidget);
      await tester.enterText(field, 'Elma');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await settle(tester);
      expect(find.byType(NzSearchField), findsNothing);
      expect(find.text('Armut'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Tablolarda ara').first);
      await settle(tester);
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byType(NzSearchField),
                matching: find.byType(TextField),
              ),
            )
            .controller!
            .text,
        isEmpty,
      );
      expect(tester.takeException(), isNull);
    });
  }
  for (final size in const [Size(360, 640), Size(1180, 820)]) {
    testWidgets(
      'Açık tablo formunun alt eylemi eski lease ile kullanılamaz: $size',
      (tester) async {
        final phase = ValueNotifier(AppPhase.scoped);
        addTearDown(phase.dispose);
        final router = await pumpRouter(
          tester,
          phase,
          width: size.width,
          height: size.height,
        );
        router.go('/tables');
        await settle(tester);
        final container = ProviderScope.containerOf(
          tester.element(find.byType(TablesPage)),
        );
        expect(tester.takeException(), isNull);
        await tester.tap(find.bySemanticsLabel('Yeni tablo').first);
        await settle(tester);
        expect(tester.takeException(), isNull);
        await tester.enterText(find.byType(TextField).last, 'Eski taslak');
        await settle(tester);
        expect(find.text('Oluştur'), findsOneWidget);
        container.invalidate(tablesControllerProvider);
        await settle(tester);
        expect(find.text('Oluştur'), findsNothing);
        expect(
          container
              .read(tablesControllerProvider)
              .documents
              .any((d) => d.title == 'Eski taslak'),
          isFalse,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('Menüden Tablolar açılır', (tester) async {
    final phase = ValueNotifier(AppPhase.scoped);
    addTearDown(phase.dispose);
    final router = await pumpRouter(tester, phase, width: 390, height: 844);
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Menü').first);
    await settle(tester);
    await tester.ensureVisible(find.text('Tablolar').last);
    await tester.tap(find.text('Tablolar').last);
    await settle(tester);
    expect(locationOf(router), '/tables');
    expect(find.byType(TablesPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
