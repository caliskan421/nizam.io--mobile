import 'package:meta/meta.dart';

/// Oturumdaki hesap (domain varlığı; `GET /v1/me` yanıtından `data` katmanında eşlenir).
/// Sunum ve uygulama katmanları üretilmiş DTO'yu değil bunu görür (sınır kuralı A1).
@immutable
final class CurrentAccount {
  const CurrentAccount({required this.accountId, required this.email});

  final String accountId;
  final String email;

  @override
  bool operator ==(Object other) =>
      other is CurrentAccount &&
      other.accountId == accountId &&
      other.email == email;

  @override
  int get hashCode => Object.hash(accountId, email);
}
