part of 'detail_actions.dart';

/// Koordinatör kararlarının ayrıntı ekranı girişleri ([TaskDecisionFlows]'a yönlendirir):
/// onaydaki görevde durum seçicisinden Onayla / İade et karar kaplamasını açar (iade sebebi
/// zorunlu kalır); süre uzatma 7 güne kadar, fazlası için tarih talebi formu. Üyede "Onaya sun"
/// seçeneği doğrudan geçiş değil, onaya sunma kaplamasıdır ([TaskDecisionFlows.submit]).
extension TaskDetailDecisionActions on TaskDetailActions {
  TaskDecisionFlows get _flows => TaskDecisionFlows(context, ref, code);

  void _pickStatus(TaskItem t, TaskStatus s) {
    final decide =
        _perms.canDecide(t) &&
        (s == TaskStatus.done || s == TaskStatus.returned);
    if (_memberActor && s == TaskStatus.review) {
      _flows.submit(onUpload: canUpload ? openUpload : null);
    } else if (!decide) {
      _setStatus(s);
    } else if (s == TaskStatus.done) {
      _flows.approve();
    } else {
      _flows.returnTask();
    }
  }

  bool get _memberActor => _perms.actor == TransitionActor.member;

  /// Seçenek etiketi: üyenin onaya sunma hedefi "Onaya sun"; diğerleri durum adı.
  String _statusOptionLabel(TaskItem t, TaskStatus s) =>
      _memberActor && s == TaskStatus.review && s != t.status
      ? context.l10n.uiTasksSubmitOption
      : context.l10n.statusLabel(s);

  String get _noTransitionsText => _memberActor
      ? context.l10n.uiTasksMemberNoTransitions
      : context.l10n.uiTasksNoStatusTransitions;

  /// Üyede seçici açıklaması (yalnız kendine açık adımlar).
  List<Widget> _statusHead(List<TaskStatus> targets) => [
    if (_memberActor && targets.isNotEmpty)
      Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space2),
        child: Text(
          context.l10n.uiTasksMemberStatusDesc,
          style: context.text.bodySm.copyWith(color: context.colors.textMuted),
        ),
      ),
  ];

  void openExtend() => _flows.extend(
    onRequestDate: canRequestDate && !(_task?.hasPendingRequest ?? true)
        ? openDateRequest
        : null,
  );
}
