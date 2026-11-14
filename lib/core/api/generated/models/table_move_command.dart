// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_command.dart';
import 'table_move_command_kind.dart';
import 'table_move_command_target_space.dart';

part 'table_move_command.freezed.dart';
part 'table_move_command.g.dart';

/// Yalnız sahip; aynı program içinde başka alana ya da departmana taşır (TABLES-K17). Sahip hedefte ekip satırı ya da şirket yöneticiliği taşımalıdır; kişisel tabloyu koordinatörlüğe doğrudan yalnız hedefin koordinatörü ya da şirket yöneticisi taşır (diğerleri öneri yolunu kullanır, 403). Açık paylaşımlar ve `team_role` temizlenir (`cleared_grants`), ekler değişmez; proje yalnız `target_project_id` verilirse hedefte kurulur. Aynı kapsama taşıma 422 (proje değişimi `set_project`'tir). Bekleyen öneri varken 409 `tables.proposal_pending`. Tekrar hedefte güncel sahiplikle doğrulanır.
@Freezed()
abstract class TableMoveCommand with _$TableMoveCommand {
  const factory TableMoveCommand({
    required TableMoveCommandKind kind,
    @JsonKey(name: 'target_space')
    required TableMoveCommandTargetSpace targetSpace,

    /// Yalnız `coordinatorship` hedefinde zorunlu; kişisel hedefte verilmez.
    @JsonKey(name: 'target_department_id') String? targetDepartmentId,

    /// Verilmezse tablo projesiz taşınır; verilmişse hedefteki silinmemiş proje (null/boş 422).
    @JsonKey(name: 'target_project_id') String? targetProjectId,
  }) = _TableMoveCommand;

  factory TableMoveCommand.fromJson(Map<String, Object?> json) =>
      _$TableMoveCommandFromJson(json);
}
