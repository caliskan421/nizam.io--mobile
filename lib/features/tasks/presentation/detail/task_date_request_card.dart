import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/task_catalog.dart';
import '../task_texts.dart';

/// Görev ayrıntısı ve çizelgede kullanılan tarih talebi ve karar kartı.
class TaskDateRequestCard extends StatelessWidget {
  const TaskDateRequestCard({
    super.key,
    required this.request,
    required this.by,
    required this.onReject,
    required this.onApprove,
    this.waiting = false,
  });

  /// Talep yöneticide bekliyor (salt okunur; kendi talebinde karar düğmesi yok).
  final bool waiting;
  final DateChangeRequest request;
  final String by;

  /// null → karar düğmeleri yok (yalnız şirket yöneticisi karar verir).
  final VoidCallback? onReject;
  final VoidCallback? onApprove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final r = request;
    final plus = DateTime.utc(r.due.year, r.due.month, r.due.day)
        .difference(DateTime.utc(r.oldDue.year, r.oldDue.month, r.oldDue.day))
        .inDays;
    return Semantics(
      container: true,
      label: l.uiTasksRequestTitle,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(NizamioRadius.card),
          border: Border.all(
            color: c.warning.withValues(alpha: 0.4),
            width: NizamioSize.borderWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(NizamioSpacing.rowPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: NizamioSpacing.space3,
            children: [
              Row(
                children: [
                  NzIconTile(icon: NzIcons.eventRepeat, color: c.warning),
                  const Gap(NizamioSpacing.gapMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.uiTasksRequestTitle,
                          style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          [
                            by,
                            if (r.at case final at?)
                              '${TaskDates.short(at)} ${TaskDates.time(at)}',
                          ].where((s) => s.isNotEmpty).join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: NizamioSpacing.space2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    TaskDates.full(r.oldDue),
                    style: t.mono.copyWith(
                      color: c.textMuted,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: c.textMuted,
                    ),
                  ),
                  ExcludeSemantics(
                    child: Text(
                      '→',
                      style: t.mono.copyWith(color: c.textMuted),
                    ),
                  ),
                  Text(
                    TaskDates.full(r.due),
                    style: t.mono.copyWith(
                      color: c.accentText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    l.plusDays(plus),
                    style: t.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ),
              Text(
                '“${r.reason.isEmpty ? l.uiTasksNoReason : r.reason}”',
                style: t.caption.copyWith(color: c.textMuted),
              ),
              if (r.state == DateRequestState.rejected &&
                  r.reviewReason.isNotEmpty)
                Text(
                  '${l.uiTasksRejectReasonLabel}: ${r.reviewReason}',
                  style: t.caption.copyWith(color: c.danger),
                ),
              if (waiting)
                Text(
                  '${l.uiTasksRequestWaitingAdmin} · ${l.uiTasksRequestWaitingNote}',
                  style: t.caption.copyWith(color: c.warning),
                ),
              if (onReject != null && onApprove != null)
                Row(
                  spacing: NizamioSpacing.space2,
                  children: [
                    Expanded(
                      child: NzButton.secondary(
                        label: l.uiTasksReject,
                        expand: true,
                        onPressed: onReject,
                      ),
                    ),
                    Expanded(
                      child: NzButton.primary(
                        label: l.uiTasksApprove,
                        expand: true,
                        onPressed: onApprove,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
