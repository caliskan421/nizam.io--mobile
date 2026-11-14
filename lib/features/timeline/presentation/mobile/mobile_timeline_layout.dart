import 'dart:math' as math;
import 'dart:ui';

import '../../domain/timeline.dart';

/// Mobil referansın yatay ekseni. Tarihler ve taslaklar mevcut TimelineView'dan gelir;
/// tabletin sütunları ve boş koordinatörlük seçim anlamı bu yerleşime taşınmaz.
final class MobileTimelineLayout {
  MobileTimelineLayout(this.view) {
    var y = 0.0;
    for (final group in view.groups) {
      // Grubun görevleri (koordinatörlük ya da durum grubu; süzgeçlerden geçmiş).
      final tasks = [for (final (t, _) in group.placed) t]
        ..sort((a, b) {
          final start = a.packStart.compareTo(b.packStart);
          return start != 0 ? start : a.packEnd.compareTo(b.packEnd);
        });
      if (tasks.isEmpty) continue;
      heads.add(
        MobileTimelineHead(
          group,
          y,
          tasks.map((t) => t.packStart).reduce(math.min),
          tasks.map((t) => t.packEnd).reduce(math.max),
        ),
      );
      y += groupHeight;
      if (view.state.closedGroups.contains(group.code)) continue;
      for (final task in tasks) {
        bars.add(MobileTimelineBar(task, y, ppd));
        y += rowHeight;
      }
    }
    height = y + 140;
  }

  static const axisHeight = 46.0;
  static const rowHeight = 44.0;
  static const groupHeight = 40.0;
  static const leftPad = 16.0;
  final TimelineView view;
  final heads = <MobileTimelineHead>[];
  final bars = <MobileTimelineBar>[];
  late final double height;
  double get ppd => switch (view.state.scale) {
    TimelineScale.day => 34,
    TimelineScale.week => 8,
    TimelineScale.month => 2.6,
  };
  double get width => leftPad + view.days * ppd + 120;
  double get todayX =>
      x(view.today) + (view.state.scale == TimelineScale.day ? ppd / 2 : 0);
  double x(num day) => leftPad + day * ppd;
  MobileTimelineBar? barOf(String code) =>
      bars.where((b) => b.task.code == code).firstOrNull;
}

final class MobileTimelineHead {
  const MobileTimelineHead(this.group, this.top, this.start, this.end);
  final TimelineGroup group;
  final double top;
  final int start;
  final int end;
}

final class MobileTimelineBar {
  MobileTimelineBar(this.task, this.top, double ppd)
    : rect = Rect.fromLTWH(
        MobileTimelineLayout.leftPad + task.range.start * ppd,
        top + 7,
        math.max(10, (task.visibleEnd - task.range.start) * ppd),
        30,
      ),
      planWidth = math.max(1, (task.range.end - task.range.start) * ppd),
      requestWidth = task.request == null
          ? 0
          : math.max(0, (task.request! - task.visibleEnd) * ppd);
  final TimelineTask task;
  final double top;
  final Rect rect;
  final double planWidth;
  final double requestWidth;
}
