import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/models/login_request.dart';
import '../../../core/api/generated/models/login_response.dart';
import '../../../core/api/generated/models/me_response.dart';
import '../../../core/errors/api_error.dart';

/// identity uçlarına üretilmiş istemciyle erişim (elle DTO yok — sınır kuralı D1/D2).
/// Bütün hatalar [ApiError] olarak fırlar.
class IdentityRepository {
  IdentityRepository(this._client);

  final IdentityClient _client;

  /// `POST /v1/auth/login` — `X-Nizamio-Client: mobile` ara katmandan; belirteçler gövdede.
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) => apiCall(
    () => _client.login(
      body: LoginRequest(email: email, password: password),
    ),
  );

  /// `POST /v1/auth/logout` — bu oturumu ve mobil eşli yenileme soyunu kapatır (TF-ID-07).
  Future<void> logout() => apiCall(_client.logout);

  /// `GET /v1/me`.
  Future<MeResponse> me() => apiCall(_client.me);
}
