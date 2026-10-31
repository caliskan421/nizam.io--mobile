// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_department_link.freezed.dart';
part 'program_department_link.g.dart';

@Freezed()
abstract class ProgramDepartmentLink with _$ProgramDepartmentLink {
  const factory ProgramDepartmentLink({
    @JsonKey(name: 'program_id') required String programId,
    @JsonKey(name: 'department_id') required String departmentId,

    /// Departmanın bu programdaki adı.
    @JsonKey(name: 'display_name') required String displayName,

    /// Bağ kurulurken kopyalanan ekip satırı sayısı (bağ zaten varsa, kopya istenmediyse ya da ad değiştirmede 0).
    @JsonKey(name: 'copied_member_count') required int copiedMemberCount,
  }) = _ProgramDepartmentLink;

  factory ProgramDepartmentLink.fromJson(Map<String, Object?> json) =>
      _$ProgramDepartmentLinkFromJson(json);
}
