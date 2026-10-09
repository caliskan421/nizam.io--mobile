import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/models/login_request.dart';
import '../../../core/api/generated/models/login_response.dart';
import '../../../core/api/generated/models/me_response.dart';
import '../../../core/errors/api_error.dart';
import '../domain/current_account.dart';
import '../domain/login_grant.dart';

/// identity uçlarına üretilmiş istemciyle erişim (elle DTO yok — sınır kuralı D1/D2).
/// Üretilmiş DTO'lar bu katmanda kalır; dışarıya domain varlıkları döner (sınır kuralı A1).
/// Bütün hatalar [ApiError] olarak fırlar.
class IdentityRepository {
  IdentityRepository(this._client);

  final IdentityClient _client;

  /// `POST /v1/auth/login` — `X-Nizamio-Client: mobile` ara katmandan; belirteçler gövdede.
  Future<LoginGrant> login({
    required String email,
    required String password,
  }) async => _grant(
    await apiCall(
      () => _client.login(
        body: LoginRequest(email: email, password: password),
      ),
    ),
  );

  /// `POST /v1/auth/logout` — bu oturumu ve mobil eşli yenileme soyunu kapatır (TF-ID-07).
  Future<void> logout() => apiCall(_client.logout);

  /// `GET /v1/me`.
  Future<CurrentAccount> me() async => _account(await apiCall(_client.me));

  static LoginGrant _grant(LoginResponse r) => LoginGrant(
    accountId: r.accountId,
    accessToken: r.accessToken,
    accessExpiresAt: r.expiresAt,
    refreshToken: r.refreshToken,
    refreshExpiresAt: r.refreshExpiresAt,
    forcePasswordChange: r.forcePasswordChange,
  );

  static CurrentAccount _account(MeResponse r) =>
      CurrentAccount(accountId: r.accountId, email: r.email);
}
