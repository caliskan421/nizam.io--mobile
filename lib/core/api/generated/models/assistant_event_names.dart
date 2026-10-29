// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_event_names.freezed.dart';
part 'assistant_event_names.g.dart';

@Freezed()
abstract class AssistantEventNames with _$AssistantEventNames {
  const factory AssistantEventNames({
    /// Bu soruda görülen takma ad (`Üye-N`) → görünen ad. E-posta ve hesap kimliği taşımaz.
    required Map<String, String> adlar,
  }) = _AssistantEventNames;

  factory AssistantEventNames.fromJson(Map<String, Object?> json) =>
      _$AssistantEventNamesFromJson(json);
}
