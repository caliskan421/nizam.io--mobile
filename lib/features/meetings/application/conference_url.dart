import '../../../core/config/flavor.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/server/server_address.dart';

/// Oda adresini (`joinConference` yanıtındaki `url`) bağlanmadan önce yerel kurallarla
/// doğrular; sunucu bağı kuralıyla ([ServerAddress.parse]) aynı ilke, fail-closed:
///   - `wss` her çeşitte;
///   - düz `ws` yalnız dev çeşidinde ve yalnız yerel geliştirme adresine (aynı makine,
///     emülatör ya da özel ağ: 10/8, 172.16/12, 192.168/16, `.local`); prod'da reddedilir;
///   - başka şema, boş host, kullanıcı bilgisi ya da parça reddedilir.
/// Hata `client.conference_insecure_url`. Token adrese eklenmez (sağlayıcı istemcisi ekler).
String conferenceUrl(String raw, Flavor flavor) {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasFragment) {
    throw ApiError(ClientErrorCode.conferenceInsecureUrl);
  }
  final scheme = uri.scheme.toLowerCase();
  final ok =
      scheme == 'wss' ||
      (scheme == 'ws' &&
          flavor.allowsLocalHttp &&
          ServerAddress.isLocalDevHost(uri.host));
  if (!ok) throw ApiError(ClientErrorCode.conferenceInsecureUrl);
  return uri.toString();
}
