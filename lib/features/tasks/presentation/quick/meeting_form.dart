import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/quick_forms_controller.dart';
import '../../application/task_catalog_controller.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'quick_parts.dart';

/// "Toplantı oluştur" formu: başlık + tarih (takvim), saat (çark), davetliler
/// (koordinatörlük ya da kişi), gündem maddeleri.
class MeetingFormBody extends ConsumerStatefulWidget {
  const MeetingFormBody({super.key, required this.expansion});

  final ValueNotifier<bool> expansion;

  @override
  ConsumerState<MeetingFormBody> createState() => _MeetingFormBodyState();
}

class _MeetingFormBodyState extends ConsumerState<MeetingFormBody> {
  late final _auto = AutoExpand(widget.expansion);
  final _draft = TextEditingController();

  static const _big = {
    MeetingPane.date,
    MeetingPane.invitees,
    MeetingPane.agenda,
  };

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(meetingFormControllerProvider.select((f) => f.pane), (a, b) {
      if (b != null && _big.contains(b)) {
        _auto.onPane(opened: true);
      } else if (a != null && _big.contains(a)) {
        _auto.onPane(opened: false);
      }
    });
    final l = context.l10n;
    final t = context.text;
    final f = ref.watch(meetingFormControllerProvider);
    final ctl = ref.read(meetingFormControllerProvider.notifier);
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final coords = catalog?.coordinatorships ?? const <CoordinatorshipRef>[];
    String name(String id) => catalog?.person(id)?.name ?? id;
    final String? who;
    if (f.mode == MeetingMode.coordinatorships) {
      who = f.coordinatorships.isEmpty
          ? null
          : (f.coordinatorships.length == 1
                    ? catalog
                              ?.coordinatorship(f.coordinatorships.first)
                              ?.name ??
                          f.coordinatorships.first
                    : '${f.coordinatorships.length} ${l.uiTasksCoordsLc}') +
                (f.allMembers ? ' · ${l.uiTasksWithMembers}' : '');
    } else {
      who = f.people.isEmpty
          ? null
          : f.people.length == 1
          ? name(f.people.first)
          : '${name(f.people.first).split(' ').first} +${f.people.length - 1}';
    }
    if (_draft.text != f.agendaDraft) _draft.text = f.agendaDraft;
    final error = f.error;
    final time =
        '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuickTitleField(
          label: l.uiTasksFieldTitle,
          hint: l.uiTasksMtTitleHint,
          value: f.title,
          maxLength: 255,
          onChanged: ctl.setTitle,
        ),
        const Gap(NizamioSpacing.space3),
        NzFormRows(
          expandedIndex: f.pane?.index,
          onToggle: (i) => ctl.togglePane(MeetingPane.values[i]),
          rows: [
            NzFormRow(
              label: l.uiTasksRowDate,
              icon: Icons.calendar_today_outlined,
              value: '${TaskDates.short(f.date)} ${TaskDates.weekday(f.date)}',
              valueSet: true,
              content: QuickPane(
                child: NzRangeCalendar(
                  month: f.month,
                  start: f.date,
                  today: ctl.today,
                  firstDate: ctl.today,
                  onMonthStep: ctl.stepMonth,
                  onDayTap: ctl.pickDate,
                ),
              ),
            ),
            NzFormRow(
              label: l.uiTasksRowTime,
              icon: Icons.schedule_rounded,
              value: time,
              valueSet: true,
              content: QuickPane(
                child: NzTimeWheel(
                  hour: f.hour,
                  minute: f.minute,
                  onChanged: ctl.setTime,
                ),
              ),
            ),
            NzFormRow(
              label: l.uiTasksRowInvitees,
              icon: Icons.group_outlined,
              value: who ?? l.uiTasksPick,
              valueSet: who != null,
              content: QuickPane(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TaskSegmented(
                      labels: [l.uiTasksGroupCoord, l.uiTasksModePeople],
                      selected: f.mode.index,
                      onSelected: (i) => ctl.setMode(MeetingMode.values[i]),
                    ),
                    const Gap(NizamioSpacing.space2),
                    if (f.mode == MeetingMode.coordinatorships) ...[
                      for (final co in coords)
                        TaskCheckRow(
                          label: co.name,
                          caption: f.allMembers
                              ? l.peopleCount(co.team.length)
                              : '${co.leads.length} ${l.uiTasksCoordAbbr}',
                          selected: f.coordinatorships.contains(co.code),
                          onTap: () => ctl.toggleCoordinatorship(co.code),
                        ),
                      NzSwitch(
                        label: l.uiTasksInviteMembers,
                        value: f.allMembers,
                        onChanged: (_) => ctl.toggleAllMembers(),
                      ),
                    ] else
                      for (final co in coords.where((x) => x.team.isNotEmpty))
                        _PeopleGroup(
                          coord: co,
                          name: name,
                          open: f.openGroups.contains(co.code),
                          selected: f.people,
                          onToggle: () => ctl.toggleGroup(co.code),
                          onPick: ctl.togglePerson,
                        ),
                  ],
                ),
              ),
            ),
            NzFormRow(
              label: l.uiTasksRowAgenda,
              icon: Icons.format_list_bulleted_rounded,
              value: f.agenda.isEmpty
                  ? l.uiTasksAddItem
                  : '${f.agenda.length} ${l.uiTasksItemsLc}',
              valueSet: f.agenda.isNotEmpty,
              content: QuickPane(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < f.agenda.length; i++)
                      _AgendaItem(
                        key: ValueKey('ag-$i-${f.agenda.length}'),
                        index: i,
                        text: f.agenda[i],
                        onChanged: (v) => ctl.setAgendaItem(i, v),
                        onDone: () => ctl.finishAgendaItem(i),
                        onRemove: () => ctl.removeAgenda(i),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _draft,
                            maxLength: 160,
                            onChanged: ctl.setAgendaDraft,
                            onSubmitted: (_) => ctl.addAgenda(),
                            style: t.bodyMd,
                            decoration: InputDecoration(
                              labelText: l.uiTasksAgendaItem,
                              hintText: l.uiTasksAddItem,
                              counterText: '',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        NzIconButton.circleAccent(
                          icon: Icons.add_rounded,
                          semanticLabel: l.uiTasksAddItemLabel,
                          onPressed: f.agendaDraft.trim().isEmpty
                              ? null
                              : ctl.addAgenda,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (error != null) ...[
          const Gap(NizamioSpacing.space3),
          TaskFormError(l.meetingError(error)),
        ],
      ],
    );
  }
}

class _PeopleGroup extends StatelessWidget {
  const _PeopleGroup({
    required this.coord,
    required this.name,
    required this.open,
    required this.selected,
    required this.onToggle,
    required this.onPick,
  });

  final CoordinatorshipRef coord;
  final String Function(String) name;
  final bool open;
  final List<String> selected;
  final VoidCallback onToggle;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final team = coord.team;
    final k = team.where(selected.contains).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: open,
          label: coord.name,
          excludeSemantics: true,
          child: InkWell(
            onTap: onToggle,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: NizamioSize.tap),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      coord.name,
                      style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    k > 0 ? '$k/${team.length}' : l.peopleCount(team.length),
                    style: t.monoSm.copyWith(
                      color: k > 0 ? c.accentText : c.textFaint,
                    ),
                  ),
                  const Gap(NizamioSpacing.space2),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: NzMotion.of(context, NizamioMotion.durPress),
                    child: Icon(
                      Icons.expand_more_rounded,
                      size: NizamioSize.iconSizeSm,
                      color: c.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        NzReveal(
          open: open,
          child: Column(
            children: [
              for (final id in team)
                TaskCheckRow(
                  label: name(id),
                  caption: coord.leads.contains(id)
                      ? l.uiTasksRoleCoordinatorLc
                      : l.uiTasksRoleMemberLc,
                  captionColor: coord.leads.contains(id)
                      ? c.accentText
                      : c.textFaint,
                  selected: selected.contains(id),
                  onTap: () => onPick(id),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AgendaItem extends StatefulWidget {
  const _AgendaItem({
    super.key,
    required this.index,
    required this.text,
    required this.onChanged,
    required this.onDone,
    required this.onRemove,
  });

  final int index;
  final String text;
  final ValueChanged<String> onChanged;
  final VoidCallback onDone;
  final VoidCallback onRemove;

  @override
  State<_AgendaItem> createState() => _AgendaItemState();
}

class _AgendaItemState extends State<_AgendaItem> {
  late final _controller = TextEditingController(text: widget.text);
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final n = widget.index + 1;
    return Row(
      children: [
        Text('$n', style: t.mono.copyWith(color: c.textFaint)),
        const Gap(NizamioSpacing.space3),
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            maxLength: 160,
            onChanged: widget.onChanged,
            onSubmitted: (_) => _focus.unfocus(),
            style: t.bodyMd,
            decoration: InputDecoration(
              isDense: true,
              counterText: '',
              border: InputBorder.none,
              semanticCounterText: '',
              hintText: '$n${l.uiTasksItemTail}',
            ),
          ),
        ),
        NzIconButton(
          icon: Icons.close_rounded,
          semanticLabel: '$n${l.uiTasksRemoveItemTail}',
          onPressed: widget.onRemove,
        ),
      ],
    );
  }
}
