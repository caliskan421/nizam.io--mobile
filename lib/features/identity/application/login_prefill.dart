import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_prefill.g.dart';

/// Giriş formunun başlangıç değerleri. YALNIZ dev flavor'da bileşim kökünden verilir (yerel
/// test hesabıyla hızlı giriş); prod'da sağlayıcı null kalır ve form boş açılır. Parola
/// `toString`'e düşmez.
class LoginPrefill {
  const LoginPrefill({required this.email, required this.password});

  final String email;
  final String password;

  @override
  String toString() => 'LoginPrefill($email, ***)';
}

/// null = boş form (varsayılan). Bileşim kökü dev'de geçersiz kılar.
@Riverpod(keepAlive: true)
LoginPrefill? loginPrefill(Ref ref) => null;
