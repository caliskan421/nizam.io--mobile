import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../tasks/tasks.dart';

/// İade edilenler devam edenlere katılır; bilinmeyen durum ayrı sayılır.
Map<TaskStatus, int> homeOverviewCounts(Iterable<TaskStatus> statuses) {
  final counts = {for (final status in TaskStatus.values) status: 0};
  for (final status in statuses) {
    final group = status == TaskStatus.returned
        ? TaskStatus.inProgress
        : status;
    counts[group] = counts[group]! + 1;
  }
  return counts;
}

const _order = [
  TaskStatus.done,
  TaskStatus.review,
  TaskStatus.inProgress,
  TaskStatus.todo,
  TaskStatus.unknown,
];

class HomeOverview extends ConsumerWidget {
  const HomeOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => NzAsyncView<TaskCatalog>(
    value: ref.watch(taskCatalogControllerProvider),
    skeletonOnReload: true,
    loading: const NzSkeleton.block(height: 190),
    onRetry: () => ref.invalidate(taskCatalogControllerProvider),
    data: (catalog) => _OverviewCard(catalog: catalog),
  );
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.catalog});
  final TaskCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final counts = homeOverviewCounts(catalog.tasks.map((task) => task.status));
    final total = catalog.tasks.length;
    String label(TaskStatus status) => switch (status) {
      TaskStatus.done => l.uiTasksStatusDone,
      TaskStatus.review => l.uiTasksStatusReview,
      TaskStatus.inProgress => l.uiTasksStatusDoing,
      TaskStatus.returned => l.uiTasksStatusReturned,
      TaskStatus.todo => l.uiTasksStatusTodo,
      TaskStatus.unknown => l.uiTasksTagUnknown,
    };
    Color color(TaskStatus status) => switch (status) {
      TaskStatus.done => c.taskDone,
      TaskStatus.review => c.warning,
      TaskStatus.inProgress => c.inProgress,
      TaskStatus.returned => c.danger,
      TaskStatus.todo => c.textFaint,
      TaskStatus.unknown => c.info,
    };
    int percent(TaskStatus status) =>
        total == 0 ? 0 : (counts[status]! * 100 / total).round();
    final visible = [
      for (final s in _order)
        if (counts[s]! > 0) s,
    ];
    final semantics =
        '${catalog.truncated ? '≥' : ''}$total ${l.uiHomeTasksLc}: '
        '${[for (final s in visible) '${label(s)} ${counts[s]}, %${percent(s)}'].join('; ')}';
    final open = context.appNav.openTasks;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 720;
        final ringSize = wide ? 140.0 : 132.0;
        Widget legend(TaskStatus s) => Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color(s),
                shape: BoxShape.circle,
              ),
            ),
            const Gap(8),
            Expanded(
              child: Text(
                label(s),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodySm.copyWith(fontSize: 13, color: c.textMuted),
              ),
            ),
            const Gap(8),
            Text(
              '%${percent(s)}',
              style: t.monoSm.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.text,
              ),
            ),
          ],
        );
        Widget wideLegend(TaskStatus s) => Container(
          padding: const EdgeInsets.only(left: 18, top: 6, bottom: 6),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: c.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color(s),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(8),
                  Flexible(
                    child: Text(
                      label(s),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySm.copyWith(
                        fontSize: 12,
                        height: 16 / 12,
                        color: c.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '%${percent(s)}',
                  maxLines: 1,
                  style: t.titleLg.copyWith(
                    fontSize: 26,
                    height: 30 / 26,
                    letterSpacing: -.52,
                    fontWeight: FontWeight.w600,
                    color: c.text,
                  ),
                ),
              ),
            ],
          ),
        );
        final items = wide
            ? LayoutBuilder(
                builder: (context, box) {
                  if (visible.isEmpty) return const SizedBox.shrink();
                  final minimum = MediaQuery.textScalerOf(context).scale(75);
                  if (box.maxWidth / visible.length < minimum) {
                    final columns = (box.maxWidth / minimum).floor().clamp(
                      1,
                      visible.length,
                    );
                    return Wrap(
                      runSpacing: 14,
                      children: [
                        for (final s in visible)
                          SizedBox(
                            width: box.maxWidth / columns,
                            child: wideLegend(s),
                          ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      for (final s in visible) Expanded(child: wideLegend(s)),
                    ],
                  );
                },
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (i, s) in visible.indexed) ...[
                    if (i > 0) const Gap(8),
                    legend(s),
                  ],
                ],
              );
        final ring = Semantics(
          button: true,
          label: semantics,
          onTap: open,
          excludeSemantics: true,
          child: GestureDetector(
            onTap: open,
            child: SizedBox.square(
              dimension: ringSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size.square(ringSize),
                    painter: _RingPainter(
                      counts: counts,
                      total: total,
                      colors: {for (final s in _order) s: color(s)},
                      track: c.surfaceRaised,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${catalog.truncated ? '≥' : ''}$total',
                        style: t.titleLg.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: c.text,
                        ),
                      ),
                      Text(
                        l.uiHomeTasksLc,
                        style: t.caption.copyWith(
                          fontSize: 12,
                          color: c.textFaint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(wide ? 22 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.uiHomeOverviewTitle,
                  style: t.bodyMd.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.text,
                  ),
                ),
                const Gap(14),
                Row(
                  children: [
                    if (wide)
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: ring,
                        ),
                      )
                    else
                      ring,
                    if (!wide) const Gap(18),
                    Expanded(flex: wide ? 4 : 1, child: items),
                  ],
                ),
                if (catalog.truncated) ...[
                  const Gap(12),
                  Text(
                    l.uiListsTruncated,
                    style: t.caption.copyWith(color: c.textMuted),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.counts,
    required this.total,
    required this.colors,
    required this.track,
  });
  final Map<TaskStatus, int> counts;
  final int total;
  final Map<TaskStatus, Color> colors;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 120;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: 46 * scale,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12 * scale
      ..color = track;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint);
    if (total == 0) return;
    var angle = -math.pi / 2;
    for (final status in _order) {
      final sweep = math.pi * 2 * counts[status]! / total;
      final visible = math.max(0.0, sweep - 1.6 / 46);
      if (visible > 0) {
        paint.color = colors[status]!;
        canvas.drawArc(rect, angle, visible, false, paint);
      }
      angle += sweep;
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.counts.toString() != counts.toString() ||
      old.total != total ||
      old.track != track ||
      old.colors.toString() != colors.toString();
}
