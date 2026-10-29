// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'workload_pdf_request.freezed.dart';
part 'workload_pdf_request.g.dart';

@Freezed()
abstract class WorkloadPdfRequest with _$WorkloadPdfRequest {
  const factory WorkloadPdfRequest({
    /// Boş ya da yoksa bütün üyeler.
    @JsonKey(name: 'member_ids') List<String>? memberIds,
  }) = _WorkloadPdfRequest;

  factory WorkloadPdfRequest.fromJson(Map<String, Object?> json) =>
      _$WorkloadPdfRequestFromJson(json);
}
