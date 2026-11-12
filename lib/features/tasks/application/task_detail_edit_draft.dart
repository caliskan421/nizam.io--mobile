part of 'task_detail_controller.dart';

/// Düzenleme taslağı: açma, alan güncelleme, çakışma çözümü, atanan seçimi (yazma yok).
mixin _EditDraftFlow on _$TaskDetailController {
  void _openEditFrom(TaskItem t) {
    state = state.copyWith(
      edit: () => TaskEditDraft(
        title: t.title,
        coordinatorship: t.coordinatorship,
        assignees: [...t.assignees],
        priority: t.priority,
        start: t.start,
        due: t.due,
        evidenceRequired: t.evidenceRequired,
        base: t,
      ),
      showErrors: false,
    );
  }

  void updateEdit(TaskEditDraft d) => state = state.copyWith(edit: () => d);

  /// Çakışan alan için kullanıcı seçimi (V3): [useServer] → sunucudaki değer, değilse
  /// kullanıcının değeri kalır. Seçimden sonra gönderim yeni tabanın sürümüyle gider.
  void resolveConflict(EditField f, {required bool useServer}) {
    final d = state.edit;
    final c = d?.conflicts[f];
    if (d == null || c == null) return;
    updateEdit(
      d
          .withValue(f, useServer ? c.server : c.local)
          .copyWith(conflicts: {...d.conflicts}..remove(f)),
    );
  }

  void editToggleAssignee(String id) {
    final d = state.edit;
    if (d == null) return;
    updateEdit(
      d.copyWith(
        assignees: d.assignees.contains(id)
            ? [
                for (final a in d.assignees)
                  if (a != id) a,
              ]
            : [...d.assignees, id],
      ),
    );
  }
}
