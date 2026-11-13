// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_proposal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableProposal _$TableProposalFromJson(Map<String, dynamic> json) =>
    _TableProposal(
      id: json['id'] as String,
      kind: TableProposalKind.fromJson(json['kind'] as String),
      programId: json['program_id'] as String,
      targetDepartmentId: json['target_department_id'] as String,
      title: json['title'] as String,
      columns: (json['columns'] as List<dynamic>)
          .map((e) => Columns.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowCount: (json['row_count'] as num).toInt(),
      proposerId: json['proposer_id'] as String,
      status: TableProposalStatus.fromJson(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      targetProjectId: json['target_project_id'] as String?,
      teamRole: json['team_role'] == null
          ? null
          : TableProposalTeamRole.fromJson(json['team_role'] as String),
    );

Map<String, dynamic> _$TableProposalToJson(_TableProposal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$TableProposalKindEnumMap[instance.kind]!,
      'program_id': instance.programId,
      'target_department_id': instance.targetDepartmentId,
      'title': instance.title,
      'columns': instance.columns.map((e) => e.toJson()).toList(),
      'row_count': instance.rowCount,
      'proposer_id': instance.proposerId,
      'status': _$TableProposalStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'target_project_id': ?instance.targetProjectId,
      'team_role': ?_$TableProposalTeamRoleEnumMap[instance.teamRole],
    };

const _$TableProposalKindEnumMap = {
  TableProposalKind.move: 'move',
  TableProposalKind.copy: 'copy',
  TableProposalKind.$unknown: r'$unknown',
};

const _$TableProposalStatusEnumMap = {
  TableProposalStatus.pending: 'pending',
  TableProposalStatus.approved: 'approved',
  TableProposalStatus.rejected: 'rejected',
  TableProposalStatus.withdrawn: 'withdrawn',
  TableProposalStatus.$unknown: r'$unknown',
};

const _$TableProposalTeamRoleEnumMap = {
  TableProposalTeamRole.editor: 'editor',
  TableProposalTeamRole.viewer: 'viewer',
  TableProposalTeamRole.$unknown: r'$unknown',
};
