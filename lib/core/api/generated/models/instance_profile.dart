// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'instance_profile.freezed.dart';
part 'instance_profile.g.dart';

@Freezed()
abstract class InstanceProfile with _$InstanceProfile {
  const factory InstanceProfile({
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'brand_color') required String brandColor,

    /// IANA saat dilimi adı.
    required String timezone,
    @JsonKey(name: 'api_version') required String apiVersion,

    /// `0.0.0` = asgari yok. Karşılaştırmayı istemci yapar.
    @JsonKey(name: 'minimum_mobile_version')
    required String minimumMobileVersion,
  }) = _InstanceProfile;

  factory InstanceProfile.fromJson(Map<String, Object?> json) =>
      _$InstanceProfileFromJson(json);
}
