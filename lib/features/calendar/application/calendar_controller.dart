import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/calendar.dart';

part 'calendar_controller.g.dart';

/// Takvim ekranının durumu: seçili gün, gösterilen ay ve kip. [selected] / [month] null →
/// verinin bugünü (açılışta ve "Bugün"den sonra); pencere ölçüsü durumun parçası değildir.
@immutable
final class CalendarViewState {
  const CalendarViewState({
    this.selected,
    this.month,
    this.mode = CalendarMode.month,
  });

  final DateTime? selected;
  final DateTime? month;
  final CalendarMode mode;

  /// [today]'e göre çözülmüş seçili gün.
  DateTime selectedOn(DateTime today) => calendarDay(selected ?? today);

  /// [today]'e göre çözülmüş ay (ayın ilk günü).
  DateTime monthOn(DateTime today) => calendarMonth(month ?? selected ?? today);

  /// Seçili gün bugün ve bugünün ayı gösteriliyor ("Bugün" düğmesi devre dışı).
  bool isTodayOn(DateTime today) =>
      selectedOn(today) == calendarDay(today) &&
      monthOn(today) == calendarMonth(today);
}

/// Takvim komutları (prototip `S_cal`). Durum ekrandan uzun yaşar (modül değişiminde ve
/// yeniden boyutlanmada seçili gün, ay ve kip korunur).
@Riverpod(keepAlive: true)
class CalendarController extends _$CalendarController {
  @override
  CalendarViewState build() => const CalendarViewState();

  /// Güne dokunma: gün seçilir, ay o günün ayı olur (ay dışı hücre ayı değiştirir).
  void pick(DateTime day) => state = CalendarViewState(
    selected: calendarDay(day),
    month: calendarMonth(day),
    mode: state.mode,
  );

  /// Bugüne döner (gün ve ay).
  void goToday() => state = CalendarViewState(mode: state.mode);

  /// Ay ↔ hafta.
  void toggleMode() => state = CalendarViewState(
    selected: state.selected,
    month: state.month,
    mode: state.mode == CalendarMode.month
        ? CalendarMode.week
        : CalendarMode.month,
  );

  /// Önceki/sonraki ([delta] −1/+1). Hafta kipinde seçili gün 7 gün kayar; ay kipinde ay
  /// değişir ve seçili gün o ay bugünün ayıysa bugün, değilse ayın 1'i olur.
  void step(int delta, {required DateTime today}) {
    if (state.mode == CalendarMode.week) {
      final s = state.selectedOn(today);
      pick(DateTime(s.year, s.month, s.day + 7 * delta));
      return;
    }
    final m = state.monthOn(today);
    final next = DateTime(m.year, m.month + delta);
    final t = calendarDay(today);
    if (next == calendarMonth(t)) {
      state = CalendarViewState(mode: state.mode);
    } else {
      state = CalendarViewState(selected: next, month: next, mode: state.mode);
    }
  }
}
