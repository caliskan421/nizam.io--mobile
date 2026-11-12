import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../domain/timeline.dart';
import '../timeline_texts.dart';
import 'timeline_selection_dates.dart';

/// Çizelgeyi görünür bırakan seçili görev: kimlik, tarihler ve gerçek tarih komutları.
/// Telefon ve tablet aynı içerik/izin yüzünü kullanır; konumu çağıran belirler.
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
    required this.onReset,
    this.canEditDates = false,
    this.canSave = false,
    this.canRequest = false,
    this.busy = false,
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
  final VoidCallback? onRemind;
  final VoidCallback onReset;
  final bool canEditDates;
  final bool canSave;
  final bool canRequest;
  final bool busy;

  static NzTone tone(TaskStatus s) => switch (s) {
    TaskStatus.todo => NzTone.neutral,
    TaskStatus.inProgress => NzTone.progress,
    TaskStatus.review => NzTone.waiting,
    TaskStatus.returned => NzTone.danger,
    TaskStatus.done => NzTone.done,
    TaskStatus.unknown => NzTone.neutral,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final s = selection;
    final task = s.task;
    final late = l.lateText(task);
    final editable = canEditDates && !busy;
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
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: c.borderControl,
                      borderRadius: BorderRadius.circular(NizamioRadius.pill),
                    ),
                  ),
                ),
                const Gap(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: t.titleSm.copyWith(
                              fontSize: 19,
                              height: 25 / 19,
                            ),
                          ),
                          const Gap(8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              NzStatusLabel(
                                label: l.statusLabel(task.status),
                                tone: tone(task.status),
                              ),
                              if (late.isNotEmpty)
                                Text(
                                  '· $late',
                                  style: t.bodySm.copyWith(color: c.danger),
                                ),
                            ],
                          ),
                          const Gap(2),
                          Text(
                            '${s.assignees.isEmpty ? l.uiTimelineGanttUnassigned : s.assignees.join(', ')} · ${l.evidenceText(task.item.files)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                        ],
                      ),
                    ),
                    _HeaderAction(
                      icon: NzIcons.bell,
                      label: onRemind == null
                          ? l.uiTimelineRemindUnavailable
                          : l.uiTimelineRemind,
                      onTap: onRemind,
                    ),
                    _HeaderAction(
                      icon: NzIcons.openExternal,
                      label: l.uiTimelineOpenTask,
                      onTap: onOpen,
                    ),
                    _HeaderAction(
                      icon: NzIcons.close,
                      label: l.uiCommonClose,
                      onTap: onClose,
                    ),
                  ],
                ),
                const Gap(14),
                Row(
                  children: [
                    Expanded(child: NzKicker(l.uiTimelineDates)),
                    if (s.changed)
                      NzButton.ghost(
                        label: l.uiTimelineReset,
                        icon: NzIcons.redo,
                        size: NzSize.sm,
                        onPressed: busy ? null : onReset,
                      ),
                  ],
                ),
                const Gap(4),
                TimelineSelectionDates(
                  selection: s,
                  year: year,
                  editable: editable,
                  onNudgeStart: onNudgeStart,
                  onNudgeEnd: onNudgeEnd,
                  onPickStart: onPickStart,
                  onPickEnd: onPickEnd,
                ),
                const Gap(14),
                Row(
                  spacing: NizamioSpacing.space2,
                  children: [
                    Expanded(
                      child: NzButton.secondary(
                        label: l.uiTimelineSendRequest,
                        expand: true,
                        onPressed: canRequest && !busy ? onRequest : null,
                      ),
                    ),
                    Expanded(
                      child: NzButton.primary(
                        label: l.uiTimelineSave,
                        expand: true,
                        loading: busy,
                        onPressed: canSave && s.changed && !busy
                            ? onSave
                            : null,
                      ),
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

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: SizedBox.square(
          dimension: 32,
          child: Center(
            child: NzIcon(
              icon,
              size: NizamioSize.iconSizeSm,
              color: onTap == null
                  ? context.colors.textFaint
                  : context.colors.text,
            ),
          ),
        ),
      ),
    ),
  );
}
