import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/table_controller.dart';
import '../application/table_reference_controller.dart';
import '../application/table_view.dart';
import '../domain/table_models.dart';
import '../domain/table_reference_sources.dart';
import 'table_sheet_host.dart';

/// Referans hücresinin gezinme eylemi (rozete dokunma): tablo ve görev uygulama içinde
/// açılır; gizlenmiş/görünmeyen hedef ve diğer tipler yalnız gösterimdir.
void openTableReference(
  BuildContext context,
  TableView view,
  TableColumnKind kind,
  String? id,
) {
  final visible = id != null && view.referenceName(kind, id) != null;
  switch (tableRefTarget(kind, id, visible: visible)) {
    case OpenTableTarget(:final id):
      context.appNav.openTable(id);
    case OpenTaskTarget(:final id):
      context.appNav.openTask(id);
    case NoTarget():
      break;
  }
}

/// Satır sayfasındaki referans alanı: seçili hedefler (dokununca gezinme), seçici ve temizleme.
/// Gizlenmiş hücrede değiştirme önce "gizli öğeler kaldırılacak" onayı ister.
class TableReferenceField extends ConsumerWidget {
  const TableReferenceField({
    super.key,
    required this.tableId,
    required this.view,
    required this.rowId,
    required this.column,
    required this.data,
  });
  final String tableId;
  final TableView view;
  final String rowId;
  final TableColumnSpec column;
  final TableCellData data;

  List<String?> get _ids => switch (data.value) {
    final List<Object?> l => [for (final e in l) e is String ? e : null],
    final String s => [s],
    _ => const [],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final editable = view.editable;
    final ids = _ids;
    Future<void> pick() async {
      if (data.redacted) {
        final yes = await NzDialog.confirm(
          context,
          title: l.uiTablesReplaceHidden,
          message: l.uiTablesReplaceHiddenMessage,
          confirmLabel: l.uiTablesReplace,
          cancelLabel: l.uiTablesCancel,
          tone: NzDialogTone.destructive,
        );
        if (!yes || !context.mounted) return;
      }
      final result = await showTableReferencePicker(
        context,
        ref,
        tableId: tableId,
        column: column,
        // Gizli (null) öğeler korunamaz: tam değiştirmede düşer.
        current: [for (final id in ids) ?id],
      );
      if (result == null) return;
      ref
          .read(tableControllerProvider(tableId).notifier)
          .editReference(
            rowId,
            column.id,
            column.multiple ? result.ids : result.ids.firstOrNull,
            picked: result.picked,
            replaceRedacted: data.redacted,
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(column.name, style: context.text.labelMd),
        const Gap(NizamioSpacing.space2),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final id in ids)
              InkWell(
                onTap: () => openTableReference(context, view, column.kind, id),
                child: NzBadge.neutral(
                  label: id == null
                      ? l.uiTablesRedacted
                      : view.referenceName(column.kind, id) ?? id,
                ),
              ),
            if (ids.isEmpty) Text('—', style: context.text.bodySm),
          ],
        ),
        if (data.redacted)
          Text(
            l.uiTablesHiddenItems,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        if (editable) ...[
          const Gap(NizamioSpacing.space2),
          Row(
            children: [
              NzButton.secondary(label: l.uiTablesPick, onPressed: pick),
              if (ids.isNotEmpty && !data.redacted) ...[
                const Gap(NizamioSpacing.space2),
                NzButton.ghost(
                  label: l.uiTablesClear,
                  onPressed: () => ref
                      .read(tableControllerProvider(tableId).notifier)
                      .editReference(rowId, column.id, null, picked: const []),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// Seçicinin sonucu: yazılacak kimlikler (sıra korunur) ve adı bilinen yeni adaylar.
typedef TableRefPick = ({List<String> ids, List<TableRefCandidate> picked});

/// Aday seçici. Tekli sütunda dokunulan aday seçilir; çoklu sütunda en çok 50 benzersiz
/// aday işaretlenip kaydedilir (mevcut görünür öğeler işaretli başlar). Dosya referansında
/// önce görev, sonra o görevin dosyası seçilir. Aday kaynağının yetki hatası (ör. 403)
/// ekranda anlaşılır metinle görünür.
Future<TableRefPick?> showTableReferencePicker(
  BuildContext context,
  WidgetRef ref, {
  required String tableId,
  required TableColumnSpec column,
  required List<String> current,
}) async {
  final l = context.l10n;
  final ids = [...current];
  final picked = <TableRefCandidate>[];
  TableRefPick? result;
  var query = '';
  TableRefCandidate? task;
  await showTableSheet(
    ref,
    context,
    title: column.name,
    expandable: true,
    actions: column.multiple
        ? (sheet) => [
            NzButton.primary(
              label: l.uiTablesSave,
              onPressed: () {
                result = (
                  ids: [...ids],
                  picked: [
                    for (final c in picked)
                      if (ids.contains(c.id)) c,
                  ],
                );
                Navigator.of(sheet).pop();
              },
            ),
          ]
        : null,
    builder: (sheet) => StatefulBuilder(
      builder: (context, setState) {
        final files = column.kind == TableColumnKind.fileReference;
        final provider = files && task != null
            ? tableRefFilesProvider(
                tableId,
                task!.id,
                task!.departmentId ?? '',
                task!.name,
              )
            : tableRefCandidatesProvider(tableId, column.kind);
        final choosingTask = files && task == null;
        return Consumer(
          builder: (context, ref, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (files)
                Text(
                  task == null ? l.uiTablesPickTask : task!.name,
                  style: context.text.caption,
                ),
              NzSearchField(
                label: l.uiTablesSearch,
                onChanged: (q) => setState(() => query = q),
              ),
              const Gap(NizamioSpacing.space2),
              NzAsyncView<List<TableRefCandidate>>(
                value: ref.watch(provider),
                onRetry: () => ref.invalidate(provider),
                data: (items) {
                  final q = query.trim().toLowerCase();
                  final shown = [
                    for (final c in items)
                      if (q.isEmpty || c.name.toLowerCase().contains(q)) c,
                  ];
                  return NzMenuGroup(
                    rows: [
                      for (final c in shown)
                        if (column.multiple && !choosingTask)
                          NzCheckbox(
                            label: c.name,
                            value: ids.contains(c.id),
                            onChanged: (v) => setState(() {
                              if (v && ids.length < 50 && !ids.contains(c.id)) {
                                ids.add(c.id);
                                picked.add(c);
                              } else if (!v) {
                                ids.remove(c.id);
                              }
                            }),
                          )
                        else
                          NzMenuRow(
                            icon: choosingTask
                                ? NzIcons.chevronRight
                                : NzIcons.check,
                            label: c.name,
                            current: current.contains(c.id),
                            onTap: () {
                              if (choosingTask) {
                                setState(() => task = c);
                                return;
                              }
                              result = (ids: [c.id], picked: [c]);
                              Navigator.of(sheet).pop();
                            },
                          ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    ),
  );
  return result;
}
