import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../meetings/meetings.dart';
import '../../tasks/tasks.dart';
import '../domain/calendar.dart';

part 'calendar_index_controller.g.dart';

/// Günlere dağıtılmış kayıtlar: toplantılar sayfasının okuduğu AYNI toplantı listesi
/// (`listMeetings`, bütün sayfalar) + görevler sayfasının okuduğu AYNI görev kataloğu (görevler
/// ve satırlarındaki bekleyen tarih talepleri). Kaynaklardan biri değişince (yeni toplantı,
/// tamamlanan görev, program değişimi) takvim de güncellenir; biri hata verirse takvim hata
/// durumundadır (kısmi veriyle devam etmez).
@Riverpod(keepAlive: true)
Future<CalendarIndex> calendarIndex(Ref ref) async {
  final meetings = ref.watch(meetingsBoardControllerProvider.future);
  final catalog = ref.watch(taskCatalogControllerProvider.future);
  return CalendarIndex.build((await meetings).visible, await catalog);
}
