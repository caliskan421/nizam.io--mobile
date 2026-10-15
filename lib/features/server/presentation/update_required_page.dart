import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/server/server_binding.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../application/server_connect_controller.dart';

/// Açık "güncelleme gerekli" ekranı (faz: `updateRequired`). Sunucunun asgari mobil sürümü
/// uygulamadan yüksektir: giriş akışı BAŞLAMAZ, bu ekranda giriş alanı yoktur. "Yeniden
/// denetle" aynı adresi yeniden doğrular (sunucu asgari sürümü düşürmüş olabilir).
class UpdateRequiredPage extends ConsumerWidget {
  const UpdateRequiredPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listenErrors(serverConnectControllerProvider, context);
    final l = context.l10n;
    final binding = ref.watch(bindingStateProvider);
    final busy = ref.watch(serverConnectControllerProvider).isLoading;
    return NzPage(
      title: l.uiServerUpdateTitle,
      width: NzContentWidth.form,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.uiServerUpdateMessage, style: context.text.bodyMd),
            if (binding is BindingUpdateRequired) ...[
              const Gap(NizamioSpacing.space6),
              _Fact(label: l.uiServerUpdateServer, value: '${binding.address}'),
              _Fact(
                label: l.uiServerUpdateRequiredVersion,
                value: binding.minimumVersion,
              ),
              _Fact(
                label: l.uiServerUpdateInstalledVersion,
                value: binding.appVersion,
              ),
              const Gap(NizamioSpacing.space6),
              NzButton.secondary(
                label: l.uiServerUpdateRecheck,
                loading: busy,
                expand: true,
                onPressed: () => ref
                    .read(serverConnectControllerProvider.notifier)
                    .connect('${binding.address}'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Etiket + değer; değişken parça ayrı `Text` (yer tutucusuz metin).
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
    child: MergeSemantics(
      child: Wrap(
        spacing: NizamioSpacing.space2,
        children: [
          Text(
            label,
            style: context.text.bodyMd.copyWith(
              color: context.colors.textMuted,
            ),
          ),
          Text(value, style: context.text.labelLg),
        ],
      ),
    ),
  );
}
