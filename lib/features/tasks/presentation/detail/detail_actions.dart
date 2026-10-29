import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/task_detail_controller.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'detail_forms.dart';

/// Ayrıntı ekranının eylemleri: denetleyici komutu + prototipteki sonuç bildirimi ve alt
/// sayfalar. Sayfa her çizimde kurar; geri çağrılar sayfa bağlamıyla çalışır.
class TaskDetailActions {
  TaskDetailActions(this.context, this.ref, this.code);

  final BuildContext context;
  final WidgetRef ref;
  final String code;

  TaskDetailControllerProvider get _p => taskDetailControllerProvider(code);
  TaskDetailController get _ctl => ref.read(_p.notifier);
  TaskCatalog? get _catalog => ref.read(taskCatalogControllerProvider).value;
  TaskItem? get _task => _catalog?.task(code);

  String _name(String id) => _catalog?.person(id)?.name ?? id;

  void _say(String msg) {
    if (context.mounted) NzToast.show(context, msg);
  }

  // ---- durum / öncelik / menü -------------------------------------------------------------

  void openStatus() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    final c = context.colors;
    final open = t.subtasks.where((u) => !u.done).length;
    _listSheet(
      title: l.uiTasksSheetStatus,
      builder: (sheet) => [
        for (final s in TaskStatus.values)
          _ListOption(
            label: l.statusLabel(s),
            leading: NzDot(color: statusTone(s).color(c)),
            hint: s == TaskStatus.done && open > 0 && !t.isDone
                ? '$open ${l.uiTasksOpenSubsTail}'
                : null,
            selected: s == t.status,
            onTap: () {
              Navigator.of(sheet).pop();
              _setStatus(s);
            },
          ),
      ],
    );
  }

  void _setStatus(TaskStatus s) {
    final l = context.l10n;
    final t = _task;
    if (t == null) return;
    switch (_ctl.setStatus(s)) {
      case StatusChange.unchanged:
        break;
      case StatusChange.blockedBySubtasks:
        _say(
          '${l.uiTasksTSubsBlock} · ${t.subtasksDone}/${t.subtasks.length} '
          '${l.uiTasksTFinishedLc}',
        );
      case StatusChange.blockedByEvidence:
        _say(l.uiTasksTEvidenceBlock);
      case StatusChange.changed:
        _say('$code · ${l.statusLabel(s)}');
    }
  }

  void openPriority() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    _listSheet(
      title: l.uiTasksSheetPriority,
      builder: (sheet) => [
        for (final p in TaskPriority.values.reversed)
          _ListOption(
            label: l.priorityLabel(p),
            leading: NzPriorityBars(level: priorityLevel(p)),
            selected: p == t.priority,
            onTap: () {
              Navigator.of(sheet).pop();
              if (_ctl.setPriority(p)) {
                _say('${l.uiTasksPriority}: ${l.priorityLabel(p)}');
              }
            },
          ),
      ],
    );
  }

  void openMenu() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    final c = context.colors;
    _listSheet(
      // Türkçe küçük harf (İDA-2 → ida-2; `toLowerCase` noktalı i üretir).
      title: trLower(code),
      builder: (sheet) => [
        _ListOption(
          label: l.uiTasksEditTask,
          leading: const Icon(
            Icons.edit_outlined,
            size: NizamioSize.iconSizeSm,
          ),
          onTap: () {
            Navigator.of(sheet).pop();
            openEdit();
          },
        ),
        _ListOption(
          label: l.uiTasksCopy,
          leading: const Icon(Icons.copy_rounded, size: NizamioSize.iconSizeSm),
          onTap: () {
            Navigator.of(sheet).pop();
            final newCode = _ctl.copy(l.uiTasksCopySuffix);
            if (newCode != null) {
              _say(
                '$newCode ${l.uiTasksTCreatedTail} · ${t.title} '
                '${l.uiTasksCopySuffix}',
              );
            }
          },
        ),
        _ListOption(
          label: l.uiTasksDeleteTask,
          color: c.danger,
          leading: Icon(
            Icons.delete_outline_rounded,
            size: NizamioSize.iconSizeSm,
            color: c.danger,
          ),
          onTap: () {
            Navigator.of(sheet).pop();
            openDelete();
          },
        ),
      ],
    );
  }

  Future<void> _listSheet({
    required String title,
    required List<Widget> Function(BuildContext sheet) builder,
  }) => NzBottomSheet.show<void>(
    context,
    title: title,
    compact: true,
    builder: (sheet) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: builder(sheet),
    ),
  );

  // ---- formlar ----------------------------------------------------------------------------

  Future<void> _form({
    required String title,
    required String description,
    required String ok,
    required bool Function() submit,
    required String Function() success,
    required Widget body,
    bool danger = false,
  }) async {
    final l = context.l10n;
    String? msg;
    await NzBottomSheet.show<void>(
      context,
      title: title,
      description: description,
      actions: (sheet) => sheetActions(
        sheet,
        cancel: l.uiTasksCancel,
        ok: ok,
        danger: danger,
        onOk: () {
          final text = success();
          if (!submit()) return;
          msg = text;
          Navigator.of(sheet).pop();
        },
      ),
      builder: (_) => body,
    );
    if (!context.mounted) return;
    _ctl.closeForms();
    final m = msg;
    if (m != null) _say(m);
  }

  void openEdit() {
    if (_task == null) return;
    final l = context.l10n;
    _ctl.openEdit();
    _form(
      title: l.uiTasksEditTask,
      description: '$code · ${l.uiTasksEditDescTail}',
      ok: l.uiTasksSave,
      submit: _ctl.submitEdit,
      success: () => '$code ${l.uiTasksTUpdatedTail}',
      body: EditTaskForm(code: code),
    );
  }

  void openDateRequest() {
    final l = context.l10n;
    if (!_ctl.openDateRequest()) {
      _say(l.uiTasksTPendingExists);
      return;
    }
    _form(
      title: l.uiTasksRequestDate,
      description: l.uiTasksDateDesc,
      ok: l.uiTasksSendRequest,
      submit: _ctl.submitDateRequest,
      success: () => l.uiTasksTRequestSent,
      body: DateRequestForm(code: code),
    );
  }

  void openUpload() {
    if (_task == null) return;
    final l = context.l10n;
    _ctl.openUpload();
    _form(
      title: l.uiTasksUploadTitle,
      description: l.uiTasksUploadDesc,
      ok: l.uiTasksUploadOk,
      submit: _ctl.submitUpload,
      success: () => l.uiTasksTUploaded,
      body: UploadForm(code: code),
    );
  }

  void openDelete() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    _form(
      title: '$code ${l.uiTasksDeleteQTail}',
      description: l.uiTasksDeleteDesc,
      ok: l.uiTasksDeleteOk,
      danger: true,
      submit: () {
        _ctl.delete();
        return true;
      },
      success: () => l.uiTasksTDeleted,
      body: Text(
        '“${t.title}” ${l.uiTasksDeleteBodyTail}',
        style: context.text.bodyMd,
      ),
    );
  }

  // ---- talep, hatırlatma, silme ------------------------------------------------------------

  void approveRequest() {
    final r = _task?.dateRequest;
    if (r == null) return;
    final l = context.l10n;
    _ctl.approveRequest();
    _say(
      '${l.uiTasksTApproved} · $code ${l.uiTasksTNewDue} ${TaskDates.full(r.due)}',
    );
  }

  void rejectRequest() {
    final r = _task?.dateRequest;
    if (r == null) return;
    final l = context.l10n;
    _ctl.rejectRequest();
    _say('${l.uiTasksTRejected} · ${_name(r.by)} ${l.uiTasksTInformed}');
  }

  void remind() {
    final t = _task;
    if (t == null) return;
    _say(
      '${context.l10n.uiTasksTReminded} · '
      '${t.assignees.map(_name).join(', ')}',
    );
  }

  void undoDelete() {
    _ctl.undoDelete();
    _say('$code ${context.l10n.uiTasksTRestoredTail}');
  }

  // ---- alt görev, not ---------------------------------------------------------------------

  void toggleSubtask(String id) {
    if (!_ctl.toggleSubtask(id)) _say(context.l10n.uiTasksTSubEvidence);
  }

  void removeSubtask(String id) {
    final l = context.l10n;
    final u = _ctl.removeSubtask(id);
    if (u == null) return;
    _say(
      '“${u.title.isEmpty ? l.uiTasksSubUntitled : u.title}” $code '
      '${l.uiTasksTSubRemovedTail}'
      '${u.evidence != null ? ' · ${l.uiTasksTSubFileKept}' : ''}',
    );
  }

  void addNoteToMemory(int i) {
    if (_ctl.addNoteToMemory(i)) _say(context.l10n.uiTasksTNoteMemory);
  }
}

/// Liste tipi alt sayfa satırı (prototip `.rp-menuitem`).
class _ListOption extends StatelessWidget {
  const _ListOption({
    required this.label,
    required this.leading,
    required this.onTap,
    this.hint,
    this.selected = false,
    this.color,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;
  final String? hint;
  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final hint = this.hint;
    return Semantics(
      button: true,
      selected: selected,
      label: [label, ?hint].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.row),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space2,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: NizamioSize.iconSize,
                  child: Center(child: leading),
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Text(
                    label,
                    style: t.list.copyWith(
                      color: color ?? c.text,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (hint != null) ...[
                  const Gap(NizamioSpacing.space2),
                  Text(hint, style: t.caption.copyWith(color: c.textMuted)),
                ],
                if (selected) ...[
                  const Gap(NizamioSpacing.space2),
                  Icon(
                    Icons.check_rounded,
                    size: NizamioSize.iconSizeSm,
                    color: c.accentText,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
