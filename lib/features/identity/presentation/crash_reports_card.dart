import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/telemetry/error_reporting_controller.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/nz_switch.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';

/// Hata raporu tercihi. Varsayılan KAPALI; yalnız raporlayıcı kullanılabilirken (Firebase
/// zamanında açıldı) görünür. Anahtar gerçek etkin durumu gösterir: açma başarısız olursa
/// (tercih yazılamadı, SDK yanıt vermedi) kapalı kalır.
class CrashReportsCard extends ConsumerWidget {
  const CrashReportsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(errorReportingControllerProvider);
    if (controller == null || !controller.available) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space6),
      child: NzCard.outlined(
        child: ValueListenableBuilder<bool>(
          valueListenable: controller.state,
          builder: (context, enabled, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.uiIdentityCrashReportsTitle, style: context.text.labelLg),
              const Gap(NizamioSpacing.space2),
              NzSwitch(
                label: l.uiIdentityCrashReportsSwitch,
                description: l.uiIdentityCrashReportsBody,
                value: enabled,
                onChanged: controller.set,
              ),
              ValueListenableBuilder<ReportingNotice>(
                valueListenable: controller.notice,
                builder: (context, notice, _) => switch (notice) {
                  ReportingNotice.none => const SizedBox.shrink(),
                  ReportingNotice.enableFailed => _Notice(
                    l.uiIdentityCrashReportsEnableFailed,
                  ),
                  ReportingNotice.revokeNotPersisted => _Notice(
                    l.uiIdentityCrashReportsRevokeNotPersisted,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: NizamioSpacing.space2),
    child: Semantics(
      liveRegion: true,
      child: Text(
        text,
        style: context.text.caption.copyWith(color: context.colors.danger),
      ),
    ),
  );
}
