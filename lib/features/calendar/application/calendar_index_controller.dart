import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../meetings/meetings.dart';
import '../../tasks/tasks.dart';
import '../domain/calendar.dart';
import '../domain/calendar_scope.dart';

part 'calendar_index_controller.g.dart';

/// Günlere dağıtılmış kayıtlar: toplantılar sayfasının okuduğu AYNI toplantı listesi
/// (`listMeetings`, bütün sayfalar) + görevler sayfasının okuduğu AYNI görev kataloğu (görevler
/// ve satırlarındaki bekleyen tarih talepleri). Kaynaklardan biri değişince (yeni toplantı,
/// tamamlanan görev, program değişimi) takvim de güncellenir; biri hata verirse takvim hata
/// durumundadır (kısmi veriyle devam etmez). Kaynaklardan biri kesikse (toplantı listesi ya da
/// katalog sayfa tavanında) dizin [CalendarIndex.truncated] taşır. Koordinatör ve Üye
/// görünümünde yalnız etkin koordinatörlüğün kayıtları ([calendarScope]); görev bitişleri
/// katalogdan türetilir (takvim ucu yok).
@Riverpod(keepAlive: true)
Future<CalendarIndex> calendarIndex(Ref ref) async {
  final meetings = ref.watch(meetingsBoardControllerProvider.future);
  final catalog = ref.watch(taskCatalogControllerProvider.future);
  // Etkin görünüm (rol × koordinatörlük) değişince dizin yeniden kurulur.
  final scope = ref.watch(scopeStateProvider);
  final board = await meetings;
  final tasks = await catalog;
  final view = tasks.viewIn(scope);
  return CalendarIndex.build(
    board.visible,
    tasks,
    meetingsTruncated: board.truncated,
    coordinatorship: calendarScope(
      known: view.known,
      seesAll: view.seesAllDepartments,
      department: view.departmentId,
    ),
  );
}
