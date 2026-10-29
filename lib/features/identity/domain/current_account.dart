import 'package:meta/meta.dart';

/// Oturumdaki hesap (domain varlığı; `GET /v1/me` yanıtından `data` katmanında eşlenir).
/// Sunum ve uygulama katmanları üretilmiş DTO'yu değil bunu görür (sınır kuralı A1).
@immutable
final class CurrentAccount {
  const CurrentAccount({
    required this.accountId,
    required this.email,
    required this.fullName,
    required this.companyAdmin,
  });

  final String accountId;
  final String email;

  /// Hesabın görünen adı.
  final String fullName;

  /// Şirket yöneticisi mi (sunucu olgusu; yetki kararı yine sunucudadır — yalnız ekran seçimi).
  final bool companyAdmin;

  @override
  bool operator ==(Object other) =>
      other is CurrentAccount &&
      other.accountId == accountId &&
      other.email == email &&
      other.fullName == fullName &&
      other.companyAdmin == companyAdmin;

  @override
  int get hashCode => Object.hash(accountId, email, fullName, companyAdmin);
}
