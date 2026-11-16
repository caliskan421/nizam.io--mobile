import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/layout/nz_pane.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_loader.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../scope/scope.dart';
import '../application/table_folder_pages.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';
import 'table_create_sheet.dart';
import 'table_library_card.dart';
import 'table_library_controls.dart';
import 'table_library_panel.dart';
import 'table_navigation_sheets.dart';
import 'table_texts.dart';
import 'tables_header.dart';
import 'tables_list_widgets.dart';

class TablesPage extends ConsumerWidget {
  const TablesPage({super.key, required this.onOpenTable});
  final ValueChanged<String> onOpenTable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(tablesControllerProvider);
    final unitOpen = state.area == TableArea.coord && state.unit != null;
    final location = TableLocation(
      ref.read(scopeStateProvider).programId ?? '',
      state.unit ?? '',
    );
    String unitName(String id) =>
        state.departmentNames[TableDepartmentId(id)] ?? l.tableUnit(id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ref.read(tablesControllerProvider.notifier).ensureDemoFixtures();
      }
    });
    return NzPage.feed(
      width: NzContentWidth.wide,
      topBar: unitOpen
          ? NzTopBar.detail(
              title: '',
              onBack: () =>
                  ref.read(tablesControllerProvider.notifier).setUnit(null),
            )
          : const RootTopBar(),
      onRefresh: () async {
        await ref.read(tablesControllerProvider.notifier).refresh();
        if (context.mounted) ref.invalidate(tableFolderPageProvider);
      },
      onRevisit: () {
        ref.read(tablesControllerProvider.notifier).refreshIfStale();
      },
      children: [
        TablesHeader(
          title: unitOpen ? unitName(state.unit!) : null,
          onBack:
              unitOpen &&
                  NzPaneScope.maybeOf(context)?.role == NzPaneRole.master
              ? () => ref.read(tablesControllerProvider.notifier).setUnit(null)
              : null,
          count: unitOpen
              ? state.documents
                    .where(
                      (d) =>
                          d.unit == state.unit &&
                          (d.area == TableArea.coord || state.remote),
                    )
                    .length
              : state.documents.length,
          showRecent: !unitOpen,
          filter: unitOpen && state.remote
              ? TableLibraryControls(
                  location: location,
                  combined: true,
                  onRecent: () => showRecentTables(context, ref, onOpenTable),
                )
              : null,
          onRecent: () => showRecentTables(context, ref, onOpenTable),
          onCreate: () => _create(context, ref),
        ),
        const Gap(NizamioSpacing.space4),
        if (state.unit == null)
          NzPillTabs(
            compact: true,
            tabs: [
              for (final area in TableArea.values)
                NzPillTab(
                  label: l.tableArea(area),
                  countText:
                      '${state.documents.where((d) => d.area == area || (state.remote && area == TableArea.coord && d.unit.isNotEmpty)).length}',
                ),
            ],
            selected: state.area.index,
            onSelected: (i) => ref
                .read(tablesControllerProvider.notifier)
                .setArea(TableArea.values[i]),
          ),
        if (!state.remote)
          Text(
            l.uiTablesDemoNotice,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        if (state.loading) const Center(child: NzLoader()),
        if (state.error case final error?) ...[
          Text(errorText(l, error)),
          NzButton.ghost(
            onPressed: () => ref
                .read(tablesControllerProvider.notifier)
                .reloadServer(refreshChoices: true),
            label: 'Yeniden dene',
          ),
        ],
        if (state.area == TableArea.coord && state.unit == null)
          LayoutBuilder(
            builder: (context, constraints) {
              final units = <String>{
                if (!state.remote) ...tableDemoUnits,
                ...state.departmentNames.keys.map((id) => id.value),
                ...state.documents
                    .where(
                      (d) =>
                          d.area == TableArea.coord ||
                          (state.remote && d.unit.isNotEmpty),
                    )
                    .map((d) => d.unit),
              };
              final columns = constraints.maxWidth >= 860
                  ? 4
                  : constraints.maxWidth >= 560
                  ? 3
                  : 2;
              final width =
                  (constraints.maxWidth - 10 - (columns - 1) * 14) / columns;
              return Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    for (final unit in units)
                      SizedBox(
                        width: width,
                        child: TablesUnitTile(
                          name: unitName(unit),
                          count: state.documents
                              .where(
                                (d) =>
                                    d.unit == unit &&
                                    (d.area == TableArea.coord || state.remote),
                              )
                              .length,
                          caption: 'tablo',
                          when: switch (unit) {
                            'DEMO-A' => 'bugün 09:20',
                            'DEMO-B' => 'dün',
                            'DEMO-C' => 'bugün 12:10',
                            _ => null,
                          },
                          onTap: () => ref
                              .read(tablesControllerProvider.notifier)
                              .setUnit(unit),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ...[
          const Gap(18),
          Text('Hızlı başla', style: context.text.kicker),
          const Gap(8),
          NzPageBleed(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final inset = NzPaneScope.sideInset(
                  context,
                  constraints,
                  NzContentWidth.wide,
                );
                final width = constraints.maxWidth >= 860
                    ? (constraints.maxWidth - 2 * inset - 6 * 8) / 7
                    : 150.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: inset),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final template in TableTemplate.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: width,
                            height: 104,
                            child: TablesTemplateTile(
                              name: l.tableTemplate(template),
                              caption: template == TableTemplate.blank
                                  ? 'Sütunları kendin belirle'
                                  : l
                                        .templateFields(template)
                                        .map((f) => f.name)
                                        .join(' · '),
                              icon: switch (template) {
                                TableTemplate.blank => Icons.add,
                                TableTemplate.taskList => Icons.checklist,
                                TableTemplate.eventPlan =>
                                  Icons.calendar_today_outlined,
                                TableTemplate.actionList => Icons.check,
                                TableTemplate.supplierList =>
                                  Icons.business_outlined,
                                TableTemplate.volunteerList =>
                                  Icons.person_add_alt,
                                TableTemplate.inventory =>
                                  Icons.inventory_2_outlined,
                              },
                              onTap: () => _create(
                                context,
                                ref,
                                initialTemplate: template,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Gap(16),
        ],
        if (!state.loading &&
            (state.error == null || state.documents.isNotEmpty) &&
            (state.area != TableArea.coord || state.unit != null)) ...[
          if (state.remote)
            TableLibraryPanel(
              key: ValueKey((
                state.area,
                state.unit,
                ref.watch(scopeStateProvider).programId,
                ref.watch(sessionGenerationProvider),
              )),
              location: location,
              showHeader: !unitOpen,
              card: (d) => _card(context, ref, d),
            )
          else ...[
            Text(
              state.unit == null ? l.uiTablesRecent : 'Tablolar',
              style: context.text.kicker,
            ),
            const Gap(NizamioSpacing.space3),
            if (state.visible.isEmpty)
              Padding(
                padding: const EdgeInsets.all(NizamioSpacing.space6),
                child: Text(
                  state.query.isEmpty ? l.uiTablesEmpty : l.uiTablesNoResults,
                ),
              ),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 860
                    ? 3
                    : constraints.maxWidth >= 560
                    ? 2
                    : 1;
                final width =
                    (constraints.maxWidth - (columns - 1) * 12) / columns;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final d in state.visible)
                      SizedBox(width: width, child: _card(context, ref, d)),
                  ],
                );
              },
            ),
          ],
        ],
      ],
    );
  }

  Widget _card(BuildContext context, WidgetRef ref, TableDocument d) =>
      TableLibraryCard(
        document: d,
        onOpen: () {
          ref.read(tablesControllerProvider.notifier).markOpened(d.id);
          onOpenTable(d.id);
        },
      );

  Future<void> _create(
    BuildContext context,
    WidgetRef ref, {
    TableTemplate initialTemplate = TableTemplate.blank,
  }) async {
    final state = ref.read(tablesControllerProvider);
    await showCreateTableSheet(
      context,
      ref,
      initialTemplate: initialTemplate,
      initialDepartment: state.area == TableArea.coord ? state.unit : null,
      onCreated: onOpenTable,
    );
  }
}
