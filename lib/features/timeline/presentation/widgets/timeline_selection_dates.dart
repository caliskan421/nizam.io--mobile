import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import 'timeline_controls.dart';

/// Taslak ve kayıtlı tarihleri aynı satırda gösterir. Gecikme sunucu olgusudur;
/// bağımsız düzenlenebilir üçüncü tarih alanı üretilmez.
class TimelineSelectionDates extends StatelessWidget {
  const TimelineSelectionDates({
    super.key,
    required this.selection,
    required this.year,
    required this.editable,
    required this.onNudgeStart,
    required this.onNudgeEnd,
    required this.onPickStart,
    required this.onPickEnd,
  });

  final TimelineSelection selection;
  final int year;
  final bool editable;
  final ValueChanged<int> onNudgeStart;
  final ValueChanged<int> onNudgeEnd;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = selection;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        children: [
          _DateRow(
            label: l.uiTimelineStart,
            value: l.fullDay(s.draft.start, year),
            previous: s.startDelta == 0
                ? null
                : l.fullDay(s.current.start, year),
            onMinus: editable ? () => onNudgeStart(-1) : null,
            onPlus: editable && s.draft.start < s.draft.end
                ? () => onNudgeStart(1)
                : null,
            onPick: editable ? onPickStart : null,
          ),
          Divider(height: 1, thickness: 1, color: context.colors.border),
          _DateRow(
            label: l.uiTimelineEnd,
            value: l.fullDay(s.draft.end, year),
            previous: s.endDelta == 0 ? null : l.fullDay(s.current.end, year),
            late: s.task.late,
            onMinus: editable && s.draft.end > s.draft.start
                ? () => onNudgeEnd(-1)
                : null,
            onPlus: editable ? () => onNudgeEnd(1) : null,
            onPick: editable ? onPickEnd : null,
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    this.previous,
    this.late = false,
    this.onMinus,
    this.onPlus,
    this.onPick,
  });

  final String label;
  final String value;
  final String? previous;
  final bool late;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final changed = previous != null;
    final stepper = DecoratedBox(
      decoration: BoxDecoration(
        color: c.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: changed ? c.accentText : c.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Step(
            icon: NzIcons.remove,
            label: '$label ${context.l10n.uiTimelineDayBack}',
            onTap: onMinus,
          ),
          TimelineTap(
            onTap: onPick,
            label: '$label $value',
            excludeSemantics: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Text(
                value,
                style: t.mono.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: changed
                      ? c.accentText
                      : late
                      ? c.danger
                      : c.text,
                ),
              ),
            ),
          ),
          _Step(
            icon: NzIcons.add,
            label: '$label ${context.l10n.uiTimelineDayForward}',
            onTap: onPlus,
          ),
        ],
      ),
    );
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.bodyMd),
        if (previous case final date?)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${context.l10n.uiTimelinePrevious} '),
                TextSpan(
                  text: date,
                  style: t.monoSm.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            style: t.caption.copyWith(color: c.textFaint),
          ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      child: LayoutBuilder(
        builder: (context, box) =>
            box.maxWidth < 160 + MediaQuery.textScalerOf(context).scale(100)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  title,
                  Align(alignment: Alignment.centerRight, child: stepper),
                ],
              )
            : Row(
                children: [
                  Expanded(child: title),
                  const Gap(12),
                  stepper,
                ],
              ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => TimelineTap(
    onTap: onTap,
    label: label,
    excludeSemantics: true,
    child: SizedBox(
      width: 34,
      height: 40,
      child: Center(
        child: NzIcon(
          icon,
          size: NizamioSize.iconSizeSm,
          color: onTap == null
              ? context.colors.textFaint
              : context.colors.textMuted,
        ),
      ),
    ),
  );
}
