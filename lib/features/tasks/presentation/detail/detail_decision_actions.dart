part of 'detail_actions.dart';

/// Koordinatör kararlarının ayrıntı ekranı girişleri ([TaskDecisionFlows]'a yönlendirir):
/// onaydaki görevde durum seçicisinden Onayla / İade et karar kaplamasını açar (iade sebebi
/// zorunlu kalır); süre uzatma 7 güne kadar, fazlası için tarih talebi formu.
extension TaskDetailDecisionActions on TaskDetailActions {
  TaskDecisionFlows get _flows => TaskDecisionFlows(context, ref, code);

  void _pickStatus(TaskItem t, TaskStatus s) {
    final decide =
        _perms.canDecide(t) &&
        (s == TaskStatus.done || s == TaskStatus.returned);
    if (!decide) {
      _setStatus(s);
    } else if (s == TaskStatus.done) {
      _flows.approve();
    } else {
      _flows.returnTask();
    }
  }

  void openExtend() => _flows.extend(
    onRequestDate: canRequestDate && !(_task?.hasPendingRequest ?? true)
        ? openDateRequest
        : null,
  );
}
