// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gantt_link.freezed.dart';
part 'gantt_link.g.dart';

@Freezed()
abstract class GanttLink with _$GanttLink {
  const factory GanttLink({
    @JsonKey(name: 'dependency_id') required String dependencyId,

    /// Ön görev.
    required String source,

    /// Bağımlı görev.
    required String target,
    @JsonKey(name: 'cross_department') required bool crossDepartment,
  }) = _GanttLink;

  factory GanttLink.fromJson(Map<String, Object?> json) =>
      _$GanttLinkFromJson(json);
}
