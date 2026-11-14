import 'task_catalog.dart';
import 'task_permissions.dart';

/// Üye bandının hâli (görev ayrıntısı ve ana sayfa odak kartı): üyenin bu görevde
/// yapabileceği tek sonraki adım. Karar sunucudadır; bu yalnız düğme seçimidir.
enum MemberStep {
  /// Başlamadı → "Başla" (devam).
  start,

  /// İade edildi → "Düzeltmeye başla" (devam).
  fix,

  /// Devam ediyor → "Tamamlandı bildir" (onaya sun).
  submit,

  /// Onaya sunuldu: salt okunur "onay bekliyor".
  waiting,

  /// Bant yok (tamamlandı ya da tanımsız durum).
  none;

  /// [t] görevinin hâli (durumdan).
  static MemberStep of(TaskItem t) => switch (t.status) {
    TaskStatus.todo => start,
    TaskStatus.returned => fix,
    TaskStatus.inProgress => submit,
    TaskStatus.review => waiting,
    TaskStatus.done || TaskStatus.unknown => none,
  };
}

/// Başlatılabilir mi: başlamadı ya da iade edilmiş görevde aktörün matrisinde "devam" hedefi
/// var ve bitmemiş ön görev ([blocking]) yok.
bool canStartTask(TaskPermissions p, TaskItem t, {int blocking = 0}) =>
    (t.status == TaskStatus.todo || t.status == TaskStatus.returned) &&
    blocking == 0 &&
    p.statusTargets(t.status).contains(TaskStatus.inProgress);

/// Onaya sunulabilir mi: devam eden görevde aktörün matrisinde "onaya sun" hedefi var.
bool canSubmitTask(TaskPermissions p, TaskItem t) =>
    t.status == TaskStatus.inProgress &&
    p.statusTargets(TaskStatus.inProgress).contains(TaskStatus.review);

/// Onaya sunma ön denetimi (WORK-K15): görev kanıt istiyor ve kanıt dosyası yok ([files] 0)
/// → eksik. Dosya sayısı bilinmiyorsa ([files] null) karar sunucuya kalır (409).
bool evidenceMissing(TaskItem t, {required int? files}) =>
    t.evidenceRequired && files == 0;

/// Son not: [me] dışındaki yazarların en yeni notu ([foreign] true; iade kartı — sunucu iade
/// gerekçesini ayrı alan olarak taşımaz, koordinatör sebebi not olarak yazar) ya da [me]'nin
/// [head] önekli en yeni notu (onaya sunma notu). Yoksa null.
TaskNote? lastNote(
  Iterable<TaskNote> notes, {
  required String me,
  bool foreign = true,
  String? head,
}) {
  TaskNote? best;
  for (final n in notes) {
    final mine = n.by == me;
    if (foreign == mine) continue;
    if (head != null && !n.text.startsWith(head)) continue;
    if (best == null || n.at.isAfter(best.at)) best = n;
  }
  return best;
}
