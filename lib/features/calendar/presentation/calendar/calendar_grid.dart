import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/calendar_controller.dart';
import '../../domain/calendar.dart';
import 'calendar_texts.dart';

/// Prototip `.t-icon` yolları (24×24).
abstract final class CalendarIcons {
  static const chevronDown = 'M6 9l6 6 6-6';
  static const chevronLeft = 'M15 6l-6 6 6 6';
  static const chevronRight = 'M9 6l6 6-6 6';
  static const close = 'M6 6l12 12M18 6 6 18';
}

/// Kayıt türünün nokta rengi (prototip `CC`).
extension CalendarKindColor on NizamioColors {
  Color kind(CalendarKind k) => switch (k) {
    CalendarKind.meeting => roleCoordinator,
    CalendarKind.task => inProgress,
    CalendarKind.request => warning,
    CalendarKind.sheet => roleMember,
    CalendarKind.season => danger,
  };
}

/// Ay/hafta ızgarası (prototip "Takvim ızgarası"): ay başlığı (dokununca ay ↔ hafta),
/// önceki/sonraki, gün adları ve haftalar. Hafta kipinde yalnız seçili günün haftası açık
/// kalır; diğer haftalar yükseklik ve saydamlıkla kapanır.
class CalendarGrid extends ConsumerWidget {
  const CalendarGrid({super.key, required this.index});

  final CalendarIndex index;

  static const _rowHeight = 50.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final view = ref.watch(calendarControllerProvider);
    final ctrl = ref.read(calendarControllerProvider.notifier);
    final today = index.today;
    final selected = view.selectedOn(today);
    final month = view.monthOn(today);
    final week = view.mode == CalendarMode.week;
    final weeks = monthWeeks(month);
    final selWeek = weekIndexOf(selected, month);
    final title = week ? l.weekTitle(selected, selWeek) : l.monthTitle(month);
    Widget arrow(String path, String label, int delta) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: () => ctrl.step(delta, today: today),
      child: InkResponse(
        onTap: () => ctrl.step(delta, today: today),
        radius: NizamioSize.tap / 2,
        child: SizedBox.square(
          dimension: NizamioSize.tap,
          child: Center(
            child: NzPathIcon(
              path,
              size: NizamioSize.iconSizeSm,
              color: c.text,
            ),
          ),
        ),
      ),
    );
    return Semantics(
      label: l.uiCalendarGrid,
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  expanded: !week,
                  label: l.modeLabel(view.mode, month),
                  excludeSemantics: true,
                  onTap: ctrl.toggleMode,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: ctrl.toggleMode,
                    child: SizedBox(
                      height: NizamioSize.tap,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.labelLg,
                            ),
                          ),
                          const Gap(6),
                          AnimatedRotation(
                            turns: week ? 0 : 0.5,
                            duration: const Duration(milliseconds: 400),
                            curve: NizamioMotion.easeSpring,
                            child: NzPathIcon(
                              CalendarIcons.chevronDown,
                              size: NizamioSize.iconSizeSm,
                              color: c.textFaint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Prototip: sonraki düğmesi sağ kenardan 10 taşar.
              Transform.translate(
                offset: const Offset(10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    arrow(
                      CalendarIcons.chevronLeft,
                      week ? l.uiCalendarPrevWeek : l.uiCalendarPrevMonth,
                      -1,
                    ),
                    arrow(
                      CalendarIcons.chevronRight,
                      week ? l.uiCalendarNextWeek : l.uiCalendarNextMonth,
                      1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(2),
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.only(bottom: NizamioSpacing.space1),
              child: Row(
                children: [
                  for (final d in l.weekdaysShort)
                    Expanded(
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: t.monoSm.copyWith(color: c.textFaint),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Gap(2),
          Semantics(
            label: l.monthTitle(month),
            container: true,
            explicitChildNodes: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var w = 0; w < weeks.length; w++)
                  _Week(
                    // Ay değişince haftalar yeniden kurulur (kapanış animasyonu yalnız
                    // kip değişiminde).
                    key: ValueKey((month, w)),
                    open: !week || w == selWeek,
                    child: SizedBox(
                      height: _rowHeight,
                      child: Row(
                        children: [
                          for (var k = 0; k < 7; k++)
                            Expanded(
                              child: _DayCell(
                                day: weeks[w][k],
                                inMonth: weeks[w][k].month == month.month,
                                weekend: k > 4,
                                selected: weeks[w][k] == selected,
                                today: weeks[w][k] == today,
                                index: index,
                                onTap: () => ctrl.pick(weeks[w][k]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Hafta satırı: kapanırken yükseklik `easeSheet` .42 s, saydamlık .3 s.
class _Week extends StatelessWidget {
  const _Week({super.key, required this.open, required this.child});

  final bool open;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: open ? 1 : 0,
    duration: NzMotion.of(context, const Duration(milliseconds: 300)),
    curve: Curves.ease,
    child: NzReveal(open: open, child: child),
  );
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.weekend,
    required this.selected,
    required this.today,
    required this.index,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool weekend;
  final bool selected;
  final bool today;
  final CalendarIndex index;
  final VoidCallback onTap;

  static const _circle = 34.0;
  static const _dot = 4.0;
  static const _fade = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final fill = selected
        ? (today ? c.primary : c.text)
        : c.primary.withValues(alpha: 0);
    final ink = selected
        ? (today ? c.onPrimary : c.background)
        : today
        ? c.accentText
        : inMonth
        ? (weekend ? c.textMuted : c.text)
        : c.borderControl;
    final kinds = index.kinds(day).take(3);
    final fade = NzMotion.of(context, _fade);
    return Semantics(
      button: true,
      selected: selected,
      label: l.cellLabel(day, today: today, count: index.count(day)),
      value: '${day.day}',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Column(
            children: [
              AnimatedContainer(
                duration: fade,
                curve: Curves.ease,
                width: _circle,
                height: _circle,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
                child: AnimatedDefaultTextStyle(
                  duration: fade,
                  curve: Curves.ease,
                  style: context.text.bodyMd.copyWith(
                    fontSize: 15,
                    fontWeight: selected || today
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: ink,
                  ),
                  child: Text('${day.day}'),
                ),
              ),
              const Gap(3),
              SizedBox(
                height: _dot,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (i, k) in kinds.indexed) ...[
                      if (i > 0) const Gap(3),
                      NzDot(
                        color: inMonth ? c.kind(k) : c.borderStrong,
                        size: _dot,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
