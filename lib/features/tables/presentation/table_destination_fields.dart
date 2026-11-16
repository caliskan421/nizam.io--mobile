import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../scope/scope.dart';
import '../application/table_destinations.dart';
import '../domain/tables_repository.dart';
import 'table_project_picker.dart';

class TableDestinationFields extends ConsumerWidget {
  const TableDestinationFields({
    super.key,
    required this.location,
    required this.project,
    required this.onChanged,
    this.allowProgram = false,
    this.allowPersonal = true,
  });
  final TableLocation location;
  final String? project;
  final void Function(TableLocation, String?) onChanged;
  final bool allowProgram;
  final bool allowPersonal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = allowProgram
        ? ref.watch(programListControllerProvider)
        : null;
    final departments = ref.watch(
      tableDestinationDepartmentsProvider(location.programId),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (allowProgram) ...[
          NzSelect<String>(
            label: 'Program',
            value: location.programId,
            items: [
              if (!(programs?.value?.items.any(
                    (p) => p.id == location.programId,
                  ) ??
                  false))
                NzSelectItem(
                  value: location.programId,
                  label: 'Geçerli program',
                ),
              for (final p in programs?.value?.items ?? <Program>[])
                NzSelectItem(value: p.id, label: p.name),
            ],
            onChanged: (v) {
              if (v != null) onChanged(TableLocation(v), null);
            },
          ),
          if (programs?.hasError == true) ...[
            Text(errorText(context.l10n, toApiError(programs!.error!))),
            NzButton.ghost(
              onPressed: () => ref.invalidate(programListControllerProvider),
              label: 'Programları yeniden yükle',
            ),
          ],
          const Gap(NizamioSpacing.space3),
        ],
        departments.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Column(
            children: [
              Text(errorText(context.l10n, toApiError(e))),
              NzButton.ghost(
                onPressed: () => ref.invalidate(
                  tableDestinationDepartmentsProvider(location.programId),
                ),
                label: 'Koordinatörlükleri yeniden yükle',
              ),
            ],
          ),
          data: (items) => NzSelect<String>(
            label: 'Alan',
            value: (!allowPersonal && location.personal)
                ? null
                : location.departmentId,
            items: [
              if (allowPersonal)
                const NzSelectItem(value: '', label: 'Kişisel alan'),
              for (final d in items.entries)
                NzSelectItem(value: d.key.value, label: d.value),
            ],
            onChanged: (v) {
              if (v != null) {
                onChanged(TableLocation(location.programId, v), null);
              }
            },
          ),
        ),
        const Gap(NizamioSpacing.space3),
        TableProjectPicker(
          key: ValueKey(location),
          location: location,
          value: project,
          onChanged: (v) => onChanged(location, v),
        ),
      ],
    );
  }
}
