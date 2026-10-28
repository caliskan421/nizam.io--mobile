import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/quick_forms_controller.dart';
import '../../application/task_catalog_controller.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'quick_parts.dart';

/// "Yeni görev" formu: başlık + tek satırlık özellikler (koordinatörlük, atanan, tarih
/// aralığı yerinde açılır; öncelik ve kanıt zorunluluğu satır içinde).
class NewTaskFormBody extends ConsumerStatefulWidget {
  const NewTaskFormBody({super.key, required this.expansion});

  final ValueNotifier<bool> expansion;

  @override
  ConsumerState<NewTaskFormBody> createState() => _NewTaskFormBodyState();
}

class _NewTaskFormBodyState extends ConsumerState<NewTaskFormBody> {
  late final _auto = AutoExpand(widget.expansion);

  @override
  Widget build(BuildContext context) {
    ref.listen(newTaskFormControllerProvider.select((f) => f.pane), (a, b) {
      if (b == NewTaskPane.dates) _auto.onPane(opened: true);
      if (a == NewTaskPane.dates && b != NewTaskPane.dates) {
        _auto.onPane(opened: false);
      }
    });
    final l = context.l10n;
    final c = context.colors;
    final f = ref.watch(newTaskFormControllerProvider);
    final ctl = ref.read(newTaskFormControllerProvider.notifier);
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final coord = f.coordinatorship == null
        ? null
        : catalog?.coordinatorship(f.coordinatorship!);
    String name(String id) => catalog?.person(id)?.name ?? id;
    final assigneeValue = f.assignees.isEmpty
        ? (coord == null ? l.uiTasksCoordFirst : l.uiTasksPickPerson)
        : f.assignees.length == 1
        ? name(f.assignees.first)
        : '${name(f.assignees.first).split(' ').first} +${f.assignees.length - 1}';
    final dateValue = f.picking
        ? '${TaskDates.short(f.start)} → …'
        : '${TaskDates.short(f.start)} → ${TaskDates.short(f.end)} · '
              '${l.duration(f.days)}';
    final error = f.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuickTitleField(
          label: l.uiTasksFieldTitle,
          hint: l.uiTasksNtTitleHint,
          value: f.title,
          onChanged: ctl.setTitle,
        ),
        const Gap(NizamioSpacing.space3),
        NzFormRows(
          expandedIndex: switch (f.pane) {
            NewTaskPane.coordinatorship => 0,
            NewTaskPane.assignees => 1,
            NewTaskPane.dates => 2,
            null => null,
          },
          onToggle: (i) => ctl.togglePane(NewTaskPane.values[i]),
          rows: [
            NzFormRow(
              label: l.uiTasksFieldCoord,
              icon: Icons.apartment_rounded,
              value: coord?.name ?? l.uiTasksPick,
              valueSet: coord != null,
              content: QuickPane(
                child: Column(
                  children: [
                    for (final co
                        in catalog?.coordinatorships ??
                            const <CoordinatorshipRef>[])
                      TaskCheckRow(
                        label: co.name,
                        caption: l.peopleCount(co.team.length),
                        radio: true,
                        selected: co.code == f.coordinatorship,
                        onTap: () => ctl.pickCoordinatorship(co.code),
                      ),
                  ],
                ),
              ),
            ),
            NzFormRow(
              label: l.uiTasksAssignee,
              icon: Icons.person_outline_rounded,
              value: assigneeValue,
              valueSet: f.assignees.isNotEmpty,
              content: QuickPane(
                child: coord == null || coord.team.isEmpty
                    ? Text(
                        l.uiTasksNobodyHere,
                        style: context.text.caption.copyWith(
                          color: c.textMuted,
                        ),
                      )
                    : Column(
                        children: [
                          for (final id in coord.team)
                            TaskCheckRow(
                              label: name(id),
                              caption: coord.leads.contains(id)
                                  ? l.uiTasksRoleCoordinatorLc
                                  : l.uiTasksRoleMemberLc,
                              selected: f.assignees.contains(id),
                              onTap: () => ctl.toggleAssignee(id),
                            ),
                        ],
                      ),
              ),
            ),
            NzFormRow(
              label: l.uiTasksRowDate,
              icon: Icons.calendar_today_outlined,
              value: dateValue,
              valueSet: true,
              content: QuickPane(
                child: NzRangeCalendar(
                  month: f.month,
                  start: f.start,
                  end: f.picking ? null : f.end,
                  today: catalog?.today,
                  onMonthStep: ctl.stepMonth,
                  onDayTap: ctl.pickDay,
                ),
              ),
            ),
            NzFormRow.custom(
              label: l.uiTasksPriority,
              leading: NzPriorityBars(level: priorityLevel(f.priority)),
              trailing: TaskSegmented(
                compact: true,
                semanticLabel: l.uiTasksPriority,
                labels: [
                  for (final p in TaskPriority.values) l.priorityLabel(p),
                ],
                selected: f.priority.index,
                onSelected: (i) => ctl.setPriority(TaskPriority.values[i]),
              ),
            ),
            NzFormRow.toggle(
              label: l.uiTasksEvidenceRequired,
              icon: Icons.attach_file_rounded,
              value: f.evidenceRequired,
              onChanged: (v) => ctl.setEvidenceRequired(value: v),
            ),
          ],
        ),
        if (error != null) ...[
          const Gap(NizamioSpacing.space3),
          TaskFormError(l.newTaskError(error)),
        ],
      ],
    );
  }
}
