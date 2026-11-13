import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/extensions/ref_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../application/tables_list_controller.dart';
import '../domain/table_models.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';
import 'tables_header.dart';

/// Tablo listesi: seçili programın koordinatörlük (seçili departman) ve kişisel alan
/// tabloları, sunucudan imleçli.
class TablesPage extends ConsumerWidget {
  const TablesPage({super.key, required this.onOpenTable});
  final ValueChanged<String> onOpenTable;

  static TableSpace _spaceOf(TablesArea a) => a == TablesArea.coordinatorship
      ? TableSpace.coordinatorship
      : TableSpace.personal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    ref.listenErrors(tablesListControllerProvider, context);
    final async = ref.watch(tablesListControllerProvider);
    final filter = ref.watch(tablesFilterControllerProvider);
    final view = async.value;
    final controller = ref.read(tablesListControllerProvider.notifier);
    return NzPage.feed(
      width: NzContentWidth.wide,
      topBar: const RootTopBar(),
      onRefresh: controller.refresh,
      children: [
        TablesHeader(
          count:
              (view?.coordinatorship?.items.length ?? 0) +
              (view?.personal?.items.length ?? 0),
          onCreate: view == null ? null : () => _create(context, ref, view),
        ),
        const Gap(NizamioSpacing.space4),
        NzPillTabs(
          compact: true,
          tabs: [
            for (final area in TablesArea.values)
              NzPillTab(
                label: l.tablesArea(area),
                countText: view == null ? null : '${view.visible(area).length}',
              ),
          ],
          selected: filter.area.index,
          onSelected: (i) => ref
              .read(tablesFilterControllerProvider.notifier)
              .setArea(TablesArea.values[i]),
        ),
        const Gap(NizamioSpacing.space4),
        NzAsyncView<TablesListView>(
          value: async,
          skeletonOnReload: true,
          onRetry: controller.refresh,
          data: (v) => _list(context, ref, v, filter),
        ),
      ],
    );
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    TablesListView view,
    TablesFilter filter,
  ) {
    final l = context.l10n;
    final space = _spaceOf(filter.area);
    final section = view.section(space);
    if (section == null) {
      return Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space6),
        child: Text(l.uiTablesNeedDepartment),
      );
    }
    final items = view.visible(filter.area, filter.query);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(NizamioSpacing.space6),
            child: Text(
              filter.query.trim().isEmpty
                  ? l.uiTablesEmpty
                  : l.uiTablesNoResults,
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 860
                ? 3
                : constraints.maxWidth >= 560
                ? 2
                : 1;
            final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final t in items)
                  SizedBox(
                    width: width,
                    child: _TableCard(
                      table: t,
                      mine: t.ownedBy(view.accountId),
                      onTap: () => onOpenTable(t.id),
                    ),
                  ),
              ],
            );
          },
        ),
        if (section.hasMore) ...[
          const Gap(NizamioSpacing.space4),
          Center(
            child: NzButton.secondary(
              label: l.uiTablesLoadMore,
              onPressed: section.loadingMore
                  ? null
                  : () => ref
                        .read(tablesListControllerProvider.notifier)
                        .loadMore(space),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref,
    TablesListView view,
  ) async {
    final l = context.l10n;
    var name = '';
    final spaces = [
      if (view.coordinatorship != null) TableSpace.coordinatorship,
      if (view.personal != null) TableSpace.personal,
    ];
    if (spaces.isEmpty) return;
    final area = ref.read(tablesFilterControllerProvider).area;
    var space = spaces.contains(_spaceOf(area)) ? _spaceOf(area) : spaces.first;
    var busy = false;
    final changes = ValueNotifier(0);
    void update(VoidCallback change) {
      change();
      changes.value++;
    }

    await showTableSheet(
      ref,
      context,
      title: l.uiTablesNew,
      actions: (sheet) => [
        ValueListenableBuilder<int>(
          valueListenable: changes,
          builder: (context, _, _) => NzButton.primary(
            label: l.uiTablesCreate,
            onPressed: name.trim().isEmpty || busy
                ? null
                : () async {
                    update(() => busy = true);
                    try {
                      final id = await ref
                          .read(tablesListControllerProvider.notifier)
                          .create(space, name);
                      if (sheet.mounted) Navigator.of(sheet).pop();
                      onOpenTable(id);
                    } on ApiError catch (e, st) {
                      reportUnexpected(e, st, source: ReportSource.tables);
                      if (context.mounted) NzToast.error(context, e);
                      update(() => busy = false);
                    }
                  },
          ),
        ),
      ],
      builder: (sheet) => ValueListenableBuilder<int>(
        valueListenable: changes,
        builder: (context, _, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzTextField(
              label: l.uiTablesName,
              onChanged: (v) => update(() => name = v),
            ),
            if (spaces.length > 1) ...[
              const Gap(NizamioSpacing.space3),
              NzSelect<TableSpace>(
                label: l.uiTablesSpace,
                value: space,
                items: [
                  for (final s in spaces)
                    NzSelectItem(value: s, label: l.tableSpace(s)),
                ],
                onChanged: (v) {
                  if (v != null) update(() => space = v);
                },
              ),
            ],
          ],
        ),
      ),
    );
    changes.dispose();
  }
}

class _TableCard extends StatelessWidget {
  const _TableCard({
    required this.table,
    required this.mine,
    required this.onTap,
  });
  final TableMeta table;
  final bool mine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colors.border),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Icon(Icons.table_chart_outlined, color: context.colors.textMuted),
              const Gap(NizamioSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      table.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.titleSm,
                    ),
                    const Gap(4),
                    Text(
                      l.tableSpace(table.space),
                      style: context.text.caption.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (mine) NzBadge.neutral(label: l.uiTablesOwner),
            ],
          ),
        ),
      ),
    );
  }
}
