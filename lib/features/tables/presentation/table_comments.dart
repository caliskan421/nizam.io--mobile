import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_comments_controller.dart';
import '../application/table_controller.dart';
import 'table_sheets.dart';

/// Satır yorumları: liste (yazar görünmüyorsa adsız), ekleme ve kendi yorumunu silme.
/// Canlı akıştaki yorum olayları listeyi yeniler.
class TableRowComments extends ConsumerStatefulWidget {
  const TableRowComments({
    super.key,
    required this.tableId,
    required this.rowId,
    required this.canWrite,
  });
  final String tableId;
  final String rowId;
  final bool canWrite;

  @override
  ConsumerState<TableRowComments> createState() => _TableRowCommentsState();
}

class _TableRowCommentsState extends ConsumerState<TableRowComments> {
  final _text = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _text.text.trim();
    if (body.isEmpty || _busy) return;
    setState(() => _busy = true);
    final ok = await tableRun(
      context,
      () => ref
          .read(tableControllerProvider(widget.tableId).notifier)
          .addComment(widget.rowId, body),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(
      tableCommentsControllerProvider(widget.tableId, widget.rowId),
    );
    final items = async.value?.items ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.uiTablesComments, style: context.text.labelMd),
        const Gap(NizamioSpacing.space2),
        if (async.isLoading && !async.hasValue)
          const LinearProgressIndicator()
        else if (items.isEmpty)
          Text(
            l.uiTablesNoComments,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        for (final c in items)
          Padding(
            padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.authorName ?? l.uiTablesHiddenAuthor,
                        style: context.text.caption.copyWith(
                          color: context.colors.textMuted,
                        ),
                      ),
                      Text(c.body, style: context.text.bodySm),
                    ],
                  ),
                ),
                if (c.mine && widget.canWrite)
                  NzIconButton(
                    icon: NzIcons.delete,
                    semanticLabel: l.uiTablesDelete,
                    onPressed: () => tableRun(
                      context,
                      () => ref
                          .read(
                            tableControllerProvider(widget.tableId).notifier,
                          )
                          .deleteComment(c.id),
                    ),
                  ),
              ],
            ),
          ),
        if (async.value?.hasMore ?? false)
          NzButton.ghost(
            label: l.uiTablesLoadMore,
            onPressed: () => tableRun(
              context,
              ref
                  .read(
                    tableCommentsControllerProvider(
                      widget.tableId,
                      widget.rowId,
                    ).notifier,
                  )
                  .loadMore,
            ),
          ),
        if (widget.canWrite) ...[
          const Gap(NizamioSpacing.space2),
          NzTextField(
            label: l.uiTablesAddComment,
            controller: _text,
            enabled: !_busy,
          ),
          const Gap(NizamioSpacing.space2),
          Align(
            alignment: Alignment.centerRight,
            child: NzButton.secondary(
              label: l.uiTablesSend,
              onPressed: _busy ? null : _send,
            ),
          ),
        ],
      ],
    );
  }
}
