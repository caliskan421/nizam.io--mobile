import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import 'table_create_sheet.dart';
import 'table_navigation_sheets.dart';
import 'table_sheets.dart';
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
    String unitName(String id) =>
        state.departmentNames[TableDepartmentId(id)] ?? l.tableUnit(id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ref.read(tablesControllerProvider.notifier).ensureDemoFixtures();
      }
    });
    return NzPage.feed(
      width: NzContentWidth.wide,
      topBar: const RootTopBar(),
      children: [
        TablesHeader(
          count: state.documents
              .where((d) => d.area != TableArea.shared)
              .length,
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
                      '${state.documents.where((d) => d.area == area).length}',
                ),
            ],
            selected: state.area.index,
            onSelected: (i) => ref
                .read(tablesControllerProvider.notifier)
                .setArea(TableArea.values[i]),
          ),
        const Gap(NizamioSpacing.space4),
        if (!state.remote)
          Text(
            l.uiTablesDemoNotice,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        const Gap(NizamioSpacing.space4),
        if (state.loading) const Center(child: CircularProgressIndicator()),
        if (state.error case final error?) ...[
          Text(errorText(l, error)),
          TextButton(
            onPressed: () => ref
                .read(tablesControllerProvider.notifier)
                .reloadServer(refreshChoices: true),
            child: const Text('Yeniden dene'),
          ),
        ],
        if (state.remote && !state.loading && state.error == null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => ref
                  .read(tablesControllerProvider.notifier)
                  .reloadServer(refreshChoices: true),
              child: const Text('Yenile'),
            ),
          ),
        if (state.area == TableArea.coord && state.unit == null)
          LayoutBuilder(
            builder: (context, constraints) {
              final units = <String>{
                if (!state.remote) ...tableDemoUnits,
                ...state.departmentNames.keys.map((id) => id.value),
                ...state.documents
                    .where((d) => d.area == TableArea.coord)
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
                                    d.area == TableArea.coord && d.unit == unit,
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
        if (state.area == TableArea.coord && state.unit != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () =>
                  ref.read(tablesControllerProvider.notifier).setUnit(null),
              icon: const NzIcon(Icons.chevron_left),
              label: const Text('Tüm tablolar'),
              style: TextButton.styleFrom(
                backgroundColor: context.colors.surfaceRaised,
              ),
            ),
          ),
          const Gap(12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.accentText.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  state.remote ? '▦' : l.tableUnitCode(state.unit!),
                  style: context.text.monoSm.copyWith(
                    color: context.colors.accentText,
                  ),
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unitName(state.unit!), style: context.text.titleSm),
                    const Gap(2),
                    Text(
                      '${state.documents.where((d) => d.area == TableArea.coord && d.unit == state.unit).length} tablo',
                      style: context.text.caption.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(18),
          Text('hızlı başla', style: context.text.kicker),
          const Gap(8),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 860
                  ? 7
                  : constraints.maxWidth >= 560
                  ? 4
                  : 2;
              final width =
                  (constraints.maxWidth - (columns - 1) * 8) / columns;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final template in TableTemplate.values)
                    SizedBox(
                      width: width,
                      height: 118,
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
                          TableTemplate.supplierList => Icons.business_outlined,
                          TableTemplate.volunteerList => Icons.person_add_alt,
                          TableTemplate.inventory => Icons.inventory_2_outlined,
                        },
                        onTap: () =>
                            _create(context, ref, initialTemplate: template),
                      ),
                    ),
                ],
              );
            },
          ),
          const Gap(18),
        ],
        if (!state.loading &&
            state.error == null &&
            (state.area != TableArea.coord || state.unit != null)) ...[
          Text(
            state.unit == null ? l.uiTablesRecent : 'tablolar',
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
    );
  }

  Widget _card(BuildContext context, WidgetRef ref, TableDocument d) {
    final l = context.l10n;
    Widget cell(String text, {bool heading = false, bool first = false}) =>
        Expanded(
          flex: first ? 3 : 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: heading
                  ? context.text.monoSm.copyWith(
                      color: context.colors.textMuted,
                      fontSize: 10,
                    )
                  : context.text.caption.copyWith(
                      color: context.colors.textMuted,
                      fontSize: 11,
                    ),
            ),
          ),
        );
    final fields = d.fields.take(3).toList();
    return Material(
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: context.colors.border),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          ref.read(tablesControllerProvider.notifier).markOpened(d.id);
          onOpenTable(d.id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!d.remote)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.surfaceRaised,
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.colors.text,
                          context.colors.text,
                          context.colors.text.withValues(alpha: 0),
                        ],
                        stops: const [0, .62, 1],
                      ).createShader(bounds),
                      blendMode: BlendMode.dstIn,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              for (var i = 0; i < fields.length; i++)
                                cell(
                                  fields[i].name,
                                  heading: true,
                                  first: i == 0,
                                ),
                            ],
                          ),
                          for (final row in d.rows.take(3))
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: context.colors.border),
                                ),
                              ),
                              child: Row(
                                children: [
                                  for (var i = 0; i < fields.length; i++)
                                    cell(
                                      tableCellText(
                                        context,
                                        fields[i],
                                        row.cells[TableFieldId(fields[i].id)],
                                        ref
                                            .read(tablesControllerProvider)
                                            .documents,
                                      ),
                                      first: i == 0,
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!d.remote && !d.editable) ...[
                        NzIcon(
                          Icons.lock_outline,
                          size: 14,
                          color: context.colors.textMuted,
                        ),
                        const Gap(6),
                      ],
                      Expanded(
                        child: Text(d.title, style: context.text.titleSm),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    d.remote
                        ? (d.unit.isEmpty
                              ? 'Kişisel tablo'
                              : (ref
                                        .read(tablesControllerProvider)
                                        .departmentNames[TableDepartmentId(
                                      d.unit,
                                    )] ??
                                    'Koordinatörlük tablosu'))
                        : '${d.rows.length} ${l.uiTablesRow} · ${d.fields.length} ${l.uiTablesColumn}${d.id.startsWith('demo-plan-') ? ' · Kadir Özbek' : ''}',
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: NzAvatarStack(
                          colored: true,
                          names: [
                            if (d.id.startsWith('demo-plan-'))
                              l.tableDemoPerson('demo-1')
                            else
                              l.uiTablesOwner,
                            ...d.people.keys
                                .where(
                                  (p) =>
                                      !d.id.startsWith('demo-plan-') ||
                                      p.value != 'demo-1',
                                )
                                .map((p) => l.tableDemoPerson(p.value)),
                          ],
                        ),
                      ),
                      if (d.id.startsWith('demo-plan-'))
                        Text(
                          'bugün 09:20',
                          style: context.text.monoSm.copyWith(
                            color: context.colors.textFaint,
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
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref, {
    TableTemplate initialTemplate = TableTemplate.blank,
  }) async {
    await showCreateTableSheet(
      context,
      ref,
      initialTemplate: initialTemplate,
      onCreated: onOpenTable,
    );
  }
}
