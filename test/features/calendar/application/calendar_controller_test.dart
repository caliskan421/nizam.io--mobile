// CalendarController: varsayılan bugün, gün seçimi (ay dışı hücre ayı değiştirir), ay/hafta
// adımı, "Bugün", kip değişiminde seçimin korunması.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/calendar/application/calendar_controller.dart';
import 'package:nizamio/features/calendar/domain/calendar.dart';

final _today = DateTime(2026, 10, 21);

void main() {
  late ProviderContainer c;
  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());
  CalendarController ctrl() => c.read(calendarControllerProvider.notifier);
  CalendarViewState s() => c.read(calendarControllerProvider);

  test('varsayılan: bugün seçili, bugünün ayı, ay kipi', () {
    expect(s().selectedOn(_today), _today);
    expect(s().monthOn(_today), DateTime(2026, 10));
    expect(s().mode, CalendarMode.month);
    expect(s().isTodayOn(_today), isTrue);
  });

  test('gün seçimi; ay dışı hücre ayı değiştirir', () {
    ctrl().pick(DateTime(2026, 10, 6));
    expect(s().selectedOn(_today), DateTime(2026, 10, 6));
    expect(s().isTodayOn(_today), isFalse);
    ctrl().pick(DateTime(2026, 11, 1));
    expect(s().monthOn(_today), DateTime(2026, 11));
  });

  test('ay kipinde adım: başka ayda 1\'i, bugünün ayında bugün seçilir', () {
    ctrl().step(1, today: _today);
    expect(s().monthOn(_today), DateTime(2026, 11));
    expect(s().selectedOn(_today), DateTime(2026, 11));
    ctrl().step(-2, today: _today);
    expect(s().selectedOn(_today), DateTime(2026, 9));
    ctrl().step(1, today: _today);
    expect(s().selectedOn(_today), _today);
    expect(s().isTodayOn(_today), isTrue);
  });

  test('hafta kipinde adım 7 gün; ay sınırında ay değişir', () {
    ctrl().toggleMode();
    expect(s().mode, CalendarMode.week);
    ctrl().step(1, today: _today);
    expect(s().selectedOn(_today), DateTime(2026, 10, 28));
    ctrl().step(1, today: _today);
    expect(s().selectedOn(_today), DateTime(2026, 11, 4));
    expect(s().monthOn(_today), DateTime(2026, 11));
    ctrl().step(-3, today: _today);
    expect(s().selectedOn(_today), DateTime(2026, 10, 14));
  });

  test(
    'Bugün: gün ve ay geri gelir, kip korunur; kip değişimi seçimi korur',
    () {
      ctrl()
        ..pick(DateTime(2026, 12, 3))
        ..toggleMode();
      expect(s().selectedOn(_today), DateTime(2026, 12, 3));
      ctrl().goToday();
      expect(s().isTodayOn(_today), isTrue);
      expect(s().mode, CalendarMode.week);
      ctrl().toggleMode();
      expect(s().mode, CalendarMode.month);
      expect(s().selectedOn(_today), _today);
    },
  );
}
