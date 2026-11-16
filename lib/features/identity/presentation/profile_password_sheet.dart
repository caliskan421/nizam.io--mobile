import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/password_change_controller.dart';

Future<void> showProfilePasswordSheet(BuildContext context) =>
    NzBottomSheet.show(
      context,
      title: context.l10n.uiIdentityPasswordTitle,
      builder: (_) => const _ProfilePasswordForm(),
    );

class _ProfilePasswordForm extends ConsumerStatefulWidget {
  const _ProfilePasswordForm();
  @override
  ConsumerState<_ProfilePasswordForm> createState() =>
      _ProfilePasswordFormState();
}

class _ProfilePasswordFormState extends ConsumerState<_ProfilePasswordForm> {
  final _current = NzPasswordController();
  final _next = NzPasswordController();
  final _confirm = NzPasswordController();
  int _generation = 0;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(passwordChangeControllerProvider).isLoading) return;
    final current = _current.text;
    final next = _next.text;
    _current.clear();
    _next.clear();
    _confirm.clear();
    setState(() => _generation++);
    await ref
        .read(passwordChangeControllerProvider.notifier)
        .submit(currentPassword: current, newPassword: next);
    if (!mounted || ref.read(passwordChangeControllerProvider).hasError) return;
    NzToast.success(context, context.l10n.uiIdentityProfilePasswordSaved);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ref.listenErrors(passwordChangeControllerProvider, context);
    final l = context.l10n;
    final change = ref.watch(passwordChangeControllerProvider);
    return NzForm(
      onSubmit: _submit,
      serverError: change.error is ApiError ? change.error as ApiError : null,
      child: Builder(
        builder: (formContext) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.uiIdentityProfilePasswordIntro, style: context.text.bodyMd),
            const Gap(NizamioSpacing.space4),
            NzPasswordField(
              key: ValueKey('current-$_generation'),
              label: l.uiIdentityPasswordCurrent,
              name: 'current_password',
              controller: _current,
              enabled: !change.isLoading,
              textInputAction: TextInputAction.next,
              validator: NzValidators.requiredText,
            ),
            const Gap(NizamioSpacing.space4),
            NzPasswordField.newPassword(
              key: ValueKey('new-$_generation'),
              label: l.uiIdentityPasswordNew,
              name: 'new_password',
              controller: _next,
              enabled: !change.isLoading,
              validator: NzValidators.requiredText,
            ),
            const Gap(NizamioSpacing.space4),
            NzPasswordField.newPassword(
              key: ValueKey('confirm-$_generation'),
              label: l.uiIdentityPasswordConfirm,
              controller: _confirm,
              enabled: !change.isLoading,
              textInputAction: TextInputAction.done,
              validator: NzValidators.all([
                NzValidators.requiredText,
                NzValidators.matches(() => _next.text),
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
          ],
        ),
      ),
    );
  }
}
