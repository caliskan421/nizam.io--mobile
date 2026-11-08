// ArchiveFoldersController + arşiv kapsamı: departman başlığı rolden (ilk koordinatörlük, yoksa
// ilk ekip satırı; yöneticide programın ilk departmanı); seçilemezse istek yok; alt yazı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/archive/application/archive_folders_controller.dart';
import 'package:nizamio/features/archive/application/archive_providers.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/archive/domain/archive.dart';

import '../archive_fixture.dart';

void main() {
  test(
    'koordinatör: kendi departmanıyla okunur; alt yazı toplam dosya',
    () async {
      final repo = FakeArchiveRepository();
      final c = archiveContainer(
        repo,
        catalog: archiveCatalog(seats: {'d5': false, 'd1': true}),
      );
      c.listen(archiveNavCaptionProvider, (_, _) {});
      expect(c.read(archiveNavCaptionProvider), isNull);
      final folders = await c.read(archiveFoldersControllerProvider.future);
      expect(folders, hasLength(2));
      // Üye satırı önce gelse de koordinatörlük seçilir.
      expect(repo.calls.single, ('folders', 'd1', null));
      expect(
        await c.read(archiveScopeProvider.future),
        const ArchiveScope(department: 'd1', admin: false),
      );
      expect(c.read(archiveNavCaptionProvider), '3 dosya');
    },
  );

  test('üye: ilk ekip satırı', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(
      repo,
      catalog: archiveCatalog(seats: {'d4': false}),
    );
    await c.read(archiveFoldersControllerProvider.future);
    expect(repo.calls.single.$2, 'd4');
  });

  test('ekip satırsız yönetici: programın ilk departmanı', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(
      repo,
      catalog: archiveCatalog(admin: true, seats: {}, departments: ['d9']),
    );
    await c.read(archiveFoldersControllerProvider.future);
    expect(repo.calls.single.$2, 'd9');
    expect((await c.read(archiveScopeProvider.future)).admin, isTrue);
  });

  test('departman seçilemiyor → client.scope_missing, istek yok', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(repo, catalog: archiveCatalog(seats: {}));
    await expectLater(
      c.read(archiveFoldersControllerProvider.future),
      throwsA(
        isA<ApiError>().having(
          (e) => e.code,
          'code',
          ClientErrorCode.scopeMissing,
        ),
      ),
    );
    expect(repo.calls, isEmpty);
  });

  test('sunucu hatası ApiError olarak görünür', () async {
    final repo = FakeArchiveRepository()
      ..error = ApiError('records.not_authorized');
    final c = archiveContainer(repo);
    await expectLater(
      c.read(archiveFoldersControllerProvider.future),
      throwsA(isA<ApiError>()),
    );
  });
}
