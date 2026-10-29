import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/calendar_providers.dart';
import 'data/sample/sample_calendar_repository.dart';
import 'domain/calendar.dart';

/// calendar modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerCalendarModule(GetIt locator) {
  // GEÇİCİ: takvim kaynakları backend'de hazır olana kadar geliştirme örneği; gerçek kaynak
  // geldiğinde yalnız bu kayıt değişir.
  locator.registerLazySingleton<CalendarRepository>(
    SampleCalendarRepository.new,
  );
}

/// calendar'ın Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> calendarOverrides(GetIt locator) => [
  calendarRepositoryProvider.overrideWith(
    (ref) => locator<CalendarRepository>(),
  ),
];
