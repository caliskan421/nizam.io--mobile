// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'voters.dart';

part 'results.freezed.dart';
part 'results.g.dart';

@Freezed()
abstract class Results with _$Results {
  const factory Results({
    @JsonKey(name: 'option_index') required int optionIndex,
    required String label,
    required int count,
    required List<Voters> voters,
  }) = _Results;

  factory Results.fromJson(Map<String, Object?> json) =>
      _$ResultsFromJson(json);
}
