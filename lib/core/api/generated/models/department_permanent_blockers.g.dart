// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_permanent_blockers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DepartmentPermanentBlockers _$DepartmentPermanentBlockersFromJson(
  Map<String, dynamic> json,
) => _DepartmentPermanentBlockers(
  tables: (json['tables'] as num).toInt(),
  projects: (json['projects'] as num).toInt(),
  pendingProposals: (json['pending_proposals'] as num).toInt(),
);

Map<String, dynamic> _$DepartmentPermanentBlockersToJson(
  _DepartmentPermanentBlockers instance,
) => <String, dynamic>{
  'tables': instance.tables,
  'projects': instance.projects,
  'pending_proposals': instance.pendingProposals,
};
