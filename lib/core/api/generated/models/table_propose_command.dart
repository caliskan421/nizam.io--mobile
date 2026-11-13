// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_propose_command_kind.dart';
import 'table_propose_command_role.dart';
import 'table_propose_command_target_space.dart';

part 'table_propose_command.freezed.dart';
part 'table_propose_command.g.dart';

/// Yalnız kişisel tablonun sahibi; hedef, sahibin ekip satırı olan koordinatörlüktür (TABLES-K18): şirket yöneticiliği tek başına öneri açmaz (hedefte ekip satırı yoksa 403). Öneri sahibin açık rızasıdır ve yalnız şu üst veriyi onaylayana gösterir: başlık, sütun adı/tipi, satır sayısı, hedef ve `role` (onayda yazılacak `team_role`). Tablo başına tek bekleyen öneri; ikincisi 409 `tables.proposal_pending`. Sonuçta `id` öneri kimliği, `status` `pending`'dir.
@Freezed()
abstract class TableProposeCommand with _$TableProposeCommand {
  const factory TableProposeCommand({
    required TableProposeCommandKind kind,
    @JsonKey(name: 'target_space')
    required TableProposeCommandTargetSpace targetSpace,
    @JsonKey(name: 'target_department_id') required String targetDepartmentId,

    /// Verilmezse onayda proje kurulmaz; verilmişse hedefteki silinmemiş proje (null/boş 422).
    @JsonKey(name: 'target_project_id') String? targetProjectId,
    TableProposeCommandRole? role,
  }) = _TableProposeCommand;

  factory TableProposeCommand.fromJson(Map<String, Object?> json) =>
      _$TableProposeCommandFromJson(json);
}
