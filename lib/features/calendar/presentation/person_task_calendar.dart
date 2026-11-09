import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../tasks/tasks.dart';
import '../application/calendar_controller.dart';
import '../domain/calendar.dart';
import 'calendar/calendar_day.dart';
import 'calendar/calendar_grid.dart';

/// Kişiye atanmış görünür görevlerin gerçek tarihleri. Toplantı yetkisi ya da katılımı
/// görev atamasından türetilmez. Takvim seçimi profil boyunca yereldir.
class PersonTaskCalendar extends StatelessWidget {
  const PersonTaskCalendar({super.key, required this.accountId});
  final String accountId;

  @override
  Widget build(BuildContext context) => ProviderScope(
    key: ValueKey(accountId),
    overrides: [
      calendarControllerProvider.overrideWith(CalendarController.new),
    ],
    child: _Calendar(accountId: accountId),
  );
}

class _Calendar extends ConsumerWidget {
  const _Calendar({required this.accountId});
  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(taskCatalogControllerProvider);
    final catalog = value.value;
    if (catalog == null) {
      if (value.hasError) {
        return Column(
          children: [
            Text(errorText(context.l10n, toApiError(value.error!))),
            NzButton.secondary(
              label: context.l10n.uiCommonRetry,
              onPressed: () => ref.invalidate(taskCatalogControllerProvider),
            ),
          ],
        );
      }
      return const Center(child: CircularProgressIndicator());
    }
    final index = CalendarIndex.build(const [], catalog, accountId: accountId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space4,
      children: [
        if (index.truncated) Text(context.l10n.uiListsTruncated),
        CalendarGrid(index: index),
        CalendarDay(index: index),
      ],
    );
  }
}
