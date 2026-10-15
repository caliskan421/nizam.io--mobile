import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'identity_providers.dart';

part 'login_controller.g.dart';

/// Giriş gönderim durumu. Parola YALNIZ [submit] parametresidir: duruma, `toString`'e ve log'a
/// girmez (durum `AsyncValue<void>`: yükleniyor / hata [ApiError] / bitti). Oturumun açılması
/// durum değildir: `sessionStateProvider` değişir, faz makinesi yönlendirir.
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final service = ref.read(identityServiceProvider);
    final result = await AsyncValue.guard(
      () => service.login(email: email.trim(), password: password),
    );
    // Giriş sürerken ekran kapandıysa (faz değişti) sonuç yazılmaz.
    if (!ref.mounted) return;
    state = result;
  }
}
