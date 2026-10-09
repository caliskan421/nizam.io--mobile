import '../../../core/api/generated/models/me_response.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/server/server_binding.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/token_pair.dart';
import '../data/identity_repository.dart';

/// Kimlik servisi (ekransız; F14 kapsam 5).
class IdentityService {
  IdentityService({
    required this.binding,
    required this.session,
    required this.repository,
  });

  final ServerBindingController binding;
  final SessionController session;
  final IdentityRepository? Function() repository;

  IdentityRepository _repo() {
    final r = repository();
    if (r == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return r;
  }

  /// Giriş. Sunucu bağı DOĞRULANMAMIŞSA (bağ yok, güvensiz/yanlış sunucu, TLS hatası,
  /// güncelleme gerekli) ağa hiçbir istek çıkmaz ve parola gönderilmez.
  Future<void> login({required String email, required String password}) async {
    final bound = binding.current;
    if (bound is! BindingVerified) {
      throw ApiError(
        binding.current is BindingUpdateRequired
            ? ClientErrorCode.updateRequired
            : ClientErrorCode.serverNotVerified,
      );
    }
    final r = await _repo().login(email: email, password: password);
    final access = r.accessToken;
    final refresh = r.refreshToken;
    final refreshExpiresAt = r.refreshExpiresAt;
    if (access == null || refresh == null || refreshExpiresAt == null) {
      // Mobil sınıf seçilmediyse (web yanıtı) belirteç gövdede yoktur: kullanılmaz.
      throw ApiError(ClientErrorCode.invalidResponse);
    }
    await session.establish(
      TokenPair(
        accountId: r.accountId,
        accessToken: access,
        accessExpiresAt: r.expiresAt,
        refreshToken: refresh,
        refreshExpiresAt: refreshExpiresAt,
        forcePasswordChange: r.forcePasswordChange,
        instanceId: bound.info.instanceId,
      ),
    );
  }

  /// Oturumdaki hesap. Zorunlu parola değişikliği yanıtı bayrağı oturum durumuna taşır.
  Future<MeResponse> me() async {
    try {
      return await _repo().me();
    } on ApiError catch (e) {
      if (e.code == 'identity.force_password_change_required') {
        await session.markForcePasswordChange(true);
      }
      rethrow;
    }
  }

  /// Çıkış: sunucu çıkışı denenir; sonucu ne olursa olsun yerel belirteçler silinir.
  Future<void> logout() async {
    try {
      if (session.accessToken != null) await _repo().logout();
    } on ApiError {
      // Sunucu çıkışı başarısız olsa da yerel oturum kapanır.
    } finally {
      await session.clear();
    }
  }
}
