// P0 ölçüm tabanı: Görevler/Zaman çizelgesi geçişlerinin kare süreleri (yalnız ölçüm aracı;
// uygulama kodu değişmez, görsel/piksel iddiası yok).
//
// Gerçek `NizamioApp` + gerçek bileşim kökü + `Flavor.dev` + sunucu sözleşmesi biçiminde sahte HTTP
// ([PerfBackend], 160 görev). Her senaryo: ısınma turu (sayılmaz) + [reps] ölçülü tekrar. Ölçüm
// penceresi dokunuştan başlayan sabit süredir ([windowMs]; `pumpAndSettle` değil); ham `FrameTiming`
// listesi `SchedulerBinding.addTimingsCallback` ile toplanır. Anlamsal ağaç yalnız hedef bulma ve
// geri dönüş sırasında açılır, ölçüm penceresinde kapalıdır (gerçek cihazda ekran okuyucusuz durum).
//
// Koşum: `docs/perf/README.md` ve `tool/perf.sh`.
//   --dart-define=PERF_ONLY=S1,S2   (varsayılan: hepsi)   --dart-define=PERF_REPS=3
//   --dart-define=PERF_VIEW=native|tablet|phone  (tablet/phone: görünüm boyutu ayarlanır)
import 'dart:developer' as developer;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RendererBinding;
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart' show scopeControllerProvider;
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/features/identity/identity.dart' show LoginPage;

import '../test/support/tablet_harness.dart';
import 'support/perf_fixture.dart';

const _only = String.fromEnvironment('PERF_ONLY');
const _view = String.fromEnvironment('PERF_VIEW', defaultValue: 'native');
const _reps = int.fromEnvironment('PERF_REPS', defaultValue: 3);
const _windowMs = int.fromEnvironment('PERF_WINDOW_MS', defaultValue: 1800);
const _frameBudgetUs = 16667;

final _l = AppLocalizationsTr();

/// Bir ölçüm senaryosu: [setup] başlangıç durumuna getirir; [target] geçişi tetikleyecek
/// dokunuş noktasını verir (anlamsal ağaç açıkken); [reset] başlangıç durumuna döner.
class _Scenario {
  const _Scenario(this.id, this.title, this.setup, this.target, this.reset);

  final String id;
  final String title;
  final Future<void> Function(TabletSession s) setup;
  final Future<Offset> Function(TabletSession s) target;
  final Future<void> Function(TabletSession s) reset;
}

/// Giriş (harness `signIn` ile aynı adımlar): sahte ağ yanıtları gerçek zamanda ilerlediği için
/// her adımdan sonra gerçek zaman + kare verilir; giriş ekranı kapanana kadar beklenir.
/// macOS'ta `enterText` alana işlemiyor; yalnız kurulumda, metni denetleyiciye doğrudan yazar.
Future<void> _type(WidgetTester t, int i, String text) async {
  final ed = t.widget<EditableText>(find.byType(EditableText).at(i));
  ed.controller.text = text;
}

Future<void> _signIn(TabletSession s) async {
  final t = s.tester;
  Future<void> beat() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await t.pump(const Duration(milliseconds: 50));
  }

  await _type(t, 0, 'a@b.test');
  await beat();
  await _type(t, 1, 'p');
  await beat();
  await t.tap(find.widgetWithText(NzButton, _l.uiIdentityLoginSubmit));
  for (
    var i = 0;
    i < 100 && find.byType(LoginPage).evaluate().isNotEmpty;
    i++
  ) {
    await beat();
  }
  expect(find.byType(LoginPage), findsNothing, reason: 'giriş tamamlanmadı');
  s.harness.read(scopeControllerProvider).selectProgram(perfProgramId);
  await s.settle();
}

Future<void> _openTasks(TabletSession s) async {
  await s.tapRail(TabletModule.tasks);
}

Future<void> _openTasksPhone(TabletSession s) async {
  final tab = find.bySemanticsLabel(
    RegExp('^${RegExp.escape(_l.uiRouterTabTasks)}( · \\d+)?\$'),
  );
  expect(tab, findsWidgets, reason: 'alt menü "Görevler"');
  _tap(s.tester, s.tester.getCenter(tab.first));
  await s.settle();
}

/// Zaman çizelgesinden listeye dönüş: başlıktaki Liste/Zaman çizelgesi anahtarının "Liste" yarısı
/// (anahtar yalnız simge; etiket anlamsal ağaçta).
Finder _back() => find.bySemanticsLabel(RegExp(r'^Liste$'));

Future<void> _tapBack(TabletSession s) async {
  await _semFlush(s);
  expect(
    _back(),
    findsWidgets,
    reason: '"Liste" anahtarı (zaman çizelgesi açık değil?)',
  );
  _tap(s.tester, s.tester.getCenter(_back().first));
  await s.settle();
}

/// Anlamsal ağaç yeniden açıldıktan sonra güncellenene kadar birkaç kare (bkz. `ensureSemantics`).
Future<void> _semFlush(TabletSession s) async {
  for (var i = 0; i < 100; i++) {
    await s.tester.pump(const Duration(milliseconds: 50));
    if (i >= 7 &&
        RendererBinding
                .instance
                .rootPipelineOwner
                .semanticsOwner
                ?.rootSemanticsNode !=
            null) {
      break;
    }
  }
}

Future<void> _tapPill(TabletSession s, Finder pill) async {
  await _semFlush(s);
  _tap(s.tester, s.tester.getCenter(pill.first));
  await s.settle();
}

Finder _modePill({required bool tablet}) {
  // Anahtar yalnız simge (`iconsOnly`): etiket anlamsal ağaçtadır, metin olarak çizilmez.
  final f = find.bySemanticsLabel(
    RegExp('^${RegExp.escape(_l.uiTasksModeTimeline)}\$'),
  );
  return tablet ? _inMaster(f) : f;
}

Finder _inMaster(Finder f) => find.descendant(
  of: find.byWidgetPredicate(
    (w) => w is NzPaneScope && w.role == NzPaneRole.master,
  ),
  matching: f,
);

Finder _firstTaskRow() => find.byWidgetPredicate(
  (w) => w is Text && RegExp(r'^[A-Z]{3}-\d+ ').hasMatch(w.data ?? ''),
);

final _scenarios = <_Scenario>[
  _Scenario(
    'S1',
    'tablet Liste→Zaman çizelgesi',
    (s) async {
      await _signIn(s);
      await _openTasks(s);
    },
    (s) async => s.tester.getCenter(_modePill(tablet: true).first),
    _tapBack,
  ),
  _Scenario(
    'S2',
    'tablet Zaman çizelgesi→Liste',
    (s) async {
      await _signIn(s);
      await _openTasks(s);
      await _tapPill(s, _modePill(tablet: true));
    },
    (s) async => s.tester.getCenter(_back().first),
    (s) => _tapPill(s, _modePill(tablet: true)),
  ),
  _Scenario(
    'S3',
    'telefon Liste→Zaman çizelgesi',
    (s) async {
      await _signIn(s);
      await _openTasksPhone(s);
    },
    (s) async => s.tester.getCenter(_modePill(tablet: false).first),
    // Telefonda çizelge tam ekran açılır (başlık/anahtar kapalı): listeye sistem geri hareketiyle dönülür.
    (s) async {
      final nav = s.tester.state<NavigatorState>(find.byType(Navigator).last);
      await nav.maybePop();
      await s.settle();
    },
  ),
  _Scenario(
    'S4',
    'telefon görev ayrıntısı sekme geçişi (Özet→Alt görev)',
    (s) async {
      await _signIn(s);
      await _openTasksPhone(s);
      expect(_firstTaskRow(), findsWidgets, reason: 'görev satırı');
      _tap(s.tester, s.tester.getCenter(_firstTaskRow().first));
      await s.settle();
    },
    (s) async =>
        s.tester.getCenter(find.textContaining(_l.uiTasksTabSubtasks).first),
    (s) async {
      _tap(
        s.tester,
        s.tester.getCenter(find.textContaining(_l.uiTasksTabSummary).first),
      );
      await s.settle();
    },
  ),
];

class _Frame {
  _Frame(this.uiUs, this.rasterUs, this.startUs);
  final int uiUs;
  final int rasterUs;
  final int startUs;
}

int _pct(List<int> sorted, double p) {
  if (sorted.isEmpty) return 0;
  final i = (p * sorted.length).ceil().clamp(1, sorted.length) - 1;
  return sorted[i];
}

double _ms(int us) => double.parse((us / 1000).toStringAsFixed(2));

Map<String, Object?> _summary(List<List<_Frame>> runs) {
  final all = [for (final r in runs) ...r];
  final ui = [for (final f in all) f.uiUs]..sort();
  final ra = [for (final f in all) f.rasterUs]..sort();
  final firstUi = [
    for (final r in runs)
      if (r.isNotEmpty) r.first.uiUs,
  ]..sort();
  final firstTotal = [
    for (final r in runs)
      if (r.isNotEmpty) r.first.uiUs + r.first.rasterUs,
  ]..sort();
  final firstRa = [
    for (final r in runs)
      if (r.isNotEmpty) r.first.rasterUs,
  ]..sort();
  return {
    'reps': runs.length,
    'frames': all.length,
    'framesPerRep': [for (final r in runs) r.length],
    'uiMs': {
      'p50': _ms(_pct(ui, .5)),
      'p90': _ms(_pct(ui, .9)),
      'p99': _ms(_pct(ui, .99)),
      'max': _ms(ui.isEmpty ? 0 : ui.last),
    },
    'rasterMs': {
      'p50': _ms(_pct(ra, .5)),
      'p90': _ms(_pct(ra, .9)),
      'p99': _ms(_pct(ra, .99)),
      'max': _ms(ra.isEmpty ? 0 : ra.last),
    },
    'over16_7': {
      'ui': ui.where((v) => v > _frameBudgetUs).length,
      'raster': ra.where((v) => v > _frameBudgetUs).length,
    },
    'firstFrameMs': {
      'uiMedian': _ms(_pct(firstUi, .5)),
      'rasterMedian': _ms(_pct(firstRa, .5)),
      'totalMedian': _ms(_pct(firstTotal, .5)),
      'totalMax': _ms(firstTotal.isEmpty ? 0 : firstTotal.last),
      'perRepTotal': [
        for (final r in runs)
          if (r.isNotEmpty) _ms(r.first.uiUs + r.first.rasterUs),
      ],
    },
  };
}

var _pointer = 9000;

/// Dokunuş: `tester.tapAt` canlı bağlayıcının işaretçi izi katmanını açar (fullyLive'da silinmez,
/// her karede yeniden boyar); ölçümü kirletmesin diye vuruş testi + gönderim doğrudan yapılır.
void _tap(WidgetTester tester, Offset at) {
  final b = TestWidgetsFlutterBinding.instance;
  final id = tester.view.viewId;
  final pointer = _pointer++;
  final hit = HitTestResult();
  b.hitTestInView(hit, at, id);
  // ignore: invalid_use_of_protected_member
  b.withPointerEventSource(TestBindingEventSource.test, () {
    b.dispatchEvent(
      PointerDownEvent(pointer: pointer, position: at, viewId: id),
      hit,
    );
    b.dispatchEvent(
      PointerUpEvent(pointer: pointer, position: at, viewId: id),
      hit,
    );
  });
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final results = <String, Object?>{};
  final wanted = _only.isEmpty
      ? null
      : _only.split(',').map((e) => e.trim()).toSet();

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  /// Dokunuştan ([at]) başlayıp [_windowMs] süren pencerede çizilen kareler. Canlı bağlayıcı
  /// geçiş bittikten sonra da boş kare üretmeye devam eder (ve uygulamada sürekli animasyon olabilir);
  /// bu boş kareler yüzdelikleri sulandırmasın diye dokunuştan önceki 300 ms'lik boşta kare
  /// örneğinden eşik çıkarılır (p90 x 1,5 + 0,2 ms, UI ve raster ayrı) ve pencerenin sonundaki
  /// eşik altı kare serisi atılır; son "etkin" kareye kadarki kareler geçiştir.
  List<_Frame> lastUntrimmed = const [];
  Future<List<_Frame>> measure(WidgetTester tester, Offset at) async {
    final got = <FrameTiming>[];
    void cb(List<FrameTiming> t) => got.addAll(t);
    SchedulerBinding.instance.addTimingsCallback(cb);
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final t0 = developer.Timeline.now;
    _tap(tester, at);
    await Future<void>.delayed(const Duration(milliseconds: _windowMs));
    // FrameTiming gruplar halinde ve gecikmeli gelir.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fadePointers;
    SchedulerBinding.instance.removeTimingsCallback(cb);
    int start(FrameTiming t) =>
        t.timestampInMicroseconds(ui.FramePhase.buildStart);
    final idle = [
      for (final t in got)
        if (start(t) < t0) t,
    ];
    // İlk kareler (ısınma) hariç, dokunuş öncesi boşta örnek.
    final idleUi = [for (final t in idle) t.buildDuration.inMicroseconds]
      ..sort();
    final idleRa = [for (final t in idle) t.rasterDuration.inMicroseconds]
      ..sort();
    final uiLimit = _pct(idleUi, .9) * 1.5 + 200;
    final raLimit = _pct(idleRa, .9) * 1.5 + 200;
    final frames = [
      for (final t in got)
        if (start(t) >= t0 && start(t) < t0 + _windowMs * 1000)
          _Frame(
            t.buildDuration.inMicroseconds,
            t.rasterDuration.inMicroseconds,
            start(t),
          ),
    ]..sort((a, b) => a.startUs.compareTo(b.startUs));
    lastUntrimmed = List.of(frames);
    while (frames.isNotEmpty &&
        frames.last.uiUs <= uiLimit &&
        frames.last.rasterUs <= raLimit) {
      frames.removeLast();
    }
    return frames;
  }

  for (final sc in _scenarios) {
    if (wanted != null && !wanted.contains(sc.id)) continue;
    testWidgets('${sc.id} ${sc.title}', (tester) async {
      if (_view != 'native') {
        final dpr = tester.view.devicePixelRatio;
        final logical = _view == 'tablet'
            ? const Size(1376, 1032)
            : const Size(430, 932);
        tester.view.physicalSize = logical * dpr;
        addTearDown(tester.view.reset);
      }
      final s = await TabletSession.launch(
        tester,
        handler: PerfBackend().handle,
      );
      debugPrint(
        'PERF size=${s.windowSize.width}x${s.windowSize.height}dpr=${tester.view.devicePixelRatio}',
      );
      var sem = tester.ensureSemantics();
      await sc.setup(s);
      // Kurulumdaki `tester.tap` işaretçi izi (canlı bağlayıcı) kareler içinde sönsün.
      for (var i = 0; i < 80; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      final runs = <List<_Frame>>[];
      final untrimmedRuns = <List<_Frame>>[];
      for (var i = 0; i <= _reps; i++) {
        await _semFlush(s);
        final at = await sc.target(s);
        sem.dispose();
        final frames = await measure(tester, at);
        debugPrint('PERF ${sc.id} rep=$i tap=$at frames=${frames.length}');
        sem = tester.ensureSemantics();
        await s.settle();
        // i == 0: ısınma turu (JIT/gölgelendirici/ilk yükleme), sayılmaz.
        if (i > 0) {
          // Kırpma sonrası küme boşsa ölçüm anlamsızdır; sessiz geçmesin.
          expect(
            frames,
            isNotEmpty,
            reason: '${sc.id} rep=$i: ölçülen kare yok',
          );
          runs.add(frames);
          untrimmedRuns.add(lastUntrimmed);
        }
        await sc.reset(s);
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
      sem.dispose();
      final summary = _summary(runs);
      final size = tester.view.physicalSize / tester.view.devicePixelRatio;
      results[sc.id] = {
        'title': sc.title,
        'view': _view,
        'logicalSize': '${size.width.round()}x${size.height.round()}',
        'dpr': tester.view.devicePixelRatio,
        'mode': const bool.fromEnvironment('dart.vm.product')
            ? 'release'
            : const bool.fromEnvironment('dart.vm.profile')
            ? 'profile'
            : 'debug',
        'tasks': perfTaskCount,
        ...summary,
        'rawFrames': [
          for (final r in runs)
            [
              for (final f in r) [f.uiUs, f.rasterUs],
            ],
        ],
        // Kırpmasız sabit pencere (ek alan; birincil sonuç yukarıdaki kırpılmış kümedir).
        'untrimmed': _summary(untrimmedRuns),
        'untrimmedRawFrames': [
          for (final r in untrimmedRuns)
            [
              for (final f in r) [f.uiUs, f.rasterUs],
            ],
        ],
      };
      binding.reportData = Map<String, dynamic>.of(results);
      debugPrint(
        'PERF ${sc.id} ${summary['uiMs']} ${summary['rasterMs']} '
        'first=${summary['firstFrameMs']} over=${summary['over16_7']} '
        'n=${summary['frames']}',
      );
    });
  }
}
