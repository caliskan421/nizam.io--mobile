import 'dart:math' as math;
import 'dart:ui';

import '../../domain/timeline.dart';

/// Çizelge geometrisi (prototip `geo()` ve `renderVals` ölçüleri). Token'ı olmayan çizelge
/// ölçüleri burada yorumlu sabittir; renk/yazı painter'da temadan gelir.
abstract final class TimelineGeometry {
  /// Çizelgenin üstüne binen başlık çubuğu (koordinatörlük + filtre) yüksekliği (`HH`).
  static const header = 44.0;

  /// İçeriğin ilk günü başlığın 12 px altında başlar (`PADT`).
  static const topPad = header + 12;

  /// Soldaki yapışkan tarih sütunu genişliği.
  static const dateColumn = 52.0;

  /// İlk görev sütununun sol kenarı (`X0`).
  static const firstX = 58.0;

  /// Şeritler arası boşluk (`GAP`).
  static const laneGap = 5.0;

  /// Çoklu koordinatörlükte grup arası ek boşluk.
  static const groupGap = 12.0;

  /// Çoklu görünümde grup sütunu asgari genişliği.
  static const groupMinWidth = 112.0;

  /// Çoklu görünümde şerit genişliği; tekli görünümde 32–44 arası.
  static const multiLane = 34.0;
  static const minLane = 32.0;
  static const maxLane = 44.0;

  /// Son günün altında kalan pay (sezon şeridi ve kartın altında kalmasın).
  static const tail = 230.0;

  /// Çoklu görünümde yapışkan koordinatörlük adı satırı.
  static const groupHeader = 28.0;

  /// Çubuğun asgari yüksekliği (dar ölçekte bile dokunulabilir).
  static const minBar = 18.0;

  /// Genel bakış sütunları arası boşluk.
  static const overviewGap = 4.0;

  static double pixelsPerDay(TimelineScale s) => switch (s) {
    TimelineScale.day => 30,
    TimelineScale.week => 7,
    TimelineScale.month => 2.4,
  };
}

/// Bir görev çubuğunun yerleşimi (içerik koordinatı).
final class TimelineBarGeom {
  const TimelineBarGeom({
    required this.task,
    required this.rect,
    required this.planHeight,
    required this.request,
  });

  final TimelineTask task;
  final Rect rect;

  /// Planlanan kısmın yüksekliği; altı gecikme/geç bitiş kısmı.
  final double planHeight;

  /// Tarih talebi çerçevesi (çubuğun altından istenen bitişe).
  final Rect? request;

  bool get overrun => task.overrun;
}

/// Çoklu görünümde yapışkan grup başlığı.
final class TimelineHeadGeom {
  const TimelineHeadGeom({
    required this.group,
    required this.x,
    required this.width,
    required this.first,
  });

  final TimelineGroup group;
  final double x;
  final double width;
  final bool first;
}

/// Genel bakış sütunu ve ince şeritleri.
final class TimelineOverviewGeom {
  const TimelineOverviewGeom({
    required this.group,
    required this.column,
    required this.strips,
  });

  final TimelineGroup group;
  final Rect column;
  final List<(TimelineTask, Rect, double)> strips;
}

/// Görünüm + genişlikten çizelge yerleşimi (saf; test edilebilir).
final class TimelineLayout {
  TimelineLayout._({
    required this.view,
    required this.ppd,
    required this.bodyHeight,
    required this.contentWidth,
    required this.bars,
    required this.heads,
    required this.separators,
    required this.overview,
    required this.stickTop,
  });

  factory TimelineLayout.of(TimelineView v, double viewportWidth) {
    final ppd = TimelineGeometry.pixelsPerDay(v.state.scale);
    final bodyH =
        TimelineGeometry.topPad + v.days * ppd + TimelineGeometry.tail;
    double yOf(int d) => TimelineGeometry.topPad + d * ppd;
    // Prototipte 390 genişlikte 324 px kullanılabilir alan (X0 58 + sağ pay 8).
    final usable = viewportWidth - TimelineGeometry.firstX - 8;

    if (v.state.overview) {
      final groups = v.overviewGroups;
      final n = math.max(1, groups.length);
      final lw = (usable - (n - 1) * TimelineGeometry.overviewGap) / n;
      final cols = <TimelineOverviewGeom>[];
      final heads = <TimelineHeadGeom>[];
      for (var i = 0; i < groups.length; i++) {
        final grp = groups[i];
        final x =
            TimelineGeometry.firstX + i * (lw + TimelineGeometry.overviewGap);
        heads.add(TimelineHeadGeom(group: grp, x: x, width: lw, first: i == 0));
        final lanes = math.max(1, grp.lanes);
        final sw = math.max(1.0, (lw - 4 - (lanes - 1)) / lanes);
        cols.add(
          TimelineOverviewGeom(
            group: grp,
            column: Rect.fromLTWH(x, 0, lw, bodyH),
            strips: [
              for (final (t, lane) in grp.placed)
                (
                  t,
                  Rect.fromLTWH(
                    x + 2 + lane * (sw + 1),
                    yOf(t.range.start),
                    sw,
                    math.max(4, (t.visibleEnd - t.range.start) * ppd),
                  ),
                  math.max(1, t.range.length * ppd),
                ),
            ],
          ),
        );
      }
      return TimelineLayout._(
        view: v,
        ppd: ppd,
        bodyHeight: bodyH,
        contentWidth: viewportWidth,
        bars: const [],
        heads: heads,
        separators: const [],
        overview: cols,
        stickTop: TimelineGeometry.header + TimelineGeometry.groupHeader + 4,
      );
    }

    final multi = v.multi;
    final totalLanes = math.max(
      1,
      v.groups.fold<int>(0, (a, grp) => a + grp.lanes),
    );
    final lw = multi
        ? TimelineGeometry.multiLane
        : ((usable - (totalLanes - 1) * TimelineGeometry.laneGap) / totalLanes)
              .clamp(TimelineGeometry.minLane, TimelineGeometry.maxLane);
    var gx = TimelineGeometry.firstX;
    final bars = <TimelineBarGeom>[];
    final heads = <TimelineHeadGeom>[];
    final seps = <double>[];
    for (var gi = 0; gi < v.groups.length; gi++) {
      final grp = v.groups[gi];
      if (gi > 0 && multi) gx += TimelineGeometry.groupGap;
      final lanesW =
          grp.lanes * lw + (grp.lanes - 1) * TimelineGeometry.laneGap;
      final w = multi
          ? math.max(lanesW, TimelineGeometry.groupMinWidth)
          : lanesW;
      final off = (w - lanesW) / 2;
      if (multi) {
        if (gi > 0) seps.add(gx - 6);
        heads.add(
          TimelineHeadGeom(
            group: grp,
            x: gx - 6,
            width: w + 12,
            first: gi == 0,
          ),
        );
      }
      for (final (t, lane) in grp.placed) {
        final x = gx + off + lane * (lw + TimelineGeometry.laneGap);
        final y = yOf(t.range.start);
        final h = math.max(
          TimelineGeometry.minBar,
          (t.visibleEnd - t.range.start) * ppd,
        );
        bars.add(
          TimelineBarGeom(
            task: t,
            rect: Rect.fromLTWH(x, y, lw, h),
            planHeight: math.max(1, t.range.length * ppd),
            request: t.hasRequest
                ? Rect.fromLTWH(x, y + h, lw, (t.request! - t.visibleEnd) * ppd)
                : null,
          ),
        );
      }
      gx += w + TimelineGeometry.laneGap;
    }
    return TimelineLayout._(
      view: v,
      ppd: ppd,
      bodyHeight: bodyH,
      contentWidth: math.max(viewportWidth, gx - TimelineGeometry.laneGap + 8),
      bars: bars,
      heads: heads,
      separators: seps,
      overview: const [],
      stickTop:
          TimelineGeometry.header +
          (multi ? TimelineGeometry.groupHeader + 4 : 4),
    );
  }

  final TimelineView view;
  final double ppd;
  final double bodyHeight;
  final double contentWidth;
  final List<TimelineBarGeom> bars;
  final List<TimelineHeadGeom> heads;
  final List<double> separators;
  final List<TimelineOverviewGeom> overview;

  /// Yapışkan çubuk etiketlerinin görünür alandaki üst sınırı.
  final double stickTop;

  bool get dayScale => view.state.scale == TimelineScale.day;

  double yOf(int day) => TimelineGeometry.topPad + day * ppd;

  /// Bugün çizgisi (gün ölçeğinde günün ortası).
  double get todayY => yOf(view.today) + (dayScale ? ppd / 2 : 0);

  /// "Bugüne dön" kaydırma hedefi (bugün çizgisi görünür alanın üst kısmında).
  double get todayOffset => yOf(view.today) - 150;

  /// Seçili çubuk önce; sonra çizim sırasının tersi (üstteki).
  TimelineBarGeom? barAt(Offset p) {
    final sel = view.state.selected;
    for (final b in bars) {
      if (b.task.code == sel && b.rect.inflate(2).contains(p)) return b;
    }
    for (final b in bars.reversed) {
      if (b.rect.inflate(2).contains(p)) return b;
    }
    return null;
  }

  TimelineOverviewGeom? overviewAt(Offset p) {
    for (final o in overview) {
      if (o.column.contains(p)) return o;
    }
    return null;
  }

  TimelineBarGeom? barOf(String code) =>
      bars.where((b) => b.task.code == code).firstOrNull;
}
