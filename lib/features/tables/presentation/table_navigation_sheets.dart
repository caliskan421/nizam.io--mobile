import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';

Future<void> showRecentTables(
  BuildContext context,
  WidgetRef ref,
  ValueChanged<String> onOpen,
) => showTableSheet(
  ref,
  context,
  title: context.l10n.uiTablesRecentAction,
  description: 'En son düzenlenen tablolar',
  builder: (sheet) => Consumer(
    builder: (context, ref, _) {
      final state = ref.watch(tablesControllerProvider);
      final l = context.l10n;
      return NzMenuGroup(
        rows: [
          for (final d in state.documents)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ref.read(tablesControllerProvider.notifier).markOpened(d.id);
                  Navigator.of(sheet).pop();
                  onOpen(d.id);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          border: Border.all(color: context.colors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: NzIcon(NzIcons.sheets, size: 18),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.list,
                            ),
                            const Gap(2),
                            Text(
                              '${l.tableArea(d.area)}${d.area == TableArea.coord ? ' · ${l.tableUnit(d.unit)}' : ''} · ${d.rows.length} ${l.uiTablesRow}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.caption.copyWith(
                                color: context.colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      NzIcon(
                        NzIcons.chevronRight,
                        size: 16,
                        color: context.colors.textFaint,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    },
  ),
);

Future<void> showCopyTable(
  BuildContext context,
  WidgetRef ref,
  String id,
  ValueChanged<String>? onOpen,
) async {
  final state = ref.read(tablesControllerProvider);
  final source = state.document(id);
  if (source == null) return;
  final l = context.l10n;
  var area = source.area == TableArea.shared ? TableArea.personal : source.area;
  var unit = source.unit;
  final units = state.documents
      .where((d) => d.area == TableArea.coord)
      .map((d) => d.unit)
      .toSet();
  await showTableSheet(
    ref,
    context,
    title: l.uiTablesCopyTo,
    actions: (sheet) => [
      NzButton.primary(
        label: l.uiTablesDuplicate,
        onPressed: () {
          final copied = ref
              .read(tablesControllerProvider.notifier)
              .duplicate(
                id,
                empty: false,
                suffix: l.uiTablesCopySuffix,
                area: area,
                unit: unit,
              );
          Navigator.of(sheet).pop();
          if (copied != null) onOpen?.call(copied);
        },
      ),
    ],
    builder: (sheet) => StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(source.title, style: context.text.titleSm),
          const Gap(NizamioSpacing.space4),
          NzSelect<TableArea>(
            label: l.uiTablesDestination,
            value: area,
            items: [
              for (final a in [TableArea.personal, TableArea.coord])
                NzSelectItem(value: a, label: l.tableArea(a)),
            ],
            onChanged: (v) {
              if (v != null) setState(() => area = v);
            },
          ),
          if (area == TableArea.coord) ...[
            const Gap(NizamioSpacing.space3),
            NzSelect<String>(
              label: l.uiTablesCoord,
              value: units.contains(unit) ? unit : null,
              items: [
                for (final u in units)
                  NzSelectItem(value: u, label: l.tableUnit(u)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => unit = v);
              },
            ),
          ],
          const Gap(NizamioSpacing.space4),
        ],
      ),
    ),
  );
}

class TableRelations extends ConsumerWidget {
  const TableRelations({super.key, required this.id, this.onOpen});
  final String id;
  final ValueChanged<String>? onOpen;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tablesControllerProvider);
    final d = state.document(id);
    if (d == null) return const SizedBox.shrink();
    final l = context.l10n;
    final outgoing = <({TableDocument table, String label, int count})>[];
    final incoming = <({TableDocument table, String label, int count})>[];
    for (final source in state.documents) {
      for (final f in source.fields.where(
        (f) => f.type == TableFieldType.link && f.target != null,
      )) {
        final target = state.document(f.target!);
        if (target == null) continue;
        final count = source.rows.fold<int>(0, (n, r) {
          final values = r.cells[TableFieldId(f.id)];
          return n + (values is List ? values.length : 0);
        });
        if (source.id == id) {
          outgoing.add((table: target, label: f.name, count: count));
        }
        if (target.id == id) {
          incoming.add((table: source, label: f.name, count: count));
        }
      }
    }
    if (outgoing.isEmpty && incoming.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: NizamioSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final group in [
            (l.uiTablesRelated, outgoing),
            (l.uiTablesBacklinks, incoming),
          ])
            if (group.$2.isNotEmpty) ...[
              Text(group.$1, style: context.text.kicker),
              const Gap(NizamioSpacing.space2),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final relation in group.$2)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: NizamioSpacing.space2,
                        ),
                        child: InkWell(
                          onTap: onOpen == null
                              ? null
                              : () {
                                  ref
                                      .read(tablesControllerProvider.notifier)
                                      .markOpened(relation.table.id);
                                  onOpen!(relation.table.id);
                                },
                          child: NzBadge.info(
                            label:
                                '${relation.table.title} · ${relation.label} · ${relation.count} ${l.uiTablesLinks}',
                            leading: Icons.link,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}
