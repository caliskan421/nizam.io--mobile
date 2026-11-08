import 'package:meta/meta.dart';

/// Tarih değişikliği talebinin durumu (sunucu `pending`/`approved`/`rejected`; [unknown]:
/// tanımsız sunucu değeri).
enum DateRequestState { pending, approved, rejected, unknown }

/// Tarih talebi incelemesinin kararı (`POST /v1/date-change-requests/{id}/review`).
enum DateRequestDecision { approve, reject }

/// Tarih değişikliği talebi: [oldDue] → [due] (yeni aralık [start]–[due]). Sunucu şeması
/// `DateChangeRequest` ile birleşik: `request_id` → [id], `work_item_id` → [workItemId],
/// `old_start_on` → [oldStart], `old_end_on` → [oldDue], `new_start_on` → [start],
/// `new_end_on` → [due], `status` → [state], `reason` → [reason] (sunucuda isteğe bağlı; yoksa
/// boş dize).
@immutable
final class DateChangeRequest {
  const DateChangeRequest({
    this.id,
    this.workItemId,
    this.by,
    this.at,
    this.oldStart,
    required this.oldDue,
    required this.start,
    required this.due,
    this.reason = '',
    this.state = DateRequestState.pending,
  });

  /// Talep kimliği (`request_id`; inceleme ve silme bununla yapılır).
  final String? id;

  /// Talebin görevi (`work_item_id`).
  final String? workItemId;

  /// Talep eden kişi kimliği. Sunucuda yok — entegrasyonda karar (backend adayı B-08).
  final String? by;

  /// Talep anı. Sunucuda yok — entegrasyonda karar (backend adayı B-08).
  final DateTime? at;

  /// Talep anındaki başlangıç (`old_start_on`).
  final DateTime? oldStart;
  final DateTime oldDue;
  final DateTime start;
  final DateTime due;

  /// Gerekçe; sunucuda isteğe bağlı (yoksa boş).
  final String reason;
  final DateRequestState state;

  bool get isPending => state == DateRequestState.pending;

  DateChangeRequest withState(DateRequestState s) => DateChangeRequest(
    id: id,
    workItemId: workItemId,
    by: by,
    at: at,
    oldStart: oldStart,
    oldDue: oldDue,
    start: start,
    due: due,
    reason: reason,
    state: s,
  );
}
