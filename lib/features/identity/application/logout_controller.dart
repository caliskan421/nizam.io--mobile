import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'identity_providers.dart';

part 'logout_controller.g.dart';

/// Çıkış durumu. Sunucu çıkışı başarısız olsa da yerel oturum kapanır (`IdentityService.logout`);
/// kapanış faz makinesiyle giriş ekranına döner.
@riverpod
class LogoutController extends _$LogoutController {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncLoading();
    final service = ref.read(identityServiceProvider);
    final result = await AsyncValue.guard(service.logout);
    if (!ref.mounted) return;
    state = result;
  }
}
