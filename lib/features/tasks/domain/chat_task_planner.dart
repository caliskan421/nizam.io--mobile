import 'package:meta/meta.dart';

import 'meeting_planner.dart';

// "Mesajdan görev" kipindeki yeni görev formunun dış bağımlılığı. Form tasks'tadır; sohbet uçları
// messages feature'ınındır. Gerçekleştirme messages'ta, bağlama bileşim kökünde
// (`messagesOverrides`). Böylece tasks messages'ı import etmez (tek yön: messages → tasks).

/// Görevin açılacağı sohbet mesajı.
@immutable
final class ChatTaskSource {
  const ChatTaskSource({required this.chatId, required this.messageId});

  final String chatId;
  final String messageId;
}

/// Mesajdan görev yazması (hata: `ApiError`).
abstract interface class ChatTaskPlanner {
  /// Mesajı göreve dönüştürür (açıklama mesaj gövdesidir); görev kimliğini döner.
  /// [requestKey] `Idempotency-Key`: aynı eylemin tekrarı aynı anahtar.
  Future<String> convertMessage(
    ChatTaskSource source,
    NoteTaskPlan plan, {
    required String requestKey,
  });
}
