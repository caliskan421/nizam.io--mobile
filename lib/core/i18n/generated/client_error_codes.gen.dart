// BU DOSYA ÜRETİLMİŞTİR — elle düzenlenmez. `make gen` (tool/gen.dart) ile yeniden üretilir.
// Kaynak: i18n/client_errors.tr.json

/// İstemcinin ürettiği kararlı hata kodları ('client.' önekli; sunucu kataloğunda yok).
abstract final class ClientErrorCode {
  static const insecureServer = 'client.insecure_server';
  static const invalidResponse = 'client.invalid_response';
  static const invalidServerAddress = 'client.invalid_server_address';
  static const networkError = 'client.network_error';
  static const notSignedIn = 'client.not_signed_in';
  static const reauthRequired = 'client.reauth_required';
  static const scopeMissing = 'client.scope_missing';
  static const secureStorageError = 'client.secure_storage_error';
  static const serverNotVerified = 'client.server_not_verified';
  static const serverUnrecognized = 'client.server_unrecognized';
  static const sessionEnded = 'client.session_ended';
  static const timeout = 'client.timeout';
  static const tlsError = 'client.tls_error';
  static const unknownOperation = 'client.unknown_operation';
  static const unsupportedApiVersion = 'client.unsupported_api_version';
  static const updateRequired = 'client.update_required';

  static const all = <String>{
    insecureServer,
    invalidResponse,
    invalidServerAddress,
    networkError,
    notSignedIn,
    reauthRequired,
    scopeMissing,
    secureStorageError,
    serverNotVerified,
    serverUnrecognized,
    sessionEnded,
    timeout,
    tlsError,
    unknownOperation,
    unsupportedApiVersion,
    updateRequired,
  };
}
