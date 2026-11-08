import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/request_pool.dart';
import '../domain/meeting_status.dart';
import 'meetings_providers.dart';

part 'meeting_summary_controller.g.dart';

/// Kart başına ayrıntı isteklerinin eşzamanlılık sınırı (ürün kararı: liste ucu sayaç ve
/// konferans taşımaz, kart ayrıntıdan doldurulur; aynı anda en çok 4 istek).
@Riverpod(keepAlive: true)
RequestPool meetingDetailPool(Ref ref) => RequestPool(4);

/// Liste kartının sayaçları ve konferansı (`getMeeting`). Başarıdan sonra önbellekte kalır;
/// liste yenilenince ve toplantı yazmalarında geçersizlenir, açık ayrıntı yazdıkça [put] eder.
@riverpod
class MeetingSummaryController extends _$MeetingSummaryController {
  @override
  Future<MeetingSummary> build(String id) async {
    final repo = ref.read(meetingsRepositoryProvider);
    final d = await ref
        .read(meetingDetailPoolProvider)
        .run(() => repo.getMeeting(id));
    ref.keepAlive();
    return MeetingSummary.of(d);
  }

  /// Açık ayrıntının güncel sayaçları (ağ isteği yok).
  void put(MeetingSummary s) => state = AsyncData(s);
}
