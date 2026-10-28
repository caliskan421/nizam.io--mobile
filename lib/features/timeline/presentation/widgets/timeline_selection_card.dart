import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import 'timeline_controls.dart';

/// Seçili görev kartı (modal değil; çizelge üstünde, altta): görev kimliği ve adı, ayrıntıda aç,
/// kapat; durum, gecikme, atananlar, kanıt; başlangıç/bitiş alanları (− / + ve tarih seçici),
/// "tümünü kaydır", fark özeti, kaydet / talep gönder / hatırlat.
class TimelineSelectionCard extends StatelessWidget {
  const TimelineSelectionCard({
    super.key,
    required this.selection,
    required this.year,
    required this.bottomInset,
    required this.maxHeight,
    required this.onOpen,
    required this.onClose,
    required this.onNudgeStart,
    required this.onNudgeEnd,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onShift,
    required this.onSave,
    required this.onRequest,
    required this.onRemind,
  });

  final TimelineSelection selection;
  final int year;
  final double bottomInset;
  final double maxHeight;
  final VoidCallback onOpen;
  final VoidCallback onClose;
  final ValueChanged<int> onNudgeStart;
  final ValueChanged<int> onNudgeEnd;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final ValueChanged<int> onShift;
  final VoidCallback onSave;
  final VoidCallback onRequest;
  final VoidCallback onRemind;

  static NzTone tone(TaskStatus s) => switch (s) {
    TaskStatus.todo => NzTone.neutral,
    TaskStatus.inProgress => NzTone.progress,
    TaskStatus.review => NzTone.waiting,
    TaskStatus.returned => NzTone.danger,
    TaskStatus.done => NzTone.done,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final s = selection;
    final task = s.task;
    final late = l.lateText(task);
    final delta = l.deltaText(s);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: l.uiTimelineSelectedTask,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(NizamioRadius.sheet),
          ),
          border: Border(top: BorderSide(color: c.borderStrong)),
          boxShadow: context.shadows.sheet,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              NizamioSpacing.gutter,
              6,
              NizamioSpacing.gutter,
              NizamioSpacing.space5 + bottomInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.borderControl,
                      borderRadius: BorderRadius.circular(NizamioRadius.pill),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                        width: 36,
                        height: 4,
                      ),
                    ),
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            [
                              task.code,
                              s.coordinatorshipName,
                              if (task.dependent) l.uiTimelineDependent,
                            ].join(' · ').toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: t.kicker.copyWith(color: c.textMuted),
                          ),
                          const Gap(NizamioSpacing.space1),
                          Text(
                            task.item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: t.labelLg,
                          ),
                        ],
                      ),
                    ),
                    NzIconButton(
                      icon: Icons.open_in_new_rounded,
                      semanticLabel: l.uiTimelineOpenTask,
                      onPressed: onOpen,
                      size: NzSize.sm,
                    ),
                    NzIconButton(
                      icon: Icons.close_rounded,
                      semanticLabel: l.uiCommonClose,
                      onPressed: onClose,
                      size: NzSize.sm,
                    ),
                  ],
                ),
                Wrap(
                  spacing: NizamioSpacing.space3,
                  runSpacing: NizamioSpacing.space1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    NzStatusLabel(
                      label: l.statusLabel(task.status),
                      tone: tone(task.status),
                    ),
                    if (late.isNotEmpty)
                      Text(
                        late,
                        style: t.labelMd.copyWith(
                          color: c.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      '${s.assignees.join(', ')} · '
                      '${l.evidenceText(task.item.files)}',
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ],
                ),
                const Gap(NizamioSpacing.space3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _DateField(
                        label: l.uiTimelineStart,
                        value: l.fullDay(s.draft.start, year),
                        changed: s.startDelta != 0,
                        late: false,
                        onMinus: () => onNudgeStart(-1),
                        onPlus: () => onNudgeStart(1),
                        onPick: onPickStart,
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    Expanded(
                      child: _DateField(
                        label: l.uiTimelineEnd,
                        value: l.fullDay(s.draft.end, year),
                        changed: s.endDelta != 0,
                        late: task.late,
                        onMinus: () => onNudgeEnd(-1),
                        onPlus: () => onNudgeEnd(1),
                        onPick: onPickEnd,
                      ),
                    ),
                  ],
                ),
                const Gap(NizamioSpacing.space2),
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.end,
                  children: [
                    Text(
                      l.uiTimelineShiftAll.toUpperCase(),
                      style: t.kicker.copyWith(color: c.textMuted),
                    ),
                    for (final (label, n) in [
                      (l.uiTimelineShiftWeekBack, -7),
                      (l.uiTimelineShiftDayBack, -1),
                      (l.uiTimelineShiftDayForward, 1),
                      (l.uiTimelineShiftWeekForward, 7),
                    ])
                      TimelineChip(
                        label: label,
                        mono: true,
                        selected: false,
                        onTap: () => onShift(n),
                      ),
                  ],
                ),
                if (delta.isNotEmpty) ...[
                  const Gap(NizamioSpacing.space1),
                  Text(delta, style: t.caption.copyWith(color: c.accentText)),
                ],
                const Gap(NizamioSpacing.space3),
                Row(
                  children: [
                    Expanded(
                      child: NzButton.primary(
                        label: l.uiTimelineSave,
                        size: NzSize.lg,
                        expand: true,
                        onPressed: s.changed ? onSave : null,
                      ),
                    ),
                    const Gap(NizamioSpacing.space2),
                    _SquareAction(
                      icon: Icons.event_available_rounded,
                      label: l.uiTimelineSendRequest,
                      onTap: onRequest,
                    ),
                    const Gap(NizamioSpacing.space2),
                    _SquareAction(
                      icon: Icons.notifications_none_rounded,
                      label: l.uiTimelineRemind,
                      onTap: onRemind,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.changed,
    required this.late,
    required this.onMinus,
    required this.onPlus,
    required this.onPick,
  });

  final String label;
  final String value;
  final bool changed;
  final bool late;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final color = changed
        ? c.accentText
        : late
        ? c.danger
        : c.text;
    final border = changed
        ? c.accentText
        : late
        ? c.danger.withValues(alpha: 0.6)
        : c.border;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: t.kicker.copyWith(color: c.textMuted)),
        const Gap(6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(NizamioRadius.tile),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              _Step(
                icon: Icons.remove_rounded,
                label: '$label ${l.uiTimelineDayBack}',
                onTap: onMinus,
              ),
              Expanded(
                child: TimelineTap(
                  onTap: onPick,
                  label: '$label $value',
                  excludeSemantics: true,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: NizamioSize.tap,
                    ),
                    child: Center(
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: t.mono.copyWith(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _Step(
                icon: Icons.add_rounded,
                label: '$label ${l.uiTimelineDayForward}',
                onTap: onPlus,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => TimelineTap(
    onTap: onTap,
    label: label,
    excludeSemantics: true,
    child: SizedBox(
      width: 36,
      height: NizamioSize.tap,
      child: Icon(
        icon,
        size: NizamioSize.iconSizeSm,
        color: context.colors.text,
      ),
    ),
  );
}

class _SquareAction extends StatelessWidget {
  const _SquareAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: label,
      child: TimelineTap(
        onTap: onTap,
        label: label,
        excludeSemantics: true,
        radius: NizamioRadius.attach,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.surfaceRaised,
            borderRadius: BorderRadius.circular(NizamioRadius.attach),
            border: Border.all(color: c.borderStrong),
          ),
          child: SizedBox(
            width: 48,
            height: NizamioSize.controlLg,
            child: Icon(icon, size: NizamioSize.iconSizeSm, color: c.text),
          ),
        ),
      ),
    );
  }
}
