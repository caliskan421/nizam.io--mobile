import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/nz_check_circle.dart';
import '../../../core/ui/widgets/nz_glyph.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_avatar.dart';
import '../domain/table_document.dart';
import '../domain/table_workspace.dart';

IconData tableFieldIcon(TableFieldType type) => switch (type) {
  TableFieldType.person => NzIcons.person,
  TableFieldType.unit => NzIcons.coordinatorships,
  TableFieldType.task => NzIcons.tasks,
  TableFieldType.link => NzIcons.link,
  TableFieldType.file => NzIcons.file,
  TableFieldType.date => NzIcons.calendar,
  TableFieldType.todo => NzIcons.checkCircle,
  TableFieldType.email => NzIcons.mail,
  _ => NzIcons.edit,
};

NzGlyph tableFieldTypeGlyph(TableFieldType type) => switch (type) {
  TableFieldType.text => NzDesignGlyphs.shortText,
  TableFieldType.date => NzDesignGlyphs.event,
  TableFieldType.todo => NzDesignGlyphs.checkboxChecked,
  TableFieldType.person => NzDesignGlyphs.person,
  TableFieldType.unit => NzDesignGlyphs.coordinatorships,
  TableFieldType.task => NzDesignGlyphs.tasks,
  TableFieldType.link => NzDesignGlyphs.link,
  TableFieldType.number => NzDesignGlyphs.number,
  TableFieldType.phone => NzDesignGlyphs.phone,
  TableFieldType.email => NzDesignGlyphs.mail,
  TableFieldType.file => NzDesignGlyphs.file,
};

Widget tableFieldGlyph(BuildContext context, TableFieldType type) =>
    NzGlyphIcon(
      tableFieldTypeGlyph(type),
      size: 16,
      color: context.colors.textMuted,
    );

class TableGridValue extends StatelessWidget {
  const TableGridValue({super.key, required this.column, required this.cell});
  final TableColumnState column;
  final TableCellState cell;
  @override
  Widget build(BuildContext context) {
    final type = column.field.type;
    final empty = cell.value == null || cell.display == '—';
    if (type == TableFieldType.todo) {
      return Semantics(
        label: column.field.name,
        checked: cell.value == true,
        child: ExcludeSemantics(
          child: IgnorePointer(
            child: NzCheckCircle(
              value: cell.value == true,
              label: column.field.name,
              selectedColor: context.colors.primary,
              onChanged: () {},
            ),
          ),
        ),
      );
    }
    if (empty) {
      return Text(
        '—',
        style: context.text.bodyMd.copyWith(color: context.colors.textMuted),
      );
    }
    final labels = cell.display.split(' · ');
    if (type == TableFieldType.file && labels.length > 1) {
      return Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const Gap(4),
            Expanded(child: _reference(context, labels[i], type)),
          ],
        ],
      );
    }
    if ([
      TableFieldType.person,
      TableFieldType.unit,
      TableFieldType.task,
      TableFieldType.link,
      TableFieldType.file,
    ].contains(type)) {
      return Wrap(
        spacing: NizamioSpacing.space1,
        runSpacing: NizamioSpacing.space1,
        children: [
          for (final label in labels) _reference(context, label, type),
        ],
      );
    }
    final date = type == TableFieldType.date
        ? DateTime.tryParse(cell.display)
        : null;
    return Text(
      date == null
          ? cell.display
          : '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: type == TableFieldType.date
          ? context.text.monoSm
          : context.text.bodyMd,
    );
  }

  Widget _reference(BuildContext context, String name, TableFieldType type) {
    final outlined = type == TableFieldType.link || type == TableFieldType.file;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type == TableFieldType.person)
          NzAvatar.initials(
            name: name,
            extent: NzAvatarSize.sm,
            fillColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
          )
        else
          NzIcon(
            tableFieldIcon(type),
            size: 16,
            color: context.colors.textMuted,
          ),
        const Gap(NizamioSpacing.space2),
        Flexible(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySm,
          ),
        ),
      ],
    );
    if (!outlined) return content;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NizamioSpacing.space2,
        vertical: NizamioSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(8),
      ),
      child: content,
    );
  }
}

String tableColumnSummary(TableWorkspace data, TableColumnState column) {
  final cells = data.document.rows.map((r) => data.cell(r.id, column.field.id));
  final values = cells.where((c) => c.value != null && !c.redacted).toList();
  if (column.field.type == TableFieldType.todo) {
    return '${values.where((c) => c.value == true).length} / ${data.document.rows.length} tamam';
  }
  if (column.field.type == TableFieldType.person ||
      column.field.type == TableFieldType.unit) {
    final unique = <Object>{};
    for (final c in values) {
      if (c.value is List) {
        unique.addAll((c.value! as List).whereType<Object>());
      } else {
        unique.add(c.value!);
      }
    }
    return '${unique.length} ${column.field.type == TableFieldType.person ? 'kişi' : 'koordinatörlük'}';
  }
  if (column.field.type == TableFieldType.date) {
    final dates =
        values
            .map((c) => DateTime.tryParse('${c.value}'))
            .whereType<DateTime>()
            .toList()
          ..sort();
    if (dates.isEmpty) return '—';
    final format = DateFormat('dd MMM', 'tr');
    return dates.first == dates.last
        ? format.format(dates.first)
        : '${format.format(dates.first)} – ${format.format(dates.last)}';
  }
  final count = values.fold<int>(
    0,
    (sum, c) =>
        sum +
        (c.value is List ? (c.value! as List).whereType<Object>().length : 1),
  );
  return '$count ${column.field.type == TableFieldType.link
      ? 'bağlantı'
      : column.field.type == TableFieldType.file
      ? 'dosya'
      : 'dolu'}';
}
