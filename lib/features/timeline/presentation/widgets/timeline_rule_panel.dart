import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/nz_size.dart';
import '../../../tasks/tasks.dart' show TaskStatus, showTaskDateRequestSheet;
import '../../domain/timeline.dart';
import '../../domain/timeline_rules.dart';

/// Seçili görev kartının kural ve komut bölümü (prototip `gantt` koordinatör dalı): bekleyen
/// talep girişi, hızlı komutlar (Süre uzat, Bitişi bugüne çek), kural satırı, gerekçe alanı
/// ve birincil komut. Yol [TimelineDateChange]'ten okunur; telefon ve tablet aynı bölümü
/// kullanır. Talep girişi ayrıntıdaki ortak gerekçe/karar kartını açar; koordinatör
/// kendi talebini onaylayamaz.
class TimelineRulePanel extends StatefulWidget {
  const TimelineRulePanel({
    super.key,
    required this.selection,
    required this.year,
    required this.directRule,
    required this.canSave,
    required this.canRequest,
    required this.busy,
    required this.onSave,
    required this.onRequest,
    required this.onExtendDraft,
    this.onPull,
  });

  final TimelineSelection selection;
  final int year;

  /// 7 gün kuralı (Koordinatör görünümü); kapalıysa her değişiklik doğrudan kaydedilir.
  final bool directRule;
  final bool canSave;
  final bool canRequest;
  final bool busy;
  final VoidCallback onSave;
  final ValueChanged<String> onRequest;
  final VoidCallback onExtendDraft;

  /// "Bitişi bugüne çek"; koşul sağlanmıyorsa null (gizli).
  final VoidCallback? onPull;

  static const reasonKey = ValueKey('timeline-request-reason');

  @override
  State<TimelineRulePanel> createState() => _TimelineRulePanelState();
}

class _TimelineRulePanelState extends State<TimelineRulePanel> {
  final _reason = TextEditingController();

  @override
  void didUpdateWidget(TimelineRulePanel old) {
    super.didUpdateWidget(old);
    if (old.selection.task.code != widget.selection.task.code) _reason.clear();
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final s = widget.selection;
    final busy = widget.busy;
    final change = TimelineDateChange.of(
      s.current,
      s.draft,
      directRule: widget.directRule,
    );
    final pending = s.task.item.hasPendingRequest;
    final done = s.task.status == TaskStatus.done;
    final request = change is TimelineRequest;
    final quick = [
      if (widget.canSave && !done)
        NzButton.primary(
          label: l.uiTasksExtend,
          icon: NzIcons.add,
          size: NzSize.sm,
          onPressed: busy ? null : widget.onExtendDraft,
        ),
      if (widget.canSave && widget.onPull != null)
        NzButton.secondary(
          label: l.uiTimelinePullToday,
          icon: NzIcons.check,
          size: NzSize.sm,
          onPressed: busy ? null : widget.onPull,
        ),
    ];
    Widget note(String text, Color color, IconData icon) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NzIcon(icon, size: NizamioSize.iconSizeSm, color: color),
        const Gap(NizamioSpacing.space2),
        Expanded(
          child: Text(text, style: t.caption.copyWith(color: color)),
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (pending || quick.isNotEmpty) ...[
          const Gap(NizamioSpacing.space3),
          Container(
            padding: const EdgeInsets.all(NizamioSpacing.space2),
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              border: Border.all(color: c.borderStrong),
            ),
            child: Row(
              children: [
                if (pending)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: busy
                          ? null
                          : () =>
                                showTaskDateRequestSheet(context, s.task.code),
                      icon: NzIcon(
                        NzIcons.clock,
                        size: NizamioSize.iconSizeSm,
                        color: c.warning,
                      ),
                      label: Text(l.uiTasksViewRequest),
                      style: TextButton.styleFrom(foregroundColor: c.warning),
                    ),
                  )
                else
                  const Spacer(),
                if (pending && quick.isNotEmpty)
                  const Gap(NizamioSpacing.space2),
                ...quick,
              ],
            ),
          ),
        ],
        if (widget.directRule) ...[
          const Gap(NizamioSpacing.space3),
          note(
            request ? l.uiTimelineRuleRequest : l.uiTimelineRuleDirect,
            c.textMuted,
            request ? NzIcons.clock : NzIcons.info,
          ),
        ],
        if (widget.directRule && request && widget.canRequest && !pending) ...[
          const Gap(NizamioSpacing.space3),
          NzTextField.multiline(
            key: TimelineRulePanel.reasonKey,
            controller: _reason,
            label: l.uiTimelineReasonLabel,
            hint: l.uiTimelineReasonHint,
            enabled: !busy,
            onChanged: (_) => setState(() {}),
          ),
        ],
        const Gap(14),
        _actions(context, change, pending: pending),
      ],
    );
  }

  Widget _actions(
    BuildContext context,
    TimelineDateChange change, {
    required bool pending,
  }) {
    final l = context.l10n;
    final busy = widget.busy;
    final changed = change is! TimelineNoChange;
    if (!widget.directRule) {
      // Kuralsız görünüm (yönetici): bugünkü iki komut.
      return Row(
        spacing: NizamioSpacing.space2,
        children: [
          Expanded(
            child: NzButton.secondary(
              label: l.uiTimelineSendRequest,
              expand: true,
              onPressed: widget.canRequest && changed && !busy && !pending
                  ? () => widget.onRequest(_reason.text)
                  : null,
            ),
          ),
          Expanded(
            child: NzButton.primary(
              label: l.uiTimelineSave,
              expand: true,
              loading: busy,
              onPressed: widget.canSave && changed && !busy
                  ? widget.onSave
                  : null,
            ),
          ),
        ],
      );
    }
    if (change is TimelineRequest) {
      final ok =
          widget.canRequest &&
          !pending &&
          _reason.text.trim().length >= timelineReasonMin;
      return NzButton.primary(
        label: l.uiTimelineRequestGo,
        expand: true,
        loading: busy,
        onPressed: ok && !busy ? () => widget.onRequest(_reason.text) : null,
      );
    }
    return NzButton.primary(
      label: switch (change) {
        TimelineExtend() => l.uiTasksExtend,
        _ => l.uiTimelineSave,
      },
      expand: true,
      loading: busy,
      onPressed: widget.canSave && changed && !busy ? widget.onSave : null,
    );
  }
}
