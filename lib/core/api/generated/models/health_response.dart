// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'health_response_status.dart';

part 'health_response.freezed.dart';
part 'health_response.g.dart';

@Freezed()
abstract class HealthResponse with _$HealthResponse {
  const factory HealthResponse({required HealthResponseStatus status}) =
      _HealthResponse;

  factory HealthResponse.fromJson(Map<String, Object?> json) =>
      _$HealthResponseFromJson(json);
}
