import '../../../core/i18n/generated/client_error_codes.gen.dart';

/// "Gönderilemedi" balonundaki neden (not 33): mesajın hata kodundan türetilir.
enum ChatSendFailure { size, type, unreadable, network, permission, other }

/// Hata kodu → neden. Ağ: bağlantı yok, zaman aşımı, sonuç bilinmiyor, sunucu hazır değil/iç
/// hata (aynı kimlikle tekrar güvenli). Yetki: `*.not_authorized`, `*.forbidden`, oturum.
ChatSendFailure chatSendFailure(String? code) => switch (code) {
  'messaging.file_too_large' ||
  'platform.body_too_large' => ChatSendFailure.size,
  'messaging.file_rejected' => ChatSendFailure.type,
  ClientErrorCode.fileUnreadable => ChatSendFailure.unreadable,
  ClientErrorCode.networkError ||
  ClientErrorCode.timeout ||
  ClientErrorCode.outcomeUnknown ||
  'platform.not_ready' ||
  'platform.internal' ||
  'platform.panic' => ChatSendFailure.network,
  'platform.unauthenticated' => ChatSendFailure.permission,
  final c? when c.endsWith('.not_authorized') || c.endsWith('.forbidden') =>
    ChatSendFailure.permission,
  _ => ChatSendFailure.other,
};

/// Tekrar anlamlı mı: dosya kabul edilmedi/okunamadı ya da işlem anahtarı başka gövdeyle
/// kullanıldıysa aynı gönderim yine reddedilir.
bool chatSendRetryable(String? code) =>
    code != 'messaging.idempotency_key_reused' &&
    switch (chatSendFailure(code)) {
      ChatSendFailure.size ||
      ChatSendFailure.type ||
      ChatSendFailure.unreadable => false,
      _ => true,
    };
