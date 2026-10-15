import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/server/server_binding.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/login_controller.dart';

/// Giriş ekranı (faz: `serverVerified` / `reauthRequired`). Giriş başarılıysa oturum açılır
/// ve faz makinesi yönlendirir; ekran kendisi gezinmez. Hata metni yalnız `errorText(code)`
/// (toast); alan hataları `NzForm.serverError` ile alanlara dağılır.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = NzPasswordController();

  /// Parola alanını sıfırlamak için anahtar nesli (alan durumu: görünürlük, doğrulama).
  int _passwordGeneration = 0;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _password.text;
    // Hata da olsa başarı da olsa parola alanında kalmaz.
    _password.clear();
    setState(() => _passwordGeneration++);
    ref
        .read(loginControllerProvider.notifier)
        .submit(email: _email.text, password: password);
  }

  @override
  Widget build(BuildContext context) {
    ref.listenErrors(loginControllerProvider, context);
    final l = context.l10n;
    final login = ref.watch(loginControllerProvider);
    final binding = ref.watch(bindingStateProvider);
    final error = login.error is ApiError ? login.error as ApiError? : null;
    return NzPage(
      title: l.uiIdentityLoginTitle,
      width: NzContentWidth.form,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
        child: NzForm(
          onSubmit: _submit,
          serverError: error,
          child: Builder(
            builder: (formContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (binding is BindingVerified) ...[
                  MergeSemantics(
                    child: Wrap(
                      spacing: NizamioSpacing.space2,
                      children: [
                        Text(
                          l.uiIdentityLoginServer,
                          style: context.text.bodyMd.copyWith(
                            color: context.colors.textMuted,
                          ),
                        ),
                        Text(
                          binding.info.displayName,
                          style: context.text.labelLg,
                        ),
                      ],
                    ),
                  ),
                  const Gap(NizamioSpacing.space4),
                ],
                NzTextField.email(
                  label: l.uiIdentityLoginEmail,
                  name: 'email',
                  controller: _email,
                  enabled: !login.isLoading,
                  validator: NzValidators.all([
                    NzValidators.requiredText,
                    NzValidators.email,
                  ]),
                ),
                const Gap(NizamioSpacing.space4),
                NzPasswordField(
                  key: ValueKey(_passwordGeneration),
                  label: l.uiIdentityLoginPassword,
                  name: 'password',
                  controller: _password,
                  enabled: !login.isLoading,
                  validator: NzValidators.requiredText,
                  onSubmitted: (_) => NzForm.of(formContext).submit(),
                ),
                const Gap(NizamioSpacing.space6),
                NzButton.primary(
                  label: l.uiIdentityLoginSubmit,
                  loading: login.isLoading,
                  expand: true,
                  onPressed: () => NzForm.of(formContext).submit(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
