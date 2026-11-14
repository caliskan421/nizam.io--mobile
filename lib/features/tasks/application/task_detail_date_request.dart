part of 'task_detail_controller.dart';

/// Tarih talebi formu, açılış sürümünü formun ömrü boyunca korur.
mixin _DateRequestFlow on _$TaskDetailController {
  TaskItem? get _task;
  TaskPermissions get permissions;
  TaskWriteRepository get _writes;
  ({int session, String? program, String? department}) _writeContext();
  Future<WriteOutcome> _writeKeyed(
    String action,
    String body,
    Future<void> Function(String key) call, {
    required bool list,
  });
  Future<WriteOutcome> _write(
    Future<void> Function() call, {
    required bool list,
  });

  TaskItem? _dateBase;

  bool openDateRequest() {
    final t = _task;
    if (t == null || t.hasPendingRequest || !permissions.canRequestDate) {
      return false;
    }
    _dateBase = t;
    state = state.copyWith(
      dateDraft: () => DateRequestDraft(
        start: t.start,
        due: t.due.add(const Duration(days: 14)),
      ),
      showErrors: false,
    );
    return true;
  }

  void updateDateDraft(DateRequestDraft d) =>
      state = state.copyWith(dateDraft: () => d);

  Future<WriteOutcome> submitDateRequest() async {
    final t = _task;
    final d = state.dateDraft;
    if (t == null ||
        d == null ||
        d.datesInvalid ||
        !permissions.canRequestDate) {
      return WriteOutcome.invalid;
    }
    final base = _dateBase;
    if (base?.datesRevision == null) {
      return _rejected(ClientErrorCode.serverOutdated);
    }
    final reason = d.reason.trim();
    final body =
        '${t.id}|${d.start.toIso8601String()}|${d.due.toIso8601String()}|$reason';
    final context = _writeContext();
    final r = await _writeKeyed(
      'date_request',
      '$body|${base!.datesRevision}',
      (key) => _writes.requestDateChange(
        base,
        d.start,
        d.due,
        requestKey: key,
        reason: reason.isEmpty ? null : reason,
      ),
      list: false,
    );
    if (!ref.mounted || _writeContext() != context) return r;
    if (r.ok ||
        r.error?.code == _editConflict ||
        r.error?.code == ClientErrorCode.requestNotResent) {
      _dateBase = null;
      state = state.copyWith(keys: state.keys.clear('date_request'));
    }
    if (r.ok || r.error?.code == _editConflict) {
      state = state.copyWith(dateDraft: () => null);
    }
    return r;
  }

  // ---- karar ve silme ---------------------------------------------------------------------

  /// Bekleyen talebi onaylar (yalnız şirket yöneticisi). Onay bağımlı görevleri zincirle
  /// öteleyebilir → liste de yeniden okunur; ret yalnız kalemi etkiler.
  Future<WriteOutcome> approveRequest() => _review(approve: true);

  /// Reddeder; gerekçe istemci kuralıyla zorunludur (sunucuda isteğe bağlı, ≤ 500 karakter).
  /// Boş gerekçe istek göndermez.
  Future<WriteOutcome> rejectRequest(String reason) {
    final r = reason.trim();
    if (r.isEmpty || r.length > 500) return Future.value(WriteOutcome.invalid);
    return _review(approve: false, reason: r);
  }

  Future<WriteOutcome> _review({required bool approve, String? reason}) async {
    final t = _task;
    final r = t?.dateRequest;
    if (t == null || r == null || !r.isPending) return WriteOutcome.invalid;
    final id = r.id;
    if (id == null || !permissions.canReviewDate) return WriteOutcome.invalid;
    return _write(
      () => _writes.reviewDateChange(id, approve: approve, reason: reason),
      list: approve,
    );
  }

  /// İncelenmiş talebi siler (yalnız şirket yöneticisi; bekleyen silinemez).
  Future<WriteOutcome> deleteDateRequest() async {
    final t = _task;
    final r = t?.dateRequest;
    if (t == null || r == null) return WriteOutcome.invalid;
    final id = r.id;
    if (id == null || !permissions.canDeleteDateRequest(r)) {
      return WriteOutcome.invalid;
    }
    return _write(() => _writes.deleteDateChange(id), list: false);
  }
}
