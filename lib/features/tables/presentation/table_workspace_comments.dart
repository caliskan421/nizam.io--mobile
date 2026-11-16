import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_loader.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import 'table_sheet_host.dart';
import 'table_workspace_forms.dart';

Future<void> workspaceComments(
  BuildContext context,
  WidgetRef ref,
  String id, {
  String? row,
  String? column,
}) => showTableSheet(
  ref,
  context,
  tableId: id,
  title: column != null
      ? 'Hücre yorumları'
      : row != null
      ? 'Satır yorumları'
      : 'Yorumlar',
  builder: (context) => _CommentsPanel(id: id, row: row, column: column),
);

class _CommentsPanel extends ConsumerStatefulWidget {
  const _CommentsPanel({required this.id, this.row, this.column});
  final String id;
  final String? row;
  final String? column;
  @override
  ConsumerState<_CommentsPanel> createState() => _CommentsPanelState();
}

class _CommentsPanelState extends ConsumerState<_CommentsPanel> {
  final _items = <TableCommentEntry>[];
  bool _loading = true;
  String? _cursor;
  ApiError? _error;
  TableDetailController get controller =>
      ref.read(tableDetailProvider(widget.id).notifier);
  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load({bool more = false}) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await controller.repository.comments(
        controller.location,
        widget.id,
        row: widget.row,
        cursor: more ? _cursor : null,
      );
      if (!mounted) return;
      setState(() {
        if (!more) _items.clear();
        _items.addAll(page.items);
        _cursor = page.cursor;
        _loading = false;
      });
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.ui);
      if (mounted) {
        setState(() {
          _error = toApiError(e);
          _loading = false;
        });
      }
    }
  }

  Future<void> _edit([TableCommentEntry? existing]) async {
    var body = existing?.body ?? '';
    await workspaceForm(
      context,
      ref,
      widget.id,
      title: existing == null ? 'Yorum ekle' : 'Yorumu düzenle',
      valid: () => body.trim().isNotEmpty && body.runes.length <= 4000,
      fields: (context, update) => NzTextField.multiline(
        pill: true,
        labelAbove: false,
        label: 'Yorum',
        initialValue: body,
        maxLength: 4000,
        onChanged: (v) {
          body = v;
          update();
        },
      ),
      submit: () async =>
          await controller.send(
            EditTableComment(
              existing == null
                  ? TableCommentAction.add
                  : TableCommentAction.edit,
              id: existing?.id,
              row: widget.row,
              column: widget.column,
              body: body,
            ),
          ) !=
          null,
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(tableDetailProvider(widget.id));
    final items = _items.where(
      (c) => widget.column == null || c.column == widget.column,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.row != null)
          NzButton.ghost(
            label: 'Yorum ekle',
            onPressed: detail.busy || detail.pending ? null : _edit,
          ),
        if (_error != null) ...[
          Text(errorText(context.l10n, _error!)),
          NzButton.ghost(onPressed: _load, label: 'Yeniden dene'),
        ],
        if (_loading) const Center(child: NzLoader()),
        if (!_loading && _error == null && items.isEmpty)
          Text(
            _cursor == null
                ? 'Henüz yorum yok.'
                : 'Bu sayfada bu hücreye ait yorum yok.',
          ),
        for (final c in items) ...[
          const Gap(NizamioSpacing.space3),
          Row(
            children: [
              Expanded(
                child: Text(c.author ?? 'Kişi', style: context.text.labelMd),
              ),
              Text(
                '${c.created.day}.${c.created.month}.${c.created.year}',
                style: context.text.caption,
              ),
            ],
          ),
          const Gap(NizamioSpacing.space2),
          Text(c.body, style: context.text.bodyMd),
          if (c.edited != null) Text('Düzenlendi', style: context.text.caption),
          Row(
            children: [
              if (c.mine)
                NzButton.ghost(onPressed: () => _edit(c), label: 'Düzenle'),
              if (c.mine || detail.data?.document.access.name == 'owner')
                NzButton.ghost(
                  onPressed: () async {
                    await workspaceConfirm(
                      context,
                      ref,
                      widget.id,
                      title: 'Yorumu sil',
                      message: 'Bu yorum kalıcı olarak silinecek.',
                      edit: EditTableComment(
                        TableCommentAction.delete,
                        id: c.id,
                      ),
                    );
                    if (mounted) await _load();
                  },
                  label: 'Sil',
                ),
            ],
          ),
        ],
        if (_cursor != null)
          NzButton.ghost(
            onPressed: _loading ? null : () => _load(more: true),
            label: 'Daha fazla yorum',
          ),
      ],
    );
  }
}
