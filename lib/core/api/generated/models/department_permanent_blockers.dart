// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_permanent_blockers.freezed.dart';
part 'department_permanent_blockers.g.dart';

/// Kalıcı silmenin çözülemeyen engelleri (tablo çekirdeği, ADR-0038).
@Freezed()
abstract class DepartmentPermanentBlockers with _$DepartmentPermanentBlockers {
  const factory DepartmentPermanentBlockers({
    required int tables,
    required int projects,
    @JsonKey(name: 'pending_proposals') required int pendingProposals,
  }) = _DepartmentPermanentBlockers;

  factory DepartmentPermanentBlockers.fromJson(Map<String, Object?> json) =>
      _$DepartmentPermanentBlockersFromJson(json);
}
