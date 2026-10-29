import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../domain/horizontal_timeline.dart';
import '../timeline_texts.dart';
import 'gantt_geometry.dart';
import 'gantt_painters.dart';
import 'gantt_texts.dart';

/// Seçili görev kartı (prototip `role="region" aria-label="Seçili görev"`, 360): kod,
/// koordinatörlük, kapat; başlık; durum / tarih / atanan kutusu; gecikme; "Görev ayrıntısını aç".
class GanttSelectionCard extends StatelessWidget {
  const GanttSelectionCard({
    super.key,
    required this.selection,
    required this.year,
    required this.onClose,
    required this.onOpen,
  });

  final GanttSelection selection;
  final int year;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  /// Kapat düğmesinin (32 × 32 dokunma alanı) anahtarı.
  static const closeKey = ValueKey('gantt-card-close');

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final task = selection.task;
    final key = t.monoSm.copyWith(
      fontSize: GanttGeometry.cardKeySize,
      color: c.textFaint,
    );
    final value = t.bodyMd.copyWith(fontSize: GanttGeometry.rowTitleSize);
    Widget field(String k, Widget v) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(k, style: key),
        const Gap(2),
        v,
      ],
    );
    final radius = BorderRadius.circular(GanttGeometry.cardRadius);
    return Semantics(
      container: true,
      label: l.uiTimelineSelectedTask,
      explicitChildNodes: true,
      child: TweenAnimationBuilder<double>(
        key: ValueKey(task.code),
        tween: Tween(begin: 0, end: 1),
        duration: NzMotion.of(context, GanttGeometry.cardDuration),
        curve: NizamioMotion.easeSheet,
        builder: (context, v, child) => Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(0, (1 - v) * GanttGeometry.cardRise),
            child: Transform.scale(
              scale:
                  GanttGeometry.cardRiseScale +
                  (1 - GanttGeometry.cardRiseScale) * v,
              child: child,
            ),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: context.shadows.sheet,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: GanttGeometry.cardBlur,
                sigmaY: GanttGeometry.cardBlur,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.surface.withValues(alpha: GanttGeometry.cardAlpha),
                  borderRadius: radius,
                  border: Border.all(color: c.borderStrong),
                ),
                // Kenarlık içi (CSS `box-sizing: border-box`): içerik 1 px içeride.
                child: Padding(
                  padding: const EdgeInsets.all(NizamioSize.borderWidth),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(GanttGeometry.cardPad),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Kapat düğmesi CSS `margin: −6 −6 −6 0` ile akışta 26 × 20 yer
                            // kaplar; görünür 32 × 32 düğme kartın üstünde ayrıca konumlanır.
                            SizedBox(
                              height:
                                  GanttGeometry.cardClose +
                                  2 * GanttGeometry.cardCloseInset,
                              child: Row(
                                children: [
                                  Text(
                                    task.code,
                                    style: t.monoSm.copyWith(
                                      fontSize: GanttGeometry.cardCodeSize,
                                      color: c.textMuted,
                                    ),
                                  ),
                                  const Gap(NizamioSpacing.space2),
                                  Expanded(
                                    child: Text(
                                      selection.coordinatorshipName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.caption.copyWith(
                                        color: c.textMuted,
                                      ),
                                    ),
                                  ),
                                  // Satır yüksekliği 20 (üstteki SizedBox); düğmenin akıştaki eni 26.
                                  const Gap(
                                    GanttGeometry.cardClose +
                                        GanttGeometry.cardCloseInset,
                                  ),
                                ],
                              ),
                            ),
                            const Gap(GanttGeometry.cardGap),
                            Text(
                              task.item.title,
                              style: t.labelLg.copyWith(
                                fontSize: GanttGeometry.cardTitleSize,
                                height:
                                    GanttGeometry.cardTitleLine /
                                    GanttGeometry.cardTitleSize,
                              ),
                            ),
                            const Gap(GanttGeometry.cardGap),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: c.surfaceRaised,
                                borderRadius: BorderRadius.circular(
                                  GanttGeometry.cardInfoRadius,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  GanttGeometry.cardInfoPad,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: field(
                                            l.uiTimelineGanttCardStatus,
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width:
                                                      GanttGeometry.statusDot,
                                                  height:
                                                      GanttGeometry.statusDot,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: ganttStatusColor(
                                                        c,
                                                        task.status,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                const Gap(
                                                  GanttGeometry.chipGap,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    l.statusLabel(task.status),
                                                    style: value,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Gap(GanttGeometry.cardInfoColGap),
                                        Expanded(
                                          child: field(
                                            l.uiTimelineGanttCardDate,
                                            Text(
                                              l.ganttRange(task, year),
                                              style: t.mono.copyWith(
                                                fontSize:
                                                    GanttGeometry.rowTitleSize,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(GanttGeometry.cardInfoRowGap),
                                    field(
                                      l.uiTimelineGanttCardAssignee,
                                      Text(
                                        l.ganttAssignees(selection),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: value,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (task.late) ...[
                              const Gap(GanttGeometry.cardGap),
                              Text(
                                l.ganttLateDays(task),
                                style: t.monoSm.copyWith(
                                  fontSize: GanttGeometry.cardCodeSize,
                                  color: c.danger,
                                ),
                              ),
                            ],
                            const Gap(GanttGeometry.cardGap),
                            NzButton.primary(
                              label: l.uiTimelineGanttOpenTask,
                              onPressed: onOpen,
                              expand: true,
                            ),
                          ],
                        ),
                      ),
                      // Görünür kaynak konumu: dolgu 16 − 6 = 10 üstten ve sağdan.
                      Positioned(
                        key: GanttSelectionCard.closeKey,
                        top:
                            GanttGeometry.cardPad +
                            GanttGeometry.cardCloseInset,
                        right:
                            GanttGeometry.cardPad +
                            GanttGeometry.cardCloseInset,
                        width: GanttGeometry.cardClose,
                        height: GanttGeometry.cardClose,
                        child: Semantics(
                          button: true,
                          label: l.uiCommonClose,
                          excludeSemantics: true,
                          onTap: onClose,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onClose,
                            child: Center(
                              child: NzPathIcon(
                                GanttGeometry.close,
                                size: NizamioSize.iconSizeSm,
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
