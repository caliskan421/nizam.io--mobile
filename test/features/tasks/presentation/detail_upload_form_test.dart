// Kanıt yükleme formu (Codex tur 6 / N12): A dosyasının içerik özeti sürerken aynı formda B
// seçilirse A gönderimi bayatlar (istek yok, `superseded`); form açık kalır, B seçimi korunur
// ve bildirim gösterilmez.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';
import '../task_detail_server.dart';

final _l = AppLocalizationsTr();

/// Sıradaki seçimi döndüren seçici.
class _Picker implements UploadPicker {
  UploadSource? next;

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async => next;
}

Future<void> _pick(WidgetTester tester, String button) async {
  await tester.tap(find.text(button));
  await settle(tester);
  await tester.tap(find.text(_l.uiTasksPickFiles));
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('özet sürerken yeni dosya seçilir: eski gönderim formu kapatmaz, '
      'yeni seçim korunur, istek yok', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1600);
    addTearDown(tester.view.reset);
    final gate = Completer<void>();
    bool? stale;
    final picker = _Picker();
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    h.backend.handler = TaskDetailServer().handle;
    h.composition.locator
      ..unregister<UploadPicker>()
      ..registerSingleton<UploadPicker>(picker)
      ..unregister<UploadDigest>()
      ..registerSingleton<UploadDigest>((path, {required cancelled}) async {
        await gate.future;
        stale = cancelled();
        return 'ozet';
      });
    h.read(scopeControllerProvider).selectProgram('prog-1');
    await real(
      tester,
      () => h.container.read(taskCatalogControllerProvider.future),
    );
    await pumpScreen(tester, h, const TaskDetailPage(code: 'w1'));
    await settle(tester);
    h.backend.requests.clear();

    await tester.tap(find.text(_l.uiTasksUpload));
    await settle(tester);
    picker.next = const UploadSource(
      path: '/a/a.pdf',
      name: 'a.pdf',
      sizeBytes: 4,
    );
    await _pick(tester, _l.uiTasksPickFileAction);
    await tester.tap(find.text(_l.uiTasksUploadOk));
    await settle(tester);

    final b = picker.next = const UploadSource(
      path: '/b/b.pdf',
      name: 'b.pdf',
      sizeBytes: 4,
    );
    await _pick(tester, 'a.pdf');
    gate.complete();
    await settle(tester);

    final st = h.container.read(taskDetailControllerProvider('w1'));
    expect(stale, isTrue, reason: 'A özeti bayat');
    expect(st.upload?.file, same(b));
    expect(find.text(_l.uiTasksUploadTitle), findsOneWidget, reason: 'açık');
    expect(find.text('b.pdf'), findsOneWidget);
    expect(find.text(_l.uiTasksTUploaded), findsNothing);
    expect(h.backend.requests.where((r) => r.method == 'POST'), isEmpty);
    expect(tester.takeException(), isNull);
  });
}
