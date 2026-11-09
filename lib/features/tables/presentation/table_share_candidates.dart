import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/nz_text_field.dart';
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
        for (final id in available)
          ListTile(
            title: Text('${l.uiTablesDemoPerson} ${id.split('-').last}'),
            trailing: const Icon(Icons.add),
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
    );
  }
}
