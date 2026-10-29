// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_department.dart';
import 'workload_member.dart';

part 'workload_report.freezed.dart';
part 'workload_report.g.dart';

@Freezed()
abstract class WorkloadReport with _$WorkloadReport {
  const factory WorkloadReport({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'program_name') required String programName,
    required List<WorkloadMember> members,
    required List<ReportDepartment> coordinatorships,
    required int total,
    @JsonKey(name: 'generated_at') required DateTime generatedAt,
  }) = _WorkloadReport;

  factory WorkloadReport.fromJson(Map<String, Object?> json) =>
      _$WorkloadReportFromJson(json);
}
