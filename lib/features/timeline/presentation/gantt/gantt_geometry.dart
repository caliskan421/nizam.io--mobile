import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../domain/horizontal_timeline.dart';

/// Yatay çizelgenin ölçüleri (tablet prototipi `12-Tablet.dc.html` "Yatay zaman çizelgesi · tam
/// genişlik" ve `S_hgantt`). Değerler kaynak CSS'tendir; çizelgeye özgü olduğu için token değildir.
abstract final class GanttGeometry {
  /// Üst başlık (geri, başlık, süzgeç, ölçek, Bugün): 72; yan dolgu sol 12, sağ 20.
  static const double header = 72;
  static const double headerPadLeft = 12;
  static const double headerPadRight = 20;

  /// Koordinatörlük çipleri: 32 yükseklik, 12 yatay dolgu, 6 aralık; şerit yanları 20, altı 12.
  static const double chip = 32;
  static const double chipPad = 12;
  static const double chipGap = 6;
  static const double chipFontSize = 12.5;

  /// Süzgeç / ölçek kapsülü: 3 iç dolgu, 34 düğme, 14 yan dolgu. Bugün düğmesi 40, 16 yan.
  static const double segPad = 3;
  static const double segButton = 34;
  static const double segButtonPad = 14;
  static const double todayButton = 40;
  static const double todayButtonPad = 16;

  /// Geri düğmesi 44, dolgu sol 6 sağ 12, ikon–metin 4.
  static const double backHeight = 44;
  static const double backPadLeft = 6;
  static const double backPadRight = 12;

  /// Başlık yazısı 22/28.
  static const double titleSize = 22;
  static const double titleLine = 28;

  /// Geri düğmesi yazısı 14; ay adı 12.
  static const double backFontSize = 14;
  static const double monthFontSize = 12;

  /// Yapışkan tarih başlığı 52: ay adları üstten 6 (12/16, sol çizgi + 8 dolgu), gün işaretleri
  /// üstten 28 (10.5/16, 4 dolgu), "bugün" hapı üstten 28 (10/16, 6 yan dolgu).
  static const double stickyHeader = 52;
  static const double monthTop = 6;
  static const double monthPad = 8;
  static const double tickTop = 28;
  static const double tickPad = 4;
  static const double headLine = 16;
  static const double tickFontSize = 10.5;
  static const double pillFontSize = 10;
  static const double pillPad = 6;

  /// Sol etiket sütunu (`LW`) ve satır yüksekliği.
  static const double labelWidth = 300;
  static const double row = 40;

  /// Etiket sütunu başlığı: yan 16, alt 8. Grup başlığı dolgusu sol 10 sağ 12; görev satırı sol 34
  /// sağ 12, kod sütunu 56, aralık 8.
  static const double labelHeadPad = 16;
  static const double labelHeadBottom = 8;
  static const double groupPadLeft = 10;
  static const double groupPadRight = 12;
  static const double taskPadLeft = 34;
  static const double idColumn = 56;
  static const double groupNameSize = 13.5;
  static const double countMinWidth = 22;

  /// Görev çubuğu: üstten 9, 22 yükseklik, 6 köşe, 8 yan dolgu, en az 6 genişlik; yazı 11.5.
  static const double barTop = 9;
  static const double barHeight = 22;
  static const double barRadius = 6;
  static const double barPad = 8;
  static const double minBar = 6;
  static const double barFontSize = 11.5;

  /// Seçili çubuk halkası 2.
  static const double ring = 2;

  /// Başlık çubuğa sığar mı: genişlik ≥ min(260, harf × 6.6 + 24).
  static const double insideMax = 260;
  static const double charWidth = 6.6;
  static const double insidePad = 24;

  /// Çubuk dışındaki başlık: çubuğun (ya da gecikmenin) sonundan 8 sonra, en çok 280; 12/20.
  static const double outsideGap = 8;
  static const double outsideMax = 280;
  static const double outsideTop = 10;
  static const double outsideLine = 20;

  /// Gecikme şeridi: üstten 10, 20 yükseklik, en az 3; sağ köşe 6; çizgi deseni 5 + 5.
  static const double lateTop = 10;
  static const double lateHeight = 20;
  static const double minLate = 3;
  static const double hatch = 5;
  static const double hatchSoft = 0.45;

  /// Grup özet çizgisi: üstten 18, 4 yükseklik, en az 4.
  static const double summaryTop = 18;
  static const double summaryHeight = 4;
  static const double minSummary = 4;

  /// Bugün çizgisi 2; Teknofest gölgesi danger %9, lejant örneği %30; seçili satır %6.
  static const double todayLine = 2;
  static const double festAlpha = 0.09;
  static const double festLegendAlpha = 0.30;
  static const double selectedRowAlpha = 0.06;

  /// Lejant: 40 yükseklik, yan 20, öğeler arası 18; örnek 14 × 8, köşe 3, çizgi deseni 3 + 3.
  static const double legend = 40;
  static const double legendPad = 20;
  static const double legendGap = 18;
  static const double swatchWidth = 14;
  static const double swatchHeight = 8;
  static const double swatchRadius = 3;
  static const double swatchHatch = 3;

  /// Seçili görev kartı: sağdan 20, alttan 56, 360 genişlik, 16 dolgu, 12 aralık, 22 köşe,
  /// %92 yüzey + 20 bulanıklık; bilgi kutusu 12 dolgu, 14 köşe, aralık 10 × 12.
  static const double cardRight = 20;
  static const double cardBottom = 56;
  static const double cardWidth = 360;
  static const double cardPad = 16;
  static const double cardGap = 12;
  static const double cardRadius = 22;
  static const double cardAlpha = 0.92;
  static const double cardBlur = 20;
  static const double cardClose = 32;
  static const double cardCloseInset = -6;
  static const double cardCodeSize = 12;
  static const double cardTitleSize = 16;
  static const double cardTitleLine = 22;
  static const double cardInfoPad = 12;
  static const double cardInfoRadius = 14;
  static const double cardInfoRowGap = 10;
  static const double cardInfoColGap = 12;
  static const double cardKeySize = 10.5;
  static const double statusDot = 8;

  /// Boş durum: dikey 48 dolgu.
  static const double emptyPad = 48;

  /// Görev satırı başlığı 13.
  static const double rowTitleSize = 13;

  /// Açılışta / ölçek değişince / Bugün'de bugün, tarih alanının %40'ına gelir.
  static const double centerBias = 0.4;

  /// Geçişler: Bugün kaydırması (`behavior: smooth`), grup oku .35 s, süzgeç kapsülü .25 s, çip
  /// .22 s, seçili halka .2 s, kart girişi .32 s (`rpRiseIn`).
  static const centerDuration = Duration(milliseconds: 420);
  static const chevronDuration = Duration(milliseconds: 350);
  static const segDuration = Duration(milliseconds: 250);
  static const chipDuration = Duration(milliseconds: 220);
  static const ringDuration = Duration(milliseconds: 200);
  static const cardDuration = Duration(milliseconds: 320);
  static const double cardRise = 14;
  static const double cardRiseScale = 0.98;

  /// Kaynak SVG yolları (`t-icon`, 24 × 24): geri, grup oku, kapat.
  static const chevronLeft = 'M15 5l-7 7 7 7';
  static const chevronRight = 'M9 6l6 6-6 6';
  static const close = 'M6 6l12 12M18 6 6 18';

  /// Gün başına piksel (`ppd`).
  static double ppd(GanttZoom z) => switch (z) {
    GanttZoom.week => 28,
    GanttZoom.month => 10,
    GanttZoom.season => 3.4,
  };

  /// Prototip `center`: `max(0, TD × ppd − (clientWidth − LW) × 0.4)`; kaydırma sınırında kesilir.
  static double centerOffset({
    required int today,
    required double ppd,
    required double viewport,
    double maxExtent = double.infinity,
  }) => math
      .max(0.0, today * ppd - (viewport - labelWidth) * centerBias)
      .clamp(0.0, math.max(0.0, maxExtent));

  /// Başlık çubuğun içine yazılır mı (`inside`).
  static bool titleInside(double barWidth, String title) =>
      barWidth >= math.min(insideMax, title.length * charWidth + insidePad);
}

/// Satırın tarih alanındaki yerleşimi (tarih alanı koordinatı: x 0 = 1 Ocak).
@immutable
final class GanttRowBox {
  const GanttRowBox({
    required this.row,
    required this.top,
    this.bar,
    this.late,
    this.summary,
    this.inside = false,
    this.outsideX = 0,
  });

  final GanttRow row;
  final double top;

  /// Görev çubuğu.
  final Rect? bar;

  /// Gecikme / geç bitiş şeridi.
  final Rect? late;

  /// Grup özet çizgisi.
  final Rect? summary;
  final bool inside;

  /// Çubuk dışı başlığın sol kenarı.
  final double outsideX;
}

/// Ay başlığı.
@immutable
final class GanttMonth {
  const GanttMonth({required this.month, required this.x, required this.width});

  /// 1–12.
  final int month;
  final double x;
  final double width;
}

/// Gün işareti (hafta: her gün; ay: pazartesiler; sezon: yok).
@immutable
final class GanttTick {
  const GanttTick({
    required this.day,
    required this.date,
    required this.x,
    required this.weekend,
    required this.today,
  });

  final int day;

  /// Ayın günü.
  final int date;
  final double x;
  final bool weekend;
  final bool today;
}

/// Görünümün ölçekteki yerleşimi. Görünüm ya da ölçek değişince bir kez kurulur; kaydırma
/// yeniden kurmaz.
@immutable
final class GanttLayout {
  const GanttLayout._({
    required this.view,
    required this.ppd,
    required this.width,
    required this.rows,
    required this.months,
    required this.ticks,
  });

  factory GanttLayout.of(GanttView v) {
    final ppd = GanttGeometry.ppd(v.state.zoom);
    final boxes = <GanttRowBox>[];
    var y = 0.0;
    for (final r in v.rows) {
      switch (r) {
        case GanttHeadRow():
          boxes.add(
            GanttRowBox(
              row: r,
              top: y,
              summary: Rect.fromLTWH(
                r.start * ppd,
                y + GanttGeometry.summaryTop,
                math.max(GanttGeometry.minSummary, (r.end - r.start) * ppd),
                GanttGeometry.summaryHeight,
              ),
            ),
          );
        case GanttTaskRow(:final task):
          final bw = math.max(
            GanttGeometry.minBar,
            (task.end - task.start) * ppd,
          );
          final lateTo = task.lateTo;
          boxes.add(
            GanttRowBox(
              row: r,
              top: y,
              bar: Rect.fromLTWH(
                task.start * ppd,
                y + GanttGeometry.barTop,
                bw,
                GanttGeometry.barHeight,
              ),
              late: lateTo == null
                  ? null
                  : Rect.fromLTWH(
                      task.end * ppd,
                      y + GanttGeometry.lateTop,
                      math.max(
                        GanttGeometry.minLate,
                        (lateTo - task.end) * ppd,
                      ),
                      GanttGeometry.lateHeight,
                    ),
              inside: GanttGeometry.titleInside(bw, task.item.title),
              outsideX: (lateTo ?? task.end) * ppd + GanttGeometry.outsideGap,
            ),
          );
      }
      y += GanttGeometry.row;
    }
    final y0 = DateTime.utc(v.year);
    int dayOf(DateTime d) => d.difference(y0).inDays;
    return GanttLayout._(
      view: v,
      ppd: ppd,
      width: v.days * ppd,
      rows: boxes,
      months: [
        for (var m = 1; m <= 12; m++)
          GanttMonth(
            month: m,
            x: dayOf(DateTime.utc(v.year, m)) * ppd,
            width:
                (dayOf(DateTime.utc(v.year, m + 1)) -
                    dayOf(DateTime.utc(v.year, m))) *
                ppd,
          ),
      ],
      ticks: switch (v.state.zoom) {
        GanttZoom.season => const [],
        final z => [
          for (var d = 0; d < v.days; d++)
            if (z == GanttZoom.week ||
                DateTime.utc(v.year, 1, 1 + d).weekday == DateTime.monday)
              GanttTick(
                day: d,
                date: DateTime.utc(v.year, 1, 1 + d).day,
                x: d * ppd,
                weekend: DateTime.utc(v.year, 1, 1 + d).weekday > 5,
                today: d == v.today,
              ),
        ],
      },
    );
  }

  final GanttView view;
  final double ppd;

  /// Tarih alanı genişliği (`W = gün × ppd`).
  final double width;
  final List<GanttRowBox> rows;
  final List<GanttMonth> months;
  final List<GanttTick> ticks;

  /// Satırların toplam yüksekliği.
  double get rowsHeight => rows.length * GanttGeometry.row;

  /// Toplam içerik genişliği (`TW = LW + W`).
  double get totalWidth => GanttGeometry.labelWidth + width;

  /// Bugün çizgisinin tarih alanındaki x'i (`TD × ppd`).
  double get todayX => view.today * ppd;

  /// Teknofest gölgesi.
  Rect festival(double height) => Rect.fromLTWH(
    view.festival.start * ppd,
    0,
    view.festival.length * ppd,
    height,
  );

  /// Haftalık ızgara çizgilerinin x'leri (`background-size 7·ppd`, `position 4·ppd`: pazartesi).
  Iterable<double> get gridLines sync* {
    final step = 7 * ppd;
    var x = (4 * ppd) % step;
    for (; x < width; x += step) {
      yield x;
    }
  }

  GanttRowBox? boxOf(String code) => rows
      .where((b) => b.row is GanttTaskRow)
      .where((b) => (b.row as GanttTaskRow).task.code == code)
      .firstOrNull;

  /// Görev çubuğu (tarih alanı koordinatı).
  Rect? barOf(String code) => boxOf(code)?.bar;
}
