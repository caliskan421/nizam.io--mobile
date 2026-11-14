part of 'gantt_chart.dart';

/// Yapışkan sol etiket sütunu (saydam zemin; camı altındaki sabit panel verir) ya da boş
/// durum metni. Sabit satır yüksekliğiyle yalnız görünür (ve önbellek payındaki) satırlar
/// kurulur; dikey ofset gövdeyle aynıdır.
class _Labels extends StatelessWidget {
  const _Labels({
    required this.layout,
    required this.offset,
    required this.height,
    required this.onToggleGroup,
    required this.expandedTasks,
    required this.onToggleSubtasks,
    required this.onPick,
  });

  final GanttLayout layout;
  final Set<String> expandedTasks;
  final ValueChanged<String>? onToggleSubtasks;
  final ViewportOffset offset;

  /// Gövdeyle aynı içerik boyu (boş durumda).
  final double height;
  final ValueChanged<String> onToggleGroup;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final rows = layout.rows;
    return Viewport(
      key: GanttChart.labelsKey,
      offset: offset,
      slivers: [
        if (layout.view.empty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: GanttGeometry.emptyPad,
                      ),
                      child: Text(
                        context.l10n.uiTimelineGanttEmpty,
                        textAlign: TextAlign.center,
                        style: context.text.bodyMd.copyWith(
                          color: context.colors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverFixedExtentList(
            itemExtent: GanttGeometry.row,
            delegate: SliverChildBuilderDelegate(
              (context, i) => switch (rows[i].row) {
                final GanttHeadRow h => _GroupLabel(
                  head: h,
                  compact: layout.labelWidth < 300,
                  onTap: () => onToggleGroup(h.code),
                ),
                final GanttSubtaskRow s => _SubtaskLabel(subtask: s.subtask),
                final GanttTaskRow r => _TaskLabel(
                  row: r,
                  expanded: expandedTasks.contains(r.task.code),
                  onToggleSubtasks: onToggleSubtasks == null
                      ? null
                      : () => onToggleSubtasks!(r.task.code),
                  compact: layout.labelWidth < 300,
                  onTap: () => onPick(r.task.code),
                ),
              },
              childCount: rows.length,
            ),
          ),
      ],
    );
  }
}

/// Grup başlığı (prototip `button[aria-expanded]`): ok, kod, ad, gecikme sayısı, görev sayısı.
class _GroupLabel extends StatelessWidget {
  const _GroupLabel({
    required this.head,
    required this.onTap,
    required this.compact,
  });

  final GanttHeadRow head;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l = context.l10n;
    final side = BorderSide(color: c.border);
    final late = head.late > 0 ? l.ganttGroupLate(head.late) : null;
    return Semantics(
      button: true,
      expanded: head.open,
      label: [
        if (head.label != head.name) head.label,
        l.groupTitle(head.code, head.name),
        ?late,
        '${head.count}',
      ].join(' '),
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _groupGlass(c),
            border: Border(top: side, right: side),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: GanttGeometry.groupPadLeft,
              right: GanttGeometry.groupPadRight,
            ),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: head.open ? 0.25 : 0,
                  duration: NzMotion.of(context, GanttGeometry.chevronDuration),
                  curve: NizamioMotion.easeSpring,
                  child: NzIcon(
                    NzIcons.chevronRight,
                    size: NizamioSize.iconSizeSm,
                    color: c.textFaint,
                  ),
                ),
                const Gap(NizamioSpacing.space2),
                // Etiket ve ad tek satır: sığmazsa sonu soluklaşır (satır dışına taşmaz).
                // Departman kodu yoksa etiket addır; o zaman yalnız ad yazılır.
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        if (head.label != head.name) ...[
                          TextSpan(
                            text: head.label,
                            style: t.monoSm.copyWith(color: c.textFaint),
                          ),
                          const TextSpan(text: '  '),
                        ],
                        if (head.name.isNotEmpty) ...[
                          TextSpan(
                            text: l.groupTitle(head.code, head.name),
                            style: t.labelMd.copyWith(
                              fontSize: GanttGeometry.groupNameSize,
                            ),
                          ),
                        ],
                      ],
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (late != null && !compact) ...[
                  const Gap(NizamioSpacing.space2),
                  Text(
                    late,
                    style: t.monoSm.copyWith(
                      fontSize: GanttGeometry.tickFontSize,
                      color: c.danger,
                    ),
                  ),
                ],
                const Gap(NizamioSpacing.space2),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: GanttGeometry.countMinWidth,
                  ),
                  child: Text(
                    '${head.count}',
                    textAlign: TextAlign.right,
                    style: t.monoSm.copyWith(color: c.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Görev satırının sol etiketi (prototip `button[aria-pressed]`): gri anahtar (koordinatörlük
/// etiketi + sıra; gecikmede kırmızı) ve beyaz, kalın başlık; dokununca seçer. Uzun etiket ve
/// başlık sonda soluklaşır, numara görünür kalır.
class _TaskLabel extends StatelessWidget {
  const _TaskLabel({
    required this.row,
    required this.onTap,
    required this.compact,
    required this.expanded,
    this.onToggleSubtasks,
  });

  final GanttTaskRow row;
  final bool expanded;
  final VoidCallback? onToggleSubtasks;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final task = row.task;
    final keyStyle = t.monoSm.copyWith(
      color: task.late ? c.danger : c.textFaint,
    );
    return Semantics(
      button: true,
      selected: row.selected,
      label: context.l10n.ganttRowLabel(row),
      excludeSemantics: false,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.glassBar,
            border: Border(right: BorderSide(color: c.border)),
          ),
          child: Tooltip(
            message: compact ? '${row.key} · ${task.item.title}' : '',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      row.key.toLowerCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: keyStyle,
                    ),
                  ),
                  const Gap(10),
                  SizedBox.square(
                    dimension: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: ganttStatusColor(c, task.status),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  if (compact && task.item.subtaskTotal > 0) const Spacer(),
                  if (!compact) ...[
                    const Gap(10),
                    Expanded(
                      child: Text(
                        task.item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMd.copyWith(
                          fontSize: GanttGeometry.rowTitleSize,
                          fontWeight: FontWeight.w600,
                          color: c.text,
                        ),
                      ),
                    ),
                  ],
                  if (task.item.subtaskTotal > 0 && onToggleSubtasks != null)
                    Tooltip(
                      message: expanded
                          ? 'Alt görevleri kapat'
                          : 'Alt görevleri göster',
                      child: InkWell(
                        onTap: onToggleSubtasks,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 5,
                          ),
                          child: Text(
                            '${task.item.subtaskDoneTotal}/${task.item.subtaskTotal}',
                            style: t.monoSm.copyWith(color: c.textMuted),
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

class _SubtaskLabel extends StatelessWidget {
  const _SubtaskLabel({required this.subtask});
  final Subtask subtask;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.glassBar,
        border: Border(right: BorderSide(color: c.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(
              subtask.done
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: subtask.done ? c.taskDone : c.textMuted,
            ),
            const Gap(10),
            Expanded(
              child: Text(
                subtask.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnIconPainter extends CustomPainter {
  const _ColumnIconPainter({required this.color, required this.expand});
  final Color color;
  final bool expand;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate((size.width - 24) / 2, (size.height - 24) / 2);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.75
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawRect(const Rect.fromLTWH(4, 4, 16, 16), p);
    canvas.drawLine(const Offset(9, 4), const Offset(9, 20), p);
    final path = Path()
      ..moveTo(expand ? 13 : 15, 10)
      ..lineTo(expand ? 15 : 13, 12)
      ..lineTo(expand ? 13 : 15, 14);
    canvas.drawPath(path, p);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ColumnIconPainter old) =>
      old.color != color || old.expand != expand;
}
