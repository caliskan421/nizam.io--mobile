// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_department.dart';
import 'workload_task.dart';

part 'workload_member.freezed.dart';
part 'workload_member.g.dart';

@Freezed()
abstract class WorkloadMember with _$WorkloadMember {
  const factory WorkloadMember({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
    required List<ReportDepartment> coordinatorships,
    required List<WorkloadTask> tasks,
  }) = _WorkloadMember;

  factory WorkloadMember.fromJson(Map<String, Object?> json) =>
      _$WorkloadMemberFromJson(json);
}
