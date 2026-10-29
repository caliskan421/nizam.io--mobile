import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/models/change_password_request.dart';
import '../../../core/api/generated/models/download_ticket_request.dart';
import '../../../core/api/generated/models/download_ticket_request_method.dart';
import '../../../core/api/generated/models/login_request.dart';
import '../../../core/api/generated/models/login_response.dart';
import '../../../core/api/generated/models/me_response.dart';
import '../../../core/api/generated/models/workload_pdf_request.dart';
import '../../../core/errors/api_error.dart';
import '../domain/current_account.dart';
import '../domain/download_ticket.dart';
import '../domain/login_grant.dart';

/// identity uçlarına üretilmiş istemciyle erişim (elle DTO yok — sınır kuralı D1/D2).
/// Üretilmiş DTO'lar bu katmanda kalır; dışarıya domain varlıkları döner (sınır kuralı A1).
/// Bütün hatalar [ApiError] olarak fırlar.
class IdentityRepository {
  /// [dio]: doğrulanmış bağın API istemcisi. Üretilmiş istemci burada kurulur; açık yapıcı
  /// üretilmiş tip anmaz (sınır kuralı A2).
  IdentityRepository(Dio dio)
    : _client = IdentityClient(dio),
      _baseUrl = dio.options.baseUrl;

  final IdentityClient _client;
  final String _baseUrl;

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

  /// `POST /v1/auth/password` — yanıtta belirteç YOKTUR (mevcut oturum aynen sürer); sunucu
  /// hesabın DİĞER oturumlarını düşürür. Dönen: düşürülen oturum sayısı. Parolalar yalnız
  /// istek gövdesine girer; hiçbir yerde saklanmaz, `toString`'e yazılmaz.
  Future<int> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final r = await apiCall(
      () => _client.changePassword(
        body: ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ),
    );
    return r.revokedSessions;
  }

  /// `GET /v1/me`.
  Future<CurrentAccount> me() async => _account(await apiCall(_client.me));

  /// `POST /v1/download-tickets` (S1), GET hedefi: [path] göreli hedef yolu + ham sorgu
  /// dizesidir (ör. `/v1/files/{id}/download`, ZIP ve PDF uçları; izin listesi sunucuda,
  /// ADR-0013 — liste dışı hedef 422 `identity.download_target_invalid`). Kapsam başlıkları ara
  /// katmandan bilete yazılır ve tüketimde hedefe taşınır. Oturum başına en çok 16 açık bilet.
  Future<DownloadTicket> issueDownloadTicket(String path) => _issue(
    DownloadTicketRequest(
      method: DownloadTicketRequestMethod.valueGet,
      path: path,
    ),
  );

  /// `POST /v1/download-tickets` (S1), tek POST hedefi: iş yükü PDF'i
  /// (`POST /v1/reports/workload`). [memberIds] boşsa bütün üyeler. Gövde üretilmiş
  /// `WorkloadPdfRequest` DTO'sudur (features içinde elle JSON gövdesi kurulmaz — D2).
  Future<DownloadTicket> issueWorkloadPdfTicket({
    List<String> memberIds = const [],
  }) => _issue(
    DownloadTicketRequest(
      method: DownloadTicketRequestMethod.post,
      path: workloadPdfPath,
      body: WorkloadPdfRequest(memberIds: memberIds),
    ),
  );

  /// İş yükü PDF'inin hedef yolu (bilet izin listesindeki tek POST hedefi).
  static const workloadPdfPath = '/v1/reports/workload';

  Future<DownloadTicket> _issue(DownloadTicketRequest request) async {
    final r = await apiCall(() => _client.issueDownloadTicket(body: request));
    return DownloadTicket(
      ticket: r.ticket,
      path: r.url,
      expiresAt: r.expiresAt,
    );
  }

  /// `GET /v1/downloads/{ticket}` (S0) için mutlak tüketme adresi: bağlı sunucunun tabanına
  /// biletin göreli yolu eklenir. Bilet, tarayıcı ya da indirme yöneticisi bu adrese kimlik
  /// başlığı OLMADAN gittiğinde tüketilir (kimlik biletten gelir; ADR-0013). Üretilmiş istemcinin
  /// `redeemDownloadTicket` imzası `Future<void>` olduğundan (yanıt `*/*`, şemasız) gövde
  /// istemciden okunamaz; bu yüzden repository bileti kendisi tüketmez.
  /// Taban yolunu korumak için (dio gibi) birleştirme yapılır, `Uri.resolve` değil.
  Uri downloadUri(DownloadTicket ticket) {
    final base = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final path = ticket.path.startsWith('/') ? ticket.path : '/${ticket.path}';
    return Uri.parse('$base$path');
  }

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
