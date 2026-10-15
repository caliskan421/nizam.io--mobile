import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/password_change_controller.dart';
import 'sign_out_button.dart';

/// Zorunlu parola değişikliği ekranı (faz: `passwordChangeRequired`). Başarıda bayrak düşer ve
/// faz makinesi kapsam seçimine yönlendirir; ekran kendisi gezinmez. Parolalar yalnız alan
/// denetleyicilerindedir: hata da başarı da olsa alanlar temizlenir, durumda/log'da yoktur.
class PasswordChangePage extends ConsumerStatefulWidget {
  const PasswordChangePage({super.key});

  @override
  ConsumerState<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends ConsumerState<PasswordChangePage> {
  final _current = NzPasswordController();
  final _new = NzPasswordController();
  final _confirm = NzPasswordController();

  /// Alanları sıfırlamak için anahtar nesli (alan durumu: görünürlük, doğrulama).
  int _generation = 0;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final current = _current.text;
    final next = _new.text;
    _current.clear();
    _new.clear();
    _confirm.clear();
    setState(() => _generation++);
    ref
        .read(passwordChangeControllerProvider.notifier)
        .submit(currentPassword: current, newPassword: next);
  }

  @override
  Widget build(BuildContext context) {
    ref.listenErrors(passwordChangeControllerProvider, context);
    final l = context.l10n;
    final change = ref.watch(passwordChangeControllerProvider);
    final error = change.error is ApiError ? change.error as ApiError? : null;
    final enabled = !change.isLoading;
    return NzPage(
      title: l.uiIdentityPasswordTitle,
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
                Text(l.uiIdentityPasswordIntro, style: context.text.bodyMd),
                const Gap(NizamioSpacing.space4),
                NzPasswordField(
                  key: ValueKey('current-$_generation'),
                  label: l.uiIdentityPasswordCurrent,
                  name: 'current_password',
                  controller: _current,
                  enabled: enabled,
                  textInputAction: TextInputAction.next,
                  validator: NzValidators.requiredText,
                ),
                const Gap(NizamioSpacing.space4),
                NzPasswordField.newPassword(
                  key: ValueKey('new-$_generation'),
                  label: l.uiIdentityPasswordNew,
                  name: 'new_password',
                  controller: _new,
                  enabled: enabled,
                  validator: NzValidators.requiredText,
                ),
                const Gap(NizamioSpacing.space4),
                NzPasswordField.newPassword(
                  key: ValueKey('confirm-$_generation'),
                  label: l.uiIdentityPasswordConfirm,
                  controller: _confirm,
                  enabled: enabled,
                  textInputAction: TextInputAction.done,
                  validator: NzValidators.all([
                    NzValidators.requiredText,
                    NzValidators.matches(() => _new.text),
                  ]),
                  onSubmitted: (_) => NzForm.of(formContext).submit(),
                ),
                const Gap(NizamioSpacing.space6),
                NzButton.primary(
                  label: l.uiIdentityPasswordSubmit,
                  loading: change.isLoading,
                  expand: true,
                  onPressed: () => NzForm.of(formContext).submit(),
                ),
                const Gap(NizamioSpacing.space3),
                const SignOutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
