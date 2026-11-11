import 'chat.dart';

/// Gönderim sözleşmesindeki tek mesaj referans tavanı.
const chatComposeMaxRefs = 10;

/// Yetkili kaynaktan gelen paylaşım seçeneği; kimlik yalnız gönderimde kullanılır.
final class ChatShareOption {
  const ChatShareOption({required this.ref, required this.label});

  final ChatRefDraft ref;
  final String label;

  bool sameTarget(ChatShareOption other) =>
      ref.kind == other.ref.kind && ref.targetId == other.ref.targetId;
}
