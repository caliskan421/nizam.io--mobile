part of 'task_detail_controller.dart';

/// Kanıt yükleme formu ve gönderimi ([TaskDetailController]'ın parçası).
///
/// Uçuş kilidi (`busy`) gönderim başlar başlamaz, içerik özetinden ÖNCE kurulur: özet sürerken
/// ikinci gönderim ve diğer yazmalar [WriteKind.busy] alır. Taslağın nesli (form açma, dosya
/// seçimi ve form kapatma artırır) gönderimin başında alınır; özet bitince ve istekten hemen
/// önce nesil ve denetleyici doğrulanır: değişmişse istek gönderilmez ([WriteKind.superseded]).
/// Başarı yalnız kendi neslindeki taslağı kapatır (kapatılıp açılan yeni taslak bozulmaz).
mixin _UploadFlow on _$TaskDetailController {
  TaskItem? get _task;
  TaskPermissions get permissions;
  TaskWriteRepository get _writes;
  Future<WriteOutcome> _writeKeyed(
    String action,
    String body,
    Future<void> Function(String key) call, {
    required bool list,
  });

  final _digests = UploadDigestMemo();

  /// Yükleme taslağının nesli.
  var _uploadGen = 0;

  /// Yükleme formunu açar; alt görev önseçilmez (alt görevde kanıt bayrağı yok, ADR-0024).
  /// Sunucuda yalnız yükleme yetkisi varsa (yönetici, koordinatör ya da atanmış üye).
  bool openUpload() {
    if (_task == null || !permissions.canUpload) return false;
    _uploadGen++;
    state = state.copyWith(
      upload: () => const UploadDraft(tag: EvidenceTag.outcome, name: ''),
      showErrors: false,
    );
    return true;
  }

  void updateUpload(UploadDraft d) => state = state.copyWith(upload: () => d);

  /// Dosya seçer (içerik okunmaz): seçim → done; yok/vazgeçme → unchanged; hata → failed.
  Future<WriteOutcome> pickUploadFile(UploadOrigin origin) async {
    final picker = ref.read(uploadPickerProvider);
    if (!picker.available) return WriteOutcome.unchanged;
    final UploadSource? f;
    try {
      f = await picker.pick(origin);
    } on ApiError catch (e) {
      return WriteOutcome(WriteKind.failed, e);
    }
    final d = state.upload;
    if (f == null || d == null || !ref.mounted) return WriteOutcome.unchanged;
    _uploadGen++;
    final next = d.copyWith(file: () => f, name: f.name);
    state = state.copyWith(upload: () => next);
    return WriteOutcome.done;
  }

  /// Dosyayı yükler, Dosya sekmesine geçer. Yerel denetim (istek yok, metin koddan): seçim yok
  /// → invalid; tür dışı → `records.content_rejected`; 90 MiB → `records.too_large`; 30 dosya
  /// → `records.too_many_files`. İçerik özeti ([UploadDigestMemo]) bunlardan SONRA, uçuş
  /// kilidi altında alınır (sınır dışı dosya okunmaz). Başarıda yalnız ayrıntı okunur.
  Future<WriteOutcome> submitUpload() async {
    final t = _task;
    final d = state.upload;
    if (t == null || d == null) return WriteOutcome.invalid;
    if (!permissions.canUpload) return WriteOutcome.invalid;
    final f = d.file;
    if (f == null) {
      state = state.copyWith(showErrors: true);
      return WriteOutcome.invalid;
    }
    if (!uploadTags.contains(d.tag)) return WriteOutcome.invalid;
    if (f.contentType == null) return _rejected('records.content_rejected');
    if (f.tooLarge) return _rejected('records.too_large');
    if (t.fileEntries.length >= uploadMaxFilesPerTask) {
      return _rejected('records.too_many_files');
    }
    if (state.busy) return WriteOutcome.busy;
    final gen = _uploadGen;
    bool stale() => !ref.mounted || gen != _uploadGen;
    state = state.copyWith(busy: true);
    final String? digest;
    try {
      digest = await _digests.of(ref, f, cancelled: stale);
    } on ApiError catch (e) {
      return WriteOutcome(WriteKind.failed, e);
    } finally {
      if (ref.mounted) state = state.copyWith(busy: false);
    }
    if (digest == null || stale()) return WriteOutcome.superseded;
    // Kilit bırakıldı; [_writeKeyed] onu arada `await` olmadan, aynı adımda yeniden kurar.
    final r = await ReportContext.run(
      ReportOperation.fileUpload,
      () => _writeKeyed(
        _upload,
        // Yol imzada yok (yeniden seçim aynı anahtar); özet var: farklı içerik yeni anahtar (§8).
        '${f.name}|${f.sizeBytes}|$digest|${d.tag.name}|${d.subtask}',
        (key) => _writes.attachFile(
          t,
          f,
          d.tag,
          subtaskId: d.subtask,
          requestKey: key,
        ),
        list: false,
      ),
    );
    if (r.ok && !stale()) {
      state = state.copyWith(
        upload: () => null,
        showErrors: false,
        tab: TaskDetailTab.files,
      );
    }
    return r;
  }
}
