import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;

import '../../errors/api_error.dart';
import '../../i18n/generated/client_error_codes.gen.dart';
import '../widgets/feedback/nz_toast.dart';

/// Ekranın göstermeyeceği "oturum bitti" sınıfı hata kodları: faz makinesi
/// (`deriveAppPhase` → router) kullanıcıyı zaten yönlendirir; ayrıca toast göstermek
/// yönlendirmeyle çakışır.
///
/// - `client.session_ended`: yenileme 401 → `SessionReauthRequired` (session_controller.dart
///   `_rotate`, `ReauthReason.refreshRejected`) ve nesil değişimi; faz → reauthRequired.
/// - `client.not_signed_in`: belirteç yok (interceptors.dart `AuthInterceptor.onRequest`);
///   faz serverVerified → /login.
/// - `client.reauth_required`: yenileme belirsiz/yanmış belirteç (session_controller.dart
///   `refresh`, `_rotate`); faz → reauthRequired.
/// - `identity.force_password_change_required`: `IdentityService.me` bayrağı oturuma işler
///   (`markForcePasswordChange`); faz → passwordChangeRequired.
///
/// `client.scope_missing` KASITLI olarak yoktur: kapsam eksikse faz zaten `sessionOpen`
/// (/scope) olur, ama S3 uçta yalnız birim eksikse faz `scoped` kalır ve kullanıcıya
/// yönlendirme olmaz; hata görünür kalmalı. Bağ/sunucu kodları (`server_*`, `update_required`,
/// `unsupported_api_version`) giriş öncesi bağ akışının kodlarıdır ve kendi ekranlarında gösterilir.
const Set<String> sessionEndedErrorCodes = {
  ClientErrorCode.sessionEnded,
  ClientErrorCode.notSignedIn,
  ClientErrorCode.reauthRequired,
  'identity.force_password_change_required',
};

extension NzRefListen on WidgetRef {
  /// [provider] AsyncError'a GEÇTİĞİNDE (aynı hata nesnesi tekrar bildirilmez) NzToast.error;
  /// kod [sessionEndedErrorCodes] içindeyse hiçbir şey gösterilmez. build içinde çağrılır
  /// (`ref.listen`); etkinin kendisi geri çağrıdadır.
  void listenErrors<T>(
    ProviderListenable<AsyncValue<T>> provider,
    BuildContext context,
  ) {
    listen<AsyncValue<T>>(provider, (previous, next) {
      if (next is! AsyncError<T>) return;
      if (previous is AsyncError<T> && identical(previous.error, next.error)) {
        return;
      }
      final error = toApiError(next.error);
      if (sessionEndedErrorCodes.contains(error.code)) return;
      if (!context.mounted) return;
      NzToast.error(context, error);
    });
  }

  /// Yükleniyor → AsyncData geçişinde [onData] (gönderim başarısı: yönlendirme, toast).
  /// İlk build'de tetiklenmez.
  void listenSuccess<T>(
    ProviderListenable<AsyncValue<T>> provider,
    void Function(T data) onData,
  ) {
    listen<AsyncValue<T>>(provider, (previous, next) {
      if (previous == null || !previous.isLoading) return;
      if (next is AsyncData<T>) onData(next.value);
    });
  }
}
