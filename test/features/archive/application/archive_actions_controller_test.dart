// ArchiveActionsController: ZIP (klasör / görünen seçim, 100 sınırı), dosya indirme, silme ve
// yükleme (seçici, tür/boyut ön denetimi, departman, yeniden okuma; belirsiz sonuçta seçicisiz
// "Yeniden dene" aynı niyet ve aynı anahtarla; niyet imzasında içerik özeti: gönderimde, ön
// denetimden sonra, okunamayan dosyada hata, denetleyici kapanınca yok sayılır).
import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/archive/application/archive_actions_controller.dart';
import 'package:nizamio/features/archive/application/archive_files_controller.dart';
import 'package:nizamio/features/archive/application/archive_folder_controller.dart';
import 'package:nizamio/features/archive/domain/records.dart';
import 'package:nizamio/features/tasks/data/upload_digest.dart';
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

  test('etiket değişimi sunucuda; aynı etiket istek göndermez', () async {
    final repo = FakeArchiveRepository();
    final c = archiveContainer(repo);
    final ctrl = _ctrl(c);
    final same = await ctrl.retagFile(archiveFile('f1'), RecordTag.plan);
    expect(same.ok, isFalse);
    expect(repo.calls.where((x) => x.$1 == 'retag'), isEmpty);
    final r = await ctrl.retagFile(archiveFile('f1'), RecordTag.sonuc);
    expect(r.ok, isTrue);
    expect(repo.calls.firstWhere((x) => x.$1 == 'retag'), (
      'retag',
      'd1',
      ('f1', RecordTag.sonuc),
    ));
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

    test('kamera: kaynak seçiciye geçer; vazgeçme istek atmaz, izin reddi açık hata', () async {
      final repo = FakeArchiveRepository();
      final picker = _CameraPicker(src('IMG_20260307_090504.jpg'));
      final c = archiveContainer(repo, picker: picker);
      final ctrl = _ctrl(c);
      Future<ArchiveOutcome> shoot() => ctrl.upload(
        workItemId: 'w2',
        tag: RecordTag.plan,
        origin: UploadOrigin.camera,
      );
      expect((await shoot()).ok, isTrue);
      expect(repo.calls.where((x) => x.$1 == 'attach').single.$3, (
        'w2',
        RecordTag.plan,
        'IMG_20260307_090504.jpg',
      ));
      picker.next = null;
      final cancelled = await shoot();
      expect((cancelled.ok, cancelled.error), (false, null));
      picker.error = ApiError(ClientErrorCode.cameraPermissionDenied);
      expect(
        (await shoot()).error?.code,
        ClientErrorCode.cameraPermissionDenied,
      );
      expect(picker.origins.toSet(), {UploadOrigin.camera});
      expect(repo.calls.where((x) => x.$1 == 'attach'), hasLength(1));
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

    test(
      'izinli olmayan tür ve 90 MiB: özet okunmadan, istek gönderilmeden hata',
      () async {
        final repo = FakeArchiveRepository();
        final picker = FakePicker(src('not.txt'));
        final digest = _CountingDigest();
        final c = archiveContainer(repo, picker: picker, digest: digest.call);
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
        expect(digest.reads, 0, reason: 'sınır dışı dosyada okuyucu açılmaz');
        expect(repo.calls.where((x) => x.$1 == 'attach'), isEmpty);
      },
    );

    // Codex tur 4 / N7: seçimden sonra silinen ya da okunamayan dosya kullanıcıya gösterilen
    // hatadır; istek gönderilmez, bekleyen niyet ve anahtar bozulmaz.
    test(
      'okunamayan dosya: client.file_unreadable, istek yok, niyet korunur',
      () async {
        final repo = FakeArchiveRepository()
          ..attachErrors.add(ApiError(ClientErrorCode.timeout));
        final picker = _FreshPathPicker();
        addTearDown(picker.dispose);
        final c = archiveContainer(repo, picker: picker, digest: uploadDigest);
        final ctrl = _ctrl(c);
        Future<ArchiveOutcome> send() => ctrl.upload(
          workItemId: 'w1',
          tag: RecordTag.plan,
          origin: UploadOrigin.files,
        );
        expect((await send()).error?.code, ClientErrorCode.outcomeUnknown);
        final key = ctrl.pendingUploadKey;
        picker.deleteNext = true;
        final r = await send();
        expect((r.ok, r.error?.code), (false, ClientErrorCode.fileUnreadable));
        expect(repo.attachKeys, [key], reason: 'istek gönderilmedi');
        expect((ctrl.hasPendingUpload, ctrl.pendingUploadKey), (true, key));
        expect((await ctrl.retryUpload()).ok, isTrue);
        expect(repo.attachKeys, [key, key]);
      },
    );

    // Codex tur 4 / N8: başlamış özet denetleyici kapanınca yok sayılır, okuma durur.
    test('denetleyici kapanınca özet sonucu yok sayılır, istek yok', () async {
      final repo = FakeArchiveRepository();
      final digest = _CountingDigest()..gate = Completer<void>();
      final c = archiveContainer(
        repo,
        picker: FakePicker(src('rapor.pdf')),
        digest: digest.call,
      );
      final sub = c.listen(archiveActionsControllerProvider('d1'), (_, _) {});
      final pending = c
          .read(archiveActionsControllerProvider('d1').notifier)
          .upload(
            workItemId: 'w1',
            tag: RecordTag.plan,
            origin: UploadOrigin.files,
          );
      await pumpEventQueue();
      expect(digest.reads, 1);
      sub.close();
      await pumpEventQueue();
      digest.gate!.complete();
      final r = await pending;
      expect((r.ok, r.error), (false, null));
      expect(digest.cancelled, isTrue);
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
        addTearDown(picker.dispose);
        final digest = _CountingDigest(uploadDigest);
        final c = archiveContainer(repo, picker: picker, digest: digest.call);
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
        expect(digest.reads, 1, reason: 'saklanan niyetin özeti kullanılır');
        expect(repo.attachKeys, [key, key, key]);
        expect(repo.attachPaths.toSet(), {'${picker.dir.path}/1/rapor.pdf'});
        expect(ctrl.hasPendingUpload, isFalse);
        expect(ctrl.pendingUploadKey, isNull);
      },
    );

    // Codex tur 3 / N5: sunucu yükleme tekrarını gövde okumadan metadata'dan tanır (§8);
    // A kaydedilip yanıtı kaybolduktan sonra aynı ad/boyutlu farklı içerikli B eski anahtarla
    // gitse yüklenmeden başarı sayılırdı. İmzadaki içerik özeti B'yi yeni niyet yapar.
    test('belirsiz sonuç sonrası aynı içeriğin yeniden seçimi (yeni yol) aynı '
        'anahtar; farklı ad, boyut ya da aynı ad/boyutta farklı içerik yeni '
        'anahtar', () async {
      final repo = FakeArchiveRepository()
        ..attachErrors.addAll([
          for (var i = 0; i < 5; i++) ApiError(ClientErrorCode.timeout),
        ]);
      final picker = _FreshPathPicker();
      addTearDown(picker.dispose);
      final c = archiveContainer(repo, picker: picker, digest: uploadDigest);
      final ctrl = _ctrl(c);
      Future<String> pickAndSend({
        String name = 'rapor.pdf',
        int size = 10,
        List<int> content = _contentA,
      }) async {
        picker
          ..name = name
          ..size = size
          ..content = content;
        final r = await ctrl.upload(
          workItemId: 'w1',
          tag: RecordTag.plan,
          origin: UploadOrigin.files,
        );
        expect(r.error?.code, ClientErrorCode.outcomeUnknown);
        return repo.attachKeys.last;
      }

      // A sunucuya kaydedildi, yanıt kayboldu (sahte depo çağrıyı kaydedip zaman aşımı döner).
      final first = await pickAndSend();
      expect(await pickAndSend(), first);
      expect(repo.attachPaths.toSet(), hasLength(2), reason: 'yeni geçici yol');
      final b = await pickAndSend(content: _contentB);
      expect(b, isNot(first), reason: 'aynı ad/boyut, farklı içerik');
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

/// Aynı uzunlukta (aynı bildirilen boyut) iki farklı içerik.
const _contentA = [37, 80, 68, 70, 1];
const _contentB = [37, 80, 68, 70, 2];

/// Gerçek seçici gibi her seçimde yeni geçici yola ([dir]`/<n>/<ad>`) [content] yazar (özet
/// gönderimde, testin verdiği özetleyiciyle). [deleteNext]: sonraki seçim dosyayı seçimden
/// sonra siler (okunamayan dosya).
class _FreshPathPicker implements UploadPicker {
  final dir = Directory.systemTemp.createTempSync('archive_upload_');
  int picks = 0;
  String name = 'rapor.pdf';
  int size = 10;
  List<int> content = _contentA;
  bool deleteNext = false;

  void dispose() => dir.deleteSync(recursive: true);

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async {
    final f = File('${dir.path}/${++picks}/$name')
      ..createSync(recursive: true)
      ..writeAsBytesSync(content);
    if (deleteNext) f.deleteSync();
    deleteNext = false;
    return UploadSource(path: f.path, name: name, sizeBytes: size);
  }
}

/// Sayan özetleyici: [inner] varsa ona devreder (yoksa yola bağlı sahte); [gate] doluysa
/// tamamlanmasını bekler, sonra iptal sorusunun yanıtını [cancelled]'a yazar.
class _CountingDigest {
  _CountingDigest([this.inner = pathDigest]);

  final UploadDigest inner;
  int reads = 0;
  Completer<void>? gate;
  bool? cancelled;

  Future<String?> call(
    String path, {
    required bool Function() cancelled,
  }) async {
    reads++;
    await gate?.future;
    final stop = this.cancelled = cancelled();
    if (stop) return null;
    return inner(path, cancelled: cancelled);
  }
}

final class _CameraPicker implements UploadPicker {
  _CameraPicker(this.next);

  UploadSource? next;
  ApiError? error;
  final origins = <UploadOrigin>[];

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async {
    origins.add(origin);
    if (error case final e?) throw e;
    return next;
  }
}
