import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/config/generated/app_version.gen.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/providers.dart';
import '../../../core/server/server_binding.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart' show sessionEndedErrorCodes;
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../application/login_controller.dart';

/// Giriş ekranı (faz: `serverVerified` / `reauthRequired`). Giriş başarılıysa oturum açılır
/// ve faz makinesi yönlendirir; ekran kendisi gezinmez. Hata metni yalnız `errorText(code)`
/// (formun altında, prototip `login` düzeni); alan hataları `NzForm.serverError` ile alanlara
/// dağılır. Görünüm prototip: ürün işareti + ad + sürüm, "Giriş yap" başlığı, üstte etiketli
/// 52'lik alanlar, büyük ana düğme.
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
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final login = ref.watch(loginControllerProvider);
    final binding = ref.watch(bindingStateProvider);
    final error = login.error is ApiError ? login.error as ApiError? : null;
    // Hata metni formun altında (prototip `.t-hint--error`, role=alert); oturum-bitti sınıfı
    // kodlar faz makinesince yönlendirilir, gösterilmez (bkz. `sessionEndedErrorCodes`).
    final shownError =
        login.hasError &&
            !login.isLoading &&
            !sessionEndedErrorCodes.contains(toApiError(login.error!).code)
        ? toApiError(login.error!)
        : null;
    return NzPage(
      title: l.uiIdentityLoginTitle,
      width: NzContentWidth.form,
      showTitleBar: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          NizamioSpacing.space2,
          NizamioSpacing.space16,
          NizamioSpacing.space2,
          NizamioSpacing.space10,
        ),
        child: NzForm(
          onSubmit: _submit,
          serverError: error,
          child: Builder(
            builder: (formContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MergeSemantics(
                  child: Row(
                    children: [
                      NzBrandMark(
                        monogram: l.uiHomeAppName.characters.first,
                        extent: NizamioSize.controlMd,
                      ),
                      const Gap(NizamioSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.uiHomeAppName,
                              style: t.brand.copyWith(
                                fontSize: t.labelLg.fontSize,
                                height: t.titleSm.height,
                              ),
                            ),
                            Text(
                              '${l.uiIdentityLoginVersionPrefix}$appVersion',
                              style: t.kicker.copyWith(color: c.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(NizamioSpacing.space10),
                Semantics(
                  header: true,
                  child: Text(l.uiIdentityLoginTitle, style: t.displayLg),
                ),
                const Gap(NizamioSpacing.space2),
                Text(
                  l.uiIdentityLoginIntro,
                  style: t.bodyLg.copyWith(color: c.textMuted),
                ),
                if (binding is BindingVerified) ...[
                  const Gap(NizamioSpacing.space3),
                  MergeSemantics(
                    child: Wrap(
                      spacing: NizamioSpacing.space2,
                      children: [
                        Text(
                          l.uiIdentityLoginServer,
                          style: t.bodyMd.copyWith(color: c.textMuted),
                        ),
                        Text(binding.info.displayName, style: t.labelLg),
                      ],
                    ),
                  ),
                ],
                const Gap(NizamioSpacing.space10),
                NzTextField.email(
                  label: l.uiIdentityLoginEmail,
                  hint: l.uiIdentityLoginEmailHint,
                  labelAbove: true,
                  size: NzSize.lg,
                  name: 'email',
                  controller: _email,
                  enabled: !login.isLoading,
                  // Prototip hata durumu: iki alan birden tehlike kenarlı, ileti formun altında.
                  invalid: shownError != null,
                  validator: NzValidators.all([
                    NzValidators.requiredText,
                    NzValidators.email,
                  ]),
                ),
                const Gap(NizamioSpacing.space5),
                NzPasswordField(
                  key: ValueKey(_passwordGeneration),
                  label: l.uiIdentityLoginPassword,
                  hint: l.uiIdentityLoginPasswordHint,
                  labelAbove: true,
                  size: NzSize.lg,
                  name: 'password',
                  controller: _password,
                  enabled: !login.isLoading,
                  invalid: shownError != null,
                  validator: NzValidators.requiredText,
                  onSubmitted: (_) => NzForm.of(formContext).submit(),
                ),
                if (shownError != null) ...[
                  const Gap(NizamioSpacing.space5),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      errorText(l, shownError),
                      style: t.caption.copyWith(color: c.danger),
                    ),
                  ),
                ],
                const Gap(NizamioSpacing.space5 + NizamioSpacing.space2),
                NzButton.primary(
                  label: login.isLoading
                      ? l.uiIdentityLoginSubmitting
                      : l.uiIdentityLoginSubmit,
                  size: NzSize.lg,
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
