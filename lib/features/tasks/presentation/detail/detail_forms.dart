import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/task_detail_controller.dart';
import '../../application/tasks_providers.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_writes.dart';
import '../task_texts.dart';
import '../task_widgets.dart';

/// "Görevi düzenle" formu: başlık, koordinatörlük, atanan (koordinatörler + açılır üyeler),
/// öncelik, başlangıç/bitiş, kanıt zorunluluğu. Sunucu görevinde departman değişmez
/// (koordinatörlük seçimi yok); atanan bölümü yalnız kapsam koordinatörüne, adaylar
/// departman ekibinden ([taskTeamProvider]).
class EditTaskForm extends ConsumerStatefulWidget {
  const EditTaskForm({super.key, required this.code});

  final String code;

  @override
  ConsumerState<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends ConsumerState<EditTaskForm> {
  late final _title = TextEditingController(
    text: ref.read(taskDetailControllerProvider(widget.code)).edit?.title,
  );

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = taskDetailControllerProvider(widget.code);
    final s = ref.watch(p);
    final ctl = ref.read(p.notifier);
    final d = s.edit;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    if (d == null || catalog == null) return const SizedBox.shrink();
    final perms = ctl.permissions;
    if (!perms.local) return _ServerEditBody(code: widget.code, title: _title);
    final co = catalog.coordinatorship(d.coordinatorship);
    final leads = co?.leads ?? const <String>[];
    final members = co?.members ?? const <String>[];
    String name(String id) => catalog.person(id)?.name ?? id;
    final memSel = [
      for (final m in members)
        if (d.assignees.contains(m)) name(m).split(' ').first,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzTextField(
          label: l.uiTasksFieldTitle,
          hint: l.uiTasksFieldTitleHint,
          controller: _title,
          onChanged: (v) => ctl.updateEdit(d.copyWith(title: v)),
        ),
        if (s.showErrors && d.titleMissing) ...[
          const Gap(NizamioSpacing.space1),
          TaskFormError(l.uiTasksErrTitleEmpty),
        ],
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(l.uiTasksFieldCoord),
        Wrap(
          spacing: NizamioSpacing.space2,
          runSpacing: NizamioSpacing.space2,
          children: [
            for (final x in catalog.coordinatorships)
              TaskChip(
                label: x.name,
                selected: x.code == d.coordinatorship,
                onTap: () => ctl.editCoordinatorship(x.code),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(
          l.uiTasksAssignee,
          trailing: Text(
            '${d.assignees.length}',
            style: t.monoSm.copyWith(color: c.textMuted),
          ),
        ),
        Text(
          l.uiTasksCoordinatorsLc,
          style: t.kicker.copyWith(color: c.accentText),
        ),
        const Gap(NizamioSpacing.space2),
        if (leads.isEmpty)
          Text(
            l.uiTasksNoCoordinators,
            style: t.caption.copyWith(color: c.textMuted),
          )
        else
          Wrap(
            spacing: NizamioSpacing.space2,
            runSpacing: NizamioSpacing.space2,
            children: [
              for (final id in leads)
                TaskChip(
                  label: name(id),
                  selected: d.assignees.contains(id),
                  onTap: () => ctl.editToggleAssignee(id),
                ),
            ],
          ),
        TaskLink(
          label:
              '${l.uiTasksMembersLc} (${members.length})'
              '${memSel.isEmpty ? '' : ' · ${memSel.join(', ')}'}',
          onTap: () => ctl.updateEdit(d.copyWith(membersOpen: !d.membersOpen)),
        ),
        NzReveal(
          open: d.membersOpen,
          child: members.isEmpty
              ? Text(
                  l.uiTasksNoMembers,
                  style: t.caption.copyWith(color: c.textMuted),
                )
              : Wrap(
                  spacing: NizamioSpacing.space2,
                  runSpacing: NizamioSpacing.space2,
                  children: [
                    for (final id in members)
                      TaskChip(
                        label: name(id),
                        selected: d.assignees.contains(id),
                        onTap: () => ctl.editToggleAssignee(id),
                      ),
                  ],
                ),
        ),
        if (s.showErrors && d.assigneesMissing) ...[
          const Gap(NizamioSpacing.space1),
          TaskFormError(l.uiTasksErrAssignOne),
        ],
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(l.uiTasksPriority),
        TaskSegmented(
          semanticLabel: l.uiTasksPriority,
          labels: [
            for (final p in TaskPriority.pickable.reversed) l.priorityLabel(p),
          ],
          selected: TaskPriority.pickable.reversed.toList().indexOf(d.priority),
          onSelected: (i) => ctl.updateEdit(
            d.copyWith(priority: TaskPriority.pickable.reversed.toList()[i]),
          ),
        ),
        const Gap(NizamioSpacing.space4),
        _DatePair(
          startLabel: l.uiTasksStart,
          endLabel: l.uiTasksDue,
          start: d.start,
          end: d.due,
          onStart: (v) => ctl.updateEdit(d.copyWith(start: v)),
          onEnd: (v) => ctl.updateEdit(d.copyWith(due: v)),
        ),
        if (d.datesInvalid) ...[
          const Gap(NizamioSpacing.space1),
          TaskFormError(l.uiTasksErrDates),
        ],
        const Gap(NizamioSpacing.space3),
        TaskCheckRow(
          label: l.uiTasksEvidenceRequired,
          square: true,
          selected: d.evidenceRequired,
          onTap: () =>
              ctl.updateEdit(d.copyWith(evidenceRequired: !d.evidenceRequired)),
        ),
      ],
    );
  }
}

/// Sunucu görevinin düzenleme gövdesi: başlık, atanan (yalnız koordinatör; ekipten),
/// öncelik, tarihler, kanıt zorunluluğu.
class _ServerEditBody extends ConsumerWidget {
  const _ServerEditBody({required this.code, required this.title});

  final String code;
  final TextEditingController title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = taskDetailControllerProvider(code);
    final s = ref.watch(p);
    final ctl = ref.read(p.notifier);
    final d = s.edit;
    final task = ref.watch(taskCatalogControllerProvider).value?.task(code);
    if (d == null || task == null) return const SizedBox.shrink();
    final dept = task.departmentId;
    final assign = ctl.permissions.canAssign && dept != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzTextField(
          label: l.uiTasksFieldTitle,
          hint: l.uiTasksFieldTitleHint,
          controller: title,
          onChanged: (v) => ctl.updateEdit(d.copyWith(title: v)),
        ),
        if (s.showErrors && d.titleMissing) ...[
          const Gap(NizamioSpacing.space1),
          TaskFormError(l.uiTasksErrTitleEmpty),
        ],
        if (assign) ...[
          const Gap(NizamioSpacing.space4),
          TaskFieldLabel(
            l.uiTasksAssignee,
            trailing: Text(
              '${d.assignees.length}',
              style: t.monoSm.copyWith(color: c.textMuted),
            ),
          ),
          TeamPicker(
            departmentId: dept,
            selected: d.assignees,
            onToggle: ctl.editToggleAssignee,
          ),
        ],
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(l.uiTasksPriority),
        TaskSegmented(
          semanticLabel: l.uiTasksPriority,
          labels: [
            for (final p in TaskPriority.pickable.reversed) l.priorityLabel(p),
          ],
          selected: TaskPriority.pickable.reversed.toList().indexOf(d.priority),
          onSelected: (i) => ctl.updateEdit(
            d.copyWith(priority: TaskPriority.pickable.reversed.toList()[i]),
          ),
        ),
        const Gap(NizamioSpacing.space4),
        _DatePair(
          startLabel: l.uiTasksStart,
          endLabel: l.uiTasksDue,
          start: d.start,
          end: d.due,
          onStart: (v) => ctl.updateEdit(d.copyWith(start: v)),
          onEnd: (v) => ctl.updateEdit(d.copyWith(due: v)),
        ),
        if (d.datesInvalid) ...[
          const Gap(NizamioSpacing.space1),
          TaskFormError(l.uiTasksErrDates),
        ],
        const Gap(NizamioSpacing.space3),
        TaskCheckRow(
          label: l.uiTasksEvidenceRequired,
          square: true,
          selected: d.evidenceRequired,
          onTap: () =>
              ctl.updateEdit(d.copyWith(evidenceRequired: !d.evidenceRequired)),
        ),
      ],
    );
  }
}

/// Departman ekibinden kişi seçimi (görev ataması adayları; `listMembers`). [single]: tek
/// seçim (görev açarken sunucu tek atanan alır).
class TeamPicker extends ConsumerWidget {
  const TeamPicker({
    super.key,
    required this.departmentId,
    required this.selected,
    required this.onToggle,
  });

  final String departmentId;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final team = ref.watch(taskTeamProvider(departmentId));
    return switch (team) {
      AsyncData(:final value) when value.isEmpty => Text(
        l.uiTasksTeamEmpty,
        style: context.text.caption.copyWith(color: c.textMuted),
      ),
      AsyncData(:final value) => Wrap(
        spacing: NizamioSpacing.space2,
        runSpacing: NizamioSpacing.space2,
        children: [
          for (final m in value)
            TaskChip(
              label: m.name,
              selected: selected.contains(m.accountId),
              onTap: () => onToggle(m.accountId),
            ),
        ],
      ),
      AsyncError(:final error) => NzBanner.danger(
        message: errorText(l, toApiError(error)),
        actionLabel: l.uiCommonRetry,
        onAction: () => ref.invalidate(taskTeamProvider(departmentId)),
      ),
      _ => const NzLoader(),
    };
  }
}

class _DatePair extends StatelessWidget {
  const _DatePair({
    required this.startLabel,
    required this.endLabel,
    required this.start,
    required this.end,
    required this.onStart,
    required this.onEnd,
  });

  final String startLabel;
  final String endLabel;
  final DateTime start;
  final DateTime end;
  final ValueChanged<DateTime> onStart;
  final ValueChanged<DateTime> onEnd;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: NizamioSpacing.space2,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskFieldLabel(startLabel),
            TaskDateField(label: startLabel, value: start, onChanged: onStart),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskFieldLabel(endLabel),
            TaskDateField(
              label: endLabel,
              value: end,
              firstDate: start,
              onChanged: onEnd,
            ),
          ],
        ),
      ),
    ],
  );
}

/// "Tarih değişikliği iste" formu.
class DateRequestForm extends ConsumerWidget {
  const DateRequestForm({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = taskDetailControllerProvider(code);
    final d = ref.watch(p).dateDraft;
    final ctl = ref.read(p.notifier);
    final task = ref.watch(taskCatalogControllerProvider).value?.task(code);
    if (d == null || task == null) return const SizedBox.shrink();
    final plus = DateTime.utc(d.due.year, d.due.month, d.due.day)
        .difference(DateTime.utc(task.due.year, task.due.month, task.due.day))
        .inDays;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(l.uiTasksNowLc, style: t.kicker.copyWith(color: c.textMuted)),
            const Gap(NizamioSpacing.space2),
            Flexible(
              child: Text(TaskDates.range(task.start, task.due), style: t.mono),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        _DatePair(
          startLabel: l.uiTasksNewStart,
          endLabel: l.uiTasksNewDue,
          start: d.start,
          end: d.due,
          onStart: (v) => ctl.updateDateDraft(d.copyWith(start: v)),
          onEnd: (v) => ctl.updateDateDraft(d.copyWith(due: v)),
        ),
        if (plus != 0) ...[
          const Gap(NizamioSpacing.space2),
          Text(
            '${l.uiTasksDue} ${l.plusDays(plus)}',
            style: t.caption.copyWith(color: c.textMuted),
          ),
        ],
        if (d.datesInvalid) ...[
          const Gap(NizamioSpacing.space1),
          TaskFormError(l.uiTasksErrDates),
        ],
        const Gap(NizamioSpacing.space4),
        NzTextField(
          label: l.uiTasksReason,
          hint: l.uiTasksReasonHint,
          initialValue: d.reason,
          onChanged: (v) => ctl.updateDateDraft(d.copyWith(reason: v)),
        ),
      ],
    );
  }
}

/// "Kanıt dosyası yükle" formu: görev klasörü, alt görev, etiket, dosya adı. Sunucu
/// görevinde etiketler sunucunun kapalı kümesi, ad yerine sistem seçicisinden dosya
/// ([onPick]); izinli türler ve sınır bilgisi gösterilir.
class UploadForm extends ConsumerWidget {
  const UploadForm({super.key, required this.code, this.onPick});

  final String code;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = taskDetailControllerProvider(code);
    final s = ref.watch(p);
    final d = s.upload;
    final ctl = ref.read(p.notifier);
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final task = catalog?.task(code);
    if (d == null || task == null) return const SizedBox.shrink();
    final server = !ctl.permissions.local;
    Color tagColor(EvidenceTag tag) => switch (tag) {
      EvidenceTag.site => c.inProgress,
      EvidenceTag.result => c.accentText,
      EvidenceTag.status => c.textFaint,
      _ => c.textFaint,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.uiTasksTaskFolder, style: t.kicker.copyWith(color: c.textMuted)),
        const Gap(NizamioSpacing.space1),
        Text(
          '${catalog?.coordinatorship(task.coordinatorship)?.name ?? task.coordinatorship}'
          ' / ${task.displayCode} · ${task.title}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: t.bodyMd,
        ),
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(l.uiTasksTabSubtasks),
        Wrap(
          spacing: NizamioSpacing.space2,
          runSpacing: NizamioSpacing.space2,
          children: [
            TaskChip(
              label: l.uiTasksTaskItself,
              selected: d.subtask == null,
              onTap: () => ctl.updateUpload(d.copyWith(subtask: () => null)),
            ),
            for (final u in task.subtasks.where(
              (u) => !u.done && u.title.isNotEmpty,
            ))
              TaskChip(
                label: u.title,
                selected: d.subtask == u.id,
                onTap: () => ctl.updateUpload(d.copyWith(subtask: () => u.id)),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(l.uiTasksTag),
        Wrap(
          spacing: NizamioSpacing.space2,
          runSpacing: NizamioSpacing.space2,
          children: [
            for (final tag in server ? uploadTags : EvidenceTag.prototype)
              TaskChip(
                label: l.tagLabel(tag),
                dot: tagColor(tag),
                selected: d.tag == tag,
                onTap: () => ctl.updateUpload(d.copyWith(tag: tag)),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        if (server) ...[
          NzButton.secondary(
            label: d.file?.name ?? l.uiTasksPickFileAction,
            icon: NzIcons.uploadFile,
            expand: true,
            onPressed: onPick,
          ),
          const Gap(NizamioSpacing.space1),
          Text(
            l.uiTasksUploadTypes,
            style: t.caption.copyWith(color: c.textMuted),
          ),
          if (s.showErrors && d.file == null) ...[
            const Gap(NizamioSpacing.space1),
            TaskFormError(l.uiTasksErrPickFile),
          ],
        ] else ...[
          NzTextField(
            label: l.uiTasksFileName,
            initialValue: d.name,
            onChanged: (v) => ctl.updateUpload(d.copyWith(name: v)),
          ),
          if (s.showErrors && d.name.trim().isEmpty) ...[
            const Gap(NizamioSpacing.space1),
            TaskFormError(l.uiTasksErrFileName),
          ],
          const Gap(NizamioSpacing.space4),
          _PickBox(title: l.uiTasksPickFile, message: l.uiTasksProtoOnly),
        ],
      ],
    );
  }
}

/// Dosya seçim alanı bilgi kutusu (prototip `.rp-empty` dosya seçim alanı).
class _PickBox extends StatelessWidget {
  const _PickBox({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(NizamioRadius.group),
        border: Border.all(
          color: c.borderStrong,
          width: NizamioSize.borderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space5),
        child: Column(
          spacing: NizamioSpacing.space1,
          children: [
            NzIcon(NzIcons.uploadFile, color: c.textMuted),
            Text(title, textAlign: TextAlign.center, style: t.bodyMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
