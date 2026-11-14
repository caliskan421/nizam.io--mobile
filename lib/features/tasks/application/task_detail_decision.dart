part of 'task_detail_controller.dart';

/// Koordinatör kararları: onaya sunulanı onayla / iade et, doğrudan süre uzatma (7 güne
/// kadar), atanmamış göreve sorumlu ata. Yetki [TaskPermissions]'tan (etkin görünümle);
/// gizleme güvenlik değildir, sunucu yeniden denetler.
///
/// İade sebebi: sunucu geçişi iade gerekçesini saklamaz (yalnız `tamamlandi`'dan geri almada);
/// sebep görevde not olarak yazılır (not yazabilen aktörde; şirket yöneticisi not yazamaz).
mixin _DecisionFlow on _$TaskDetailController {
  TaskItem? get _task;
  TaskPermissions get permissions;
  TaskWriteRepository get _writes;
  Future<WriteOutcome> _write(
    Future<void> Function() call, {
    required bool list,
  });
  Future<WriteOutcome> _writeKeyed(
    String action,
    String body,
    Future<void> Function(String key) call, {
    required bool list,
  });

  /// Onayla: `onaya_sunuldu → tamamlandi`. [pullEndDate] erken bitişte bitişi bugüne çeker;
  /// [closeSubtasks] yalnız kullanıcı "alt görevleri de kapat" dediğinde (409
  /// `work.subtasks_open` sonrası). [note] verilirse onaydan sonra not olarak yazılır.
  Future<WriteOutcome> approve({
    bool pullEndDate = false,
    bool closeSubtasks = false,
    String? note,
  }) async {
    final t = _task;
    final via = permissions.statusEndpoint;
    if (t == null || via == null || !permissions.canDecide(t)) {
      return WriteOutcome.invalid;
    }
    final r = await _write(
      () => _writes.changeStatus(
        t,
        via,
        TaskStatus.done,
        closeSubtasks: closeSubtasks,
        pullEndDate: pullEndDate,
      ),
      list: false,
    );
    return r.ok ? _decisionNote(t, note) : r;
  }

  /// İade et: `onaya_sunuldu → iade_edildi`; [reason] zorunlu ([isValidDecisionReason]).
  /// Sebep [asNote] metniyle görev notu olarak yazılır.
  Future<WriteOutcome> returnTask({
    required String reason,
    required String Function(String reason) asNote,
  }) async {
    final t = _task;
    final via = permissions.statusEndpoint;
    if (t == null || via == null || !permissions.canDecide(t)) {
      return WriteOutcome.invalid;
    }
    if (!isValidDecisionReason(reason)) {
      return const WriteOutcome(WriteKind.reasonRequired);
    }
    final r = await _write(
      () => _writes.changeStatus(t, via, TaskStatus.returned),
      list: false,
    );
    return r.ok ? _decisionNote(t, asNote(reason.trim())) : r;
  }

  Future<WriteOutcome> _decisionNote(TaskItem t, String? note) async {
    final text = note?.trim() ?? '';
    if (text.isEmpty || !permissions.canAddNote) return WriteOutcome.done;
    return _writeKeyed(
      'decision_note',
      '${t.id}|$text',
      (key) => _writes.addNote(t, text, requestKey: key),
      list: false,
    );
  }

  /// Doğrudan süre uzatma: [days] 1–[maxDirectExtendDays] (ürün kuralı; fazlası tarih
  /// talebiyle). Okunan tarih sürümüyle gider; bağımlılar ötelenebilir → liste de okunur.
  Future<WriteOutcome> extend(int days) async {
    final t = _task;
    if (t == null || !permissions.canExtend(t) || !isValidExtendDays(days)) {
      return WriteOutcome.invalid;
    }
    if (t.datesRevision == null) {
      return _rejected(ClientErrorCode.serverOutdated);
    }
    return _writeKeyed(
      'extend',
      '${t.id}|$days|${t.datesRevision}',
      (key) => _writes.extend(t, days, requestKey: key),
      list: true,
    );
  }

  /// Atanmamış göreve sorumlu ata (yalnız kapsam koordinatörü, WORK-K10).
  Future<WriteOutcome> assign(String accountId) async {
    final t = _task;
    if (t == null ||
        !permissions.canAssign ||
        t.isDone ||
        t.assignees.contains(accountId)) {
      return WriteOutcome.invalid;
    }
    return _write(() => _writes.addAssignments(t, [accountId]), list: false);
  }
}
