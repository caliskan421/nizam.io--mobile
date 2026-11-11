import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/nz_text_field.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/tables_controller.dart';
import '../domain/table_document.dart';

class TableShareCandidates extends ConsumerStatefulWidget {
  const TableShareCandidates({super.key, required this.document});
  final TableDocument document;
  @override
  ConsumerState<TableShareCandidates> createState() =>
      _TableShareCandidatesState();
}

class _TableShareCandidatesState extends ConsumerState<TableShareCandidates> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final available = ['demo-1', 'demo-2', 'demo-3']
        .where((id) => !widget.document.people.containsKey(TablePersonId(id)))
        .where(
          (id) => '${l.uiTablesDemoPerson} ${id.split('-').last}'
              .toLowerCase()
              .contains(_query.toLowerCase().trim()),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzTextField(
          label: l.uiTablesPersonSearch,
          onChanged: (v) => setState(() => _query = v),
        ),
        const Gap(NizamioSpacing.space3),
        NzMenuGroup(
          rows: [
            for (final id in available)
              NzMenuRow(
                icon: NzIcons.add,
                label: '${l.uiTablesDemoPerson} ${id.split('-').last}',
                onTap: () => ref
                    .read(tablesControllerProvider.notifier)
                    .share(
                      widget.document.id,
                      people: {
                        ...widget.document.people,
                        TablePersonId(id): TableAccess.edit,
                      },
                    ),
              ),
          ],
        ),
      ],
    );
  }
}
