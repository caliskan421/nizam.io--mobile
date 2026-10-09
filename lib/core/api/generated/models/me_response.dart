// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_response.freezed.dart';
part 'me_response.g.dart';

@Freezed()
abstract class MeResponse with _$MeResponse {
  const factory MeResponse({
    @JsonKey(name: 'account_id') required String accountId,
    required String email,
  }) = _MeResponse;

  factory MeResponse.fromJson(Map<String, Object?> json) =>
      _$MeResponseFromJson(json);
}
