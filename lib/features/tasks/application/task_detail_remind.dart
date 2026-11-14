part of 'task_detail_controller.dart';

/// "Şimdi hatırlat" (WORK-K90, iPad 8): görevin atananlarına anlık bildirim. Yalnız kapsam
/// koordinatörü ya da şirket yöneticisi; teslim sunucuda asenkron (202).
mixin _RemindFlow on _$TaskDetailController {
  TaskItem? get _task;
  TaskPermissions get permissions;
  TaskWriteRepository get _writes;
  Future<WriteOutcome> _write(
    Future<void> Function() call, {
    required bool list,
  });

  /// Sonuç + bildirimi kuyruğa alınan alıcı sayısı (eylemi yapan hariç). Atanansız görevde
  /// istek gönderilmez.
  Future<(WriteOutcome, int)> remind() async {
    final t = _task;
    if (t == null || t.assignees.isEmpty || !permissions.canRemind) {
      return (WriteOutcome.invalid, 0);
    }
    var count = 0;
    final r = await _write(
      () async => count = await _writes.remind(t),
      list: false,
    );
    return (r, count);
  }
}
