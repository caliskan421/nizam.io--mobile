import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_tap.dart';
import '../../../core/ui/widgets/nz_glyph.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_avatar.dart';
import '../application/table_detail_controller.dart';
import '../application/tables_controller.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import 'table_columns_sheet.dart';
import 'table_design.dart';
import 'table_new_row_sheet.dart';

class TableWorkspacePeople extends ConsumerWidget {
  const TableWorkspacePeople({
    super.key,
    required this.id,
    required this.onPressed,
  });
  final String id;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(tableDetailProvider(id));
    final choices = ref.watch(tableSharingChoicesProvider).value;
    final document = detail.data?.document;
    final people = <TablePersonId, String>{};
    void include(String? id) {
      if (id == null || id.isEmpty) return;
      final name = id == choices?.accountId
          ? choices?.accountName
          : choices?.people[TablePersonId(id)];
      if (name != null) people[TablePersonId(id)] = name;
    }

    include(document?.ownerId);
    for (final person in document?.people.keys ?? <TablePersonId>[]) {
      if (document?.people[person] != TableAccess.off) include(person.value);
    }
    if (document != null && document.teamAccess != TableAccess.off) {
      if (choices?.memberships[TablePersonId(choices.accountId)]?.contains(
            document.unit,
          ) ==
          true) {
        include(choices?.accountId);
      }
      people.addAll(choices?.teamPeopleIn(document.unit) ?? {});
    }
    for (final participant in detail.participants) {
      people[TablePersonId(participant.account)] = participant.name;
    }
    final shown = people.entries.take(3).toList();
    return Semantics(
      button: true,
      label: 'Paylaş',
      onTap: onPressed,
      hint: 'Paylaşılan kişileri ve yetkilerini düzenle',
      excludeSemantics: true,
      child: Tooltip(
        message: 'Paylaş ve yetkileri düzenle',
        child: NzTap(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (shown.isEmpty)
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceRaised,
                        shape: BoxShape.circle,
                      ),
                      child: NzGlyphIcon(
                        NzDesignGlyphs.person,
                        size: 18,
                        color: context.colors.textMuted,
                      ),
                    ),
                  for (var i = 0; i < shown.length; i++)
                    Align(
                      widthFactor: i == shown.length - 1 ? 1 : .72,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: NzAvatar.initials(
                            name: shown[i].value,
                            extent: NzAvatarSize.sm,
                            fillColor: switch (choices?.roles[shown[i].key]) {
                              TableSharingRole.admin =>
                                context.colors.roleAdmin,
                              TableSharingRole.member =>
                                context.colors.roleMember,
                              _ => context.colors.primary,
                            },
                            foregroundColor: context.colors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TableWorkspaceHeader extends ConsumerStatefulWidget {
  const TableWorkspaceHeader({super.key, required this.id, this.onOpenTable});
  final String id;
  final ValueChanged<String>? onOpenTable;
  @override
  ConsumerState<TableWorkspaceHeader> createState() =>
      _TableWorkspaceHeaderState();
}

class _TableWorkspaceHeaderState extends ConsumerState<TableWorkspaceHeader> {
  @override
  Widget build(BuildContext context) {
    final id = widget.id;
    final state = ref.watch(tableDetailProvider(id));
    final data = state.data!;
    final choices = ref.watch(tableSharingChoicesProvider).value;
    final names = ref.watch(tablesControllerProvider).departmentNames;
    final scope = data.document.unit.isEmpty
        ? 'Kişisel'
        : names[TableDepartmentId(data.document.unit)] ?? 'Koordinatörlük';
    final owner = choices?.accountId == data.document.ownerId
        ? 'Sen'
        : choices?.people[TablePersonId(data.document.ownerId)];
    final locked = state.loading || state.busy || state.pending;
    final related = <TableDocumentId, String>{};
    for (final column in data.columns.where(
      (c) => c.field.type == TableFieldType.link,
    )) {
      for (final cell in data.cells.where((c) => c.column == column.field.id)) {
        final ids = cell.value is List
            ? (cell.value! as List).whereType<String>().toList()
            : cell.value is String
            ? [cell.value! as String]
            : <String>[];
        for (final target in ids) {
          final key = TableDocumentId(target);
          final name = data.linkedTables[key];
          if (name != null && name.trim().isNotEmpty) related[key] = name;
        }
      }
    }
    Widget actions() => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableDesignButton(
          label: 'Sütunlar',
          glyph: NzDesignGlyphs.columns,
          kind: TableButtonKind.outline,
          onPressed: () => workspaceColumns(context, ref, id),
        ),
        const Gap(8),
        TableDesignButton(
          label: 'Yeni satır',
          fadeWhenDisabled: false,
          icon: NzIcons.add,
          kind: TableButtonKind.primary,
          onPressed: locked ? null : () => workspaceNewRow(context, ref, id),
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (owner != null)
                    Text(
                      owner == 'Sen' ? 'Sen oluşturdun' : '$owner oluşturdu',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySm.copyWith(
                        color: context.colors.textMuted,
                      ),
                    ),
                  const Gap(2),
                  Text(
                    scope,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.monoSm.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (related.isNotEmpty) ...[
          const Gap(8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text(
                'Bağlı tablolar',
                style: context.text.monoSm.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
              for (final e in related.entries)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.min(
                      400,
                      MediaQuery.sizeOf(context).width - 32,
                    ),
                  ),
                  child: TableDesignButton(
                    label: e.value,
                    icon: NzIcons.link,
                    kind: TableButtonKind.outline,
                    onPressed: widget.onOpenTable == null
                        ? null
                        : () => widget.onOpenTable!(e.key.value),
                  ),
                ),
            ],
          ),
        ],
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: Text(
                '${data.document.rows.length}${data.cursor != null ? '+' : ''} satır',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: context.text.monoSm.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
            ),
            actions(),
          ],
        ),
        const Gap(6),
      ],
    );
  }
}
