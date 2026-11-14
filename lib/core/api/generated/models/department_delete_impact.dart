// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'department_delete_impact_program.dart';
import 'department_permanent_blockers.dart';

part 'department_delete_impact.freezed.dart';
part 'department_delete_impact.g.dart';

/// Departman silme etki önizlemesi (ADR-0043). Sayılar okuma anının.
/// görüntüsüdür; yazım ya da kilit yoktur. Geri alınabilir silme.
/// `programs[].active_items + completed_items` görevini "Silinenler"e.
/// taşır; kalıcı silme `deleted_items` dahil bütün görevleri, dosyaları,.
/// program bağlarını ve ekip satırlarını siler. Toplantılar departman.
/// adının kopyasıyla kalır.
///
@Freezed()
abstract class DepartmentDeleteImpact with _$DepartmentDeleteImpact {
  const factory DepartmentDeleteImpact({
    @JsonKey(name: 'department_id') required String departmentId,

    /// Katalog adı.
    required String name,

    /// Departman şu an geri alınabilir silinmiş mi.
    required bool deleted,

    /// Görevi ya da bağı olan programlar (program kimliği sırası).
    required List<DepartmentDeleteImpactProgram> programs,

    /// Silinmemiş, tamamlanmamış görev toplamı.
    @JsonKey(name: 'active_items') required int activeItems,

    /// Silinmemiş, tamamlanmış görev toplamı.
    @JsonKey(name: 'completed_items') required int completedItems,

    /// Silinmiş görev toplamı (departmanla silinenler dahil).
    @JsonKey(name: 'deleted_items') required int deletedItems,

    /// Departmanla birlikte silinmiş görev toplamı; geri yüklemede geri gelir.
    @JsonKey(name: 'deleted_with_department')
    required int deletedWithDepartment,

    /// Departmanın dosya sayısı (silinmiş görevlerin ekleri dahil).
    @JsonKey(name: 'file_count') required int fileCount,

    /// Ekip satırı bulunan farklı kişi sayısı (bütün programlar).
    @JsonKey(name: 'member_count') required int memberCount,

    /// Departmanı taşıyan silinmemiş toplantı sayısı.
    @JsonKey(name: 'meeting_count') required int meetingCount,
    @JsonKey(name: 'permanent_blockers')
    required DepartmentPermanentBlockers permanentBlockers,

    /// `true` ise kalıcı silme 409 `organization.department_in_use` alır.
    @JsonKey(name: 'permanent_blocked') required bool permanentBlocked,
  }) = _DepartmentDeleteImpact;

  factory DepartmentDeleteImpact.fromJson(Map<String, Object?> json) =>
      _$DepartmentDeleteImpactFromJson(json);
}
