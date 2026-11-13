part of 'table_page.dart';

extension _TablePageActions on _TablePageState {
  /// Izgara satırı; ilk hücre (#) yatay kaydırmada solda sabit kalır.
  Widget _gridLine(
    BuildContext context, {
    required List<Widget> children,
    bool header = false,
  }) {
    final color = header
        ? context.colors.surfaceRaised
        : context.colors.surface;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: header ? 44 : 52),
        child: AnimatedBuilder(
          animation: _horizontal,
          builder: (context, _) => Stack(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Opacity(opacity: 0, child: children.first),
                    for (final cell in children.skip(1))
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: context.colors.border),
                          ),
                        ),
                        child: cell,
                      ),
                  ],
                ),
              ),
              Positioned(
                left: _horizontal.hasClients
                    ? _horizontal.positions.last.pixels
                    : 0,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border(
                      right: BorderSide(color: context.colors.border),
                    ),
                  ),
                  child: children.first,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _kindIcon(TableColumnKind kind) => switch (kind) {
    TableColumnKind.text => Icons.short_text,
    TableColumnKind.number => Icons.tag,
    TableColumnKind.date => Icons.calendar_today_outlined,
    TableColumnKind.phone => Icons.phone_outlined,
    TableColumnKind.email => Icons.mail_outline,
    TableColumnKind.checkbox => Icons.check_box_outlined,
    TableColumnKind.personReference => Icons.person_outline,
    TableColumnKind.departmentReference => Icons.account_tree_outlined,
    TableColumnKind.taskReference => Icons.checklist,
    TableColumnKind.fileReference => Icons.description_outlined,
    TableColumnKind.tableReference => Icons.link,
    TableColumnKind.attachment => Icons.attach_file,
    TableColumnKind.unknown => Icons.help_outline,
  };

  Future<void> _options(TableView d) async {
    final l = context.l10n;
    await showTableSheet(
      ref,
      context,
      title: l.uiTablesOptions,
      builder: (sheet) => NzMenuGroup(
        rows: [
          NzMenuRow(
            icon: NzIcons.copy,
            label: l.uiTablesCopyLink,
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: '/tables/${d.meta.id}'),
              );
              if (sheet.mounted) Navigator.of(sheet).pop();
              if (mounted) NzToast.show(context, l.uiTablesLinkCopied);
            },
          ),
          if (d.editable)
            NzMenuRow(
              icon: NzIcons.edit,
              label: l.uiTablesRename,
              onTap: () {
                Navigator.of(sheet).pop();
                tableRename(context, ref, widget.id);
              },
            ),
          if (d.editable && d.undoSequence != null)
            NzMenuRow(
              icon: Icons.undo,
              label: l.uiTablesUndo,
              onTap: () async {
                Navigator.of(sheet).pop();
                var skipped = 0;
                final ok = await tableRun(context, () async {
                  skipped = await _controller.undoLast();
                });
                if (ok && mounted) {
                  NzToast.show(
                    context,
                    skipped > 0 ? l.uiTablesUndoSkipped : l.uiTablesUndoDone,
                  );
                }
              },
            ),
          if (d.isOwner)
            NzMenuRow(
              icon: NzIcons.delete,
              label: l.uiTablesDelete,
              danger: true,
              onTap: () async {
                Navigator.of(sheet).pop();
                final yes = await NzDialog.confirm(
                  context,
                  title: l.uiTablesDeleteTable,
                  message: l.uiTablesDeleteMessage,
                  confirmLabel: l.uiTablesDelete,
                  cancelLabel: l.uiTablesCancel,
                  tone: NzDialogTone.destructive,
                );
                if (!yes || !mounted) return;
                final ok = await tableRun(context, _controller.deleteTable);
                if (ok && mounted) Navigator.of(context).maybePop();
              },
            ),
        ],
      ),
    );
  }
}
