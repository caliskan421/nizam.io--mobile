import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../tasks/tasks.dart';
import '../domain/archive.dart';
import '../domain/records.dart';
import 'archive_files_controller.dart';
import 'archive_folder_controller.dart';
import 'archive_folder_sources.dart';
import 'archive_folders_controller.dart';
import 'archive_providers.dart';

part 'archive_actions_controller.g.dart';

/// Arşiv eyleminin sonucu: [ok] başarı (vazgeçme `false`, hatasız), [error] hata, [path]
/// kaydedilen dosya (indirmelerde).
typedef ArchiveOutcome = ({bool ok, ApiError? error, String? path});

const ArchiveOutcome _cancelled = (ok: false, error: null, path: null);

/// Yükleme eyleminin işlem anahtarı adı ([RequestKeys]).
const _upload = 'upload';

/// Yükleme akışının ön sonucu: seçici yok → [noPicker].
enum ArchiveUploadStart { ready, noPicker }

/// Klasörün sunucu eylemleri (indirme, ZIP, yükleme, silme); durum: eylem sürüyor mu (çift
/// dokunuş tek istek). Yazmadan sonra etkilenen listeler yeniden okunur (iyimser güncelleme
/// yok). Görünüm ve dosya listesi bu sağlayıcıya bağlı değildir (döngü yok).
@riverpod
class ArchiveActionsController extends _$ArchiveActionsController {
  @override
  bool build(String code) => false;

  ArchiveRepository get _repo => ref.read(archiveRepositoryProvider);

  /// Bekleyen yükleme anahtarı (anahtar + imza; denetleyici ömrü = klasör sayfası).
  var _keys = const RequestKeys();

  /// Sonucu bilinmeyen yüklemenin niyeti ([retryUpload] seçiciyi açmadan bunu gönderir).
  _UploadIntent? _intent;

  /// [op] süren eylem kilidiyle çalışır; hata [ApiError]'a çevrilir.
  Future<ArchiveOutcome> _run(Future<ArchiveOutcome> Function() op) async {
    if (state) return _cancelled;
    state = true;
    try {
      return await op();
    } on Object catch (e, st) {
      final error = toReportedApiError(e, st, source: ReportSource.archive);
      return (ok: false, error: error, path: null);
    } finally {
      if (ref.mounted) state = false;
    }
  }

  Future<ArchiveFolderContext> _context() async {
    final ctx = await ref.read(archiveFolderContextProvider(code).future);
    if (ctx == null) throw ApiError('records.not_authorized');
    return ctx;
  }

  Future<ArchiveOutcome> _save(String name, Stream<List<int>> bytes) async {
    final path = await ref.read(downloadSinkProvider).save(name, bytes);
    return (ok: true, error: null, path: path);
  }

  /// ZIP: süzgeç yoksa klasörün tamamı (`archiveFolderZip`), varsa yüklenmiş görünen dosyalar
  /// (`archiveSelectionZip`, en çok 100; fazlası istek gönderilmeden `records.too_many_files`).
  /// Görünen dosya yoksa vazgeçme. [name] kayıt adı.
  Future<ArchiveOutcome> downloadZip(String name) => _run(() async {
    final ctx = await _context();
    final view = ref.read(archiveFolderControllerProvider(code));
    if (!view.filtered) {
      return _save(
        name,
        await _repo.downloadFolderZip(
          ctx.folder.code,
          department: ctx.department,
        ),
      );
    }
    final files = ref.read(archiveFilesControllerProvider(code));
    if (files.isLoading || files.hasError) return _cancelled;
    final ids = [
      for (final f in files.value?.items ?? const <RecordFile>[]) f.id,
    ];
    if (ids.isEmpty) return _cancelled;
    if (ids.length > RecordsDownloadTargets.maxSelection) {
      throw ApiError('records.too_many_files');
    }
    return _save(
      name,
      await _repo.downloadSelectionZip(ids, department: ctx.department),
    );
  });

  /// Tek dosyayı akışla indirip kaydeder.
  Future<ArchiveOutcome> downloadFile(RecordFile file) => _run(() async {
    final ctx = await _context();
    return _save(
      file.displayName,
      await _repo.downloadFile(file.id, department: ctx.department),
    );
  });

  /// Dosyayı siler (sunucu yalnız yükleyene izin verir); listeler yeniden okunur.
  Future<ArchiveOutcome> deleteFile(RecordFile file) => _run(() async {
    final ctx = await _context();
    await _repo.deleteFile(file.id, department: ctx.department);
    _reload();
    return (ok: true, error: null, path: null);
  });

  /// Etiketi değiştirir; aynı etiket ya da bilinmeyen değer istek göndermez (vazgeçme).
  /// Başarıda listeler yeniden okunur.
  Future<ArchiveOutcome> retagFile(RecordFile file, RecordTag tag) =>
      _run(() async {
        if (tag == file.tag || tag == RecordTag.unknown) return _cancelled;
        final ctx = await _context();
        await _repo.retagFile(file.id, tag, department: ctx.department);
        _reload();
        return (ok: true, error: null, path: null);
      });

  /// Sistem dosya seçicisi bu kurulumda var mı.
  ArchiveUploadStart get uploadStart => ref.read(uploadPickerProvider).available
      ? ArchiveUploadStart.ready
      : ArchiveUploadStart.noPicker;

  /// [workItemId] görevine [tag] etiketiyle dosya yükler: [origin] seçicisi (fotoğraflar /
  /// dosyalar) açılır (vazgeçme → `ok: false`), izinli tür ve boyut istekten önce, içerik
  /// okunmadan denetlenir (`records.content_rejected`, `records.too_large`; istek gönderilmez).
  /// İçerik özeti YALNIZ bunlardan sonra okunur; denetleyici kapanırsa okuma durur, sonuç yok
  /// sayılır; okunamayan dosya `client.file_unreadable`. Başarıda listeler yeniden okunur.
  ///
  /// İşlem anahtarı (istemci akışları §8, görev ayrıntısındaki yüklemeyle aynı kural): niyet
  /// (kapsam, görev, etiket, dosya adı, boyutu ve içerik özeti) başına bir anahtar. Geçici
  /// dosya yolu imzada yoktur: gerçek seçici yeniden seçimde yeni geçici yol döndürür, aynı
  /// içeriğin yeniden seçimi aynı anahtarı taşır. İçerik özeti (`uploadDigesterProvider`)
  /// imzadadır: sunucu tekrarı gövde okumadan metadata'dan tanır, aynı ad/boyutlu farklı içerik
  /// eski anahtarla gitse yüklenmeden başarı sayılırdı; özet onu yeni niyet yapar. Sonuç
  /// bilinmezse (`client.outcome_unknown`) niyet (özetiyle) ve anahtarı saklanır;
  /// [retryUpload] seçiciyi açmadan ve özeti yeniden hesaplamadan aynı niyeti AYNI anahtarla
  /// gönderir. `platform.conflict_retry` aynı anahtarla bir kez otomatik yeniden denenir. Başarı ve "anahtar başka istekle kullanılmış" niyeti düşürür; bekleyen
  /// anahtar denetleyici ömrü (klasör sayfası) boyunca kalır.
  Future<ArchiveOutcome> upload({
    required String workItemId,
    required RecordTag tag,
    required UploadOrigin origin,
  }) => _run(() async {
    final picker = ref.read(uploadPickerProvider);
    if (!picker.available) return _cancelled;
    final file = await picker.pick(origin);
    if (file == null || !ref.mounted) return _cancelled;
    if (file.contentType == null) throw ApiError('records.content_rejected');
    if (file.tooLarge) throw ApiError('records.too_large');
    final digest = await ref.read(uploadDigesterProvider)(
      file.path,
      cancelled: () => !ref.mounted,
    );
    if (digest == null || !ref.mounted) return _cancelled;
    final ctx = await _context();
    return _send((
      department: ctx.department,
      workItemId: workItemId,
      tag: tag,
      file: file,
      digest: digest,
    ));
  });

  /// Sonucu bilinmeyen yüklemeyi seçici açmadan aynı niyet ve aynı anahtarla yeniden gönderir;
  /// bekleyen niyet yoksa vazgeçme.
  Future<ArchiveOutcome> retryUpload() => _run(() async {
    final intent = _intent;
    return intent == null ? _cancelled : _send(intent);
  });

  /// Seçici açmadan gönderilebilecek, sonucu bilinmeyen yükleme var mı.
  bool get hasPendingUpload => _intent != null;

  Future<ArchiveOutcome> _send(_UploadIntent i) async {
    final f = i.file;
    final (keys, key) = _keys.keyFor(
      _upload,
      '${i.department}|${i.workItemId}|${i.tag.name}|${f.name}|${f.sizeBytes}|'
      '${i.digest}',
    );
    _keys = keys;
    _intent = null;
    Future<void> send() => _repo.attachFile(
      department: i.department,
      workItemId: i.workItemId,
      tag: i.tag,
      filePath: f.path,
      filename: f.name,
      requestKey: key,
    );
    try {
      try {
        await send();
      } on ApiError catch (e, st) {
        reportUnexpected(e, st, source: ReportSource.archive);
        if (e.code != conflictRetryCode) rethrow;
        await send();
      }
    } on Object catch (e, st) {
      final err = toReportedApiError(e, st, source: ReportSource.archive);
      if (isOutcomeUnknown(err)) {
        _intent = i;
        throw ApiError(ClientErrorCode.outcomeUnknown, status: err.status);
      }
      if (isKeyReused(err)) {
        _keys = _keys.clear(_upload);
        throw ApiError(ClientErrorCode.requestNotResent, status: err.status);
      }
      rethrow;
    }
    _keys = _keys.clear(_upload);
    _reload();
    return (ok: true, error: null, path: null);
  }

  /// Bekleyen yükleme anahtarı (test ve tanılama).
  String? get pendingUploadKey => _keys.pending(_upload);

  void _reload() {
    if (!ref.mounted) return;
    ref
      ..invalidate(archiveFilesControllerProvider(code))
      ..invalidate(archiveFolderTasksProvider(code))
      ..invalidate(archiveFolderUploadersProvider(code))
      ..invalidate(archiveFoldersControllerProvider);
  }
}

/// Yükleme niyeti: kapsam (departman), görev, etiket, seçilmiş dosya kaynağı ve içerik özeti.
typedef _UploadIntent = ({
  String department,
  String workItemId,
  RecordTag tag,
  UploadSource file,
  String digest,
});
