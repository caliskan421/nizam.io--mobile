import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/table_view.dart';
import '../domain/table_models.dart';
import 'table_texts.dart';

/// Tipe göre hücre düzenleyici. Değer sunucu tel biçiminde verilir: metin/telefon/e-posta/
/// tarih (`YYYY-MM-DD`) String, sayı num, onay kutusu bool; boş → null. Referans ve ek
/// sütunları burada düzenlenmez (seçiciler henüz bağlanmadı); değer salt okunur gösterilir.
class TableCellEditor extends StatelessWidget {
  const TableCellEditor({
    super.key,
    required this.view,
    required this.column,
    required this.data,
    required this.onChanged,
  });
  final TableView view;
  final TableColumnSpec column;
  final TableCellData data;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = column;
    final value = data.value;
    final editable =
        view.editable && !data.redacted && editableColumnKinds.contains(c.kind);
    if (!editableColumnKinds.contains(c.kind) || data.redacted) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(c.name, style: context.text.labelMd),
          Text(l.tableCellText(view, c, data), style: context.text.bodySm),
          Text(
            data.redacted ? l.uiTablesRedacted : l.uiTablesNotEditable,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
        ],
      );
    }
    switch (c.kind) {
      case TableColumnKind.checkbox:
        return NzFormRows(
          rows: [
            NzFormRow.toggle(
              label: c.name,
              value: value == true,
              onChanged: editable ? onChanged : null,
            ),
          ],
        );
      case TableColumnKind.date:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(c.name, style: context.text.labelMd),
            NzButton.secondary(
              label: value == null ? l.uiTablesDate : '$value',
              onPressed: editable
                  ? () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.tryParse('$value') ?? now,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2200),
                      );
                      if (picked != null) {
                        onChanged(picked.toIso8601String().substring(0, 10));
                      }
                    }
                  : null,
            ),
            if (editable && value != null)
              NzButton.ghost(
                label: l.uiTablesClear,
                onPressed: () => onChanged(null),
              ),
          ],
        );
      case TableColumnKind.number:
        return NzTextField.number(
          label: c.name,
          initialValue: value == null ? '' : '$value',
          enabled: editable,
          onChanged: (v) {
            final t = v.trim();
            if (t.isEmpty) return onChanged(null);
            final n = num.tryParse(t.replaceAll(',', '.'));
            if (n != null) onChanged(n);
          },
        );
      case TableColumnKind.email:
        return NzTextField.email(
          label: c.name,
          initialValue: value == null ? '' : '$value',
          enabled: editable,
          onChanged: (v) => onChanged(v.trim().isEmpty ? null : v.trim()),
        );
      default:
        return NzTextField(
          label: c.name,
          initialValue: value == null ? '' : '$value',
          enabled: editable,
          onChanged: (v) => onChanged(v.isEmpty ? null : v),
        );
    }
  }
}
