import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/nz_page_header.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import 'table_navigation_sheets.dart';
import 'table_sheet_host.dart';
import 'table_sheets.dart';
import 'table_texts.dart';

class TablesPage extends ConsumerWidget {
  const TablesPage({super.key, required this.onOpenTable});
  final ValueChanged<String> onOpenTable;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(tablesControllerProvider);
    return NzPage.feed(
      topBar: const RootTopBar(),
      children: [
        NzPageHeader(
          title: l.uiTablesTitle,
          actions: [
            NzIconButton.circle(
              icon: Icons.history,
              semanticLabel: l.uiTablesRecentAction,
              onPressed: () => showRecentTables(context, ref, onOpenTable),
            ),
            NzIconButton.circleAccent(
              icon: Icons.add,
              semanticLabel: l.uiTablesNew,
              onPressed: () => _create(context, ref),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        NzTextField(
          label: l.uiTablesSearch,
          initialValue: state.query,
          onChanged: ref.read(tablesControllerProvider.notifier).setQuery,
        ),
        const Gap(NizamioSpacing.space4),
        NzPillTabs(
          tabs: [
            for (final area in TableArea.values)
              NzPillTab(
                label: l.tableArea(area),
                count: state.documents.where((d) => d.area == area).length,
              ),
          ],
          selected: state.area.index,
          onSelected: (i) => ref
              .read(tablesControllerProvider.notifier)
              .setArea(TableArea.values[i]),
        ),
        const Gap(NizamioSpacing.space4),
        Text(
          l.uiTablesDemoNotice,
          style: context.text.caption.copyWith(color: context.colors.textMuted),
        ),
        const Gap(NizamioSpacing.space4),
        if (state.visible.isEmpty)
          Padding(
            padding: const EdgeInsets.all(NizamioSpacing.space6),
            child: Text(
              state.query.isEmpty ? l.uiTablesEmpty : l.uiTablesNoResults,
            ),
          ),
        if (state.area == TableArea.coord) ...[
          if (state.unit != null)
            NzButton.ghost(
              label: l.uiTablesBackAreas,
              onPressed: () =>
                  ref.read(tablesControllerProvider.notifier).setUnit(null),
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              final units = state.documents
                  .where((d) => d.area == TableArea.coord)
                  .map((d) => d.unit)
                  .toSet();
              return Wrap(
                spacing: NizamioSpacing.space3,
                runSpacing: NizamioSpacing.space3,
                children: [
                  for (final unit in units)
                    if (state.unit == null || state.unit == unit)
                      SizedBox(
                        width:
                            (constraints.maxWidth - NizamioSpacing.space3) / 2,
                        child: NzFolder(
                          name: unit == 'DEMO-A'
                              ? l.uiTablesUnitA
                              : l.uiTablesUnitB,
                          caption:
                              '${state.documents.where((d) => d.area == TableArea.coord && d.unit == unit).length} ${l.uiTablesTitle.toLowerCase()}',
                          onTap: () => ref
                              .read(tablesControllerProvider.notifier)
                              .setUnit(unit),
                        ),
                      ),
                ],
              );
            },
          ),
          if (state.unit != null)
            Wrap(
              spacing: NizamioSpacing.space2,
              children: [
                for (final template in [
                  TableTemplate.taskList,
                  TableTemplate.inventory,
                ])
                  NzButton.secondary(
                    label: l.tableTemplate(template),
                    onPressed: () =>
                        _create(context, ref, initialTemplate: template),
                  ),
              ],
            ),
          const Gap(NizamioSpacing.space4),
        ],
        Text(l.uiTablesRecent, style: context.text.kicker),
        const Gap(NizamioSpacing.space3),
        for (final d in state.visible)
          Padding(
            padding: const EdgeInsets.only(bottom: NizamioSpacing.space3),
            child: _card(context, ref, d),
          ),
      ],
    );
  }

  Widget _card(BuildContext context, WidgetRef ref, TableDocument d) {
    final l = context.l10n;
    Widget cell(String text, {bool heading = false}) => Expanded(
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space2),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: heading
              ? context.text.monoSm.copyWith(color: context.colors.textMuted)
              : context.text.caption,
        ),
      ),
    );
    return NzCard.outlined(
      onTap: () {
        ref.read(tablesControllerProvider.notifier).markOpened(d.id);
        onOpenTable(d.id);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(NizamioRadius.tile),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.surfaceRaised,
                border: Border.all(color: context.colors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (final f in d.fields.take(3))
                        cell(f.name, heading: true),
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
                          for (final f in d.fields.take(3))
                            cell(
                              tableCellText(
                                context,
                                f,
                                row.cells[TableFieldId(f.id)],
                                ref.read(tablesControllerProvider).documents,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Gap(NizamioSpacing.space3),
          Row(
            children: [
              Expanded(child: Text(d.title, style: context.text.titleSm)),
              if (!d.editable)
                Icon(Icons.lock_outline, color: context.colors.textMuted),
            ],
          ),
          const Gap(NizamioSpacing.space2),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${d.rows.length} ${l.uiTablesRow} · ${d.fields.length} ${l.uiTablesColumn}',
                  style: context.text.caption,
                ),
              ),
              NzAvatarStack(
                colored: true,
                names: [
                  l.uiTablesOwner,
                  ...d.people.keys.map(
                    (p) => '${l.uiTablesDemoPerson} ${p.value.split('-').last}',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref, {
    TableTemplate initialTemplate = TableTemplate.blank,
  }) async {
    final l = context.l10n;
    var name = '';
    final initial = ref.read(tablesControllerProvider);
    var area = initial.unit == null ? TableArea.personal : TableArea.coord;
    var template = initialTemplate;
    var share = false;
    var shareAccess = TableAccess.edit;
    var selectedUnit = initial.unit ?? 'DEMO-A';
    final epoch = ref.read(tablesControllerProvider.notifier);
    final lease = epoch.lease;
    await showTableSheet(
      ref,
      context,
      title: l.uiTablesNew,
      builder: (sheet) => StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NzTextField(
              label: l.uiTablesName,
              onChanged: (v) => setState(() => name = v),
            ),
            const Gap(NizamioSpacing.space4),
            Text(l.uiTablesTemplate, style: context.text.kicker),
            Wrap(
              spacing: NizamioSpacing.space2,
              children: [
                for (final t in TableTemplate.values)
                  ChoiceChip(
                    label: Text(l.tableTemplate(t)),
                    selected: template == t,
                    onSelected: (_) => setState(() => template = t),
                  ),
              ],
            ),
            const Gap(NizamioSpacing.space4),
            Wrap(
              spacing: NizamioSpacing.space2,
              children: [
                for (final a in [TableArea.personal, TableArea.coord])
                  ChoiceChip(
                    label: Text(l.tableArea(a)),
                    selected: area == a,
                    onSelected: (_) => setState(() => area = a),
                  ),
              ],
            ),
            if (area == TableArea.coord)
              Wrap(
                spacing: NizamioSpacing.space2,
                children: [
                  for (final unit in ['DEMO-A', 'DEMO-B'])
                    ChoiceChip(
                      label: Text(l.tableUnit(unit)),
                      selected: selectedUnit == unit,
                      onSelected: (_) => setState(() => selectedUnit = unit),
                    ),
                ],
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.uiTablesAddPerson),
              value: share,
              onChanged: (v) => setState(() => share = v),
            ),
            if (share)
              Wrap(
                spacing: NizamioSpacing.space2,
                children: [
                  for (final access in [TableAccess.view, TableAccess.edit])
                    ChoiceChip(
                      label: Text(l.tableAccess(access)),
                      selected: shareAccess == access,
                      onSelected: (_) => setState(() => shareAccess = access),
                    ),
                ],
              ),
            Text(
              l.templateFields(template).map((f) => f.name).join(' · '),
              style: context.text.caption,
            ),
            const Gap(NizamioSpacing.space4),
            NzButton.primary(
              label: l.uiTablesCreate,
              onPressed: name.trim().isEmpty
                  ? null
                  : () {
                      final id = epoch.create(
                        expectedLease: lease,
                        unit: selectedUnit,
                        title: name,
                        area: area,
                        fields: l.templateFields(template),
                        people: share
                            ? {const TablePersonId('demo-1'): shareAccess}
                            : {},
                      );
                      Navigator.of(sheet).pop();
                      if (id != null) onOpenTable(id);
                    },
            ),
          ],
        ),
      ),
    );
  }
}
