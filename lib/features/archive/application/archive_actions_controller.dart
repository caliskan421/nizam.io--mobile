import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
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

  /// [op] süren eylem kilidiyle çalışır; hata [ApiError]'a çevrilir.
  Future<ArchiveOutcome> _run(Future<ArchiveOutcome> Function() op) async {
    if (state) return _cancelled;
    state = true;
    try {
      return await op();
    } on Object catch (e) {
      return (ok: false, error: toApiError(e), path: null);
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
    final ids = [
      for (final f
          in ref.read(archiveFilesControllerProvider(code)).value?.items ??
              const <RecordFile>[])
        f.id,
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

  /// Sistem dosya seçicisi bu kurulumda var mı.
  ArchiveUploadStart get uploadStart => ref.read(uploadPickerProvider).available
      ? ArchiveUploadStart.ready
      : ArchiveUploadStart.noPicker;

  /// [workItemId] görevine [tag] etiketiyle dosya yükler: seçici açılır (vazgeçme → `ok: false`),
  /// izinli tür ve boyut istekten önce denetlenir (`records.content_rejected`,
  /// `records.too_large`; istek gönderilmez). Başarıda listeler yeniden okunur.
  Future<ArchiveOutcome> upload({
    required String workItemId,
    required RecordTag tag,
  }) => _run(() async {
    final picker = ref.read(uploadPickerProvider);
    if (!picker.available) return _cancelled;
    final file = await picker.pick();
    if (file == null || !ref.mounted) return _cancelled;
    if (file.contentType == null) throw ApiError('records.content_rejected');
    if (file.tooLarge) throw ApiError('records.too_large');
    final ctx = await _context();
    await _repo.attachFile(
      department: ctx.department,
      workItemId: workItemId,
      tag: tag,
      filePath: file.path,
      filename: file.name,
      requestKey: newRequestKey(),
    );
    _reload();
    return (ok: true, error: null, path: null);
  });

  void _reload() {
    if (!ref.mounted) return;
    ref
      ..invalidate(archiveFilesControllerProvider(code))
      ..invalidate(archiveFolderTasksProvider(code))
      ..invalidate(archiveFolderUploadersProvider(code))
      ..invalidate(archiveFoldersControllerProvider);
  }
}
