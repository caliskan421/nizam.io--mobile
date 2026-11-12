import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/telemetry/error_report.dart';
import '../../../core/telemetry/unexpected_error.dart';
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
    // Hata raporu bağlamı: giriş işlemi (yanlış parola/doğrulama raporlanmaz; yalnız
    // beklenmeyen yanıt/arıza). Eposta ve parola rapora girmez.
    final result = await AsyncValue.guard(() async {
      try {
        return await ReportContext.run(
          ReportOperation.login,
          () => service.login(email: email.trim(), password: password),
        );
      } on Object catch (e, st) {
        // AsyncError'a çevrilmeden önce: beklenmeyen hata (geçersiz yanıt, eşleme
        // arızası) raporlanır; yanlış parola/doğrulama raporlanmaz.
        reportUnexpected(e, st, operation: ReportOperation.login);
        rethrow;
      }
    });
    // Giriş sürerken ekran kapandıysa (faz değişti) sonuç yazılmaz.
    if (!ref.mounted) return;
    state = result;
  }
}
