import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/errors/error_text.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/quick_forms_controller.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/tasks_providers.dart';
import '../../domain/task_catalog.dart';
import '../detail/detail_forms.dart';
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
    // Sunucu katalogu: koordinatörlük = departman; adaylar departman ekibinden (tek atanan).
    final server = catalog?.access != null;
    // Ekip (`listMembers`) yalnız görev açabilen hesapta okunur: yetkisizde istek yok.
    final teamOpen =
        server && coord != null && ref.watch(canCreateTaskProvider);
    // Seçili atananın adı: sunucuda departman ekibinden (`listMembers`, seçicinin kaynağı),
    // yoksa katalogdaki addan; bilinmiyorsa nötr etiket.
    final team = teamOpen
        ? ref.watch(taskTeamProvider(coord.code)).value
        : null;
    String name(String id) =>
        team?.where((m) => m.accountId == id).firstOrNull?.name ??
        catalog?.nameOf(id) ??
        l.uiTasksUnknownPerson;
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
              icon: NzIcons.coordinatorships,
              value: coord?.name ?? l.uiTasksPick,
              valueSet: coord != null,
              // Kaynak: seçilmemiş "Seç" `accent-text`, seçili `ink-muted`.
              valueColor: coord == null ? c.accentText : c.textMuted,
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
              icon: NzIcons.person,
              value: assigneeValue,
              valueSet: f.assignees.isNotEmpty,
              valueColor: f.assignees.isNotEmpty
                  ? c.textMuted
                  : coord == null
                  ? c.textFaint
                  : c.accentText,
              content: QuickPane(
                child: teamOpen
                    ? TeamPicker(
                        departmentId: coord.code,
                        selected: f.assignees,
                        onToggle: ctl.toggleAssignee,
                      )
                    : coord == null || coord.team.isEmpty
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
              icon: NzIcons.calendar,
              value: dateValue,
              valueSet: true,
              valueColor: f.end.isBefore(f.start) ? c.danger : c.textMuted,
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
                  for (final p in TaskPriority.pickable) l.priorityLabel(p),
                ],
                selected: TaskPriority.pickable.indexOf(f.priority),
                onSelected: (i) => ctl.setPriority(TaskPriority.pickable[i]),
              ),
            ),
            NzFormRow.toggle(
              label: l.uiTasksEvidenceRequired,
              icon: NzIcons.attach,
              value: f.evidenceRequired,
              onChanged: (v) => ctl.setEvidenceRequired(value: v),
            ),
          ],
        ),
        if (error != null) ...[
          const Gap(NizamioSpacing.space3),
          TaskFormError(l.newTaskError(error)),
        ],
        if (f.failure case final failure?) ...[
          const Gap(NizamioSpacing.space3),
          TaskFormError(errorText(l, failure)),
        ],
      ],
    );
  }
}
