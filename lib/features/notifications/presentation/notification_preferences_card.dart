import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/nz_switch.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/notification_preferences_controller.dart';
import '../domain/notification_preferences.dart';

/// Ayarlardaki bildirim tercihleri (NOTIFICATIONS-K36): dört grup için anahtar; açık = anlık
/// bildirim gelir. Uygulama içi bildirimler sessize almadan etkilenmez (açıklama satırı).
class NotificationPreferencesCard extends ConsumerWidget {
  const NotificationPreferencesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(notificationPreferencesControllerProvider);
    final ctl = ref.read(notificationPreferencesControllerProvider.notifier);
    String label(NotificationPrefGroup g) => switch (g) {
      NotificationPrefGroup.gorev => l.uiNotificationsPrefTasks,
      NotificationPrefGroup.mesaj => l.uiNotificationsPrefMessages,
      NotificationPrefGroup.toplanti => l.uiNotificationsPrefMeetings,
      NotificationPrefGroup.sistem => l.uiNotificationsPrefSystem,
    };
    Future<void> set(NotificationPrefGroup g, bool on) async {
      final error = await ctl.setMuted(g, muted: !on);
      if (error != null && context.mounted) NzToast.error(context, error);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space6),
      child: NzCard.outlined(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.uiNotificationsPrefTitle, style: context.text.labelLg),
            const Gap(NizamioSpacing.space1),
            Text(
              l.uiNotificationsPrefIntro,
              style: context.text.caption.copyWith(
                color: context.colors.textMuted,
              ),
            ),
            const Gap(NizamioSpacing.space2),
            NzAsyncView<NotificationPreferences>(
              value: value,
              onRetry: () =>
                  ref.invalidate(notificationPreferencesControllerProvider),
              data: (prefs) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final g in NotificationPrefGroup.values)
                    NzSwitch(
                      label: label(g),
                      value: !(prefs[g] ?? false),
                      onChanged: (on) => unawaited(set(g, on)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
