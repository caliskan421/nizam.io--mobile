// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_person.freezed.dart';
part 'report_person.g.dart';

@Freezed()
abstract class ReportPerson with _$ReportPerson {
  const factory ReportPerson({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _ReportPerson;

  factory ReportPerson.fromJson(Map<String, Object?> json) =>
      _$ReportPersonFromJson(json);
}
