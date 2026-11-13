// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'columns.dart';
import 'table_proposal_kind.dart';
import 'table_proposal_status.dart';
import 'table_proposal_team_role.dart';

part 'table_proposal.freezed.dart';
part 'table_proposal.g.dart';

/// Sahibin rıza verdiği üst veri (TABLES-K18); kaynak tabloya okuma yetkisi vermez, hücre içeriği taşımaz.
@Freezed()
abstract class TableProposal with _$TableProposal {
  const factory TableProposal({
    required String id,
    required TableProposalKind kind,
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'target_department_id') required String targetDepartmentId,
    required String title,
    required List<Columns> columns,
    @JsonKey(name: 'row_count') required int rowCount,
    @JsonKey(name: 'proposer_id') required String proposerId,
    required TableProposalStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'target_project_id') String? targetProjectId,
    @JsonKey(name: 'team_role') TableProposalTeamRole? teamRole,
  }) = _TableProposal;

  factory TableProposal.fromJson(Map<String, Object?> json) =>
      _$TableProposalFromJson(json);
}
