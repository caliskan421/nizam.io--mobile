// Görev ayrıntısı yüklemesinin içerik özeti (Codex tur 4 / N7, N8) — gerçek bileşim kökü ve
// HTTP yığını, sahte sunucu: özet seçimde DEĞİL gönderimde ve tür/boyut ön denetiminden sonra
// okunur; okunamayan dosya kullanıcıya gösterilen hatadır (istek yok, anahtar ve seçim
// bozulmaz); seçici hatası önceki seçimi korur; denetleyici kapanınca özet sonucu yok sayılır;
// sonucu bilinmeyen yüklemenin aynı taslakla tekrarı özeti yeniden okumaz. Uçuş kilidi özetten
// önce kurulur, taslak nesli form kapanınca/yeniden açılınca eski gönderimi geçersiz kılar
// (Codex tur 5 / N10).
import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/data/upload_digest.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../task_detail_server.dart';

const _files = '/v1/work-items/w1/files';

/// Sayan özetleyici: gerçek [uploadDigest]'e devreder; [gate] doluysa önce onu bekler ve iptal
/// sorusunun yanıtını [cancelled]'a yazar.
class _Digest {
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
    return uploadDigest(path, cancelled: cancelled);
  }
}

/// Önceden belirlenmiş seçim ya da hata döndüren seçici.
class _Picker implements UploadPicker {
  UploadSource? next;
  ApiError? error;

  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async {
    if (error case final e?) throw e;
    return next;
  }
}

typedef _Open = ({
  TaskDetailServer server,
  Harness h,
  ProviderContainer c,
  TaskDetailController ctl,
  ProviderSubscription<TaskDetailState> sub,
});

/// [ok] false → yükleme isteği zaman aşımı (sonuç bilinmiyor); true → varsayılan başarı.
Future<_Open> _open(_Digest digest, _Picker picker, {bool ok = false}) async {
  final server = TaskDetailServer();
  if (!ok) server.writes['POST $_files'] = () => timeout(null);
  final h = await pilotHarness(PilotBackend(), signedIn: true);
  h.backend.handler = server.handle;
  h.composition.locator
    ..unregister<UploadPicker>()
    ..registerSingleton<UploadPicker>(picker)
    ..unregister<UploadDigest>()
    ..registerSingleton<UploadDigest>(digest.call);
  final c = h.container;
  h.read(scopeControllerProvider).selectProgram('prog-1');
  c
    ..listen(taskCatalogControllerProvider, (_, _) {})
    ..listen(taskDetailsProvider('w1'), (_, _) {});
  final sub = c.listen(taskDetailControllerProvider('w1'), (_, _) {});
  await c.read(taskCatalogControllerProvider.future);
  await c.read(taskDetailsProvider('w1').future);
  h.backend.requests.clear();
  final ctl = c.read(taskDetailControllerProvider('w1').notifier)..openUpload();
  return (server: server, h: h, c: c, ctl: ctl, sub: sub);
}

int _posts(Harness h) => h.backend.count('POST', _files);

List<String?> _keys(Harness h) => [
  for (final r in h.backend.requests)
    if (r.method == 'POST' && r.path == _files) r.header('Idempotency-Key'),
];

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('nz_up_digest_'));
  tearDown(() => dir.deleteSync(recursive: true));

  /// [dir] altında [sub]/[name] dosyası ([content]); [exists] false → dosya yazılmaz.
  UploadSource src(
    String sub,
    String name, {
    int size = 4,
    bool exists = true,
  }) {
    final f = File('${dir.path}/$sub/$name');
    if (exists) {
      f
        ..createSync(recursive: true)
        ..writeAsBytesSync(const [37, 80, 68, 70]);
    }
    return UploadSource(path: f.path, name: name, sizeBytes: size);
  }

  void choose(TaskDetailController ctl, ProviderContainer c, UploadSource f) {
    final d = c.read(taskDetailControllerProvider('w1')).upload!;
    ctl.updateUpload(d.copyWith(file: () => f));
  }

  test('tür ya da boyut sınır dışı: özet okunmaz, istek yok', () async {
    final digest = _Digest();
    final o = await _open(digest, _Picker());
    choose(o.ctl, o.c, src('1', 'not.txt'));
    expect(
      (await o.ctl.submitUpload()).error?.code,
      'records.content_rejected',
    );
    choose(o.ctl, o.c, src('2', 'b.pdf', size: uploadMaxBytes));
    expect((await o.ctl.submitUpload()).error?.code, 'records.too_large');
    expect(digest.reads, 0, reason: 'sınır dışı dosyada okuyucu açılmaz');
    expect(_posts(o.h), 0);
  });

  test(
    'okunamayan dosya: client.file_unreadable, istek yok; bekleyen anahtar ve '
    'seçim korunur; aynı taslağın tekrarı özeti yeniden okumaz',
    () async {
      final digest = _Digest();
      final o = await _open(digest, _Picker());
      final a = src('1', 'rapor.pdf');
      choose(o.ctl, o.c, a);
      expect((await o.ctl.submitUpload()).kind, WriteKind.unknown);
      final key = _keys(o.h).single;
      // Yeniden dene (aynı taslak): saklanan niyetin özeti, aynı anahtar.
      expect((await o.ctl.submitUpload()).kind, WriteKind.unknown);
      expect(digest.reads, 1);
      expect(_keys(o.h), [key, key]);

      final gone = src('2', 'rapor.pdf', exists: false);
      choose(o.ctl, o.c, gone);
      final r = await o.ctl.submitUpload();
      expect(
        (r.kind, r.error?.code),
        (WriteKind.failed, ClientErrorCode.fileUnreadable),
      );
      expect(_posts(o.h), 2, reason: 'istek gönderilmedi');
      final st = o.c.read(taskDetailControllerProvider('w1'));
      expect(st.upload?.file, same(gone), reason: 'seçim tutarlı kalır');
      expect(
        st.keys.pending('upload'),
        key,
        reason: 'bekleyen anahtar bozulmaz',
      );

      // Aynı içeriğin yeniden seçimi (yeni yol): özet yeniden okunur, imza aynı → aynı anahtar.
      choose(o.ctl, o.c, src('3', 'rapor.pdf'));
      expect((await o.ctl.submitUpload()).kind, WriteKind.unknown);
      expect(_keys(o.h).last, key);
    },
  );

  test('seçici hatası: failed, önceki seçim korunur', () async {
    final picker = _Picker();
    final o = await _open(_Digest(), picker);
    final a = src('1', 'rapor.pdf');
    picker.next = a;
    expect((await o.ctl.pickUploadFile(UploadOrigin.files)).ok, isTrue);
    picker.error = ApiError(ClientErrorCode.fileUnreadable);
    final r = await o.ctl.pickUploadFile(UploadOrigin.photos);
    expect(
      (r.kind, r.error?.code),
      (WriteKind.failed, ClientErrorCode.fileUnreadable),
    );
    expect(o.c.read(taskDetailControllerProvider('w1')).upload?.file, same(a));
    expect(o.h.backend.requests, isEmpty);
  });

  test('denetleyici kapanınca özet sonucu yok sayılır, istek yok', () async {
    final digest = _Digest()..gate = Completer<void>();
    final o = await _open(digest, _Picker());
    choose(o.ctl, o.c, src('1', 'rapor.pdf'));
    final pending = o.ctl.submitUpload();
    await pumpEventQueue();
    expect(digest.reads, 1);
    o.sub.close();
    await pumpEventQueue();
    digest.gate!.complete();
    expect((await pending).kind, WriteKind.superseded);
    expect(digest.cancelled, isTrue);
    expect(_posts(o.h), 0);
  });

  group('uçuş kilidi ve taslak nesli (N10)', () {
    TaskDetailState st(_Open o) => o.c.read(taskDetailControllerProvider('w1'));

    test(
      'özet sürerken ikinci gönderim busy; ilk başarılı, tek istek',
      () async {
        final digest = _Digest()..gate = Completer<void>();
        final o = await _open(digest, _Picker(), ok: true);
        choose(o.ctl, o.c, src('1', 'rapor.pdf'));
        final first = o.ctl.submitUpload();
        await pumpEventQueue();
        expect(st(o).busy, isTrue, reason: 'kilit özetten önce');
        expect((await o.ctl.submitUpload()).kind, WriteKind.busy);
        digest.gate!.complete();
        expect((await first).ok, isTrue);
        expect(digest.reads, 1);
        expect(_posts(o.h), 1);
        expect(st(o).upload, isNull);
        expect((await o.ctl.submitUpload()).kind, WriteKind.invalid);
        expect(_posts(o.h), 1, reason: 'aynı dosya yeniden yüklenmez');
      },
    );

    test('özet sürerken form kapanır (ya da yenisi açılır): istek yok, yeni '
        'taslak bozulmaz', () async {
      final digest = _Digest()..gate = Completer<void>();
      final o = await _open(digest, _Picker(), ok: true);
      choose(o.ctl, o.c, src('1', 'rapor.pdf'));
      final pending = o.ctl.submitUpload();
      await pumpEventQueue();
      o.ctl
        ..closeForms()
        ..openUpload();
      final b = src('2', 'yeni.pdf');
      choose(o.ctl, o.c, b);
      digest.gate!.complete();
      expect((await pending).kind, WriteKind.superseded);
      expect(digest.cancelled, isTrue, reason: 'okuma durdu');
      expect(_posts(o.h), 0);
      expect(st(o).upload?.file, same(b));
      expect(st(o).busy, isFalse);
    });

    test('özet sürerken aynı formda yeni dosya seçilir: superseded, istek yok, '
        'yeni seçim korunur (N12)', () async {
      final digest = _Digest()..gate = Completer<void>();
      final picker = _Picker();
      final o = await _open(digest, picker, ok: true);
      choose(o.ctl, o.c, src('1', 'rapor.pdf'));
      final pending = o.ctl.submitUpload();
      await pumpEventQueue();
      final b = picker.next = src('2', 'yeni.pdf');
      expect((await o.ctl.pickUploadFile(UploadOrigin.files)).ok, isTrue);
      digest.gate!.complete();
      expect((await pending).kind, WriteKind.superseded);
      expect(_posts(o.h), 0);
      expect(st(o).upload?.file, same(b));
    });

    test('istek uçuştayken kapatılıp yeni taslak açılır: eski başarı yeni '
        'taslağı temizlemez', () async {
      final o = await _open(_Digest(), _Picker(), ok: true);
      final hold = o.server.hold = Completer<void>();
      // İstek sunucuya ulaşınca haber verilir (özet gerçek dosyayı okur; süre belirsiz).
      final arrived = Completer<void>();
      final inner = o.h.backend.handler;
      o.h.backend.handler = (r) {
        if (r.method == 'POST' && r.path == _files) arrived.complete();
        return inner(r);
      };
      choose(o.ctl, o.c, src('1', 'rapor.pdf'));
      final pending = o.ctl.submitUpload();
      await arrived.future;
      expect(_posts(o.h), 1);
      o.ctl
        ..closeForms()
        ..openUpload();
      final b = src('2', 'yeni.pdf');
      choose(o.ctl, o.c, b);
      hold.complete();
      expect((await pending).ok, isTrue);
      expect(st(o).upload?.file, same(b));
      expect(st(o).tab, isNot(TaskDetailTab.files));
    });
  });
}
