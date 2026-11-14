import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/turkish_collation.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../domain/task_catalog.dart';

/// Görev arayıp seçtiren alt sayfa (bağımlılık ekleme, arşivden yükleme). Arama başlıkta,
/// görev anahtarında ve [subtitle] metninde Türkçe harf duyarsız yapılır; en çok [_shown]
/// satır çizilir (fazlası için arama daraltılır). Seçilen görev döner, vazgeçme null.
Future<TaskItem?> showTaskPickerSheet(
  BuildContext context, {
  required String title,
  required List<TaskItem> tasks,
  String? Function(TaskItem task)? subtitle,
  String? description,
}) => NzBottomSheet.show<TaskItem>(
  context,
  title: title,
  description: description,
  expandable: true,
  builder: (_) => _TaskPicker(tasks: tasks, subtitle: subtitle),
);

const _shown = 60;

class _TaskPicker extends StatefulWidget {
  const _TaskPicker({required this.tasks, this.subtitle});

  final List<TaskItem> tasks;
  final String? Function(TaskItem task)? subtitle;

  @override
  State<_TaskPicker> createState() => _TaskPickerState();
}

class _TaskPickerState extends State<_TaskPicker> {
  String _query = '';

  bool _matches(TaskItem t, String q) =>
      trLower(t.title).contains(q) ||
      trLower(t.displayCode).contains(q) ||
      trLower(widget.subtitle?.call(t) ?? '').contains(q);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final q = trLower(_query.trim());
    final hits = [
      for (final task in widget.tasks)
        if (q.isEmpty || _matches(task, q)) task,
    ]..sort((a, b) => compareTurkish(a.title, b.title));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzSearchField(
          label: 'Görev ara',
          hint: 'Görev adı ya da koordinatörlük',
          onChanged: (v) => setState(() => _query = v),
          onClear: () => setState(() => _query = ''),
        ),
        const Gap(NizamioSpacing.space3),
        if (hits.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space6,
            ),
            child: Text(
              'Eşleşen görev yok',
              textAlign: TextAlign.center,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ),
        for (final task in hits.take(_shown))
          NzListTile(
            title: task.title,
            subtitle: widget.subtitle?.call(task),
            onTap: () => Navigator.of(context).pop(task),
          ),
        if (hits.length > _shown)
          Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space2),
            child: Text(
              '${hits.length - _shown} görev daha; aramayı daraltın',
              textAlign: TextAlign.center,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ),
      ],
    );
  }
}
