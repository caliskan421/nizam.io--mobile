import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';

/// İşlem geçmişine giriş kartı: yalnız şirket yöneticisine görünür (AUDIT-K10; diğer rollerde
/// hiçbir şey çizilmez), dokununca işlem geçmişini açar.
class ActivityLogCard extends ConsumerWidget {
  const ActivityLogCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin =
        ref.watch(taskCatalogControllerProvider).value?.access?.companyAdmin ??
        false;
    if (!admin) return const SizedBox.shrink();
    return NzCard.outlined(
      onTap: context.appNav.openHistory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: NizamioSpacing.space2,
        children: [
          NzKicker(context.l10n.uiActivityTitle),
          Text(
            context.l10n.uiActivityIntro,
            style: context.text.bodySm.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
