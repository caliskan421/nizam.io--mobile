import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/page/nz_shell_events.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/activity_log_controller.dart';
import '../application/activity_query_controller.dart';
import '../domain/activity_log.dart';
import '../domain/activity_query.dart';
import 'activity_texts.dart';

/// İşlem geçmişi (prototip `history`, Ana sayfa sekmesi içinde): başlık + CSV, açıklama, arama +
/// filtre dairesi, renk noktalı tür rayı, etkin süzgeç çipleri, gün gruplu kayıt listesi, "daha
/// fazla göster", filtre alt sayfası (yapan kişi, koordinatörlük). Alt menüde Ana sayfa
/// sekmesine yeniden dokunmak (bu sayfa görünürken) kısayol menüsünü açar.
class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key});

  /// Kabukta bu sayfanın sekme sırası (kısayol olayı süzgeci).
  static const shellTab = 0;

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _retry() => ref
    ..invalidate(activityLogControllerProvider)
    ..invalidate(taskCatalogControllerProvider);

  @override
  Widget build(BuildContext context) {
    ref.listen(shellReselectEventsProvider, (_, next) {
      final visible = ModalRoute.of(context)?.isCurrent ?? true;
      final view = ref.read(activityViewProvider).value;
      if (next?.tab != ActivityPage.shellTab || !visible || view == null) {
        return;
      }
      _showShortcuts(view);
    });
    final l = context.l10n;
    final view = ref.watch(activityViewProvider);
    return NzPage.feed(
      onRetry: _retry,
      topBar: NzTopBar.detail(
        title: l.uiActivityTitle,
        actions: [
          NzIconButton(
            icon: Icons.download_rounded,
            semanticLabel: l.uiActivityCsv,
            onPressed: () =>
                NzToast.show(context, l.activitySoon(l.uiActivityCsvExport)),
          ),
        ],
      ),
      // Kayıt satırları akışın doğrudan öğeleridir: liste tembel kurulur (yalnız görünen
      // satırlar), tek büyük Column değil.
      children: [
        Text(
          l.uiActivityIntro,
          style: context.text.bodyMd.copyWith(color: context.colors.textMuted),
        ),
        const Gap(NizamioSpacing.space3),
        ...switch (view) {
          AsyncValue(value: final v?) => _records(context, v),
          AsyncError(:final error) => [
            NzErrorState(error: toApiError(error), onRetry: _retry),
          ],
          _ => [const NzLoader.page()],
        },
      ],
    );
  }

  List<Widget> _records(BuildContext context, ActivityView v) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final commands = ref.read(activityQueryControllerProvider.notifier);
    final today = ref.read(activityLogControllerProvider).value?.today;
    return [
      _Controls(
        view: v,
        search: _search,
        onOpenFilters: () => showActivityFilters(context),
      ),
      const Gap(NizamioSpacing.space4),
      for (final (i, day) in v.days.indexed) ...[
        if (i > 0) const Gap(NizamioSpacing.space5),
        _DayHeader(
          key: ValueKey(day.day),
          label: l.activityDay(day.day, today ?? day.day),
          count: day.count,
        ),
        for (final (j, e) in day.entries.indexed)
          _EntryRow(
            key: ObjectKey(e),
            entry: e,
            divided: j < day.entries.length - 1,
            onTap: switch (taskCodeOf(e)) {
              final code? => () => context.appNav.openTask(code),
              null => null,
            },
          ),
      ],
      if (v.total == 0)
        NzEmptyState(
          title: l.uiActivityEmpty,
          actionLabel: l.uiActivityClearFilters,
          onAction: commands.clearAll,
        ),
      const Gap(NizamioSpacing.space4),
      if (v.canShowMore) ...[
        NzButton.secondary(
          label: l.uiActivityMore,
          expand: true,
          onPressed: commands.showMore,
        ),
        const Gap(NizamioSpacing.gapMd),
      ],
      Text(
        l.activityShown(v.shown, v.total),
        textAlign: TextAlign.center,
        style: t.caption.copyWith(color: c.textMuted),
      ),
      const Gap(NizamioSpacing.gapMd),
      Text(
        l.uiActivityFooter,
        textAlign: TextAlign.center,
        style: t.caption.copyWith(color: c.textMuted),
      ),
    ];
  }

  void _showShortcuts(ActivityView view) {
    final l = context.l10n;
    final c = context.colors;
    final query = ref.read(activityQueryControllerProvider);
    final commands = ref.read(activityQueryControllerProvider.notifier);
    NzFlyoutMenu.show(
      context,
      semanticLabel: l.uiActivityShortcuts,
      entries: [
        NzFlyoutSection(l.uiActivitySectionType),
        NzFlyoutItem(
          label: l.uiActivityTypeAll,
          icon: Icons.list_rounded,
          count: '${view.allCount}',
          selected: query.kind == null,
          onSelected: () => commands.selectKind(null),
        ),
        for (final k in ActivityKind.values)
          NzFlyoutItem(
            label: l.activityKindLabel(k),
            dot: activityTone(k).color(c),
            count: '${view.kindCounts[k] ?? 0}',
            selected: query.kind == k,
            onSelected: () => commands.selectKind(k),
          ),
        NzFlyoutSection(l.uiActivitySectionHistory),
        NzFlyoutItem(
          label: l.uiActivityFlyFilter,
          icon: Icons.tune_rounded,
          onSelected: () {
            if (mounted) showActivityFilters(context);
          },
        ),
        NzFlyoutItem(
          label: l.uiActivityFlyHome,
          icon: Icons.arrow_back_rounded,
          onSelected: () {
            if (mounted) Navigator.of(context).maybePop();
          },
        ),
      ],
    );
  }
}

/// Arama + filtre dairesi, tür rayı ve etkin süzgeç çipleri (kayıt bölgesinin başı; okuyucuda
/// "Kayıtlar" bölgesi satırlarla birlikte gelir).
class _Controls extends ConsumerWidget {
  const _Controls({
    required this.view,
    required this.search,
    required this.onOpenFilters,
  });

  final ActivityView view;
  final TextEditingController search;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final query = ref.watch(activityQueryControllerProvider);
    final commands = ref.read(activityQueryControllerProvider.notifier);
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final kinds = [null, ...ActivityKind.values];
    final chips = <(String, String, VoidCallback)>[
      if (query.kind case final k?)
        (
          l.activityTypeChip(k),
          l.uiActivityRemoveType,
          () {
            commands.selectKind(null);
          },
        ),
      for (final id in query.people)
        if (catalog?.person(id)?.name case final name?)
          (name, l.activityRemove(name), () => commands.removePerson(id)),
      if (query.coordinatorship case final code?)
        (
          catalog?.coordinatorship(code)?.name ?? code,
          l.uiActivityRemoveCoord,
          commands.clearCoordinatorship,
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: NzSearchField(
                controller: search,
                label: l.uiActivitySearchHint,
                hint: l.uiActivitySearchHint,
                onChanged: commands.search,
                onClear: () => commands.search(''),
              ),
            ),
            const Gap(NizamioSpacing.space2),
            NzIconButton.circle(
              icon: Icons.tune_rounded,
              semanticLabel: l.uiActivityFiltersLabel,
              dot: query.hasExtra ? c.accentText : null,
              onPressed: onOpenFilters,
            ),
          ],
        ),
        const Gap(NizamioSpacing.space3),
        NzFilterRail(
          semanticLabel: l.uiActivityTypeLabel,
          selected: kinds.indexOf(query.kind),
          onSelected: (i) => commands.selectKind(kinds[i]),
          options: [
            for (final k in kinds)
              NzFilterOption(
                label: l.activityKindLabel(k),
                count: k == null ? view.allCount : view.kindCounts[k],
                dot: k == null ? null : activityTone(k).color(c),
              ),
          ],
        ),
        if (chips.isNotEmpty) ...[
          const Gap(NizamioSpacing.space3),
          Wrap(
            spacing: NizamioSpacing.space2,
            runSpacing: NizamioSpacing.space2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final (label, aria, onClear) in chips)
                _Chip(label: label, semanticLabel: aria, onClear: onClear),
              _Link(label: l.uiActivityClearAll, onTap: commands.clearAll),
            ],
          ),
        ],
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({super.key, required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      header: true,
      label: '$label, $count',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space1),
        child: Row(
          children: [
            Flexible(
              child: Text(label, style: t.kicker.copyWith(color: c.text)),
            ),
            const Gap(NizamioSpacing.gapMd),
            Expanded(
              child: Divider(
                height: NizamioSize.borderWidth,
                thickness: NizamioSize.borderWidth,
                color: c.borderStrong,
              ),
            ),
            const Gap(NizamioSpacing.gapMd),
            Text('$count', style: t.kicker.copyWith(color: c.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    super.key,
    required this.entry,
    required this.divided,
    required this.onTap,
  });

  final ActivityEntry entry;
  final bool divided;

  /// Hedef görevse görevi açar; değilse satır dokunulmaz.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final e = entry;
    final who = '${e.actorName} · ${e.target}';
    final kind = l.activityKindLabel(e.kind);
    final row = DecoratedBox(
      decoration: BoxDecoration(
        border: divided
            ? Border(
                bottom: BorderSide(
                  color: c.border,
                  width: NizamioSize.borderWidth,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NzAvatar.initials(
              name: e.actorName,
              tone: NzAvatar.neutralTone,
              extent: NzAvatarSize.md,
            ),
            const Gap(NizamioSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: NizamioSpacing.space1 / 2,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          e.action,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyMd.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Gap(NizamioSpacing.space3),
                      Text(
                        l.activityTime(e.at),
                        style: t.monoSm.copyWith(color: c.textMuted),
                      ),
                    ],
                  ),
                  if (e.detail.isNotEmpty)
                    Text(
                      e.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  const Gap(NizamioSpacing.space1 / 2),
                  Row(
                    children: [
                      NzStatusLabel.badge(
                        label: kind,
                        tone: activityTone(e.kind),
                      ),
                      const Gap(NizamioSpacing.space2),
                      Expanded(
                        child: Text(
                          who,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.caption.copyWith(color: c.textMuted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    final label = [
      e.action,
      l.activityTime(e.at),
      if (e.detail.isNotEmpty) e.detail,
      kind,
      who,
    ].join('. ');
    final tap = onTap;
    if (tap == null) {
      return Semantics(label: label, excludeSemantics: true, child: row);
    }
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: tap,
      child: InkWell(onTap: tap, child: row),
    );
  }
}

/// Etkin süzgeç çipi (prototip `.t-chip`): etiket + kaldır; tamamı dokunulabilir (≥ 44).
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.semanticLabel,
    required this.onClear,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      onTap: onClear,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClear,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.tap),
          child: Align(
            widthFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceOverlay,
                borderRadius: BorderRadius.circular(NizamioRadius.bubbleTail),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  NizamioSpacing.gapMd,
                  NizamioSpacing.space1,
                  NizamioSpacing.space1,
                  NizamioSpacing.space1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.labelMd.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Gap(NizamioSpacing.space1),
                    Icon(
                      Icons.close_rounded,
                      size: NizamioSize.iconSizeSm,
                      color: c.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    onTap: onTap,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(NizamioRadius.tile),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: NizamioSize.tap),
        child: Align(
          widthFactor: 1,
          child: Text(
            label,
            style: context.text.labelMd.copyWith(
              color: context.colors.accentText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );
}

/// Filtre alt sayfası: yapan kişi (rol, kayıt sayısı) ve koordinatörlük seçimi; "Temizle" ve
/// "N kaydı göster".
Future<void> showActivityFilters(BuildContext context) {
  final l = context.l10n;
  return NzBottomSheet.show<void>(
    context,
    title: l.uiActivityFilters,
    // Prototip: "Temizle" başlık satırında.
    headerAction: Consumer(
      builder: (context, ref, _) => _Link(
        label: l.uiActivityClear,
        onTap: ref.read(activityQueryControllerProvider.notifier).clearExtra,
      ),
    ),
    actions: (sheet) => [
      Consumer(
        builder: (context, ref, _) {
          final view = ref.watch(activityViewProvider).value;
          return NzButton.primary(
            label: l.activityApply(view?.total ?? 0),
            expand: true,
            onPressed: () => Navigator.of(sheet).pop(),
          );
        },
      ),
    ],
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        final c = context.colors;
        final t = context.text;
        final query = ref.watch(activityQueryControllerProvider);
        final commands = ref.read(activityQueryControllerProvider.notifier);
        final log = ref.watch(activityLogControllerProvider).value;
        final catalog = ref.watch(taskCatalogControllerProvider).value;
        if (log == null || catalog == null) return const NzLoader();
        Widget kicker(String s) => Padding(
          padding: const EdgeInsets.only(bottom: NizamioSpacing.space1),
          child: NzKicker(s),
        );
        // Onay kutusu satırları mürekkebini kendi Material'ına çizer (sayfa zemini üstünde).
        return Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              kicker(l.uiActivityByRole),
              for (final id in log.people)
                if (catalog.person(id) case final p?)
                  NzCheckbox(
                    label: p.name,
                    labelLeading: NzAvatar.initials(
                      name: p.name,
                      tone: NzAvatar.neutralTone,
                      extent: NzAvatarSize.sm,
                    ),
                    value: query.people.contains(id),
                    onChanged: (_) => commands.togglePerson(id),
                    trailing: Text(
                      '${l.activityRole(p.role)} · '
                      '${log.entries.where((e) => e.actorId == id).length}',
                      style: t.caption.copyWith(color: c.textMuted),
                    ),
                  ),
              const Gap(NizamioSpacing.space4),
              kicker(l.uiActivityCoordinatorship),
              for (final code in log.coordinatorships)
                if (catalog.coordinatorship(code) case final k?)
                  NzCheckbox(
                    label: k.name,
                    value: query.coordinatorship == code,
                    onChanged: (_) => commands.toggleCoordinatorship(code),
                    trailing: Text(
                      code,
                      style: t.monoSm.copyWith(color: c.textMuted),
                    ),
                  ),
            ],
          ),
        );
      },
    ),
  );
}
