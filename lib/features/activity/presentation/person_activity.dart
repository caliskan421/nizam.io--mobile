import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../tasks/tasks.dart';
import '../application/person_activity.dart';
import '../domain/activity_log.dart';
import '../domain/activity_query.dart';
import 'activity_entry_row.dart';

/// Kullanıcı ayrıntısındaki kişiye özel işlem geçmişi (`actor_account_id` süzgeci; son
/// [limit] kayıt). Yalnız şirket yöneticisi okur; diğerlerinde kısa açıklama.
class PersonActivity extends ConsumerWidget {
  const PersonActivity({super.key, required this.accountId, this.limit = 30});

  final String accountId;
  final int limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(personActivityProvider(accountId));
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    Widget note(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space4),
      child: Text(
        text,
        style: context.text.caption.copyWith(color: context.colors.textMuted),
      ),
    );
    if (value.error is ActivityUnavailable) {
      return note(l.uiActivityUnsupported);
    }
    return NzAsyncView(
      value: value,
      onRetry: () => ref.invalidate(personActivityProvider(accountId)),
      isEmpty: (log) => log.entries.isEmpty,
      empty: note(l.uiActivityPersonEmpty),
      data: (log) {
        final entries = catalog == null
            ? log.entries
            : resolveActivityTargets(log.entries, catalog);
        final shown = entries.take(limit).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (i, e) in shown.indexed)
              ActivityEntryRow(
                entry: e,
                divided: i < shown.length - 1,
                onTap: switch (taskCodeOf(e)) {
                  final code? => () => context.appNav.openTask(code),
                  null => null,
                },
              ),
          ],
        );
      },
    );
  }
}
