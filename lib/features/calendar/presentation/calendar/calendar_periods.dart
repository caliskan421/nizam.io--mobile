import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';
import 'calendar_period_sheet.dart';
import 'calendar_texts.dart';

/// Dönem kartları: Geçen hafta, Bugün, Gelecek hafta. Her kart başlık + tarih aralığı, solda
/// halka (geçen haftada tamamlanma oranı, diğerlerinde biten/başlayan/toplantı dağılımı;
/// ortadaki sayı her zaman etiketli), sağda renk noktalı sayı satırları (devam eden görevler
/// dahil). Dokunuş o dönemin kayıtlarını pencerede açar ([showCalendarPeriodSheet]).
/// Genişte yan yana, darda alt alta.
class CalendarPeriods extends StatelessWidget {
  const CalendarPeriods({super.key, required this.index});

  final CalendarIndex index;

  /// Üç kartın yan yana sığdığı en küçük genişlik.
  static const _rowMinWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final today = index.today;
    final last = weekOf(DateTime(today.year, today.month, today.day - 7));
    final next = weekOf(DateTime(today.year, today.month, today.day + 7));
    final past = index.period(last.first, last.last);
    final now = index.period(today, today);
    final ahead = index.period(next.first, next.last);
    final ends = c.kind(CalendarKind.task);
    final starts = c.roleMember;
    final meetings = c.kind(CalendarKind.meeting);

    _Period upcoming(
      String label,
      DateTime from,
      DateTime to,
      CalendarPeriod p,
    ) => (
      label: label,
      from: from,
      to: to,
      ring: [(p.due, ends), (p.starts, starts), (p.meetings, meetings)],
      center: '${p.due + p.starts + p.meetings}',
      centerCaption: l.uiCalendarRingRecords,
      legend: [
        (l.uiCalendarLegendEnds, p.due, ends, false),
        (l.uiCalendarLegendStarts, p.starts, starts, false),
        (l.uiCalendarLegendOngoing, p.ongoing, c.textMuted, true),
        (l.uiCalendarLegendMeetings, p.meetings, meetings, false),
      ],
    );

    final rate = past.due == 0 ? null : (past.done * 100 / past.due).round();
    final periods = <_Period>[
      (
        label: l.uiCalendarLastWeek,
        from: last.first,
        to: last.last,
        ring: [(past.done, c.taskDone), (past.late, c.danger)],
        center: rate == null ? '—' : '%$rate',
        centerCaption: rate == null
            ? l.uiCalendarRingNoDue
            : l.uiCalendarRingDone,
        legend: [
          (l.uiCalendarLegendDone, past.done, c.taskDone, false),
          (l.uiCalendarLegendLate, past.late, c.danger, false),
          (l.uiCalendarLegendStarted, past.starts, starts, false),
          (l.uiCalendarLegendOngoing, past.ongoing, c.textMuted, true),
          (l.uiCalendarLegendMeetings, past.meetings, meetings, false),
        ],
      ),
      upcoming(l.uiCalendarToday, today, today, now),
      upcoming(l.uiCalendarNextWeekCard, next.first, next.last, ahead),
    ];
    final cards = [
      for (final p in periods)
        _PeriodCard(
          period: p,
          onTap: () => showCalendarPeriodSheet(
            context,
            index: index,
            title: p.label,
            from: p.from,
            to: p.to,
          ),
        ),
    ];
    return Semantics(
      label: l.uiCalendarPeriods,
      container: true,
      explicitChildNodes: true,
      child: LayoutBuilder(
        builder: (context, box) => box.maxWidth < _rowMinWidth
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NizamioSpacing.gapMd,
                children: cards,
              )
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, card) in cards.indexed) ...[
                      if (i > 0) const Gap(NizamioSpacing.gapMd),
                      Expanded(child: card),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

/// Sayı satırı: etiket, sayı, nokta rengi; hollow → içi boş nokta (halkada yer almayan,
/// dönem boyunca süren görevler).
typedef _Legend = (String label, int count, Color color, bool hollow);

typedef _Period = ({
  String label,
  DateTime from,
  DateTime to,
  List<(int, Color)> ring,
  String center,
  String centerCaption,
  List<_Legend> legend,
});

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({required this.period, required this.onTap});

  final _Period period;
  final VoidCallback onTap;

  static const _ring = 92.0;
  static const _dot = 8.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = period;
    final range = p.from == p.to
        ? l.shortDay(p.from)
        : l.weekRange(p.from, p.to);
    final num = [const FontFeature.tabularFigures()];
    return Semantics(
      button: true,
      label: [
        p.label,
        range,
        '${p.center} ${p.centerCaption}',
        for (final (label, n, _, _) in p.legend) '$label $n',
      ].join(', '),
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NizamioRadius.sheet),
          side: BorderSide(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(NizamioSpacing.gapLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ortalı hiza: yan yana düzendeki IntrinsicHeight, taban çizgisi hizalı satırda
                // Gap'in kuru ölçümünü yapamaz.
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMd.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(range, style: t.monoSm.copyWith(color: c.textFaint)),
                    const Gap(NizamioSpacing.space2),
                    NzIcon(
                      NzIcons.northEast,
                      size: NizamioSize.iconSizeSm,
                      color: c.textFaint,
                    ),
                  ],
                ),
                const Gap(NizamioSpacing.space4),
                Row(
                  children: [
                    SizedBox.square(
                      dimension: _ring,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size.square(_ring),
                            painter: _RingPainter(
                              parts: p.ring,
                              track: c.surfaceRaised,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                p.center,
                                style: t.titleSm.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: num,
                                ),
                              ),
                              Text(
                                p.centerCaption,
                                style: t.caption.copyWith(
                                  fontSize: 11,
                                  color: c.textFaint,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(NizamioSpacing.gapLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: NizamioSpacing.space1 + 2,
                        children: [
                          for (final (label, n, color, hollow) in p.legend)
                            Row(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hollow ? null : color,
                                    border: hollow
                                        ? Border.all(color: color, width: 1.5)
                                        : null,
                                  ),
                                  child: const SizedBox.square(dimension: _dot),
                                ),
                                const Gap(NizamioSpacing.space2),
                                Expanded(
                                  child: Text(
                                    label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodySm.copyWith(
                                      color: c.textMuted,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$n',
                                  style: t.bodySm.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: n == 0 ? c.textFaint : c.text,
                                    fontFeatures: num,
                                  ),
                                ),
                              ],
                            ),
                        ],
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

/// Parçalı halka (ana sayfa genel durum halkasının dili): iz `surfaceRaised`, parçalar
/// aralarında küçük boşlukla saat 12'den saat yönünde.
class _RingPainter extends CustomPainter {
  const _RingPainter({required this.parts, required this.track});

  final List<(int, Color)> parts;
  final Color track;

  static const _stroke = 10.0;
  static const _gap = 0.05;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - _stroke) / 2,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..color = track;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint);
    final total = parts.fold(0, (a, p) => a + p.$1);
    if (total == 0) return;
    final shown = parts.where((p) => p.$1 > 0).length;
    var angle = -math.pi / 2;
    for (final (n, color) in parts) {
      if (n == 0) continue;
      final sweep = math.pi * 2 * n / total;
      paint.color = color;
      canvas.drawArc(
        rect,
        angle,
        shown > 1 ? math.max(0.0, sweep - _gap) : sweep,
        false,
        paint,
      );
      angle += sweep;
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.track != track || old.parts.toString() != parts.toString();
}
