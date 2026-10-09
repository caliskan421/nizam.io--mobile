import '../config/flavor.dart';
import '../errors/api_error.dart';
import '../i18n/generated/client_error_codes.gen.dart';

/// Doğrulanmış sunucu kökü (`scheme://host[:port]`). Tek sunucu adresi elle URL ya da yalnız
/// URL taşıyan QR'dan gelir (K-11). Ağ isteği yapılmadan önce yerel kurallar uygulanır:
///   - prod: yalnız `https` (düz http'ye parola gitmez — istek hiç oluşmaz);
///   - dev: `https` ya da yalnız yerel geliştirme adresine `http`;
///   - kullanıcı bilgisi, sorgu, parça ve yol (kök dışı) reddedilir.
final class ServerAddress {
  ServerAddress._(this.origin);

  /// Geliştirmede düz http'ye izin verilen yerel adresler (emülatör: 10.0.2.2).
  static const localHosts = {'localhost', '127.0.0.1', '10.0.2.2', '::1'};

  final Uri origin;

  bool get isHttps => origin.scheme == 'https';

  /// Girdi geçersizse `client.invalid_server_address`, http yasaksa `client.insecure_server`.
  static ServerAddress parse(String input, Flavor flavor) {
    final raw = input.trim();
    final uri = Uri.tryParse(raw);
    if (uri == null ||
        !uri.hasScheme ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.path.isNotEmpty && uri.path != '/')) {
      throw ApiError(ClientErrorCode.invalidServerAddress);
    }
    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'http') {
      if (!(flavor.allowsLocalHttp &&
          localHosts.contains(uri.host.toLowerCase()))) {
        throw ApiError(ClientErrorCode.insecureServer);
      }
    } else if (scheme != 'https') {
      throw ApiError(ClientErrorCode.invalidServerAddress);
    }
    return ServerAddress._(
      Uri(
        scheme: scheme,
        host: uri.host.toLowerCase(),
        port: uri.hasPort ? uri.port : null,
      ),
    );
  }

  /// [uri] bu sunucuya mı gidiyor (şema, host, port birebir)?
  bool owns(Uri uri) =>
      uri.scheme == origin.scheme &&
      uri.host == origin.host &&
      uri.port == origin.port;

  @override
  String toString() => origin.toString();

  @override
  bool operator ==(Object other) =>
      other is ServerAddress && other.origin == origin;

  @override
  int get hashCode => origin.hashCode;
}
