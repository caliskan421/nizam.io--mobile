// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_info.freezed.dart';
part 'system_info.g.dart';

@Freezed()
abstract class SystemInfo with _$SystemInfo {
  const factory SystemInfo({
    @JsonKey(name: 'product_id') required String productId,

    /// Aktivasyon tamamlanmadıysa boş.
    @JsonKey(name: 'instance_id') required String instanceId,
    @JsonKey(name: 'company_display_name') required String companyDisplayName,
    @JsonKey(name: 'server_version') required String serverVersion,
    @JsonKey(name: 'api_version') required String apiVersion,
    @JsonKey(name: 'minimum_mobile_version')
    required String minimumMobileVersion,
    required List<String>? capabilities,
  }) = _SystemInfo;

  factory SystemInfo.fromJson(Map<String, Object?> json) =>
      _$SystemInfoFromJson(json);
}
