import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../tasks/tasks.dart';
import '../application/calendar_controller.dart';
import '../domain/calendar.dart';
import 'calendar/calendar_day.dart';
import 'calendar/calendar_grid.dart';

/// Kişiye atanmış görünür görevlerin gerçek tarihleri. Toplantı yetkisi ya da katılımı
/// görev atamasından türetilmez. Takvim seçimi profil boyunca yereldir.
class PersonTaskCalendar extends StatefulWidget {
  const PersonTaskCalendar({
    super.key,
    required this.accountId,
    this.visible = true,
  });
  final String accountId;
  final bool visible;
  @override
  State<PersonTaskCalendar> createState() => _PersonTaskCalendarState();
}

class _PersonTaskCalendarState extends State<PersonTaskCalendar>
    with AutomaticKeepAliveClientMixin {
  late bool _opened = widget.visible;
  @override
  bool get wantKeepAlive => true;
  @override
  void didUpdateWidget(PersonTaskCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountId != widget.accountId) {
      _opened = false;
    }
    _opened = _opened || widget.visible;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_opened) {
      return const SizedBox.shrink();
    }
    return Offstage(
      offstage: !widget.visible,
      child: TickerMode(
        enabled: widget.visible,
        child: PageContentEntrance(
          child: ProviderScope(
            key: ValueKey(widget.accountId),
            overrides: [
              calendarControllerProvider.overrideWith(CalendarController.new),
            ],
            child: _Calendar(accountId: widget.accountId),
          ),
        ),
      ),
    );
  }
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
    final index = CalendarIndex.personTasks(catalog, accountId);
    final view = ref.watch(calendarControllerProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(NizamioRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NizamioSpacing.space3,
          children: [
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
              emptyMessage: context.l10n.uiUsersTaskNoDay,
            ),
          ],
        ),
      ),
    );
  }
}
