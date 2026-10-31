// HorizontalTimelinePage (tablet `S_hgantt`, ray dışı 1080 × 820): bölümler ve kaynak ölçüleri,
// açılışta bugünü ortalama, çubuğa dokun → satır vurgusu + kart (kapat / ayrıntıda aç), grup
// aç/kapa, durum süzgeci + koordinatörlük çipleri, ölçek değişince ve Bugün'de yeniden ortalama,
// yatay/dikey kaydırmada yapışkan etiket sütunu ve tarih başlığı, boş durum, geri; açık/koyu ve
// metin ölçeğinde taşma yok. Ekran durumu canlı sağlayıcıda: aynı sağlayıcıda sayfa kapat/aç,
// koordinatörlük niyeti ve yeniden boyutlanma; kart kapat düğmesinin 32 × 32 dokunma alanı.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/timeline/application/horizontal_timeline_controller.dart';
import 'package:nizamio/features/timeline/domain/horizontal_timeline.dart';
import 'package:nizamio/features/timeline/domain/timeline.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_chart.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_geometry.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_painters.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_selection_card.dart';
import 'package:nizamio/features/timeline/timeline.dart';

import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

/// Kaynak tuvali 1180 × 820, ray 100 → sayfa 1080 × 820.
const _tablet = Size(1080, 820);

final _today = seasonDay(DateTime(2026, 10, 21), 2026);

final class _Calls {
  final opened = <String>[];
  var backs = 0;
}

Future<(_Calls, RecordingAppNav)> _open(
  WidgetTester tester, {
  Size size = _tablet,
  double textScale = 1,
  bool dark = false,
  String? coordinatorship,
  bool callbacks = true,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final h = _h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectSample();
  final calls = _Calls();
  final nav = RecordingAppNav();
  await pumpScreen(
    tester,
    h,
    HorizontalTimelinePage(
      coordinatorship: coordinatorship,
      onBack: callbacks ? () => calls.backs++ : null,
      onOpenTask: callbacks ? calls.opened.add : null,
    ),
    nav: nav,
    dark: dark,
  );
  await settle(tester);
  return (calls, nav);
}

/// Son [_open]'ın düzeneği (aynı sağlayıcı kabı).
late Harness _h;

GanttState _st() => _h.read(horizontalTimelineControllerProvider);

/// Sayfayı kapatır (başka ekran) ve aynı sağlayıcı kabında yeniden açar.
Future<void> _reopen(WidgetTester tester, {String? coordinatorship}) async {
  await pumpScreen(tester, _h, const Text('başka ekran'));
  await settle(tester);
  expect(find.byType(HorizontalTimelinePage), findsNothing);
  await pumpScreen(
    tester,
    _h,
    HorizontalTimelinePage(coordinatorship: coordinatorship),
  );
  await settle(tester);
}

ScrollController _hCtrl(WidgetTester tester) => tester
    .widget<SingleChildScrollView>(find.byKey(GanttChart.horizontalKey))
    .controller!;

ScrollController _vCtrl(WidgetTester tester) => tester
    .widget<SingleChildScrollView>(find.byKey(GanttChart.verticalKey))
    .controller!;

GanttLayout _layout(WidgetTester tester) =>
    (tester.widget<CustomPaint>(find.byKey(GanttChart.bodyKey)).painter!
            as GanttBodyPainter)
        .layout;

/// Tarih alanının görünür dikdörtgeni (etiket sütunu ve yapışkan başlık hariç).
Rect _dates(WidgetTester tester) {
  final r = tester.getRect(find.byKey(GanttChart.horizontalKey));
  return Rect.fromLTRB(
    r.left + GanttGeometry.labelWidth,
    r.top + GanttGeometry.stickyHeader,
    r.right,
    r.bottom,
  );
}

/// Çubuğun görünür kısmının ortasına dokunur (gerçek dokunma).
Future<void> _tapBar(WidgetTester tester, String code) async {
  final bar = tester.getRect(find.byKey(GanttChart.barKey(code)));
  final visible = bar.intersect(_dates(tester));
  expect(
    visible.width > 0 && visible.height > 0,
    isTrue,
    reason: '$code görünür değil',
  );
  await tester.tapAt(visible.center);
  await settle(tester);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final scale in const [1.0, 1.3]) {
    for (final dark in const [false, true]) {
      testWidgets('bölümler; taşma yok [$scale × ${dark ? 'koyu' : 'açık'}]', (
        tester,
      ) async {
        await _open(tester, textScale: scale, dark: dark);
        expect(find.text(_l.uiTimelineTitle), findsOneWidget);
        expect(find.bySemanticsLabel(_l.uiTimelineGanttBackLabel), findsOne);
        expect(
          find.text(
            '76 ${_l.uiTimelineTasksLc} · '
            '${_l.uiTimelineGanttAllCoordsLc}',
          ),
          findsOneWidget,
        );
        expect(find.text('${_l.uiTimelineStatusLate} · 15'), findsOneWidget);
        for (final z in [
          _l.uiTimelineScaleWeek,
          _l.uiTimelineScaleMonth,
          _l.uiTimelineGanttScaleSeason,
        ]) {
          expect(find.text(z), findsOneWidget);
        }
        expect(find.text(_l.uiTimelineToday), findsOneWidget);
        expect(find.text(_l.uiTimelineGanttAllCoords), findsOneWidget);
        expect(find.text('SİS'), findsWidgets);
        expect(find.text(_l.uiTimelineGanttLabelHead), findsOneWidget);
        expect(find.text(_l.uiTimelineGanttTodayPill), findsOneWidget);
        expect(find.text(_l.uiTimelineGanttLegendLate), findsOneWidget);
        expect(find.text(_l.uiTimelineGanttLegendFest), findsOneWidget);
        expect(find.byKey(GanttChart.barKey('ALT-10')), findsOneWidget);
        expect(_layout(tester).rows, hasLength(87));
        expect(tester.takeException(), isNull);

        await _tapBar(tester, 'ALT-10');
        expect(find.text(_l.uiTimelineGanttOpenTask), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'kaynak ölçüleri: başlık 72, çipler, tarih başlığı 52, sütun 300, '
    'lejant 40, kart 360 (sağ 20, alt 56)',
    (tester) async {
      await _open(tester);
      final chart = tester.getRect(find.byKey(GanttChart.horizontalKey));
      // 72 başlık + 32 çip + 12 alt boşluk.
      expect(chart.top, 72 + 32 + 12);
      expect(chart.width, 1080);
      expect(chart.bottom, 820 - 40);
      expect(
        tester.getSize(find.byKey(GanttChart.headerKey)).height,
        GanttGeometry.stickyHeader,
      );
      expect(tester.getRect(find.byKey(GanttChart.labelsKey)).left, 0);
      expect(tester.getSize(find.byKey(GanttChart.labelsKey)).width, 300);
      final bar = tester.getRect(find.byKey(GanttChart.barKey('ALT-13')));
      expect(bar.height, 22);
      // Başlık satırı (ALT) 40, ardından ALT-13: üstten 9.
      expect(bar.top - _vOrigin(tester), 40 + 9);
      final today = tester.getRect(find.byKey(GanttChart.todayKey));
      expect(today.width, 2);

      await _tapBar(tester, 'ALT-10');
      final card = tester.getRect(find.byKey(HorizontalTimelinePage.cardKey));
      expect(card.width, 360);
      expect(card.right, 1080 - 20);
      expect(card.bottom, 820 - 56);
    },
  );

  testWidgets('açılışta bugün ortalanır (ay: TD × 10 − 780 × 0.4)', (
    tester,
  ) async {
    await _open(tester);
    expect(_hCtrl(tester).offset, closeTo(_today * 10 - 780 * 0.4, 0.01));
    // Bugün çizgisi görünür alanın %40'ında.
    final line = tester.getRect(find.byKey(GanttChart.todayKey)).center.dx;
    expect(line, closeTo(300 + 780 * 0.4, 1));
  });

  testWidgets(
    'çubuğa dokun → seçili satır + kart; tekrar dokun kaldırır; kapat',
    (tester) async {
      await _open(tester);
      await _tapBar(tester, 'ALT-10');
      expect(find.text('Montaj, test ve devreye alma aşaması'), findsWidgets);
      expect(find.text('Altyapı ve tesisat'), findsWidgets);
      expect(find.text('21 ${_l.uiTimelineGanttDaysLate}'), findsOneWidget);
      expect(find.text('7 Tem – 30 Eyl'), findsOneWidget);
      expect(find.text(_l.uiTimelineGanttCardStatus), findsOneWidget);
      expect(find.text(_l.uiTimelineGanttCardAssignee), findsOneWidget);
      final selected = [
        for (final b in _layout(tester).rows)
          if (b.row case GanttTaskRow(:final task, selected: true)) task.code,
      ];
      expect(selected, ['ALT-10']);

      await _tapBar(tester, 'ALT-10');
      expect(find.byKey(HorizontalTimelinePage.cardKey), findsNothing);

      await _tapBar(tester, 'ALT-10');
      await tester.tap(find.bySemanticsLabel(_l.uiCommonClose));
      await settle(tester);
      expect(find.byKey(HorizontalTimelinePage.cardKey), findsNothing);
    },
  );

  testWidgets('çubuk okuyucu etiketi: kod · başlık · tarih · durum · gecikme', (
    tester,
  ) async {
    await _open(tester);
    expect(
      find.bySemanticsLabel(
        'ALT-5 · Su deposu temel betonunun yapılması · 16 Haz – 15 Tem · '
        '${_l.uiTimelineStDoing} · ${_l.uiTimelineLateLc}',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(
        'ALT-13 · Altyapı keşif raporu · 2 Mar – 31 Mar · '
        '${_l.uiTimelineStDone}',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Görev ayrıntısını aç: kart kapanır, geri çağrı kodla', (
    tester,
  ) async {
    final (calls, nav) = await _open(tester);
    await _tapBar(tester, 'ALT-10');
    await tester.tap(find.text(_l.uiTimelineGanttOpenTask));
    await settle(tester);
    expect(calls.opened, ['ALT-10']);
    expect(nav.calls, isEmpty);
    expect(find.byKey(HorizontalTimelinePage.cardKey), findsNothing);
  });

  testWidgets('geri çağrı yoksa appNav.openTask', (tester) async {
    final (_, nav) = await _open(tester, callbacks: false);
    await _tapBar(tester, 'ALT-10');
    await tester.tap(find.text(_l.uiTimelineGanttOpenTask));
    await settle(tester);
    expect(nav.calls, ['task:ALT-10']);
  });

  testWidgets('geri: onBack', (tester) async {
    final (calls, _) = await _open(tester);
    await tester.tap(find.bySemanticsLabel(_l.uiTimelineGanttBackLabel));
    await settle(tester);
    expect(calls.backs, 1);
  });

  testWidgets('sol etiket satırı da seçer', (tester) async {
    await _open(tester);
    await tester.tap(
      find.bySemanticsLabel(
        'ALT-1 Dolamaç Mezrası–Havalimanı '
        'arası iletim hattının yapımı',
      ),
    );
    await settle(tester);
    expect(find.byKey(HorizontalTimelinePage.cardKey), findsOneWidget);
  });

  testWidgets('grup başlığı aç/kapa', (tester) async {
    await _open(tester);
    final alt = find.bySemanticsLabel(
      'ALT Altyapı ve tesisat 3 ${_l.uiTimelineGanttLateTail} 13',
    );
    expect(alt, findsOneWidget);
    await tester.tap(alt);
    await settle(tester);
    expect(find.byKey(GanttChart.barKey('ALT-1')), findsNothing);
    expect(_layout(tester).rows, hasLength(87 - 13));
    await tester.tap(alt);
    await settle(tester);
    expect(find.byKey(GanttChart.barKey('ALT-1')), findsOneWidget);
  });

  testWidgets('durum süzgeci ve koordinatörlük çipleri; sayı satırı', (
    tester,
  ) async {
    await _open(tester);
    await tester.tap(find.text('${_l.uiTimelineStatusLate} · 15'));
    await settle(tester);
    expect(
      find.text(
        '15 ${_l.uiTimelineTasksLc} · ${_l.uiTimelineGanttAllCoordsLc}',
      ),
      findsOneWidget,
    );
    expect(find.byKey(GanttChart.barKey('ALT-13')), findsNothing);

    await tester.tap(find.bySemanticsLabel('ULA'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('MEK'));
    await settle(tester);
    expect(find.text('4 ${_l.uiTimelineTasksLc} · ULA, MEK'), findsOneWidget);

    await tester.tap(find.text(_l.uiTimelineGanttAllCoords));
    await settle(tester);
    await tester.tap(find.text(_l.uiTimelineStatusOpen));
    await settle(tester);
    expect(find.byKey(GanttChart.barKey('ALT-13')), findsNothing);
    expect(find.byKey(GanttChart.barKey('ALT-10')), findsOneWidget);
  });

  testWidgets('boş durum', (tester) async {
    await _open(tester, coordinatorship: 'SİS');
    expect(find.text('4 ${_l.uiTimelineTasksLc} · SİS'), findsOneWidget);
    await tester.tap(find.text('${_l.uiTimelineStatusLate} · 15'));
    await settle(tester);
    expect(find.text(_l.uiTimelineGanttEmpty), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'ölçek: genişlik değişir, bugün yeniden ortalanır; Bugün kayarak',
    (tester) async {
      await _open(tester);
      await tester.tap(find.text(_l.uiTimelineScaleWeek));
      await settle(tester);
      expect(_layout(tester).width, 365 * 28);
      expect(_hCtrl(tester).offset, closeTo(_today * 28 - 780 * 0.4, 0.01));

      await tester.tap(find.text(_l.uiTimelineGanttScaleSeason));
      await settle(tester);
      expect(_layout(tester).width, closeTo(365 * 3.4, 0.01));
      // Sezonda hedef kaydırma sınırını aşar → sınırda durur (tarayıcı `scrollLeft` gibi).
      final max = _hCtrl(tester).position.maxScrollExtent;
      expect(max, closeTo(300 + 365 * 3.4 - 1080, 0.01));
      expect(_today * 3.4 - 780 * 0.4, greaterThan(max));
      expect(_hCtrl(tester).offset, closeTo(max, 0.01));

      await tester.tap(find.text(_l.uiTimelineScaleMonth));
      await settle(tester);
      _hCtrl(tester).jumpTo(0);
      await tester.pump();
      await tester.tap(find.text(_l.uiTimelineToday));
      await tester.pumpAndSettle();
      expect(_hCtrl(tester).offset, closeTo(_today * 10 - 780 * 0.4, 0.01));
    },
  );

  testWidgets(
    'yatay kaydırma: çubuklar kayar, etiket sütunu ve sol başlık sabit',
    (tester) async {
      await _open(tester);
      final label = find.bySemanticsLabel(RegExp('^ALT Altyapı ve tesisat'));
      final labelX = tester.getRect(label).left;
      final barX = tester.getRect(find.byKey(GanttChart.barKey('ALT-10'))).left;
      final headX = tester.getRect(find.text(_l.uiTimelineGanttLabelHead)).left;
      final x = _hCtrl(tester).offset;
      await tester.dragFrom(_dates(tester).center, const Offset(-200, 0));
      await tester.pumpAndSettle();
      expect(_hCtrl(tester).offset, greaterThan(x));
      expect(tester.getRect(label).left, labelX);
      expect(
        tester.getRect(find.text(_l.uiTimelineGanttLabelHead)).left,
        headX,
      );
      expect(
        tester.getRect(find.byKey(GanttChart.barKey('ALT-10'))).left,
        lessThan(barX),
      );
    },
  );

  testWidgets('dikey kaydırma: etiket ve çubuk birlikte, tarih başlığı sabit', (
    tester,
  ) async {
    await _open(tester);
    final header = tester.getRect(find.byKey(GanttChart.headerKey)).top;
    final label = find.bySemanticsLabel(RegExp('^MEK Mekanik sistemler'));
    final labelY = tester.getRect(label).top;
    final bar = find.byKey(GanttChart.barKey('MEK-8'));
    final barY = tester.getRect(bar).top;
    _vCtrl(tester).jumpTo(200);
    await tester.pump();
    expect(tester.getRect(label).top, labelY - 200);
    expect(tester.getRect(bar).top, barY - 200);
    expect(tester.getRect(find.byKey(GanttChart.headerKey)).top, header);
  });

  testWidgets('dikey sürükleme gerçek kaydırır', (tester) async {
    await _open(tester);
    final chart = tester.getRect(find.byKey(GanttChart.horizontalKey));
    // Etiket sütunundan ve tarih alanından sürükleme.
    await tester.dragFrom(Offset(150, chart.top + 200), const Offset(0, -300));
    await tester.pumpAndSettle();
    final y = _vCtrl(tester).offset;
    expect(y, greaterThan(0));
    final x = _hCtrl(tester).offset;
    await tester.dragFrom(_dates(tester).center, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(_vCtrl(tester).offset, greaterThan(y));
    expect(_hCtrl(tester).offset, x);
  });

  testWidgets('rota koordinatörlüğü ile açılış', (tester) async {
    await _open(tester, coordinatorship: 'ULA');
    expect(find.text('4 ${_l.uiTimelineTasksLc} · ULA'), findsOneWidget);
    expect(_layout(tester).rows, hasLength(5));
    expect(find.byKey(GanttChart.barKey('ALT-1')), findsNothing);
  });

  testWidgets('openTaskFromGantt seçimi sağlayıcıda da temizler', (
    tester,
  ) async {
    await _open(tester);
    await _tapBar(tester, 'ALT-10');
    expect(_st().selected, 'ALT-10');
    await tester.tap(find.text(_l.uiTimelineGanttOpenTask));
    await settle(tester);
    expect(_st().selected, isNull);
  });

  testWidgets('kapat/aç (genel açılış): ölçek, süzgeç, çipler, kapalı grup, '
      'seçim korunur', (tester) async {
    await _open(tester);
    await tester.tap(find.text(_l.uiTimelineScaleWeek));
    await settle(tester);
    await tester.tap(find.text(_l.uiTimelineStatusOpen));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('MEK'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('ULA'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^MEK Mekanik sistemler')));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^ULA-1 [^·]')));
    await settle(tester);
    final before = _st();
    expect(before.zoom, GanttZoom.week);
    expect(before.filter, GanttFilter.open);
    expect(before.coords, ['MEK', 'ULA']);
    expect(before.closed, {'MEK'});
    expect(before.selected, 'ULA-1');

    await _reopen(tester);
    expect(_st(), before);
    expect(find.byKey(HorizontalTimelinePage.cardKey), findsOneWidget);
    expect(_layout(tester).width, 365 * 28);
    expect(
      find.text(
        '${_layout(tester).view.visible} ${_l.uiTimelineTasksLc} · MEK, ULA',
      ),
      findsOneWidget,
    );
    // Kaydırma sayfa içidir: yeniden açılışta bugün yine ortalanır.
    expect(_hCtrl(tester).offset, closeTo(_today * 28 - 780 * 0.4, 0.01));
  });

  testWidgets('kapat/aç (koordinatörlük niyeti): yalnız seçim ve seçili görev '
      'değişir', (tester) async {
    await _open(tester);
    await tester.tap(find.text(_l.uiTimelineGanttScaleSeason));
    await settle(tester);
    await tester.tap(find.text('${_l.uiTimelineStatusLate} · 15'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^ALT Altyapı ve tesisat')));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^İDA-1 [^·]')));
    await settle(tester);
    expect(_st().selected, 'İDA-1');

    await _reopen(tester, coordinatorship: 'ULA');
    final s = _st();
    expect(s.coords, ['ULA']);
    expect(s.selected, isNull);
    expect(s.zoom, GanttZoom.season);
    expect(s.filter, GanttFilter.late);
    expect(s.closed, {'ALT'});
    expect(find.byKey(HorizontalTimelinePage.cardKey), findsNothing);
    expect(find.text('3 ${_l.uiTimelineTasksLc} · ULA'), findsOneWidget);

    // "*" → hepsi, seçim kalkar; süzgeç kalır.
    await tester.tap(find.bySemanticsLabel(RegExp('^ULA-1 [^·]')));
    await settle(tester);
    expect(_st().selected, 'ULA-1');
    await _reopen(tester, coordinatorship: TimelinePage.allCoordinatorships);
    expect(_st().coords, isEmpty);
    expect(_st().selected, isNull);
    expect(_st().filter, GanttFilter.late);
  });

  testWidgets('yeniden boyutlanma niyeti tekrar uygulamaz, durumu korur', (
    tester,
  ) async {
    await _open(tester, coordinatorship: 'ULA');
    expect(_st().coords, ['ULA']);
    await tester.tap(find.bySemanticsLabel('MEK'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^ULA-1 [^·]')));
    await settle(tester);
    expect(_st().coords, ['ULA', 'MEK']);
    expect(_st().selected, 'ULA-1');

    for (final size in const [Size(1180, 820), Size(1366, 1024), _tablet]) {
      tester.view.physicalSize = size;
      await settle(tester);
      expect(_st().coords, ['ULA', 'MEK']);
      expect(_st().selected, 'ULA-1');
      expect(find.byKey(HorizontalTimelinePage.cardKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('kart kapat: üst/sağ 10 (+1 kenarlık), 32 × 32 alanın her yeri '
      'kapatır', (tester) async {
    await _open(tester);
    for (final at in const [
      Offset(0.5, 0.5),
      Offset(31.5, 0.5),
      Offset(0.5, 31.5),
      Offset(31.5, 31.5),
      Offset(16, 16),
    ]) {
      await _tapBar(tester, 'ALT-10');
      final card = tester.getRect(find.byKey(HorizontalTimelinePage.cardKey));
      final close = tester.getRect(find.byKey(GanttSelectionCard.closeKey));
      expect(close.size, const Size(32, 32));
      expect(close.top - card.top, 1 + 10);
      expect(card.right - close.right, 1 + 10);
      expect(card.intersect(close), close);
      await tester.tapAt(close.topLeft + at);
      await settle(tester);
      expect(
        find.byKey(HorizontalTimelinePage.cardKey),
        findsNothing,
        reason: 'kapat dokunuşu $at',
      );
    }
  });
}

/// Dikey içeriğin ekrandaki üst kenarı (tarih başlığının altı, kaydırma 0).
double _vOrigin(WidgetTester tester) =>
    tester.getRect(find.byKey(GanttChart.verticalKey)).top -
    _vCtrl(tester).offset;
