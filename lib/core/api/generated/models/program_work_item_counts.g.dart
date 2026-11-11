// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_work_item_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramWorkItemCounts _$ProgramWorkItemCountsFromJson(
  Map<String, dynamic> json,
) => _ProgramWorkItemCounts(
  total: (json['total'] as num).toInt(),
  byStatus: ByStatus.fromJson(json['by_status'] as Map<String, dynamic>),
  overdue: (json['overdue'] as num).toInt(),
  pendingDateRequests: (json['pending_date_requests'] as num).toInt(),
);

Map<String, dynamic> _$ProgramWorkItemCountsToJson(
  _ProgramWorkItemCounts instance,
) => <String, dynamic>{
  'total': instance.total,
  'by_status': instance.byStatus.toJson(),
  'overdue': instance.overdue,
  'pending_date_requests': instance.pendingDateRequests,
};
