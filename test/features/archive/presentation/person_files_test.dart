import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../../tasks/task_detail_server.dart';
import '../archive_fixture.dart';

final _l = AppLocalizationsTr();

class _DeletingRepository extends FakeArchiveRepository {
  @override
  Future<void> deleteFile(String id, {required String department}) async {
    await super.deleteFile(id, department: department);
    pages = {
      for (final entry in pages.entries)
        entry.key: PageSlice(
          items: entry.value.items.where((f) => f.id != id).toList(),
          nextCursor: entry.value.nextCursor,
        ),
    };
  }
}

Future<Harness> _open(
  WidgetTester tester,
  FakeArchiveRepository repo, {
  required bool admin,
  required String role,
  String account = 'acc-1',
}) async {
  final server = TaskDetailServer()
    ..admin = admin
    ..role = role
    ..assignees = ['acc-1'];
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.backend.handler = server.handle;
  useArchiveFakes(h, repo);
  h.read(scopeControllerProvider).selectProgram('prog-1');
  await real(
    tester,
    () => h.container.read(taskCatalogControllerProvider.future),
  );
  await pumpScreen(tester, h, Scaffold(body: PersonFiles(accountId: account)));
  await settle(tester);
  return h;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final (name, admin, role) in [
    ('yönetici', true, 'uye'),
    ('koordinatör', false, 'koordinator'),
    ('üye', false, 'uye'),
  ]) {
    testWidgets('$name kendi dosyasını onayla siler; liste yenilenir', (
      tester,
    ) async {
      final repo = _DeletingRepository()
        ..pages = {
          null: PageSlice(items: [archiveFile('mine', uploader: 'acc-1')]),
        };
      await _open(tester, repo, admin: admin, role: role);
      expect(find.text('mine.pdf'), findsOneWidget);
      await _tap(tester, find.bySemanticsLabel(_l.uiArchiveDelete));
      await _tap(tester, find.text(_l.uiCommonCancel));
      expect(repo.calls.where((c) => c.$1 == 'delete'), isEmpty);
      expect(find.text('mine.pdf'), findsOneWidget);
      await _tap(tester, find.bySemanticsLabel(_l.uiArchiveDelete));
      await _tap(tester, find.text(_l.uiArchiveDeleteOk));
      expect(repo.calls.where((c) => c.$1 == 'delete').single, (
        'delete',
        'd1',
        'mine',
      ));
      expect(find.text('mine.pdf'), findsNothing);
      expect(find.text(_l.uiArchiveEmptyFiles), findsOneWidget);
    });

    testWidgets('$name başkasının dosyasında silme görmez', (tester) async {
      final repo = FakeArchiveRepository()
        ..pages = {
          null: PageSlice(items: [archiveFile('other', uploader: 'acc-9')]),
        };
      await _open(tester, repo, admin: admin, role: role, account: 'acc-9');
      expect(find.text('other.pdf'), findsOneWidget);
      expect(find.bySemanticsLabel(_l.uiArchiveDelete), findsNothing);
    });
  }

  testWidgets('silme onayında kapsam değişirse yazma gönderilmez', (
    tester,
  ) async {
    final repo = FakeArchiveRepository()
      ..pages = {
        null: PageSlice(items: [archiveFile('mine', uploader: 'acc-1')]),
      };
    final h = await _open(tester, repo, admin: false, role: 'koordinator');
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveDelete));
    h.read(scopeControllerProvider).selectProgram('different-program');
    await settle(tester);
    await _tap(tester, find.text(_l.uiArchiveDeleteOk));
    expect(repo.calls.where((c) => c.$1 == 'delete'), isEmpty);
  });

  testWidgets('sunucu reddederse dosya listede korunur', (tester) async {
    final repo = FakeArchiveRepository()
      ..pages = {
        null: PageSlice(items: [archiveFile('mine', uploader: 'acc-1')]),
      };
    await _open(tester, repo, admin: false, role: 'koordinator');
    await _tap(tester, find.bySemanticsLabel(_l.uiArchiveDelete));
    // Hata yalnız yazma başladıktan sonraki çağrılara uygulanır.
    repo.error = ApiError('records.not_authorized', status: 403);
    await _tap(tester, find.text(_l.uiArchiveDeleteOk));
    expect(find.text('mine.pdf'), findsOneWidget);
  });
}
