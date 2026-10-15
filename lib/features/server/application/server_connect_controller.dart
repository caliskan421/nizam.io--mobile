import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';

part 'server_connect_controller.g.dart';

/// Sunucu bağlama gönderim durumu (ekran akışı). Doğrulamanın kendisi core
/// `ServerBindingController.verify`'dadır (well-known + profile, https, sürüm uyumu; fail-closed);
/// bu denetleyici onu yeniden yazmaz, yalnız çağırır. SONUÇ burada tutulmaz: bağın durumu
/// (doğrulandı / güncelleme gerekli / başarısız + hata kodu) tek kaynak olan `bindingStateProvider`
/// üzerinden okunur ve faz makinesi ekranı yönlendirir.
@riverpod
class ServerConnectController extends _$ServerConnectController {
  @override
  FutureOr<void> build() {}

  /// [url] adresini doğrular. `verify` hata fırlatmaz (başarısızlık `BindingFailed` durumudur).
  Future<void> connect(String url) async {
    state = const AsyncLoading();
    final binding = ref.read(serverBindingProvider);
    final result = await AsyncValue.guard(() => binding.verify(url));
    if (!ref.mounted) return;
    state = result.whenData((_) {});
  }
}
