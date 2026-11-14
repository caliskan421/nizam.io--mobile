import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart' show effectiveAccessProvider;
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import 'table_navigation_sheets.dart';
import 'table_sheet_host.dart';
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
        Text(
          l.uiTablesDemoNotice,
          style: context.text.caption.copyWith(color: context.colors.textMuted),
        ),
        const Gap(NizamioSpacing.space4),
        if (state.area == TableArea.coord && state.unit == null)
          LayoutBuilder(
            builder: (context, constraints) {
              final units = <String>{
                ...tableDemoUnits,
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
                          name: l.tableUnit(unit),
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
              icon: const Icon(Icons.chevron_left),
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
                  l.tableUnitCode(state.unit!),
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
                    Text(l.tableUnit(state.unit!), style: context.text.titleSm),
                    const Gap(2),
                    Text(
                      '${state.documents.where((d) => d.area == TableArea.coord && d.unit == state.unit).length} tablo · örnek çalışma alanı',
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
        if (state.area != TableArea.coord || state.unit != null) ...[
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
                      if (!d.editable) ...[
                        Icon(
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
                    '${d.rows.length} ${l.uiTablesRow} · ${d.fields.length} ${l.uiTablesColumn}${d.id.startsWith('demo-plan-') ? ' · Kadir Özbek' : ''}',
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
    final l = context.l10n;
    var name = '';
    final initial = ref.read(tablesControllerProvider);
    // Koordinatörlük tablosu (tablo projesi, `POST /v1/table-projects`) yönetici ve koordinatör
    // yüzüdür; üye görünümünde yalnız kişisel tablo açılır. Erişim bilinmiyorsa kısıt yok.
    final access = ref.read(effectiveAccessProvider);
    final canProject = access.canCreateTask || !access.known;
    var area = initial.unit == null || !canProject
        ? TableArea.personal
        : TableArea.coord;
    var template = initialTemplate;
    var share = false;
    var shareAccess = TableAccess.edit;
    var selectedUnit = initial.unit ?? 'DEMO-A';
    final epoch = ref.read(tablesControllerProvider.notifier);
    final lease = epoch.lease;
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
            const Gap(NizamioSpacing.space4),
            NzSelect<TableTemplate>(
              label: l.uiTablesTemplate,
              value: template,
              items: [
                for (final t in TableTemplate.values)
                  NzSelectItem(value: t, label: l.tableTemplate(t)),
              ],
              onChanged: (v) {
                if (v != null) update(() => template = v);
              },
            ),
            const Gap(NizamioSpacing.space3),
            NzSelect<TableArea>(
              label: l.uiTablesDestination,
              value: area,
              items: [
                for (final a in [
                  TableArea.personal,
                  if (canProject) TableArea.coord,
                ])
                  NzSelectItem(value: a, label: l.tableArea(a)),
              ],
              onChanged: (v) {
                if (v != null) update(() => area = v);
              },
            ),
            if (area == TableArea.coord) ...[
              const Gap(NizamioSpacing.space3),
              NzSelect<String>(
                label: l.uiTablesCoord,
                value: tableDemoUnits.contains(selectedUnit)
                    ? selectedUnit
                    : null,
                items: [
                  for (final unit in tableDemoUnits)
                    NzSelectItem(value: unit, label: l.tableUnit(unit)),
                ],
                onChanged: (v) {
                  if (v != null) update(() => selectedUnit = v);
                },
              ),
            ],
            const Gap(NizamioSpacing.space3),
            NzFormRows(
              rows: [
                NzFormRow.toggle(
                  label: l.uiTablesAddPerson,
                  value: share,
                  onChanged: (v) => update(() => share = v),
                ),
              ],
            ),
            if (share) ...[
              const Gap(NizamioSpacing.space3),
              NzSelect<TableAccess>(
                label: l.uiTablesProgramAccess,
                value: shareAccess,
                items: [
                  for (final access in [TableAccess.view, TableAccess.edit])
                    NzSelectItem(value: access, label: l.tableAccess(access)),
                ],
                onChanged: (v) {
                  if (v != null) update(() => shareAccess = v);
                },
              ),
            ],
            const Gap(NizamioSpacing.space3),
            Text(
              l.templateFields(template).map((f) => f.name).join(' · '),
              style: context.text.caption,
            ),
          ],
        ),
      ),
    );
    changes.dispose();
  }
}
