import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/calendar.dart';

part 'calendar_providers.g.dart';

/// PORT: takvim kaynakları (`calendar_module.dart`'ta bağlanır; bugün geliştirme örneği).
@Riverpod(keepAlive: true)
CalendarRepository calendarRepository(Ref ref) => throw UnimplementedError(
  'calendarRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);
