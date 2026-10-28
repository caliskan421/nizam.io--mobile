import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/logout_controller.dart';

/// Çıkış düğmesi: onay diyaloğu (`NzDialog.confirm`) → `LogoutController.signOut`. Sunucu çıkışı
/// başarısız olsa da yerel oturum kapanır; faz makinesi giriş ekranına döner. Parola değişikliği
/// ve program seçimi ekranlarında da kullanılır (profil sekmesi yalnız kapsam seçildikten sonra
/// açıktır; bu iki kapıda oturumdan çıkış yolu başka türlü yoktur).
class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenErrors(logoutControllerProvider, context);
    final l = context.l10n;
    final busy = ref.watch(logoutControllerProvider).isLoading;
    return NzButton.ghost(
      label: l.uiIdentitySignOut,
      icon: Icons.logout,
      loading: busy,
      expand: true,
      onPressed: () => confirmSignOut(context, ref),
    );
  }
}

/// Onay diyaloğu → `LogoutController.signOut` (çekmecedeki "Çıkış yap" satırı da bunu çağırır).
/// Hata gösterimi için çağıran `ref.listenErrors(signOutProvider, …)` ile dinler.
Future<void> confirmSignOut(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final confirmed = await NzDialog.confirm(
    context,
    title: l.uiIdentitySignOutConfirmTitle,
    message: l.uiIdentitySignOutConfirmMessage,
    confirmLabel: l.uiIdentitySignOut,
    tone: NzDialogTone.destructive,
  );
  if (!confirmed || !context.mounted) return;
  await ref.read(logoutControllerProvider.notifier).signOut();
}

/// Çıkış işleminin durumu (hata dinlemek için açık yüz).
final signOutProvider = logoutControllerProvider;
