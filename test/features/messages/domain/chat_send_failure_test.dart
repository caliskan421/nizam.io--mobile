import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/features/messages/domain/chat_send_failure.dart';

void main() {
  test('hata kodu → gönderilemedi nedeni', () {
    const cases = {
      'messaging.file_too_large': ChatSendFailure.size,
      'platform.body_too_large': ChatSendFailure.size,
      'messaging.file_rejected': ChatSendFailure.type,
      ClientErrorCode.fileUnreadable: ChatSendFailure.unreadable,
      ClientErrorCode.networkError: ChatSendFailure.network,
      ClientErrorCode.timeout: ChatSendFailure.network,
      ClientErrorCode.outcomeUnknown: ChatSendFailure.network,
      'platform.internal': ChatSendFailure.network,
      'messaging.not_authorized': ChatSendFailure.permission,
      'tables.forbidden': ChatSendFailure.permission,
      'platform.unauthenticated': ChatSendFailure.permission,
      'platform.rate_limited': ChatSendFailure.other,
      'messaging.idempotency_key_reused': ChatSendFailure.other,
    };
    cases.forEach((code, reason) {
      expect(chatSendFailure(code), reason, reason: code);
    });
    expect(chatSendFailure(null), ChatSendFailure.other);
  });

  test('tekrar: dosya reddi ve anahtar çakışmasında yok', () {
    expect(chatSendRetryable(ClientErrorCode.networkError), isTrue);
    expect(chatSendRetryable('messaging.not_authorized'), isTrue);
    expect(chatSendRetryable('platform.rate_limited'), isTrue);
    expect(chatSendRetryable('messaging.file_too_large'), isFalse);
    expect(chatSendRetryable('messaging.file_rejected'), isFalse);
    expect(chatSendRetryable(ClientErrorCode.fileUnreadable), isFalse);
    expect(chatSendRetryable('messaging.idempotency_key_reused'), isFalse);
  });
}
