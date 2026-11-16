import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_loader.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../tasks/tasks.dart';
import '../application/table_reference_choices.dart';
import 'table_choice_row.dart';

class TableFileReferenceInput extends ConsumerStatefulWidget {
  const TableFileReferenceInput({
    super.key,
    required this.value,
    required this.multiple,
    required this.onChanged,
  });
  final Object? value;
  final bool multiple;
  final ValueChanged<Object?> onChanged;
  @override
  ConsumerState<TableFileReferenceInput> createState() =>
      _TableFileReferenceInputState();
}

class _TableFileReferenceInputState
    extends ConsumerState<TableFileReferenceInput> {
  String? _task;
  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(taskCatalogControllerProvider);
    return catalog.when(
      loading: () => const Center(child: NzLoader()),
      error: (e, _) => Text(errorText(context.l10n, toApiError(e))),
      data: (catalog) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NzSelect<String>(
            label: 'Görev',
            value: _task,
            items: [
              for (final t in catalog.tasks)
                NzSelectItem(value: t.id, label: t.title),
            ],
            onChanged: (v) => setState(() => _task = v),
          ),
          if (widget.value != null)
            NzButton.ghost(
              onPressed: () => widget.onChanged(null),
              label: 'Mevcut dosya seçimini temizle',
            ),
          if (_task != null) ...[
            const Gap(NizamioSpacing.space3),
            Consumer(
              builder: (context, ref, _) => ref
                  .watch(tableFileReferenceChoicesProvider(_task!))
                  .when(
                    loading: () => const Center(child: NzLoader()),
                    error: (e, _) => Column(
                      children: [
                        const Text('Görev dosyaları yüklenemedi.'),
                        NzButton.ghost(
                          onPressed: () => ref.invalidate(
                            tableFileReferenceChoicesProvider(_task!),
                          ),
                          label: 'Yeniden dene',
                        ),
                      ],
                    ),
                    data: (files) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (files.isEmpty)
                          const Text('Bu görevde görünür dosya yok.'),
                        for (final f in files.entries)
                          TableChoiceRow(
                            label: f.value,
                            value: widget.multiple
                                ? widget.value is List &&
                                      (widget.value! as List).contains(
                                        f.key.value,
                                      )
                                : widget.value == f.key.value,
                            onChanged: (selected) {
                              if (!widget.multiple) {
                                widget.onChanged(selected ? f.key.value : null);
                                return;
                              }
                              final values = widget.value is List
                                  ? List<Object?>.of(widget.value! as List)
                                  : <Object?>[];
                              values.removeWhere(
                                (v) => v == null || v == f.key.value,
                              );
                              if (selected) values.add(f.key.value);
                              widget.onChanged(values.isEmpty ? null : values);
                            },
                          ),
                      ],
                    ),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
