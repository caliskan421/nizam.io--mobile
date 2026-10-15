import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/providers.dart';
import '../../../core/server/server_binding.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/server_connect_controller.dart';

/// Sunucu bağlama ekranı (faz: `unbound` / `verifying` / `bindingFailed`).
///
/// Doğrulama sonucu `bindingStateProvider`'dan okunur: başarısızlık nedeni (güvensiz adres,
/// TLS hatası, tanınmayan sunucu, API sürümü…) `errorText(code)` ile AYRI metinler olarak
/// ekranda kalır, yutulmaz. Başarıda faz makinesi giriş ekranına yönlendirir; bu ekran
/// kendisi gezinmez.
class ServerPage extends ConsumerStatefulWidget {
  const ServerPage({super.key});

  @override
  ConsumerState<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends ConsumerState<ServerPage> {
  late final TextEditingController _url = TextEditingController(
    text: _knownAddress(ref.read(bindingStateProvider)),
  );

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  /// Önceki denemenin (ya da kayıtlı bağın) adresi: yeniden denemek için alana konur.
  static String _knownAddress(BindingState s) => switch (s) {
    BindingFailed(:final address) => address?.toString() ?? '',
    BindingVerifying(:final address) => address.toString(),
    BindingUpdateRequired(:final address) => address.toString(),
    BindingUnbound() || BindingVerified() => '',
  };

  void _submit() =>
      ref.read(serverConnectControllerProvider.notifier).connect(_url.text);

  @override
  Widget build(BuildContext context) {
    ref.listenErrors(serverConnectControllerProvider, context);
    final l = context.l10n;
    final binding = ref.watch(bindingStateProvider);
    final connecting = ref.watch(serverConnectControllerProvider).isLoading;
    final busy = connecting || binding is BindingVerifying;
    return NzPage(
      title: l.uiServerTitle,
      width: NzContentWidth.form,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
        child: NzForm(
          onSubmit: _submit,
          child: Builder(
            builder: (formContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.uiServerIntro, style: context.text.bodyMd),
                const Gap(NizamioSpacing.space4),
                if (binding is BindingFailed) ...[
                  NzBanner.danger(message: errorText(l, binding.error)),
                  const Gap(NizamioSpacing.space4),
                ],
                NzTextField(
                  label: l.uiServerUrlLabel,
                  hint: l.uiServerUrlHint,
                  controller: _url,
                  enabled: !busy,
                  validator: NzValidators.requiredText,
                  autofillHints: const [AutofillHints.url],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => NzForm.of(formContext).submit(),
                ),
                const Gap(NizamioSpacing.space6),
                NzButton.primary(
                  label: l.uiServerConnect,
                  loading: busy,
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
