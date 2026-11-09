import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../meetings/meetings.dart';
import '../../tasks/tasks.dart';
import '../domain/calendar.dart';

part 'calendar_index_controller.g.dart';

/// Günlere dağıtılmış kayıtlar: toplantılar sayfasının okuduğu AYNI toplantı listesi
/// (`listMeetings`, bütün sayfalar) + görevler sayfasının okuduğu AYNI görev kataloğu (görevler
/// ve satırlarındaki bekleyen tarih talepleri). Kaynaklardan biri değişince (yeni toplantı,
/// tamamlanan görev, program değişimi) takvim de güncellenir; biri hata verirse takvim hata
/// durumundadır (kısmi veriyle devam etmez). Kaynaklardan biri kesikse (toplantı listesi ya da
/// katalog sayfa tavanında) dizin [CalendarIndex.truncated] taşır.
@Riverpod(keepAlive: true)
Future<CalendarIndex> calendarIndex(Ref ref) async {
  final meetings = ref.watch(meetingsBoardControllerProvider.future);
  final catalog = ref.watch(taskCatalogControllerProvider.future);
  final board = await meetings;
  return CalendarIndex.build(
    board.visible,
    await catalog,
    meetingsTruncated: board.truncated,
  );
}
