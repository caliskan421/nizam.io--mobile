// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'conference_token_role.dart';

part 'conference_token.freezed.dart';
part 'conference_token.g.dart';

/// Katılım token'ı. `token` SIRDIR: log, audit ve hata zarfına yazılmaz; yanıt önbelleğe alınmaz.
@Freezed(toStringOverride: false)
abstract class ConferenceToken with _$ConferenceToken {
  const factory ConferenceToken({
    required String token,

    /// İstemcinin bağlanacağı genel adres (wss).
    required String url,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,

    /// host: yönetici ve toplantıya bağlı departmanın koordinatörü; speaker: toplantıyı gören üye.
    required ConferenceTokenRole role,
  }) = _ConferenceToken;

  factory ConferenceToken.fromJson(Map<String, Object?> json) =>
      _$ConferenceTokenFromJson(json);
}
