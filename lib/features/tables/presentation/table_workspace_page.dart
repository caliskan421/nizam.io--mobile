import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_loader.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/navigation/nz_top_bar.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_detail_controller.dart';
import '../application/table_view_controller.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import 'table_undo_result.dart';
import 'table_workspace_actions.dart';
import 'table_workspace_cells.dart';
import 'table_workspace_forms.dart';
import 'table_workspace_grid.dart';
import 'table_workspace_header.dart';
import 'table_workspace_sharing.dart';

class TableWorkspacePage extends ConsumerStatefulWidget {
  const TableWorkspacePage({super.key, required this.id, this.onOpenTable});
  final String id;
  final ValueChanged<String>? onOpenTable;

  @override
  ConsumerState<TableWorkspacePage> createState() => _TableWorkspacePageState();
}

class _TableWorkspacePageState extends ConsumerState<TableWorkspacePage>
    with WidgetsBindingObserver {
  TableDetailController? _controller;
  String get id => widget.id;
  ValueChanged<String>? get onOpenTable => widget.onOpenTable;
  bool _foreground = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visibility();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _visibility();
  }

  void _visibility() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller?.active(
          _foreground && TickerMode.valuesOf(context).enabled,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.active(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tableDetailProvider(id));
    final controller = ref.read(tableDetailProvider(id).notifier);
    _controller = controller;
    final data = state.data;
    final d = data?.document;
    final knownTitle = ref.watch(
      tablesControllerProvider.select((s) => s.document(id)?.title),
    );
    final hidden = ref.watch(tableHiddenColumnsProvider(id));
    return NzPage.feed(
      width: NzContentWidth.wide,
      paneLead: NizamioSpacing.space2,
      topBar: NzTopBar.detail(
        title: d?.title ?? knownTitle ?? 'Tablo',
        actions: [
          if (data != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.undoSequence != null)
                  NzIconButton(
                    icon: NzIcons.undo,
                    semanticLabel: 'Son hücre değişikliğimi geri al',
                    onPressed: state.busy || state.pending || state.loading
                        ? null
                        : () async {
                            final r = await controller.send(
                              UndoTableCells(state.undoSequence!),
                            );
                            if (r != null && context.mounted) {
                              NzToast.show(
                                context,
                                r.skipped == 0
                                    ? 'Değişiklik geri alındı.'
                                    : 'Değişiklik geri alındı; ${r.skipped} hücre korunarak atlandı.',
                                actionLabel: r.skipped > 0
                                    ? 'Atlananları gör'
                                    : null,
                                onAction: r.skipped > 0
                                    ? () => tableUiAction(
                                        context,
                                        () => workspaceUndoSkipped(
                                          context,
                                          ref,
                                          id,
                                          r,
                                        ),
                                      )
                                    : null,
                              );
                            }
                          },
                  ),
                NzIconButton(
                  icon: NzIcons.more,
                  semanticLabel: 'Tablo seçenekleri',
                  onPressed: () => workspaceOptions(
                    context,
                    ref,
                    id,
                    onOpenTable: onOpenTable,
                  ),
                ),
              ],
            ),
          if (data != null)
            TableWorkspacePeople(
              key: const ValueKey('table-sharing-people'),
              id: id,
              onPressed: () => workspaceSharing(context, ref, id),
            ),
        ],
      ),
      onRefresh: controller.refresh,
      onRevisit: controller.refreshIfStale,
      children: [
        if (d != null) ...[
          TableWorkspaceHeader(id: id, onOpenTable: onOpenTable),
          if (state.query.filters.isNotEmpty ||
              state.query.sorts.isNotEmpty ||
              state.query.cursor != null) ...[
            const Gap(NizamioSpacing.space2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    state.query.cursor != null
                        ? 'Son eklenen satır gösteriliyor'
                        : '${state.query.filters.length} filtre · ${state.query.sorts.length} sıralama',
                    style: context.text.caption,
                  ),
                ),
                NzButton.ghost(
                  onPressed: () => controller.query(const TableReadQuery()),
                  label: state.query.cursor != null
                      ? 'Tüm satırlar'
                      : 'Temizle',
                ),
              ],
            ),
          ],
        ],
        if (state.error != null || state.pending && !state.busy) ...[
          const Gap(NizamioSpacing.space3),
          if (state.error != null) Text(errorText(context.l10n, state.error!)),
          if (state.pending)
            const Text('Son işlemin sonucu henüz doğrulanmadı.'),
          NzButton.ghost(
            onPressed: state.busy
                ? null
                : () async {
                    if (state.pending) {
                      final result = await controller.retry();
                      if (result != null && context.mounted) {
                        if (ref.read(tableDetailProvider(id)).deleted) {
                          Navigator.of(context).maybePop();
                        } else {
                          NzToast.show(context, 'İşlem tamamlandı.');
                        }
                      }
                    } else {
                      await controller.refresh();
                    }
                  },
            label: state.pending ? 'Kaydı yeniden dene' : 'Yeniden dene',
          ),
          if (state.pending)
            NzButton.ghost(
              onPressed: state.busy
                  ? null
                  : () => workspaceAbandon(context, ref, id),
              label: 'Denemeyi bırak',
            ),
        ],
        if (state.deleted) const Text('Tablo silindi.'),
        if (state.loading && data == null)
          const Padding(
            padding: EdgeInsets.all(NizamioSpacing.space4),
            child: Center(child: NzLoader()),
          ),
        if (data != null) ...[
          const Gap(NizamioSpacing.space2),
          TableWorkspaceGrid(
            data: data,
            columns: data.columns
                .where((c) => !hidden.contains(TableFieldId(c.field.id)))
                .toList(),
            offset: state.offset,
            onAddColumn: () => workspaceColumn(context, ref, id),
            enabled: !state.loading && !state.busy && !state.pending,
            participants: state.participants,
            onCell: (row, column) => tableUiAction(context, () async {
              final field = data.columns
                  .where((c) => c.field.id == column)
                  .firstOrNull;
              if (field?.field.type == TableFieldType.todo) {
                final cell = data.cell(row, column);
                await controller.send(
                  WriteTableCells([
                    TableCellWrite(
                      row,
                      column,
                      cell.value != true,
                      cell.version,
                    ),
                  ]),
                );
              } else {
                await workspaceCell(context, ref, id, row, column);
              }
            }),
            onRow: (row) => tableUiAction(
              context,
              () => workspaceRow(context, ref, id, row),
            ),
            onColumn: (column) => tableUiAction(
              context,
              () => workspaceColumnOptions(context, ref, id, column),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          if (data.cursor != null || state.page > 1)
            Text(
              'Alt özetler bu sayfadaki satırları kapsar.',
              style: context.text.caption.copyWith(
                color: context.colors.textMuted,
              ),
            ),
          if (d!.rows.isEmpty) ...[
            const Gap(NizamioSpacing.space5),
            Center(
              child: Column(
                children: [
                  const NzIcon(NzIcons.sheets, size: 32),
                  const Gap(NizamioSpacing.space3),
                  Text('İlk kaydını ekle', style: context.text.titleSm),
                  const Gap(NizamioSpacing.space2),
                  Text(
                    'Sütunların hazır. Satır ekleyerek tabloyu doldurmaya başla.',
                    style: context.text.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
          if (state.prefetching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: NizamioSpacing.space2),
              child: Center(child: NzLoader()),
            ),
          if (state.prefetchError != null) ...[
            Text('Diğer satırlar yüklenemedi.', style: context.text.caption),
            NzButton.ghost(
              label: 'Kalan satırları yeniden yükle',
              onPressed: controller.loadRemaining,
            ),
          ],
          if (data.cursor != null || state.page > 1) ...[
            const Gap(NizamioSpacing.space3),
            Wrap(
              spacing: NizamioSpacing.space2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (state.page > 1)
                  NzButton.ghost(
                    label: 'Önceki sayfa',
                    onPressed: state.loading || state.busy || state.prefetching
                        ? null
                        : () => controller.refresh(previous: true),
                  ),
                Text('${state.page}. sayfa', style: context.text.caption),
                if (data.cursor != null)
                  NzButton.ghost(
                    label: 'Sonraki sayfa',
                    onPressed: state.loading || state.busy || state.prefetching
                        ? null
                        : () => controller.refresh(more: true),
                  ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}
