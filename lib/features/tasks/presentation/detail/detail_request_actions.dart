part of 'detail_actions.dart';

/// Tarih talebi kararı ve "Şimdi hatırlat" eylemleri ([TaskDetailActions] uzantısı; sayfa
/// bağlamı ve sonuç bildirimi aynı sınıftan).
extension TaskDetailRequestActions on TaskDetailActions {
  /// "Şimdi hatırlat" görünür mü: koordinatör ya da şirket yöneticisi ve görevde atanan var.
  bool get canRemind =>
      _ctl.permissions.canRemind && (_task?.assignees.isNotEmpty ?? false);

  /// Atananlara anlık hatırlatma (WORK-K90); başarıda alıcı sayısıyla bildirim.
  Future<void> remind() async {
    final l = context.l10n;
    final (r, n) = await _ctl.remind();
    _report(r, done: '${l.uiTasksTReminded} · $n ${l.uiTasksPeopleLc}');
  }

  Future<void> approveRequest() async {
    final r = _task?.dateRequest;
    if (r == null) return;
    final l = context.l10n;
    _report(
      await _ctl.approveRequest(),
      done:
          '${l.uiTasksTApproved} · ${l.uiTasksTNewDue} '
          '${TaskDates.full(r.due)}',
    );
  }

  Future<void> rejectRequest() async {
    final r = _task?.dateRequest;
    if (r == null) return;
    final l = context.l10n;
    final reason = await _askText(
      title: l.uiTasksReject,
      description: l.uiTasksRejectReasonHint,
      label: l.uiTasksRejectReasonLabel,
      ok: l.uiTasksReject,
      valid: (v) => v.length <= 500,
    );
    if (reason == null || !context.mounted) return;
    _report(
      await _ctl.rejectRequest(reason),
      done:
          '${l.uiTasksTRejected} · '
          '${r.by == null ? '' : _name(r.by!)} ${l.uiTasksTInformed}',
    );
  }
}
