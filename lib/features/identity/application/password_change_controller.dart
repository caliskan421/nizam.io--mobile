import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'identity_providers.dart';

part 'password_change_controller.g.dart';

/// Zorunlu parola değişikliği gönderim durumu. Parolalar YALNIZ [submit] parametresidir; durum
/// yalnız gönderim sonucudur (yükleniyor / hata [ApiError] / bitti). Başarıda bayrak
/// `IdentityService`'te düşer ve faz makinesi kapsam seçimine yönlendirir.
@riverpod
class PasswordChangeController extends _$PasswordChangeController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    final service = ref.read(identityServiceProvider);
    final result = await AsyncValue.guard(
      () => service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    if (!ref.mounted) return;
    state = result.whenData((_) {});
  }
}
