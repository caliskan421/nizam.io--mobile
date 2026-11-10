// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'known_user_account_status.dart';
import 'user_team.dart';

part 'known_user.freezed.dart';
part 'known_user.g.dart';

@Freezed()
abstract class KnownUser with _$KnownUser {
  const factory KnownUser({
    @JsonKey(name: 'account_id') required String accountId,
    @JsonKey(name: 'full_name') required String fullName,

    /// Hesabın e-postası. Yalnız şirket yöneticisinin kullanıcı yönetim uçlarında döner; üye listesi, havuz ve diğer okuma yüzleri e-posta taşımaz.
    required String email,

    /// Hesap şirket yöneticisi mi (ekip satırlarından bağımsız).
    @JsonKey(name: 'company_admin') required bool companyAdmin,

    /// Hesap durumu; `disabled` girişi kapatılmış hesaptır (silinmiş hesap listede yoktur).
    @JsonKey(name: 'account_status')
    required KnownUserAccountStatus accountStatus,

    /// Hesapta şu an süren başarısız giriş kilidi var mı (IDENTITY-K19). Süresi geçmiş kilit ve kilide varmamış sayaç `false`tur; yöneticinin kilit açma ucu ikisini de temizler. Hesabı kapatma (`account_status`) değildir.
    @JsonKey(name: 'login_locked') required bool loginLocked,

    /// Ekip satırı etiketleri, `program:departman:rol` biçiminde.
    required List<String>? memberships,

    /// Aynı ekip satırlarının yapısal hâli (bütün programlar; canlı departmanlar). Ekipsiz hesapta boş dizi.
    required List<UserTeam> teams,
  }) = _KnownUser;

  factory KnownUser.fromJson(Map<String, Object?> json) =>
      _$KnownUserFromJson(json);
}
