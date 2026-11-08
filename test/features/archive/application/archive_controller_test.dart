// ArchiveController: arama aç/kapa; dönemin tam arşivi yalnız yöneticide (akış kaydedilir).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/archive/application/archive_controller.dart';

import '../archive_fixture.dart';

void main() {
  test('arama: açılınca sorgu tutulur, kapanınca temizlenir', () {
    final c = archiveContainer(FakeArchiveRepository());
    final ctrl = c.read(archiveControllerProvider.notifier)
      ..toggleSearch()
      ..setQuery('alt');
    expect(c.read(archiveControllerProvider).searchOpen, isTrue);
    expect(c.read(archiveControllerProvider).query, 'alt');
    ctrl.toggleSearch();
    expect(c.read(archiveControllerProvider).searchOpen, isFalse);
    expect(c.read(archiveControllerProvider).query, '');
  });

  test('yönetici: tam arşiv ZIP akışı kaydedilir', () async {
    final repo = FakeArchiveRepository();
    final sink = RecordingSink();
    final c = archiveContainer(
      repo,
      catalog: archiveCatalog(admin: true, seats: {}),
      sink: sink,
    );
    final r = await c
        .read(archiveControllerProvider.notifier)
        .downloadAll('Arşiv.zip');
    expect(r.ok, isTrue);
    expect(r.path, '/indirilenler/Arşiv.zip');
    expect(repo.calls.single, ('periodZip', 'd1', null));
    expect(sink.saved['Arşiv.zip'], [1, 2, 3]);
    expect(c.read(archiveControllerProvider).busy, isFalse);
  });

  test('yönetici değil: istek gönderilmez', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(repo);
    final r = await c
        .read(archiveControllerProvider.notifier)
        .downloadAll('Arşiv.zip');
    expect(r.ok, isFalse);
    expect(r.error, isNull);
    expect(repo.calls, isEmpty);
  });

  test('sunucu hatası sonuçta döner', () async {
    final repo = FakeArchiveRepository()..error = ApiError('records.busy');
    final c = archiveContainer(
      repo,
      catalog: archiveCatalog(admin: true, seats: {}),
    );
    final r = await c
        .read(archiveControllerProvider.notifier)
        .downloadAll('Arşiv.zip');
    expect(r.ok, isFalse);
    expect(r.error?.code, 'records.busy');
  });
}
