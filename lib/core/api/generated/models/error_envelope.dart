// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'field_error.dart';

part 'error_envelope.freezed.dart';
part 'error_envelope.g.dart';

/// C2 §3.3 kararlı hata gövdesi. İç hata metni hiçbir zaman taşınmaz.
@Freezed()
abstract class ErrorEnvelope with _$ErrorEnvelope {
  const factory ErrorEnvelope({
    /// Kararlı makine kodu (`<alan>.<durum>`); katalog docs/api/error-codes.json.
    required String code,
    required String message,

    /// Sunucunun ürettiği istek kimliği (X-Request-Id ile aynı).
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'correlation_id') String? correlationId,
    List<FieldError>? fields,
    String? details,
  }) = _ErrorEnvelope;

  factory ErrorEnvelope.fromJson(Map<String, Object?> json) =>
      _$ErrorEnvelopeFromJson(json);
}
