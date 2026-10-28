import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';

/// Ay takvimi (tasarım `components/RangeCalendar`; prototip yeni görev "Tarih" ve toplantı
/// "Tarih" satırları). Durumsuz: seçim kuralı ekranın denetleyicisindedir.
///
/// Üstte ay adı ve önceki/sonraki ay düğmeleri ([onMonthStep] −1/+1), haftanın günleri
/// (Pazartesi başlar), 34 px satırlar. [end] verilirse [start]–[end] aralığı satır boyunca
/// `text` renginde hap ile, uçlar `background` dairesiyle çizilir; [end] null ise yalnız
/// [start] tek gün olarak seçilidir. Ay dışı günler ve [firstDate]'ten önceki günler
/// dokunulamaz. [today] (seçili değilse) ince halkalı.
class NzRangeCalendar extends StatelessWidget {
  const NzRangeCalendar({
    super.key,
    required this.month,
    required this.onMonthStep,
    required this.onDayTap,
    this.start,
    this.end,
    this.today,
    this.firstDate,
    this.semanticLabel,
  });

  /// Gösterilen ay (gün yok sayılır).
  final DateTime month;
  final ValueChanged<int> onMonthStep;
  final ValueChanged<DateTime> onDayTap;
  final DateTime? start;
  final DateTime? end;
  final DateTime? today;
  final DateTime? firstDate;
  final String? semanticLabel;

  static const _rowHeight = 34.0;
  static const _navButton = 32.0;

  static DateTime _d(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final material = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final first = DateTime(month.year, month.month);
    final lead = (first.weekday + 6) % 7;
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final rows = ((lead + days) / 7).ceil();
    final s = start == null ? null : _d(start!);
    final e = end == null ? null : _d(end!);
    final now = today == null ? null : _d(today!);
    final min = firstDate == null ? null : _d(firstDate!);
    final weekdays = [
      for (var i = 0; i < 7; i++)
        // 2024-01-01 Pazartesi.
        DateFormat.E(locale).format(DateTime(2024, 1, 1 + i)),
    ];

    Widget nav(IconData icon, String label, int delta) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: () => onMonthStep(delta),
        radius: NizamioSize.tap / 2,
        child: SizedBox.square(
          dimension: NizamioSize.tap,
          child: Center(
            child: SizedBox.square(
              dimension: _navButton,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: c.surfaceOverlay,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: NizamioSize.iconSizeSm, color: c.text),
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      label: semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              nav(
                Icons.chevron_left_rounded,
                material.previousMonthTooltip,
                -1,
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale).format(first),
                  textAlign: TextAlign.center,
                  style: t.labelLg,
                ),
              ),
              nav(Icons.chevron_right_rounded, material.nextMonthTooltip, 1),
            ],
          ),
          const Gap(NizamioSpacing.space1),
          ExcludeSemantics(
            child: Row(
              children: [
                for (final w in weekdays)
                  Expanded(
                    child: Text(
                      w,
                      textAlign: TextAlign.center,
                      style: t.caption.copyWith(color: c.textFaint),
                    ),
                  ),
              ],
            ),
          ),
          const Gap(NizamioSpacing.space1),
          for (var r = 0; r < rows; r++)
            _Week(
              days: [
                for (var col = 0; col < 7; col++)
                  DateTime(month.year, month.month, 1 + r * 7 + col - lead),
              ],
              month: month.month,
              start: s,
              end: e,
              today: now,
              firstDate: min,
              onDayTap: onDayTap,
              rowHeight: _rowHeight,
            ),
        ],
      ),
    );
  }
}

class _Week extends StatelessWidget {
  const _Week({
    required this.days,
    required this.month,
    required this.start,
    required this.end,
    required this.today,
    required this.firstDate,
    required this.onDayTap,
    required this.rowHeight,
  });

  final List<DateTime> days;
  final int month;
  final DateTime? start;
  final DateTime? end;
  final DateTime? today;
  final DateTime? firstDate;
  final ValueChanged<DateTime> onDayTap;
  final double rowHeight;

  bool _inRange(DateTime d) {
    final s = start;
    final e = end;
    if (s == null) return false;
    if (e == null) return d == s;
    return !d.isBefore(s) && !d.isAfter(e);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final material = MaterialLocalizations.of(context);
    final range = end != null;
    var a = -1;
    var b = -1;
    for (var i = 0; i < 7; i++) {
      if (_inRange(days[i])) {
        if (a < 0) a = i;
        b = i;
      }
    }
    return SizedBox(
      height: rowHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cell = constraints.maxWidth / 7;
          final half = rowHeight / 2;
          return Stack(
            children: [
              if (range && a >= 0)
                AnimatedPositioned(
                  duration: NzMotion.of(context, NizamioMotion.durSheet),
                  curve: NizamioMotion.easeSheet,
                  top: 0,
                  bottom: 0,
                  left: (a + 0.5) * cell - half,
                  width: (b - a) * cell + rowHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.text,
                      borderRadius: BorderRadius.circular(NizamioRadius.pill),
                    ),
                  ),
                ),
              Row(
                children: [
                  for (final d in days)
                    Expanded(child: _day(context, d, c, material)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _day(
    BuildContext context,
    DateTime d,
    NizamioColors c,
    MaterialLocalizations material,
  ) {
    final inMonth = d.month == month;
    final past = firstDate != null && d.isBefore(firstDate!);
    final enabled = inMonth && !past;
    final selected = _inRange(d);
    final edge = d == start || (end != null && d == end);
    final isToday = d == today;
    final range = end != null;
    final Color fg;
    Color? circle;
    if (range && edge) {
      circle = c.background;
      fg = c.text;
    } else if (selected) {
      // Aralık içi (hap üstünde) ya da tek gün seçimi (dolu daire).
      if (!range) circle = c.text;
      fg = c.background;
    } else {
      fg = enabled ? c.text : c.textFaint;
    }
    final bold = edge || isToday || (!range && selected);
    return Semantics(
      button: true,
      enabled: enabled,
      selected: selected,
      label: material.formatFullDate(d),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onDayTap(d) : null,
        child: Center(
          child: SizedBox.square(
            dimension: rowHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: circle,
                shape: BoxShape.circle,
                border: isToday && !selected
                    ? Border.all(
                        color: c.borderControl,
                        width: NizamioSize.focusRingWidth - 0.5,
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  '${d.day}',
                  style: context.text.bodyMd.copyWith(
                    color: fg,
                    fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
