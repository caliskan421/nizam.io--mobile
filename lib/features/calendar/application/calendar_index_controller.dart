import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/calendar.dart';
import 'calendar_providers.dart';

part 'calendar_index_controller.g.dart';

/// Takvim kaynakları (sezon, toplantı, talep, tablo kaydı); yeniden yükleme yalnız dokunuşla.
@Riverpod(keepAlive: true)
Future<CalendarSources> calendarSources(Ref ref) =>
    ref.read(calendarRepositoryProvider).load();

/// Günlere dağıtılmış kayıtlar: kaynaklar + görevler sayfasının okuduğu aynı görev kataloğu
/// (katalog değişince — yeni/silinen görev — takvim de güncellenir).
@Riverpod(keepAlive: true)
Future<CalendarIndex> calendarIndex(Ref ref) async {
  final sources = await ref.watch(calendarSourcesProvider.future);
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  return CalendarIndex.build(sources, catalog);
}
