// ArchiveActionsController: ZIP (klasör / görünen seçim, 100 sınırı), dosya indirme, silme ve
// yükleme (seçici, tür/boyut ön denetimi, departman, yeniden okuma; belirsiz sonuçta seçicisiz
// "Yeniden dene" aynı niyet ve aynı anahtarla).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
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

    test('seçilen dosya (kaynak seçiciye geçer) göreve, etiketle, klasör departmanıyla', () async {
      final repo = FakeArchiveRepository();
      final picker = FakePicker(src('rapor.pdf'));
      final c = archiveContainer(repo, picker: picker);
      final r = await _ctrl(c).upload(
        workItemId: 'w2',
        tag: RecordTag.cikti,
        origin: UploadOrigin.photos,
      );
      expect(r.ok, isTrue);
      expect(picker.origins, [UploadOrigin.photos]);
      expect(repo.calls.firstWhere((x) => x.$1 == 'attach'), (
        'attach',
        'd1',
        ('w2', RecordTag.cikti, 'rapor.pdf'),
      ));
    });

    test('vazgeçme: istek yok', () async {
      final repo = FakeArchiveRepository();
      final c = archiveContainer(repo, picker: FakePicker());
      final r = await _ctrl(c).upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      expect((r.ok, r.error), (false, null));
      expect(repo.calls.where((x) => x.$1 == 'attach'), isEmpty);
    });

    test('izinli olmayan tür ve 90 MiB: istek gönderilmeden hata', () async {
      final repo = FakeArchiveRepository();
      final picker = FakePicker(src('not.txt'));
      final c = archiveContainer(repo, picker: picker);
      final ctrl = _ctrl(c);
      final a = await ctrl.upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      expect(a.error?.code, 'records.content_rejected');
      picker.next = src('b.pdf', size: uploadMaxBytes);
      final b = await ctrl.upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      expect(b.error?.code, 'records.too_large');
      expect(repo.calls.where((x) => x.$1 == 'attach'), isEmpty);
    });

    // Codex tur 1 / 7 (istemci akışları §8): işlem anahtarı niyet başına bir kez.
    test(
      'sonuç bilinmiyor: niyet saklanır, aynı niyetin tekrarı aynı anahtar',
      () async {
        final repo = FakeArchiveRepository()
          ..attachErrors.add(ApiError(ClientErrorCode.timeout));
        final c = archiveContainer(repo, picker: FakePicker(src('rapor.pdf')));
        final ctrl = _ctrl(c);
        Future<ArchiveOutcome> send() => ctrl.upload(
          workItemId: 'w1',
          tag: RecordTag.plan,
          origin: UploadOrigin.files,
        );
        final a = await send();
        expect(a.error?.code, ClientErrorCode.outcomeUnknown);
        final pending = ctrl.pendingUploadKey;
        expect(pending, repo.attachKeys.single);
        final b = await send();
        expect(b.ok, isTrue);
        expect(repo.attachKeys, [pending, pending]);
        // Başarı niyeti düşürür: aynı dosyanın yeni gönderimi yeni eylemdir.
        expect(ctrl.pendingUploadKey, isNull);
        await send();
        expect(repo.attachKeys.last, isNot(pending));
      },
    );

    test('conflict_retry aynı anahtarla tek kez yeniden denenir', () async {
      final repo = FakeArchiveRepository()
        ..attachErrors.add(ApiError(conflictRetryCode, status: 409));
      final c = archiveContainer(repo, picker: FakePicker(src('rapor.pdf')));
      final ctrl = _ctrl(c);
      final r = await ctrl.upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      expect(r.ok, isTrue);
      expect(repo.attachKeys, hasLength(2));
      expect(repo.attachKeys.toSet(), hasLength(1));

      // İkinci 409 kullanıcıya gösterilir; üçüncü deneme yok.
      repo
        ..attachKeys.clear()
        ..attachErrors.addAll([
          ApiError(conflictRetryCode, status: 409),
          ApiError(conflictRetryCode, status: 409),
        ]);
      final e = await ctrl.upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      expect(e.error?.code, conflictRetryCode);
      expect(repo.attachKeys, hasLength(2));
    });

    test('farklı dosya yeni anahtar; key_reused niyeti düşürür', () async {
      final repo = FakeArchiveRepository()
        ..attachErrors.addAll([
          ApiError(ClientErrorCode.networkError),
          ApiError(ClientErrorCode.networkError),
        ]);
      final picker = FakePicker(src('a.pdf'));
      final c = archiveContainer(repo, picker: picker);
      final ctrl = _ctrl(c);
      await ctrl.upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      picker.next = src('b.pdf');
      await ctrl.upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      expect(repo.attachKeys.toSet(), hasLength(2));

      repo.attachErrors.add(
        ApiError('records.idempotency_key_reused', status: 409),
      );
      final r = await ctrl.upload(
        workItemId: 'w1',
        tag: RecordTag.plan,
        origin: UploadOrigin.files,
      );
      expect(r.error?.code, ClientErrorCode.requestNotResent);
      expect(ctrl.pendingUploadKey, isNull);
    });

    // Codex tur 2 / N2: gerçek seçici her seçimde yeni geçici yol döndürür; "Yeniden dene"
    // seçiciyi açmadan saklanan niyeti aynı anahtarla gönderir.
    test(
      'belirsiz sonuç → yeniden dene seçicisiz, aynı yol ve aynı anahtar',
      () async {
        final repo = FakeArchiveRepository()
          ..attachErrors.addAll([
            ApiError(ClientErrorCode.timeout),
            ApiError(ClientErrorCode.networkError),
          ]);
        final picker = _FreshPathPicker();
        final c = archiveContainer(repo, picker: picker);
        final ctrl = _ctrl(c);
        expect((await ctrl.retryUpload()).ok, isFalse, reason: 'niyet yok');
        final a = await ctrl.upload(
          workItemId: 'w1',
          tag: RecordTag.plan,
          origin: UploadOrigin.files,
        );
        expect(a.error?.code, ClientErrorCode.outcomeUnknown);
        expect(ctrl.hasPendingUpload, isTrue);
        final key = repo.attachKeys.single;
        final b = await ctrl.retryUpload();
        expect(b.error?.code, ClientErrorCode.outcomeUnknown);
        final ok = await ctrl.retryUpload();
        expect(ok.ok, isTrue);
        expect(picker.picks, 1, reason: 'yeniden dene seçiciyi açmaz');
        expect(repo.attachKeys, [key, key, key]);
        expect(repo.attachPaths.toSet(), {'/tmp/1/rapor.pdf'});
        expect(ctrl.hasPendingUpload, isFalse);
        expect(ctrl.pendingUploadKey, isNull);
      },
    );

    test('belirsiz sonuç sonrası aynı dosyanın yeniden seçimi (yeni yol) aynı '
        'anahtar; farklı ad ya da boyut yeni anahtar', () async {
      final repo = FakeArchiveRepository()
        ..attachErrors.addAll([
          for (var i = 0; i < 4; i++) ApiError(ClientErrorCode.timeout),
        ]);
      final picker = _FreshPathPicker();
      final c = archiveContainer(repo, picker: picker);
      final ctrl = _ctrl(c);
      Future<String> pickAndSend({
        String name = 'rapor.pdf',
        int size = 10,
      }) async {
        picker
          ..name = name
          ..size = size;
        final r = await ctrl.upload(
          workItemId: 'w1',
          tag: RecordTag.plan,
          origin: UploadOrigin.files,
        );
        expect(r.error?.code, ClientErrorCode.outcomeUnknown);
        return repo.attachKeys.last;
      }

      final first = await pickAndSend();
      expect(await pickAndSend(), first);
      expect(repo.attachPaths.toSet(), hasLength(2), reason: 'yeni geçici yol');
      expect(await pickAndSend(size: 11), isNot(first));
      expect(await pickAndSend(name: 'plan.pdf'), isNot(first));
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

/// Gerçek seçici gibi her seçimde yeni geçici yol döndürür (`/tmp/<n>/rapor.pdf`).
class _FreshPathPicker implements UploadPicker {
  int picks = 0;
  String name = 'rapor.pdf';
  int size = 10;

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async =>
      UploadSource(path: '/tmp/${++picks}/$name', name: name, sizeBytes: size);
}
