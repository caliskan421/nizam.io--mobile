import '../domain/timeline_rules.dart' show timelineReasonMin;

/// Tarih talebi gönderme sonucu (prototip `request`).
sealed class TimelineRequestResult {
  const TimelineRequestResult();
}

/// Görevin zaten bekleyen bir talebi var.
final class TimelineRequestPending extends TimelineRequestResult {
  const TimelineRequestPending();
}

/// Taslakta değişiklik yok.
final class TimelineRequestNoChange extends TimelineRequestResult {
  const TimelineRequestNoChange();
}

/// Koordinatör talebinde gerekçe eksik (en az [timelineReasonMin] karakter).
final class TimelineRequestNeedsReason extends TimelineRequestResult {
  const TimelineRequestNeedsReason();
}

/// Talep kaydedildi; [end] istenen yeni bitiş.
final class TimelineRequestSent extends TimelineRequestResult {
  const TimelineRequestSent(this.end);

  final DateTime end;
}
