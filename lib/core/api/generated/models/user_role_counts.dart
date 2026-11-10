// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role_counts.freezed.dart';
part 'user_role_counts.g.dart';

/// Rol dışındaki süzgeçlere (`search`, `program_id`, `department_id`) uyan hesapların rol sekmesi sayıları. Bir hesap birden çok rolde sayılabilir (ör. bir programda koordinatör, başka programda üye, aynı zamanda şirket yöneticisi); `all` rolden bağımsız toplamdır, rol sayılarının toplamı değildir.
@Freezed()
abstract class UserRoleCounts with _$UserRoleCounts {
  const factory UserRoleCounts({
    required int all,
    @JsonKey(name: 'company_admin') required int companyAdmin,
    required int koordinator,
    required int uye,
  }) = _UserRoleCounts;

  factory UserRoleCounts.fromJson(Map<String, Object?> json) =>
      _$UserRoleCountsFromJson(json);
}
