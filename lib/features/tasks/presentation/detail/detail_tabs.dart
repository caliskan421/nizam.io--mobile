import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_detail_controller.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'detail_actions.dart';

/// Özet sekmesi: tanım listesi + "ilerleme" zaman çizgisi.
class DetailSummary extends StatelessWidget {
  const DetailSummary({super.key, required this.task, required this.catalog});

  final TaskItem task;
  final TaskCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    String name(String id) => catalog.nameOf(id) ?? l.uiTasksUnknownPerson;
    final names = task.assignees.map(name).toList();
    final today = catalog.today;
    // Sunucu görevinde gecikme sunucu değeridir (WORK-K37); örnekte bugüne göre.
    final late = task.lateness != null
        ? (task.isDone ? 0 : task.overdueDays)
        : catalog.overdueDaysFor(task.due, done: task.isDone);
    final description = task.description?.trim() ?? '';
    final started = !task.start.isAfter(today);
    final done = task.completedAt;

    final events = <(Color, String, String, bool)>[
      // Oluşturma anı sunucu görev yüzlerinde yok (isteğe bağlı): yoksa olay gösterilmez.
      if (task.createdAt case final created?)
        (c.accentText, l.uiTasksEvCreated, TaskDates.short(created), false),
      (
        started ? c.inProgress : c.textFaint,
        started ? l.uiTasksEvStarted : l.uiTasksEvWillStart,
        TaskDates.short(task.start),
        false,
      ),
      if (task.isDone)
        (
          c.accentText,
          done != null && done.isAfter(task.due)
              ? '${l.uiTasksEvDone} ${l.uiTasksEvDoneLate}'
              : l.uiTasksEvDone,
          TaskDates.short(done ?? task.due),
          false,
        )
      else if (late > 0) ...[
        (c.danger, l.uiTasksEvDuePassed, TaskDates.short(task.due), false),
        (c.danger, '$late ${l.uiTasksEvLateTail}', l.uiTasksEvToday, true),
      ] else
        (c.textFaint, l.uiTasksEvDue, TaskDates.short(task.due), false),
    ];

    Widget row(String label, Widget value) => ConstrainedBox(
      constraints: const BoxConstraints(minHeight: NizamioSize.controlSm - 2),
      child: Row(
        children: [
          Text(label, style: t.bodyMd.copyWith(color: c.textMuted)),
          const Gap(NizamioSpacing.space3),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: value),
          ),
        ],
      ),
    );
    Widget strong(String s, {bool mono = false}) => Text(
      s,
      textAlign: TextAlign.end,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: (mono ? t.mono : t.bodyMd).copyWith(fontWeight: FontWeight.w600),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row(
          l.uiTasksAssignee,
          names.length <= 1
              ? strong(names.isEmpty ? l.uiTasksNone : names.first)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NzAvatarStack(names: names, extent: NzAvatarSize.sm),
                    const Gap(NizamioSpacing.space2),
                    Flexible(
                      child: Text(
                        names.map((n) => n.split(' ').first).join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.caption.copyWith(color: c.textMuted),
                      ),
                    ),
                  ],
                ),
        ),
        row(
          l.uiTasksCreator,
          strong(task.creator == null ? l.uiTasksNone : name(task.creator!)),
        ),
        row(
          l.uiTasksCreated,
          task.createdAt == null
              ? strong(l.uiTasksNone)
              : strong(TaskDates.full(task.createdAt!), mono: true),
        ),
        row(
          l.uiTasksDateRange,
          strong(TaskDates.range(task.start, task.due), mono: true),
        ),
        row(
          l.uiTasksEvidenceFile,
          strong(
            task.fileEntries.isEmpty
                ? l.uiTasksNone
                : '${task.fileEntries.length}',
            mono: true,
          ),
        ),
        if (description.isNotEmpty) ...[
          const Gap(NizamioSpacing.space5),
          NzKicker(l.uiTasksDescription),
          const Gap(NizamioSpacing.space2),
          Text(description, style: t.bodyMd.copyWith(color: c.text)),
        ],
        const Gap(NizamioSpacing.space5),
        NzKicker(l.uiTasksProgress),
        const Gap(NizamioSpacing.space2),
        for (var i = 0; i < events.length; i++)
          _TimelineRow(
            color: events[i].$1,
            text: events[i].$2,
            when: events[i].$3,
            danger: events[i].$4,
            last: i == events.length - 1,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.color,
    required this.text,
    required this.when,
    required this.danger,
    required this.last,
  });

  final Color color;
  final String text;
  final String when;
  final bool danger;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: NizamioSpacing.space6,
            child: Column(
              children: [
                const Gap(NizamioSpacing.space2),
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: danger ? c.danger : c.borderStrong,
                      width: NizamioSize.borderWidth,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(NizamioSpacing.space1 - 1),
                    child: NzDot(color: color),
                  ),
                ),
                if (!last)
                  Expanded(
                    child: VerticalDivider(
                      width: NizamioSize.borderWidth,
                      thickness: NizamioSize.borderWidth,
                      color: c.border,
                    ),
                  ),
              ],
            ),
          ),
          const Gap(NizamioSpacing.space3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: NizamioSpacing.space2,
              ),
              child: Text(
                text,
                style: t.bodyMd.copyWith(
                  color: danger ? c.danger : c.text,
                  fontWeight: danger ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space2),
            child: Text(when, style: t.kicker.copyWith(color: c.textMuted)),
          ),
        ],
      ),
    );
  }
}

/// Alt görev sekmesi: ilerleme çubuğu, işaretlenebilir ve açılır alt görev blokları, ekleme.
class DetailSubtasks extends ConsumerWidget {
  const DetailSubtasks({
    super.key,
    required this.task,
    required this.catalog,
    required this.actions,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final TaskDetailActions actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = taskDetailControllerProvider(task.code);
    final ctl = ref.read(p.notifier);
    final (openSubs, editing) = ref.watch(
      p.select((s) => (s.openSubtasks, s.editingSubtask)),
    );
    final subs = task.subtasks;
    final done = task.subtasksDone;
    final perms = ctl.permissions;
    final manage = perms.canManageSubtasks;
    // Sunucuda alt görev adayı ana görevin atananlarıdır; örnekte koordinatörlük ekibi.
    final team = perms.local
        ? catalog.coordinatorship(task.coordinatorship)?.team ??
              const <String>[]
        : perms.subtaskAssignees(task);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.uiTasksSubsHint, style: t.caption.copyWith(color: c.textMuted)),
        const Gap(NizamioSpacing.space3),
        Row(
          children: [
            Expanded(
              child: NzProgressBar(
                value: subs.isEmpty ? 0 : done / subs.length,
                color: c.accentText,
              ),
            ),
            const Gap(NizamioSpacing.gapMd),
            Text(
              '$done / ${subs.length} ${l.uiTasksDoneLc}',
              style: t.monoSm.copyWith(
                color: subs.isNotEmpty && done == subs.length
                    ? c.accentText
                    : c.textMuted,
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        for (final u in subs) ...[
          _SubtaskBlock(
            sub: u,
            catalog: catalog,
            team: team,
            open: openSubs.contains(u.id),
            editing: editing == u.id,
            manage: manage,
            onCheck: perms.canToggleSubtask(u)
                ? () => actions.toggleSubtask(u.id)
                : null,
            onOpen: () => ctl.toggleSubtaskOpen(u.id),
            onTitle: (v) => ctl.setSubtaskTitle(u.id, v),
            onTitleDone: ctl.finishSubtaskEdit,
            onRename: perms.local ? null : () => actions.renameSubtask(u),
            onAssignee: (v) => actions.setSubtaskAssignee(u.id, v),
            onStart: (v) => actions.setSubtaskStart(u.id, v),
            onEnd: (v) => actions.setSubtaskEnd(u.id, v),
            onClearDates: () => actions.clearSubtaskDates(u.id),
            onDelete: () => actions.removeSubtask(u.id),
          ),
          const Gap(NizamioSpacing.space2),
        ],
        if (manage)
          NzButton.secondary(
            label: l.uiTasksSubAdd,
            icon: NzIcons.add,
            expand: true,
            onPressed: actions.addSubtask,
          ),
      ],
    );
  }
}

class _SubtaskBlock extends StatelessWidget {
  const _SubtaskBlock({
    required this.sub,
    required this.catalog,
    required this.team,
    required this.open,
    required this.editing,
    required this.manage,
    required this.onCheck,
    required this.onOpen,
    required this.onTitle,
    required this.onTitleDone,
    required this.onRename,
    required this.onAssignee,
    required this.onStart,
    required this.onEnd,
    required this.onClearDates,
    required this.onDelete,
  });

  final Subtask sub;
  final TaskCatalog catalog;
  final List<String> team;
  final bool open;
  final bool editing;

  /// Başlık/kişi/tarih düzenleme ve silme açık mı (yönetici ya da koordinatör).
  final bool manage;

  /// null → işaretleme bu hesaba kapalı.
  final VoidCallback? onCheck;
  final VoidCallback onOpen;
  final ValueChanged<String> onTitle;
  final VoidCallback onTitleDone;

  /// Sunucu alt görevinde başlık düzenleme alt sayfası; null → yok (örnekte satır içi).
  final VoidCallback? onRename;
  final ValueChanged<String?> onAssignee;
  final ValueChanged<DateTime?> onStart;
  final ValueChanged<DateTime?> onEnd;
  final VoidCallback onClearDates;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final u = sub;
    String name(String id) => catalog.nameOf(id) ?? l.uiTasksUnknownPerson;
    final title = u.title.isEmpty ? l.uiTasksSubUntitled : u.title;
    final dates = u.start != null && u.end != null
        ? '${TaskDates.dayMonth(u.start!)} – ${TaskDates.dayMonth(u.end!)}'
        : u.start != null
        ? '${TaskDates.dayMonth(u.start!)} –'
        : '';
    final bits = [
      if (u.assignee case final a?) name(a).split(' ').first,
      if (dates.isNotEmpty) dates,
      if (u.evidence != null) l.uiTasksOneEvidence,
      if (u.missingAssignee) l.uiTasksNeedsPerson,
    ];
    final missing = u.missingAssignee;

    Widget field(String label, Widget child) => Padding(
      padding: const EdgeInsets.only(top: NizamioSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: NizamioSpacing.space16,
            child: Padding(
              padding: const EdgeInsets.only(top: NizamioSpacing.space3),
              child: Text(label, style: t.caption.copyWith(color: c.textMuted)),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          Expanded(child: child),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(NizamioRadius.group),
        border: Border.all(color: c.border, width: NizamioSize.borderWidth),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space3,
          vertical: NizamioSpacing.space1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Semantics(
                  checked: u.done,
                  label: '$title ${l.uiTasksDoneLc}',
                  button: true,
                  enabled: onCheck != null,
                  excludeSemantics: true,
                  child: InkResponse(
                    onTap: onCheck,
                    radius: NizamioSize.tap / 2,
                    child: SizedBox.square(
                      dimension: NizamioSize.tap,
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: u.done ? c.primary : null,
                            borderRadius: BorderRadius.circular(
                              NizamioSpacing.space1 + 1,
                            ),
                            border: u.done
                                ? null
                                : Border.all(
                                    color: c.borderControl,
                                    width: NizamioSize.borderWidth + 0.5,
                                  ),
                          ),
                          child: SizedBox.square(
                            dimension: NizamioSize.iconSize,
                            child: u.done
                                ? NzIcon(
                                    NzIcons.check,
                                    size: NizamioSize.iconSizeSm,
                                    color: c.onPrimary,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(NizamioSpacing.space1),
                Expanded(
                  child: editing
                      ? _TitleInput(
                          value: u.title,
                          label: l.uiTasksSubName,
                          onChanged: onTitle,
                          onDone: onTitleDone,
                        )
                      : Semantics(
                          button: true,
                          expanded: open,
                          label: [title, ...bits].join(', '),
                          excludeSemantics: true,
                          child: InkWell(
                            onTap: onOpen,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: NizamioSpacing.space2,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: t.bodyMd.copyWith(
                                      color: u.done ? c.textMuted : c.text,
                                      decoration: u.done
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationColor: c.textMuted,
                                    ),
                                  ),
                                  if (bits.isNotEmpty)
                                    Text(
                                      bits.join(' · '),
                                      style: t.caption.copyWith(
                                        color: missing
                                            ? c.warning
                                            : c.textMuted,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
            NzReveal(
              open: open,
              child: Padding(
                padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (manage) ...[
                      field(
                        l.uiTasksSubPerson,
                        NzSelect<String>(
                          label: l.uiTasksSubPerson,
                          value: u.assignee ?? '',
                          items: [
                            NzSelectItem(
                              value: '',
                              label: u.assigneeRequired
                                  ? l.uiTasksPickPerson
                                  : l.uiTasksNoPerson,
                            ),
                            for (final id in {...team, ?u.assignee})
                              NzSelectItem(value: id, label: name(id)),
                          ],
                          onChanged: (v) =>
                              onAssignee(v == null || v.isEmpty ? null : v),
                        ),
                      ),
                      field(
                        l.uiTasksSubDate,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: NizamioSpacing.space2,
                          children: [
                            // Prototip: başlangıç ve bitiş yan yana (1fr 1fr).
                            Row(
                              spacing: NizamioSpacing.space2,
                              children: [
                                Expanded(
                                  child: TaskDateField(
                                    label: l.uiTasksStart,
                                    value: u.start,
                                    onChanged: onStart,
                                  ),
                                ),
                                Expanded(
                                  child: TaskDateField(
                                    label: l.uiTasksDue,
                                    value: u.end,
                                    firstDate: u.start,
                                    onChanged: onEnd,
                                  ),
                                ),
                              ],
                            ),
                            if (u.start != null || u.end != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TaskLink(
                                  label: l.uiTasksClearDate,
                                  onTap: onClearDates,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    if (u.evidence case final f?)
                      field(
                        l.uiTasksSubFile,
                        Padding(
                          padding: const EdgeInsets.only(
                            top: NizamioSpacing.space3,
                          ),
                          child: Text(
                            f,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.mono,
                          ),
                        ),
                      ),
                    if (manage)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: NizamioSpacing.space3,
                        children: [
                          if (onRename case final rename?)
                            TaskLink(label: l.uiTasksSubRename, onTap: rename),
                          TaskLink(
                            label: l.uiTasksSubDelete,
                            color: c.danger,
                            onTap: onDelete,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleInput extends StatefulWidget {
  const _TitleInput({
    required this.value,
    required this.label,
    required this.onChanged,
    required this.onDone,
  });

  final String value;
  final String label;
  final ValueChanged<String> onChanged;
  final VoidCallback onDone;

  @override
  State<_TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<_TitleInput> {
  late final _controller = TextEditingController(text: widget.value);
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) widget.onDone();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    focusNode: _focus,
    onChanged: widget.onChanged,
    onSubmitted: (_) => widget.onDone(),
    style: context.text.bodyMd,
    decoration: InputDecoration(
      hintText: widget.label,
      labelText: null,
      border: InputBorder.none,
      isDense: true,
    ),
  );
}

/// Dosya sekmesi. Sunucu dosyasına dokunmak yetkiye göre indir / adı değiştir / sil
/// işlemlerini açar ([TaskDetailActions.openFile]).
class DetailFiles extends StatelessWidget {
  const DetailFiles({
    super.key,
    required this.task,
    required this.catalog,
    required this.actions,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final TaskDetailActions actions;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    if (task.fileEntries.isEmpty) {
      return NzEmptyState(title: l.uiTasksNoFiles);
    }
    return Column(
      spacing: NizamioSpacing.space2,
      children: [
        for (final f in task.fileEntries)
          InkWell(
            borderRadius: BorderRadius.circular(NizamioRadius.group),
            onTap: () => actions.openFile(f),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(NizamioRadius.group),
                border: Border.all(
                  color: c.border,
                  width: NizamioSize.borderWidth,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(NizamioSpacing.space3),
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: c.surfaceOverlay,
                        borderRadius: BorderRadius.circular(NizamioRadius.tile),
                      ),
                      child: SizedBox.square(
                        dimension: NizamioSize.iconTileLg,
                        child: Center(
                          child: Text(
                            fileKindLabel(f.kind),
                            style: t.monoSm.copyWith(color: c.textMuted),
                          ),
                        ),
                      ),
                    ),
                    const Gap(NizamioSpacing.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.mono,
                          ),
                          Text(
                            _meta(l, f),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _meta(AppLocalizations ll, TaskFile f) {
    final sub = f.subtask == null
        ? null
        : task.subtasks.where((s) => s.id == f.subtask).firstOrNull;
    return [
      if (f.subtask != null)
        '${ll.uiTasksSubtaskPrefix} ${sub?.title ?? ll.uiTasksDeletedLc}',
      ll.tagLabel(f.tag),
      catalog.nameOf(f.by) ?? ll.uiTasksUnknownPerson,
      '${f.sizeKb} ${ll.uiTasksKb}',
    ].join(' · ');
  }
}

/// Not sekmesi: notlar, hafızaya ekle, not yazma.
class DetailNotes extends ConsumerStatefulWidget {
  const DetailNotes({
    super.key,
    required this.task,
    required this.catalog,
    required this.actions,
  });

  final TaskItem task;
  final TaskCatalog catalog;
  final TaskDetailActions actions;

  @override
  ConsumerState<DetailNotes> createState() => _DetailNotesState();
}

class _DetailNotesState extends ConsumerState<DetailNotes> {
  TaskDetailControllerProvider get _p =>
      taskDetailControllerProvider(widget.task.code);

  // initState'te kurulur: yazma alanı gizliyken (yönetici) dispose'ta ref'e gidilmez.
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(_p).noteDraft);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final ctl = ref.read(_p.notifier);
    // Taslak dışarıdan değişince (gönderimde silinir) alan eşitlenir; yazarken yeniden
    // kurulum yok.
    ref.listen(_p.select((s) => s.noteDraft), (_, next) {
      if (next != _controller.text) _controller.text = next;
    });
    final notes = widget.task.noteEntries;
    final perms = ctl.permissions;
    final actions = widget.actions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (notes.isEmpty)
          Text(l.uiTasksNoNotes, style: t.caption.copyWith(color: c.textMuted)),
        for (var i = 0; i < notes.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NzAvatar.initials(
                name:
                    widget.catalog.nameOf(notes[i].by) ??
                    l.uiTasksUnknownPerson,
                extent: NzAvatarSize.sm,
              ),
              const Gap(NizamioSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                widget.catalog.nameOf(notes[i].by) ??
                                l.uiTasksUnknownPerson,
                            style: t.caption.copyWith(
                              fontWeight: FontWeight.w600,
                              color: c.text,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' · ${TaskDates.short(notes[i].at)} '
                                '${TaskDates.time(notes[i].at)}',
                          ),
                        ],
                      ),
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                    const Gap(NizamioSpacing.space1),
                    Text(notes[i].text, style: t.bodyMd),
                    // Hafıza yalnız örnekte (sunucuda karşılığı yok, B-17).
                    if (perms.local)
                      TaskLink(
                        label: notes[i].inMemory
                            ? l.uiTasksInMemory
                            : l.uiTasksToMemory,
                        color: notes[i].inMemory ? c.accentText : c.textMuted,
                        onTap: () => actions.addNoteToMemory(i),
                      )
                    else if (perms.canEditNote(notes[i]))
                      Row(
                        spacing: NizamioSpacing.space3,
                        children: [
                          TaskLink(
                            label: l.uiTasksNoteEdit,
                            color: c.textMuted,
                            onTap: () => actions.editNote(notes[i]),
                          ),
                          TaskLink(
                            label: l.uiTasksNoteDelete,
                            color: c.danger,
                            onTap: () => actions.deleteNote(notes[i]),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(NizamioSpacing.space2),
        ],
        // Not yazma: koordinatör ya da atanmış üye; yönetici yazamaz (salt okur).
        if (perms.canAddNote) ...[
          const Gap(NizamioSpacing.space2),
          Row(
            children: [
              Expanded(
                child: NzTextField(
                  label: l.uiTasksNoteHint,
                  hint: l.uiTasksNoteHint,
                  controller: _controller,
                  onChanged: ctl.setNoteDraft,
                  onSubmitted: (_) => actions.sendNote(),
                ),
              ),
              const Gap(NizamioSpacing.space2),
              NzIconButton.circleAccent(
                icon: NzIcons.arrowUp,
                semanticLabel: l.uiTasksSend,
                onPressed: actions.sendNote,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
