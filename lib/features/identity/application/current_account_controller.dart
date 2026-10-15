import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/current_account.dart';
import 'identity_providers.dart';

part 'current_account_controller.g.dart';

/// Oturumdaki hesap (`GET /v1/me`); profil ekranı okur. Yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
@riverpod
class CurrentAccountController extends _$CurrentAccountController {
  @override
  Future<CurrentAccount> build() => ref.read(identityServiceProvider).me();
}
