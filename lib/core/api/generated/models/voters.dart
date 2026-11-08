// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'voters.freezed.dart';
part 'voters.g.dart';

@Freezed()
abstract class Voters with _$Voters {
  const factory Voters({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String? fullName,
  }) = _Voters;

  factory Voters.fromJson(Map<String, Object?> json) => _$VotersFromJson(json);
}
