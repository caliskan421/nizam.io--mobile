// ArchiveActionsController: ZIP (klasör / görünen seçim, 100 sınırı), dosya indirme, silme ve
// yükleme (seçici, tür/boyut ön denetimi, departman, yeniden okuma).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/features/archive/application/archive_actions_controller.dart';
import 'package:nizamio/features/archive/application/archive_files_controller.dart';
import 'package:nizamio/features/archive/application/archive_folder_controller.dart';
import 'package:nizamio/features/archive/domain/records.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';

import '../archive_fixture.dart';

ArchiveActionsController _ctrl(ProviderContainer c, [String code = 'd1']) {
  c
    ..listen(archiveFolderControllerProvider(code), (_, _) {})
    ..listen(archiveFilesControllerProvider(code), (_, _) {})
    ..listen(archiveActionsControllerProvider(code), (_, _) {});
  return c.read(archiveActionsControllerProvider(code).notifier);
}

ArchiveFolderController _view(ProviderContainer c, [String code = 'd1']) =>
    c.read(archiveFolderControllerProvider(code).notifier);

void main() {
  test('ZIP: süzgeçsiz klasörün tamamı (klasör departmanı)', () async {
    final repo = FakeArchiveRepository();
    final sink = RecordingSink();
    final c = archiveContainer(repo, sink: sink);
    final r = await _ctrl(c).downloadZip('Altyapı.zip');
    expect(r.ok, isTrue);
    expect(repo.calls.firstWhere((x) => x.$1 == 'folderZip'), (
      'folderZip',
      'd1',
      'd1',
    ));
    expect(sink.saved['Altyapı.zip'], [1, 2, 3]);
  });

  test('ZIP: süzgeçliyken yüklenmiş görünen dosyalar seçimle', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(repo);
    final ctrl = _ctrl(c);
    _view(c).setTag(RecordTag.plan);
    await c.read(archiveFilesControllerProvider('d1').future);
    final r = await ctrl.downloadZip('x.zip');
    expect(r.ok, isTrue);
    final zip = repo.calls.firstWhere((x) => x.$1 == 'selectionZip');
    expect(zip.$3, ['f1', 'f2', 'f3']);
  });

  test(
    'ZIP: görünen dosya yok → vazgeçme; 100+ → too_many_files, istek yok',
    () async {
      final repo = FakeArchiveRepository()..pages = {null: PageSlice.empty()};
      final c = archiveContainer(repo);
      final ctrl = _ctrl(c);
      _view(c).setTag(RecordTag.plan);
      await c.read(archiveFilesControllerProvider('d1').future);
      final empty = await ctrl.downloadZip('x.zip');
      expect((empty.ok, empty.error), (false, null));

      repo.pages = {
        null: PageSlice(
          items: [for (var i = 0; i < 101; i++) archiveFile('f$i')],
        ),
      };
      _view(c).setTag(RecordTag.sonuc);
      await c.read(archiveFilesControllerProvider('d1').future);
      final r = await ctrl.downloadZip('x.zip');
      expect(r.error?.code, 'records.too_many_files');
      expect(repo.calls.where((x) => x.$1 == 'selectionZip'), isEmpty);
    },
  );

  test('dosya indirme görünen adla kaydedilir; hata sonuçta', () async {
    final repo = FakeArchiveRepository();
    final sink = RecordingSink();
    final c = archiveContainer(repo, sink: sink);
    final ctrl = _ctrl(c);
    final r = await ctrl.downloadFile(archiveFile('f1'));
    expect(r.path, '/indirilenler/f1.pdf');
    expect(repo.calls.firstWhere((x) => x.$1 == 'file'), ('file', 'd1', 'f1'));
    repo.error = ApiError('records.file_not_found');
    final e = await ctrl.downloadFile(archiveFile('f1'));
    expect(e.error?.code, 'records.file_not_found');
    expect(c.read(archiveActionsControllerProvider('d1')), isFalse);
  });

  test('silme sunucuda; listeler yeniden okunur', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(repo);
    final ctrl = _ctrl(c);
    await c.read(archiveFilesControllerProvider('d1').future);
    final before = repo.calls.where((x) => x.$1 == 'files').length;
    final r = await ctrl.deleteFile(archiveFile('f2'));
    expect(r.ok, isTrue);
    expect(repo.calls.firstWhere((x) => x.$1 == 'delete'), (
      'delete',
      'd1',
      'f2',
    ));
    await c.read(archiveFilesControllerProvider('d1').future);
    expect(repo.calls.where((x) => x.$1 == 'files').length, before + 1);
  });

  group('yükleme', () {
    UploadSource src(String name, {int size = 10}) =>
        UploadSource(path: '/tmp/$name', name: name, sizeBytes: size);

    test('seçilen dosya göreve, etiketle, klasör departmanıyla', () async {
      final repo = FakeArchiveRepository();
      final c = archiveContainer(repo, picker: FakePicker(src('rapor.pdf')));
      final r = await _ctrl(c).upload(workItemId: 'w2', tag: RecordTag.cikti);
      expect(r.ok, isTrue);
      expect(repo.calls.firstWhere((x) => x.$1 == 'attach'), (
        'attach',
        'd1',
        ('w2', RecordTag.cikti, 'rapor.pdf'),
      ));
    });

    test('vazgeçme: istek yok', () async {
      final repo = FakeArchiveRepository();
      final c = archiveContainer(repo, picker: FakePicker());
      final r = await _ctrl(c).upload(workItemId: 'w1', tag: RecordTag.plan);
      expect((r.ok, r.error), (false, null));
      expect(repo.calls.where((x) => x.$1 == 'attach'), isEmpty);
    });

    test('izinli olmayan tür ve 90 MiB: istek gönderilmeden hata', () async {
      final repo = FakeArchiveRepository();
      final picker = FakePicker(src('not.txt'));
      final c = archiveContainer(repo, picker: picker);
      final ctrl = _ctrl(c);
      final a = await ctrl.upload(workItemId: 'w1', tag: RecordTag.plan);
      expect(a.error?.code, 'records.content_rejected');
      picker.next = src('b.pdf', size: uploadMaxBytes);
      final b = await ctrl.upload(workItemId: 'w1', tag: RecordTag.plan);
      expect(b.error?.code, 'records.too_large');
      expect(repo.calls.where((x) => x.$1 == 'attach'), isEmpty);
    });

    test('seçici yoksa başlangıç noPicker', () {
      final c = archiveContainer(
        FakeArchiveRepository(),
        picker: const UnavailableUploadPicker(),
      );
      expect(_ctrl(c).uploadStart, ArchiveUploadStart.noPicker);
    });
  });
}
