import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_document.dart';

/// Navigation uses the saved cell and backend-resolved names, never a parsed label
/// or an unsaved draft. Hidden/null targets cannot create a navigation action.
class TableLinkedTargets extends ConsumerWidget {
  const TableLinkedTargets({
    super.key,
    required this.id,
    required this.row,
    required this.column,
    required this.onOpen,
  });
  final String id, row, column;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(tableDetailProvider(id)).data;
    if (data == null) return const SizedBox.shrink();
    final value = data.cell(row, column).value;
    final ids = value is String
        ? [value]
        : value is List
        ? value.whereType<String>()
        : <String>[];
    final targets = <TableDocumentId, String>{
      for (final target in ids)
        if (data.linkedTables[TableDocumentId(target)] case final String name)
          if (name.trim().isNotEmpty) TableDocumentId(target): name,
    };
    if (targets.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Bağlı tabloyu aç', style: context.text.labelMd),
        const Gap(8),
        for (final entry in targets.entries) ...[
          NzMenuGroup(
            radius: NizamioRadius.pill,
            rows: [
              NzMenuRow(
                icon: NzIcons.sheets,
                label: entry.value,
                trailing: const NzIcon(NzIcons.chevronRight),
                onTap: () => onOpen(entry.key.value),
              ),
            ],
          ),
          if (entry.key != targets.keys.last) const Gap(8),
        ],
        const Gap(16),
      ],
    );
  }
}
