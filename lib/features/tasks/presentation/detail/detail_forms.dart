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
import '../../../../core/ui/widgets/nz_icons.dart';
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
    final p = taskDetailControllerProvider(widget.code);
    // Çakışma birleştirmesi ya da seçimi başlığı değiştirirse alan da güncellenir.
    ref.listen(p.select((s) => s.edit?.title), (_, next) {
      if (next != null && next != _title.text) _title.text = next;
    });
    final d = ref.watch(p).edit;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    if (d == null || catalog == null) return const SizedBox.shrink();
    return _ServerEditBody(code: widget.code, title: _title);
  }
}

/// Sunucu görevinin düzenleme gövdesi: başlık, koordinatörlük (salt okunur), atanan (yalnız
/// koordinatör seçer; ekipten), tarihler, öncelik, kanıt zorunluluğu (zorunlu/opsiyonel).
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
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final task = catalog?.task(code);
    if (d == null || task == null) return const SizedBox.shrink();
    final dept = task.departmentId;
    final assign = ctl.permissions.canAssign && dept != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (d.conflicts.isNotEmpty) ...[
          EditConflictPanel(
            conflicts: d.conflicts,
            onPick: ctl.resolveConflict,
          ),
          const Gap(NizamioSpacing.space4),
        ],
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
        // Yeni görev formuyla aynı sıra: koordinatörlük, atanan, tarih, öncelik, kanıt.
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(l.uiTasksFieldCoord),
        Text(
          catalog?.coordinatorship(task.coordinatorship)?.name ??
              task.coordinatorship,
          style: t.bodyMd.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space4),
        TaskFieldLabel(
          l.uiTasksAssignee,
          trailing: Text(
            '${d.assignees.length}',
            style: t.monoSm.copyWith(color: c.textMuted),
          ),
        ),
        if (assign)
          TeamPicker(
            departmentId: dept,
            selected: d.assignees,
            onToggle: ctl.editToggleAssignee,
          )
        else ...[
          // Atamayı yalnız kapsam koordinatörü yapar (WORK-K10); diğerine salt okunur.
          Text(
            d.assignees.isEmpty
                ? l.uiTasksNoPerson
                : d.assignees
                      .map(
                        (id) => catalog?.nameOf(id) ?? l.uiTasksUnknownPerson,
                      )
                      .join(', '),
            style: t.bodyMd,
          ),
          const Gap(NizamioSpacing.space1),
          Text(
            l.uiTasksAssignByCoord,
            style: t.caption.copyWith(color: c.textMuted),
          ),
        ],
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
        TaskFieldLabel(l.uiTasksEvidenceFile),
        for (final required in const [true, false])
          TaskCheckRow(
            label: required ? l.uiTasksRequired : l.uiTasksOptional,
            radio: true,
            selected: d.evidenceRequired == required,
            onTap: () => ctl.updateEdit(d.copyWith(evidenceRequired: required)),
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
          ' / ${task.title}',
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
            for (final tag in uploadTags)
              TaskChip(
                label: l.tagLabel(tag),
                dot: tagColor(tag),
                selected: d.tag == tag,
                onTap: () => ctl.updateUpload(d.copyWith(tag: tag)),
              ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
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
      ],
    );
  }
}

/// V3 çakışma görünümü: aynı alanı başkası da değiştirdiyse alan başına üç görüntü (açtığınızda,
/// sizin değeriniz, sunucudaki değer) ve iki seçim. Seçim yapılmadan kaydedilmez.
class EditConflictPanel extends StatelessWidget {
  const EditConflictPanel({
    super.key,
    required this.conflicts,
    required this.onPick,
  });

  final Map<EditField, EditConflict> conflicts;
  final void Function(EditField f, {required bool useServer}) onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.text;
    final c = context.colors;
    String label(EditField f) => switch (f) {
      EditField.title => l.uiTasksFieldTitle,
      EditField.priority => l.uiTasksPriority,
      EditField.start => l.uiTasksStart,
      EditField.due => l.uiTasksDue,
      EditField.evidenceRequired => l.uiTasksEvidenceRequired,
    };
    String value(Object v) => switch (v) {
      final String s => s.isEmpty ? l.uiTasksEmptyValue : s,
      final TaskPriority p => l.priorityLabel(p),
      final DateTime d => MaterialLocalizations.of(
        context,
      ).formatCompactDate(d),
      final bool b => b ? l.uiTasksConflictOn : l.uiTasksConflictOff,
      _ => '$v',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzBanner.warning(
          message: '${l.uiTasksConflictTitle}. ${l.uiTasksConflictDesc}',
        ),
        for (final MapEntry(key: f, value: x) in conflicts.entries) ...[
          const Gap(NizamioSpacing.space3),
          TaskFieldLabel(label(f)),
          Text(
            '${l.uiTasksConflictBase}: ${value(x.base)}',
            style: t.caption.copyWith(color: c.textMuted),
          ),
          Text('${l.uiTasksConflictMine}: ${value(x.local)}', style: t.bodyMd),
          Text(
            '${l.uiTasksConflictServer}: ${value(x.server)}',
            style: t.bodyMd,
          ),
          const Gap(NizamioSpacing.space2),
          Row(
            spacing: NizamioSpacing.space2,
            children: [
              Expanded(
                child: NzButton.secondary(
                  label: l.uiTasksConflictKeepMine,
                  expand: true,
                  onPressed: () => onPick(f, useServer: false),
                ),
              ),
              Expanded(
                child: NzButton.secondary(
                  label: l.uiTasksConflictTakeServer,
                  expand: true,
                  onPressed: () => onPick(f, useServer: true),
                ),
              ),
            ],
          ),
        ],
        const Gap(NizamioSpacing.space2),
        TaskFormError(l.uiTasksConflictPending),
      ],
    );
  }
}
