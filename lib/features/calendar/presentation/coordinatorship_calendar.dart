import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cache_owner.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../meetings/meetings.dart';
import '../../tasks/tasks.dart';
import '../application/calendar_controller.dart';
import '../domain/calendar.dart';
import 'calendar/calendar_day.dart';
import 'calendar/calendar_grid.dart';

/// Koordinatörlüğün görünür görev ve toplantıları. Seçili ay/gün diğer takvimlerden
/// bağımsızdır; hesap/program değişiminde kaynakların sahiplik kapısı korunur.
class CoordinatorshipCalendar extends StatelessWidget {
  const CoordinatorshipCalendar({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => ProviderScope(
    key: ValueKey(code),
    overrides: [
      calendarControllerProvider.overrideWith(CalendarController.new),
    ],
    child: _Calendar(code: code),
  );
}

class _Calendar extends ConsumerWidget {
  const _Calendar({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(taskCatalogControllerProvider);
    final meetings = CacheOwnership.ownedOnly(
      ref.watch(meetingsBoardControllerProvider),
      owned: ref.read(meetingsBoardControllerProvider.notifier).ownsValue,
    );
    final index = catalog.whenData(
      (tasks) => meetings.whenData(
        (board) => CalendarIndex.build(
          board.visible,
          tasks,
          meetingsTruncated: board.truncated,
          coordinatorship: code,
        ),
      ),
    );
    final value =
        index.value ??
        switch (index) {
          AsyncError(:final error, :final stackTrace) =>
            AsyncError<CalendarIndex>(error, stackTrace),
          _ => const AsyncLoading<CalendarIndex>(),
        };
    return NzCard.outlined(
      child: NzAsyncView<CalendarIndex>(
        value: value,
        onRetry: () {
          ref.invalidate(meetingsBoardControllerProvider);
          ref.invalidate(taskCatalogControllerProvider);
        },
        data: (index) {
          final view = ref.watch(calendarControllerProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: NizamioSpacing.space3,
            children: [
              NzKicker(context.l10n.uiCalendarTitle),
              if (index.truncated) Text(context.l10n.uiListsTruncated),
              CalendarGrid(
                index: index,
                compact: true,
                headerAction: NzButton.ghost(
                  label: context.l10n.uiCalendarToday,
                  onPressed: view.isTodayOn(index.today)
                      ? null
                      : () => ref
                            .read(calendarControllerProvider.notifier)
                            .goToday(),
                ),
              ),
              CalendarDay(
                index: index,
                emptyMessage: context.l10n.uiCalendarEmpty,
              ),
            ],
          );
        },
      ),
    );
  }
}
