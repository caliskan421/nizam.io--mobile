import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/layout/nz_pane.dart';
import '../../../../core/ui/theme/nz_motion.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';

/// Görünüm noktası rengi (prototip `VD`).
Color viewDot(TaskView v, NizamioColors c) => switch (v) {
  TaskView.all => c.textMuted,
  TaskView.late => c.danger,
  TaskView.inProgress => c.inProgress,
  TaskView.review || TaskView.dateRequest => c.warning,
  TaskView.notStarted => c.textFaint,
  TaskView.done => c.taskDone,
};

/// Görünüm kutucukları: dar alanda 4×2 ("Tümü" iki sütun), geniş alanda (tablette tam
/// genişlik liste) tek satır 8 sütun.
class TaskViewGrid extends StatelessWidget {
  const TaskViewGrid({
    super.key,
    required this.counts,
    required this.selected,
    required this.onSelected,
    this.truncated = false,
  });

  final Map<TaskView, int> counts;
  final TaskView selected;
  final ValueChanged<TaskView> onSelected;
  final bool truncated;

  /// Tek satıra geçilen genişlik (kutucuk ~85'ten geniş kalır).
  static const singleRowMinWidth = 720.0;

  static const _gap = NizamioSpacing.space2;

  static const _first = [
    (TaskView.all, 2),
    (TaskView.late, 1),
    (TaskView.inProgress, 1),
  ];
  static const _second = [
    (TaskView.review, 1),
    (TaskView.dateRequest, 1),
    (TaskView.notStarted, 1),
    (TaskView.done, 1),
  ];

  @override
  Widget build(BuildContext context) {
    Widget tile(TaskView v) => _ViewTile(
      view: v,
      count: counts[v] ?? 0,
      truncated: truncated,
      selected: v == selected,
      onTap: () => onSelected(v),
    );
    // Kaynak ızgarası `repeat(4, minmax(0, 1fr))` + `gap: 8px`; "Tümü" 2 sütun kaplar
    // (genişlik 2 sütun + 1 boşluk; oranla paylaştırma değil).
    Widget row(List<(TaskView, int)> items, double col) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: _gap,
        children: [
          for (final (v, span) in items)
            SizedBox(width: span * col + (span - 1) * _gap, child: tile(v)),
        ],
      ),
    );
    return Semantics(
      container: true,
      label: context.l10n.uiTasksViews,
      child: LayoutBuilder(
        builder: (context, box) {
          final single = box.maxWidth >= singleRowMinWidth;
          final columns = single ? 8 : 4;
          final col = (box.maxWidth - (columns - 1) * _gap) / columns;
          return Column(
            spacing: _gap,
            children: single
                ? [
                    row([..._first, ..._second], col),
                  ]
                : [row(_first, col), row(_second, col)],
          );
        },
      ),
    );
  }
}

// Tablet kaynak görünüm kutucuğu: sayı `rp-num` 22/26, etiket 11/14.
const _tileNum = 22.0;
const _tileNumLine = 26.0;
const _tileLabel = 11.0;
const _tileLabelLine = 14.0;

class _ViewTile extends StatelessWidget {
  const _ViewTile({
    required this.view,
    required this.count,
    required this.truncated,
    required this.selected,
    required this.onTap,
  });

  final TaskView view;
  final int count;
  final bool truncated;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tablet = NzTabletMetrics.tabletVisualAt(
      MediaQuery.sizeOf(context).width,
    );
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final numColor = switch (view) {
      TaskView.late => c.danger,
      TaskView.dateRequest => c.warning,
      _ => c.text,
    };
    return Semantics(
      button: true,
      selected: selected,
      label: '${l.viewLabel(view)}, ${truncated ? '≥' : ''}$count',
      excludeSemantics: true,
      child: NzPressable.card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(NizamioRadius.group),
          child: AnimatedContainer(
            duration: NzMotion.of(context, NizamioMotion.durPress),
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.all(NizamioSpacing.gapMd),
            decoration: BoxDecoration(
              color: selected ? c.surfaceOverlay : c.surface,
              borderRadius: BorderRadius.circular(NizamioRadius.group),
              border: Border.all(
                color: selected ? c.accentText : c.border,
                width: NizamioSize.borderWidth,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: NizamioSpacing.space1,
              children: [
                NzDot(color: viewDot(view, c)),
                Text(
                  '${truncated ? '≥' : ''}$count',
                  style: tablet
                      ? t.titleSm.copyWith(
                          fontSize: _tileNum,
                          height: _tileNumLine / _tileNum,
                          color: numColor,
                        )
                      : t.titleSm.copyWith(color: numColor),
                ),
                Text(
                  l.viewLabel(view),
                  maxLines: tablet ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: tablet
                      ? t.caption.copyWith(
                          fontSize: _tileLabel,
                          height: _tileLabelLine / _tileLabel,
                          color: c.textMuted,
                        )
                      : t.caption.copyWith(color: c.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
