part of 'table_page.dart';

extension _TablePageActions on _TablePageState {
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

  IconData _fieldIcon(TableFieldType type) => switch (type) {
    TableFieldType.text => Icons.short_text,
    TableFieldType.number => Icons.tag,
    TableFieldType.date => Icons.calendar_today_outlined,
    TableFieldType.phone => Icons.phone_outlined,
    TableFieldType.email => Icons.mail_outline,
    TableFieldType.person => Icons.person_outline,
    TableFieldType.unit => Icons.account_tree_outlined,
    TableFieldType.task => Icons.checklist,
    TableFieldType.link => Icons.link,
    TableFieldType.file => Icons.attach_file,
    TableFieldType.todo => Icons.check_box_outlined,
  };

  String _summary(TableDocument d, TableField f) {
    final values = d.rows
        .map((r) => r.cells[TableFieldId(f.id)])
        .where((v) => v != null && v != '' && (v is! List || v.isNotEmpty))
        .toList();
    if (f.type == TableFieldType.number) {
      return '${values.fold<num>(0, (sum, v) => sum + (num.tryParse('$v') ?? 0))}';
    }
    if (f.type == TableFieldType.todo) {
      return '${values.where((v) => v == true).length} / ${d.rows.length}';
    }
    if (f.type == TableFieldType.person) return '${values.toSet().length} kişi';
    if (f.type == TableFieldType.file) {
      return '${values.fold<int>(0, (sum, value) => sum + (value is List ? value.length : 1))} dosya';
    }
    return '${values.length}';
  }

  Future<void> _options(TableDocument d) async {
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
              await Clipboard.setData(ClipboardData(text: '/tables/${d.id}'));
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
                tableRename(context, ref, d.id);
              },
            ),
          NzMenuRow(
            icon: NzIcons.folderMove,
            label: l.uiTablesCopyTo,
            onTap: () {
              Navigator.of(sheet).pop();
              showCopyTable(context, ref, d.id, widget.onOpenTable);
            },
          ),
          for (final empty in [false, true])
            NzMenuRow(
              icon: NzIcons.copy,
              label: empty ? l.uiTablesDuplicateEmpty : l.uiTablesDuplicate,
              onTap: () {
                final id = _controller.duplicate(
                  d.id,
                  empty: empty,
                  suffix: empty ? l.uiTablesEmptySuffix : l.uiTablesCopySuffix,
                );
                Navigator.of(sheet).pop();
                if (id != null) widget.onOpenTable?.call(id);
              },
            ),
          if (d.canShare)
            NzMenuRow(
              icon: NzIcons.delete,
              label: l.uiTablesDelete,
              danger: true,
              onTap: () async {
                final lease = _controller.lease;
                Navigator.of(sheet).pop();
                final yes = await NzDialog.confirm(
                  context,
                  title: l.uiTablesDeleteTable,
                  message: l.uiTablesDeleteMessage,
                  confirmLabel: l.uiTablesDelete,
                  cancelLabel: l.uiTablesCancel,
                  tone: NzDialogTone.destructive,
                );
                if (yes && mounted && identical(lease, _controller.lease)) {
                  _controller.delete(d.id);
                }
              },
            ),
        ],
      ),
    );
  }
}
