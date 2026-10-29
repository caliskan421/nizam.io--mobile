// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'gantt_link.dart';
import 'gantt_task.dart';

part 'gantt.freezed.dart';
part 'gantt.g.dart';

@Freezed()
abstract class Gantt with _$Gantt {
  const factory Gantt({
    required List<GanttTask> tasks,
    required List<GanttLink> links,
  }) = _Gantt;

  factory Gantt.fromJson(Map<String, Object?> json) => _$GanttFromJson(json);
}
