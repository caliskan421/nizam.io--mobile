// Tablet test düzeneği (yalnız test; üretim kodu ve `screen_matrix.dart` değişmez).
//
// İki yüzey aynı sahneleri kullanır:
//  - `test/app/tablet_measurements_test.dart`: host `testWidgets`, 1180×820 (prototip artboard)
//    ve yerel boyut listesi; görünüm boyutu bu testte AYARLANIR (dpr 1).
//  - `integration_test/tablet_visual_test.dart`: gerçek iPad simülatörü; görünüm boyutu ASLA
//    ayarlanmaz, gerçek yüzey çizilir ve ölçüler çalışma anında FlutterView'dan okunup yazılır.
//
// Uygulama gerçek `NizamioApp`, gerçek bileşim kökü ([Harness]: bellek depoları + sahte HTTP +
// örnek veri depoları), sahte backend ([PilotBackend]): bağ doğrulanmış açılır → Giriş ekranı →
// gerçek giriş akışı (sahte ağ) + program seçimi → ana sayfa. Kapıyı atlayan mod yoktur.
// Gerçek backend'e çıkılmaz. Bugünün tarihi sahtelenmez (üretim kancası yok); Ana sayfa
// `DateTime.now()` farkı bilinen açık madde.
//
// Beklentiler `docs/design/tablet/12-Tablet.dc.html` ve referans AX ağacından alınan LİTERAL
// sözleşmedir ([TabletContract]); `NzTabletMetrics` değerleriyle yetinilmez. Bulunamayan
// özellik (takvim, yatay Gantt, merkezi modal…) atlanmaz ya da geçmiş sayılmaz: sahne kırmızı
// kalır.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/app.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_tablet_rail.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_chat_bubble.dart';
import 'package:nizamio/features/identity/identity.dart';
import 'package:nizamio/features/messages/messages.dart' show ChatPage;
import 'package:nizamio/features/timeline/presentation/gantt/gantt_chart.dart'
    show GanttChart;

import '../features/pilot_support.dart' show PilotBackend, real;
import 'harness.dart';

final _l = AppLocalizationsTr();

// ---------------------------------------------------------------------------------------------
// Sözleşme (HTML literal'leri; 12-Tablet.dc.html + CUA referansı 1180×820)
// ---------------------------------------------------------------------------------------------

/// Prototip artboard (HTML satır 77).
const tabletReferenceSize = Size(1180, 820);

/// Yerel, YALNIZ bu düzeneğe ait boyutlar (`screen_matrix.dart` büyütülmez). Mantıksal pt;
/// iPad Pro 13" ölçüleri beklenen değerdir, gerçek cihazda çalışma anında ölçülür.
const tabletHostSizes = <({String name, Size size, bool split, bool rail})>[
  (name: 'ipad-air-yatay', size: Size(1180, 820), split: true, rail: true),
  (name: 'ipad-pro13-yatay', size: Size(1376, 1032), split: true, rail: true),
  (name: 'ipad-pro13-dikey', size: Size(1032, 1376), split: true, rail: true),
  (name: 'dar-pencere-820', size: Size(820, 1180), split: false, rail: true),
  (name: 'telefon-599', size: Size(599, 900), split: false, rail: false),
];

abstract final class TabletContract {
  /// Ray: `nav[aria-label="Ana menü"]` genişlik 100 (HTML 133).
  static const railWidth = 100.0;

  /// Liste bölmesi: `.tb-pane` genişlik 390 + sağ kenar 1 (HTML 144); box-sizing yok.
  static const masterWidth = 390.0;
  static const masterBorder = 1.0;

  /// Sağ bölme kalan genişliği: pencere − 100 − 390 − 1 (1180'de 689).
  static double detailWidth(double windowWidth) =>
      windowWidth - railWidth - masterWidth - masterBorder;

  /// Modal: `width:min(560px, 100%-48px)`, `max-height:calc(100%-64px)` (HTML 73–74).
  static double modalWidth(double windowWidth) =>
      windowWidth - 48 < 560 ? windowWidth - 48 : 560;
  static double modalMaxHeight(double windowHeight) => windowHeight - 64;
  static const modalRadius = 28.0;

  /// Rayın altı modülü, prototip `RAIL` sırası (HTML 3852–3853).
  static const railLabels = [
    'Ana sayfa',
    'Görevler',
    'Takvim',
    'Koordinatörlükler',
    'Arşiv',
    'Mesajlar',
  ];

  /// Gantt ölçek ve süzgeç düğmeleri (HTML 1485–1486, gantt.ax).
  static const ganttScales = ['Hafta', 'Ay', 'Sezon'];
  static const ganttFilters = ['Tümü', 'Açık'];

  /// Üçüncü süzgeç kaynakta sayaçlıdır: "Geciken · N" (referans AX: N = 15).
  static final ganttLateFilter = RegExp(r'^Geciken · 15$');
}

enum TabletModule {
  home('Ana sayfa', 'İşlem geçmişi'), // TB_DEF.home = history
  tasks('Görevler', 'Su deposu temel betonunun yapılması'), // detail = ALT-5
  calendar('Takvim', 'Bir kayıt seç'), // empty
  coordinatorships('Koordinatörlükler', 'Altyapı ve tesisat'), // cdetail = ALT
  archive('Arşiv', 'Altyapı ve tesisat'), // afolder = ALT
  messages('Mesajlar', 'Koordinatörler'); // chat = koord

  const TabletModule(this.railLabel, this.defaultDetailText);
  final String railLabel;
  final String defaultDetailText;
}

// ---------------------------------------------------------------------------------------------
// Çıktı kökü, ölçüler, PNG
// ---------------------------------------------------------------------------------------------

/// `Directory.systemTemp/nizamio-tablet-shots` (simülatörde uygulama konteyneri tmp'si;
/// ana makineye `xcrun simctl get_app_container <udid> <bundle> data` ile kopyalanır).
Directory tabletShotsDir() {
  final dir = Directory('${Directory.systemTemp.path}/nizamio-tablet-shots');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  return dir;
}

/// Boş değilse dosya adlarına `<ad>.<etiket>.png` eki (ör. portrait yeniden koşumu eskiyi
/// ezmesin). Varsayılan boş: tam `login.png`, `home.png`…
const shotTag = String.fromEnvironment('NIZAMIO_SHOT_TAG');
const _deviceIdDefine = String.fromEnvironment('NIZAMIO_DEVICE_ID');

String shotFileName(String scene, String ext) =>
    shotTag.isEmpty ? '$scene.$ext' : '$scene.$shotTag.$ext';

({int width, int height}) pngSize(List<int> bytes) {
  final d = ByteData.sublistView(Uint8List.fromList(bytes.sublist(0, 24)));
  return (width: d.getUint32(16), height: d.getUint32(20));
}

Map<String, double> rectJson(Rect r) => {
  'l': r.left,
  't': r.top,
  'w': r.width,
  'h': r.height,
};

Map<String, double> sizeJson(Size s) => {'w': s.width, 'h': s.height};

Map<String, double> insetsJson(double dpr, ui.ViewPadding p) => {
  'l': p.left / dpr,
  't': p.top / dpr,
  'r': p.right / dpr,
  'b': p.bottom / dpr,
};

// ---------------------------------------------------------------------------------------------
// Pompa
// ---------------------------------------------------------------------------------------------

class PumpReport {
  const PumpReport(this.frames, this.idle);

  /// Çizilen kare sayısı.
  final int frames;

  /// Son karede planlı kare kalmadıysa true; false = kalıcı animasyon var, sınırlı pompa
  /// kanıtı (kare sayısı) JSON'a yazılır.
  final bool idle;
  Map<String, Object?> toJson() => {'frames': frames, 'idle': idle};
}

Future<void> _realDelay(WidgetTester tester, Duration d) async {
  if (tester.binding is LiveTestWidgetsFlutterBinding) {
    await Future<void>.delayed(d);
  } else {
    await tester.runAsync(() => Future<void>.delayed(d));
  }
}

/// `pumpAndSettle` yerine sınırlı pompa: kalıcı animasyonda (yükleyici, imleç) takılmaz.
Future<PumpReport> pumpBounded(
  WidgetTester tester, {
  int maxFrames = 60,
  Duration step = const Duration(milliseconds: 50),
  int minFrames = 4,
}) async {
  var n = 0;
  var idle = false;
  while (n < maxFrames) {
    await _realDelay(tester, const Duration(milliseconds: 10));
    await tester.pump(step);
    n++;
    if (n >= minFrames && !tester.binding.hasScheduledFrame) {
      idle = true;
      break;
    }
  }
  return PumpReport(n, idle);
}

// ---------------------------------------------------------------------------------------------
// Oturum
// ---------------------------------------------------------------------------------------------

/// Bir sahnede kullanılan canlı uygulama.
class TabletSession {
  TabletSession._(this.tester, this.harness, this.hostControlled);

  final WidgetTester tester;
  final Harness harness;

  /// true: görünüm boyutu bu düzenekçe ayarlandı (host). false: gerçek cihaz yüzeyi.
  final bool hostControlled;

  PumpReport lastPump = const PumpReport(0, true);

  /// [hostSize] verilirse (yalnız host testi) görünüm dpr 1 ve bu boyuta ayarlanır; null →
  /// görünüm DOKUNULMAZ (native).
  static Future<TabletSession> launch(
    WidgetTester tester, {
    Size? hostSize,
    ThemeMode theme = ThemeMode.dark,
  }) async {
    if (hostSize != null) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = hostSize;
      addTearDown(tester.view.reset);
    }
    final h = Harness(flavor: Flavor.dev, handler: PilotBackend().handle);
    addTearDown(h.dispose);
    await real(tester, () => h.read(serverBindingProvider).verify(testUrl));
    h.read(themeModeControllerProvider).state.value = theme;
    final s = TabletSession._(tester, h, hostSize != null);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: h.container,
        child: const NizamioApp(),
      ),
    );
    await s.settle();
    return s;
  }

  Future<void> settle() async => lastPump = await pumpBounded(tester);

  Future<void> setTheme(ThemeMode mode) async {
    harness.read(themeModeControllerProvider).state.value = mode;
    await settle();
  }

  /// Giriş ekranından gerçek akış (sahte ağ): e-posta + parola → "Giriş yap" → program seçimi.
  Future<void> signIn() async {
    expect(
      find.byType(LoginPage),
      findsOneWidget,
      reason: 'açılış Giriş ekranı',
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.test');
    await tester.enterText(find.byType(TextFormField).at(1), 'p');
    await tester.tap(find.widgetWithText(NzButton, _l.uiIdentityLoginSubmit));
    await settle();
    harness.read(scopeControllerProvider).selectSample();
    await settle();
  }

  // ---- bulucular ----

  Finder pane(NzPaneRole role) =>
      find.byWidgetPredicate((w) => w is NzPaneScope && w.role == role);

  Finder inPane(NzPaneRole role, Finder f) =>
      find.descendant(of: pane(role), matching: f);

  /// Semantik ağaç aynı etiketi iç içe iki düğümde verebilir; ilki ray düğmesidir.
  Finder railItem(TabletModule m) => find
      .bySemanticsLabel(RegExp('^${RegExp.escape(m.railLabel)}( · \\d+)?\$'))
      .first;

  Finder get railMenu => find.bySemanticsLabel(_l.uiRouterAllModules);

  // ---- eylemler ----

  Future<void> tapRail(TabletModule m) async {
    final f = railItem(m);
    expect(f, findsOneWidget, reason: 'ray öğesi "${m.railLabel}"');
    await tester.tap(f);
    await settle();
  }

  Future<void> tapText(Finder f, {String? reason}) async {
    expect(f, findsWidgets, reason: reason ?? 'dokunulacak öğe bulunamadı');
    // Kaynakta normal tıklama kaydırma üretmez: hedef zaten görünür ve tıklanabilirse doğrudan
    // dokun; yalnız görünmüyorsa görünür yap (Flutter `ensureVisible` hizalama 0 ile görünen
    // öğeyi de tepeye kaydırırdı).
    if (f.first.hitTestable().evaluate().isEmpty) {
      await tester.ensureVisible(f.first);
      await tester.pump();
    }
    await tester.tap(f.first);
    await settle();
  }

  // ---- ölçü ----

  Rect? rectOf(Finder f) =>
      f.evaluate().isEmpty ? null : tester.getRect(f.first);

  Rect? get railRect => rectOf(find.byType(NzTabletRail));
  Rect? get masterRect => rectOf(pane(NzPaneRole.master));
  Rect? get detailRect => rectOf(pane(NzPaneRole.detail));

  /// Üst güvenli alan (mantıksal pt): host'ta 0; gerçek iPad'de işletim sistemi durum çubuğu/
  /// pencere kontrolleri. Kaynak geometrisindeki dikey konumlar pencere üstünden başlar;
  /// bölme içeriği güvenli alanın ALTINDA başladığı için beklenen üst değerlere eklenir.
  double get safeTop => tester.view.padding.top / tester.view.devicePixelRatio;

  Size get windowSize =>
      tester.view.physicalSize / tester.view.devicePixelRatio;

  /// Merkezi modalın görünen kartı: başlık alanını içeren `Dialog`un ilk `Material`'ı.
  /// Dialog yoksa (alt sayfa vb.) null; çağıran başarısız olmalıdır.
  Rect? get modalRect {
    final dialog = find.byType(Dialog);
    if (dialog.evaluate().isEmpty) return null;
    final card = find.descendant(
      of: dialog.last,
      matching: find.byType(Material),
    );
    return card.evaluate().isEmpty ? null : tester.getRect(card.first);
  }

  /// Merkezi modal kartının köşe yarıçapı (okunamazsa null).
  double? get modalRadius {
    final dialog = find.byType(Dialog);
    if (dialog.evaluate().isEmpty) return null;
    final card = find.descendant(
      of: dialog.last,
      matching: find.byType(Material),
    );
    if (card.evaluate().isEmpty) return null;
    final shape = tester.widget<Material>(card.first).shape;
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius.resolve(TextDirection.ltr).topLeft.x;
    }
    return null;
  }

  /// Ölçü kaydı. Değerler çalışma anında FlutterView'dan okunur (varsayım yok).
  Map<String, Object?> measurements(String scene) {
    final v = tester.view;
    final dpr = v.devicePixelRatio;
    final env = Platform.environment;
    final udid = env['SIMULATOR_UDID'];
    return {
      'scene': scene,
      'hostControlled': hostControlled,
      'deviceId': udid ?? (_deviceIdDefine.isEmpty ? null : _deviceIdDefine),
      'deviceIdSource': udid != null
          ? 'SIMULATOR_UDID'
          : (_deviceIdDefine.isEmpty ? 'unknown' : 'dart-define'),
      'simulatorName': env['SIMULATOR_DEVICE_NAME'],
      'simulatorModel': env['SIMULATOR_MODEL_IDENTIFIER'],
      'os': Platform.operatingSystem,
      'osVersion': Platform.operatingSystemVersion,
      'physicalSize': sizeJson(v.physicalSize),
      'devicePixelRatio': dpr,
      'logicalSize': sizeJson(v.physicalSize / dpr),
      'orientation': v.physicalSize.width >= v.physicalSize.height
          ? 'landscape'
          : 'portrait',
      'safeArea': insetsJson(dpr, v.padding),
      'viewPadding': insetsJson(dpr, v.viewPadding),
      'viewInsets': insetsJson(dpr, v.viewInsets),
      'theme': Theme.of(tester.element(find.byType(Scaffold).first))
          .brightness
          .name,
      'pump': lastPump.toJson(),
      'rects': {
        'rail': railRect == null ? null : rectJson(railRect!),
        'master': masterRect == null ? null : rectJson(masterRect!),
        'detail': detailRect == null ? null : rectJson(detailRect!),
        'modal': modalRect == null ? null : rectJson(modalRect!),
      },
      'modalRadius': modalRadius,
    };
  }

  /// Çift bölme geometrisi: ray [0,100], liste [100,490] (+1 kenar), sağ kalan. Tam eşitlik
  /// (dpr 1 host'ta tam piksel; native'de mantıksal pt, 1/dpr hassasiyeti 0.01).
  void expectSplitGeometry() {
    final w = windowSize;
    final rail = railRect, master = masterRect, detail = detailRect;
    expect(rail, isNotNull, reason: 'NzTabletRail yok');
    expect(master, isNotNull, reason: 'liste bölmesi (NzPaneScope.master) yok');
    expect(detail, isNotNull, reason: 'sağ bölme (NzPaneScope.detail) yok');
    const eps = 0.01;
    expect(rail!.left, closeTo(0, eps));
    expect(
      rail.width,
      closeTo(TabletContract.railWidth, eps),
      reason: 'ray 100',
    );
    expect(master!.left, closeTo(TabletContract.railWidth, eps));
    expect(
      master.width,
      closeTo(TabletContract.masterWidth, eps),
      reason: 'liste 390',
    );
    expect(
      detail!.left,
      closeTo(
        TabletContract.railWidth +
            TabletContract.masterWidth +
            TabletContract.masterBorder,
        eps,
      ),
      reason: 'sağ bölme 491 (100 + 390 + 1 kenar)',
    );
    expect(
      detail.width,
      closeTo(TabletContract.detailWidth(w.width), eps),
      reason: 'sağ bölme kalan genişlik',
    );
    expect(detail.right, closeTo(w.width, eps));
  }
}

// ---------------------------------------------------------------------------------------------
// Sahneler
// ---------------------------------------------------------------------------------------------

/// Bir yakalama sahnesi: [run] uygulamayı hedef duruma getirir ve ASSERT eder; ardından
/// (integration) ekran görüntüsü ve ölçü JSON'u yazılır. [name] referans dosya adıdır.
class TabletScene {
  const TabletScene(this.name, this.run, {this.needsSignIn = true});

  final String name;
  final Future<void> Function(TabletSession s) run;
  final bool needsSignIn;
}

Future<void> _expectDefaultDetail(TabletSession s, TabletModule m) async {
  s.expectSplitGeometry();
  expect(
    s.inPane(NzPaneRole.detail, find.textContaining(m.defaultDetailText)),
    findsWidgets,
    reason: '${m.railLabel}: sağ bölme varsayılanı "${m.defaultDetailText}"',
  );
}

Finder _bubble(String text) => find.ancestor(
  of: find.textContaining(text, findRichText: true),
  matching: find.byType(NzChatBubble),
);

Future<void> _openTasks(TabletSession s) async {
  await s.tapRail(TabletModule.tasks);
  await _expectDefaultDetail(s, TabletModule.tasks);
}

Future<void> _openNewTaskModal(TabletSession s) async {
  await _openTasks(s);
  await s.tester.tap(find.bySemanticsLabel(_l.uiTasksNewTask).first);
  await s.settle();
  final r = s.modalRect;
  expect(
    r,
    isNotNull,
    reason: 'Yeni görev merkezi modal (Dialog) olmalı; alt sayfa/diğer yüzey kabul değil',
  );
  final w = s.windowSize;
  expect(
    r!.width,
    closeTo(TabletContract.modalWidth(w.width), 0.01),
    reason: 'modal genişliği',
  );
  expect(
    r.height,
    lessThanOrEqualTo(TabletContract.modalMaxHeight(w.height) + 0.01),
  );
  expect(r.center.dx, closeTo(w.width / 2, 0.5), reason: 'modal yatay ortalı');
  expect(r.center.dy, closeTo(w.height / 2, 0.5), reason: 'modal dikey ortalı');
  expect(find.text(_l.uiTasksNewTask), findsWidgets);
  // Köşe 28 (HTML 74); yarıçap okunamazsa (özel şekil) assert edilmez, JSON'a null yazılır.
  final radius = s.modalRadius;
  if (radius != null) {
    expect(radius, TabletContract.modalRadius, reason: 'modal köşe yarıçapı');
  }
}

/// Dark çekirdek sahneler (referans adlarıyla). Light varyantı aynı gövdelerle `-light`.
final tabletScenes = <TabletScene>[
  TabletScene('login', (s) async {
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(NzTabletRail), findsNothing, reason: 'girişte ray yok');
  }, needsSignIn: false),
  TabletScene('home', (s) async {
    s.expectSplitGeometry();
    // Ray: altı modül prototip sırasıyla, yukarıdan aşağı.
    var lastTop = -1.0;
    for (final m in TabletModule.values) {
      final f = s.railItem(m);
      expect(f, findsOneWidget, reason: 'ray "${m.railLabel}"');
      final top = s.tester.getRect(f).top;
      expect(top, greaterThan(lastTop), reason: 'ray sırası ${m.railLabel}');
      lastTop = top;
    }
    expect(s.railMenu, findsOneWidget);
    expect(find.bySemanticsLabel(_l.uiRouterAssistant), findsOneWidget);
    // Referans AX (home): rozet ve zil etiketi birebir. Kaynakta kurucu `chat.load('koord')`
    // koordinatör sohbetini baştan okunmuş sayar → ray rozeti ana sayfada 4 (5 değil).
    expect(
      find.bySemanticsLabel('Mesajlar · 4'),
      findsWidgets,
      reason: 'ray Mesajlar rozeti 4',
    );
    expect(
      find.bySemanticsLabel(
        'Bildirimler · 3 tarih talebi ve 3 onay seni bekliyor',
      ),
      findsWidgets,
      reason: 'zil etiketi',
    );
    expect(
      s.inPane(NzPaneRole.master, find.textContaining('79 görevin 39')),
      findsWidgets,
      reason: 'Tamamlanma KPI altyazısı',
    );
    expectHomeSourceGeometry(s);
    await _expectDefaultDetail(s, TabletModule.home);
  }),
  TabletScene('tasks', (s) async {
    await _openTasks(s);
    expectTasksSourceGeometry(s);
  }),
  TabletScene('tasks-select', (s) async {
    await _openTasks(s);
    final before = (s.masterRect, s.railRect);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Faz3 asfalt işlemi')),
      reason: 'sol liste MEK-6 kartı',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Faz3 asfalt işlemi')),
      findsWidgets,
      reason: 'seçilen görev sağ panelde',
    );
    // Liste tembeldir ve seçim kartı görünür yapar (ALT-5 kaydırmayla dışarıda kalabilir):
    // sol listenin yerinde olduğu seçilen kartın ve komşusunun sol bölmede durmasıyla sınanır.
    for (final t in ['Faz3 asfalt işlemi', 'ULA-1']) {
      expect(
        s.inPane(NzPaneRole.master, find.text(t)),
        findsWidgets,
        reason: 'sol liste yerinde kalır: "$t"',
      );
    }
    expect(
      (s.masterRect, s.railRect),
      before,
      reason: 'ray ve liste geometrisi sabit',
    );
    s.expectSplitGeometry();
  }),
  TabletScene('calendar', (s) async {
    await s.tapRail(TabletModule.calendar);
    // Takvim henüz uygulanmadıysa burada KIRMIZI kalır (atlanmaz).
    await _expectDefaultDetail(s, TabletModule.calendar);
    expect(
      s.inPane(NzPaneRole.master, find.text('Takvim')),
      findsWidgets,
      reason: 'sol bölme "Takvim" başlığı',
    );
    expect(
      s.inPane(NzPaneRole.master, find.textContaining('Ekim 2026')),
      findsWidgets,
    );
  }),
  TabletScene('coordinatorships', (s) async {
    await s.tapRail(TabletModule.coordinatorships);
    await _expectDefaultDetail(s, TabletModule.coordinatorships);
    expect(
      s.inPane(NzPaneRole.master, find.textContaining('11 koordinatörlük')),
      findsWidgets,
    );
    expect(s.inPane(NzPaneRole.detail, find.text('Genel')), findsWidgets);
  }),
  TabletScene('archive', (s) async {
    await s.tapRail(TabletModule.archive);
    await _expectDefaultDetail(s, TabletModule.archive);
    expect(s.inPane(NzPaneRole.master, find.text('Operasyon')), findsWidgets);
  }),
  TabletScene('archive-folder', (s) async {
    await s.tapRail(TabletModule.archive);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Operasyon')),
      reason: 'sol klasör listesi "Operasyon"',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.text('Operasyon')),
      findsWidgets,
      reason: 'klasör sağ panelde',
    );
    expect(s.inPane(NzPaneRole.master, find.text('Operasyon')), findsWidgets);
    s.expectSplitGeometry();
  }),
  TabletScene('messages', (s) async {
    await s.tapRail(TabletModule.messages);
    await _expectDefaultDetail(s, TabletModule.messages);
    expect(s.inPane(NzPaneRole.master, find.text('Genel')), findsWidgets);
    // Referans (messages.jpg/AX): rozet 4 ve k1–k2 arasında ayırıcı; ilk giriş bunları bozmaz.
    expect(find.bySemanticsLabel('Mesajlar · 4'), findsWidgets);
    expectUnreadDivider(s, present: true);
    expectChatSourceGeometry(s);
    expectInboxRowSourceGeometry(s);
  }),
  TabletScene('chat-reply', (s) async {
    await s.tapRail(TabletModule.messages);
    // Örnek veri adları referanstan farklıdır (Kadir Özbek ↔ Kerem Özdal…); varsayılan
    // "Koordinatörler" sohbeti ve içindeki mesaj kullanılır, kişi adına bağlanılmaz.
    await _expectDefaultDetail(s, TabletModule.messages);
    await s.tester.longPress(_bubble('trafo onayı bugün bekleniyor').first);
    await s.settle();
    await s.tapText(find.text(_l.uiMessagesReply));
    expect(
      find.textContaining(_l.uiMessagesReplyTo),
      findsWidgets,
      reason: 'yanıt bağlamı çipi',
    );
    final field = find.descendant(
      of: find.byType(NzComposer),
      matching: find.byType(TextField),
    );
    await s.tester.enterText(field.last, 'Tablet taslak');
    await s.settle();
    expect(
      s.tester.widget<TextField>(field.last).controller!.text,
      'Tablet taslak',
      reason: 'taslak yazılı',
    );
    // Gönder düğmesi artık NzIcon: Icons.* yerine erişilebilirlik etiketiyle bulunur.
    await s.tester.tap(find.bySemanticsLabel(_l.uiMessagesSend).last);
    await s.settle();
    // Kaynak: gönder 500 ms'de tek tik, 1600 ms'de okundu (S_chat.send). Görüntü KARARLI okundu
    // fazında alınsın: >1600 ms bekle (Live bağlayıcıda gerçek duvar zamanı; sahte boyut yok).
    await s.tester.pump(const Duration(seconds: 2));
    await s.settle();
    expect(
      find.textContaining('Tablet taslak', findRichText: true),
      findsWidgets,
    );
    expect(
      find.textContaining(_l.uiMessagesReplyTo),
      findsNothing,
      reason: 'gönderince yanıt bağlamı temizlenir',
    );
  }),
  TabletScene('gantt', (s) async {
    await _openTasks(s);
    await openTimelineFromTasks(s);
    // Yatay Gantt yoksa burada KIRMIZI kalır.
    expect(
      s.pane(NzPaneRole.master),
      findsNothing,
      reason: 'Gantt tam genişlik: liste gizli',
    );
    expect(s.railRect, isNotNull, reason: 'ray görünür kalır');
    expect(find.bySemanticsLabel('Geri: Görevler'), findsOneWidget);
    for (final label in [
      ...TabletContract.ganttScales,
      ...TabletContract.ganttFilters,
    ]) {
      expect(find.text(label), findsWidgets, reason: 'Gantt düğmesi "$label"');
    }
    expect(
      find.bySemanticsLabel(TabletContract.ganttLateFilter),
      findsWidgets,
      reason: 'Gantt süzgeci "Geciken · 15" (kaynak sayaçlı etiket)',
    );
    for (final scale in ['Hafta', 'Sezon', 'Ay']) {
      await s.tapText(find.text(scale));
    }
  }),
  TabletScene('gantt-open-task', (s) async {
    await _openTasks(s);
    await openTimelineFromTasks(s);
    await tapGanttBar(s, 'ALT-5');
    expect(find.bySemanticsLabel('Seçili görev'), findsWidgets);
    await s.tapText(find.text('Görev ayrıntısını aç'));
    // Kaynak istisnası openTaskFromGantt: Görevler modülü + sağda tek ALT-5 detayı.
    await _expectDefaultDetail(s, TabletModule.tasks);
    expect(find.text('Geri: Görevler'), findsNothing, reason: 'Gantt kapandı');
  }),
  const TabletScene('task-create', _openNewTaskModal),
  TabletScene('drawer', (s) async {
    await s.tester.tap(s.railMenu);
    await s.settle();
    expect(
      find.bySemanticsLabel(RegExp(RegExp.escape(_l.uiHomeProfile))),
      findsWidgets,
      reason: 'çekmece hesap satırı',
    );
  }),
];

/// Ayrı sahne grubu: ölçüye göre bölme (ROT-01/07 sözleşmesi).
void expectLayoutForSize(
  TabletSession s, {
  required bool split,
  required bool rail,
}) {
  expect(find.byType(NzTabletRail), rail ? findsOneWidget : findsNothing);
  if (!rail) expect(find.byType(NzFloatingNav), findsOneWidget);
  expect(
    s.pane(NzPaneRole.master),
    split ? findsOneWidget : findsNothing,
    reason: 'bölme yöne değil genişliğe bağlı (≥840 çift)',
  );
  if (split) s.expectSplitGeometry();
}

// ---------------------------------------------------------------------------------------------
// Yakalama
// ---------------------------------------------------------------------------------------------

typedef TakeScreenshot = Future<List<int>> Function(String name);

/// PNG (cihaz yüzeyi) + ölçü JSON'unu [tabletShotsDir]'e yazar. [takeScreenshot] boşsa yalnız
/// JSON yazılır. Dönüş: yazılan ölçü kaydı.
Future<Map<String, Object?>> captureScene(
  TabletSession s,
  String scene, {
  TakeScreenshot? takeScreenshot,
}) async {
  await s.settle();
  final data = s.measurements(scene);
  final dir = tabletShotsDir();
  if (takeScreenshot != null) {
    final bytes = await takeScreenshot(scene);
    File('${dir.path}/${shotFileName(scene, 'png')}').writeAsBytesSync(bytes);
    final px = pngSize(bytes);
    data['png'] = {
      'file': shotFileName(scene, 'png'),
      'px': {'w': px.width, 'h': px.height},
      'bytes': bytes.length,
    };
  }
  File('${dir.path}/${shotFileName(scene, 'json')}')
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  return data;
}

/// Host: kök RepaintBoundary'den PNG (yalnız `NIZAMIO_TABLET_HOST_SHOTS=true` dart-define ile
/// ve gerçek yazı tipleri yüklüyse anlamlıdır; golden DEĞİLDİR, repoya yazılmaz).
Future<List<int>> hostPng(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byType(RepaintBoundary).first,
  );
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  return bytes!;
}

// ---------------------------------------------------------------------------------------------
// Değişmez (invariant) sahneleri: ekran görüntüsü almaz; kaynaktaki gezinme/durum kurallarını
// uygulamanın gerçek UI'sinden sınar. Beklentiler `docs/yurutme/tablet-test-matrisi.md` §1.1
// (düzeltilmiş sözleşme) ve HTML satırlarındandır; uygulama içi yapıyı (SplitMemory, iz sorgusu,
// denetleyici adları) yansıtmaz.
// ---------------------------------------------------------------------------------------------

/// Sağ bölmedeki "Geri" düğmesi (prototip `data-canback`: yalnız `rs.length > 1`).
Finder paneBack(TabletSession s) =>
    s.inPane(NzPaneRole.detail, find.bySemanticsLabel(RegExp(r'^Geri')));

/// Gerçek BAR tıklaması. Çubuk anlamsal sarmalayıcısının merkezi yapışkan etiket sütununun
/// ARKASINA düşebilir (`warnIfMissed` uyarısı bunun kanıtıydı); kullanıcı çubuğun gerçekten
/// GÖRÜNEN kısmına basar. Burada: gerekirse görünür yap, çubuk ∩ görünüm penceresi −
/// yapışkan etiket sütunu (`labelsKey` sağ kenarı) kesişimini ölç, pozitif alanın merkezine
/// dokun ve dokunuşun yol listesinde ÇUBUĞUN render nesnesi olduğunu kanıtla.
Future<void> tapGanttBar(TabletSession s, String code) async {
  final t = s.tester;
  final bar = find.byKey(GanttChart.barKey(code));
  expect(bar, findsOneWidget, reason: 'Gantt çubuğu $code');
  Rect visible() {
    final b = t.getRect(bar);
    final view = t
        .getRect(find.byKey(GanttChart.horizontalKey))
        .intersect(t.getRect(find.byKey(GanttChart.verticalKey)));
    final labelsRight = t.getRect(find.byKey(GanttChart.labelsKey)).right;
    return Rect.fromLTRB(
      b.left > labelsRight ? b.left : labelsRight,
      b.top,
      b.right,
      b.bottom,
    ).intersect(view);
  }

  var v = visible();
  if (v.isEmpty || v.width < 2 || v.height < 2) {
    // Kullanıcı gibi kaydır: önce dikeyde görünür yap, sonra çubuğu yatay sürüklemeyle
    // yapışkan etiket sütununun SAĞINA getir (ensureVisible çubuğu sütunun altına bırakır).
    await t.ensureVisible(bar);
    await t.pump();
    for (var i = 0; i < 8; i++) {
      v = visible();
      if (!(v.isEmpty || v.width < 24 || v.height < 2)) break;
      final b = t.getRect(bar);
      final labelsRight = t.getRect(find.byKey(GanttChart.labelsKey)).right;
      final dx = (labelsRight + 32) - b.left;
      await t.drag(find.byKey(GanttChart.horizontalKey), Offset(dx, 0));
      await t.pump(const Duration(milliseconds: 100));
    }
    await s.settle();
    v = visible();
  }
  expect(
    v.isEmpty || v.width < 2 || v.height < 2,
    isFalse,
    reason:
        '$code: çubuğun etiket sütunu ve başlık dışında görünen kısmı yok ($v)',
  );
  final point = v.center;
  final hit = t.hitTestOnBinding(point);
  final target = t.renderObject(bar);
  expect(
    hit.path.any((e) => identical(e.target, target)),
    isTrue,
    reason:
        '$code: $point noktasına dokunuş çubuğun render nesnesine ulaşmıyor',
  );
  await t.tapAt(point);
  await s.settle();
}

/// Görevler listesinden "Zaman çizelgesi" hapı. Liste tembeldir ve seçim kartı görünür yapmak
/// için kaydırmış olabilir; kaynak akışında kullanıcı başa döner, burada da öyle: hap kurulu
/// değilse dikey liste yukarı kaydırılır (üretim listesi tembel kalır).
Future<void> openTimelineFromTasks(TabletSession s) async {
  final pill = s.inPane(NzPaneRole.master, find.text(_l.uiTasksModeTimeline));
  if (pill.evaluate().isEmpty) {
    final scrollable = s.inPane(
      NzPaneRole.master,
      find.byWidgetPredicate((w) => w is Scrollable && w.axis == Axis.vertical),
    );
    expect(scrollable, findsWidgets, reason: 'Görevler listesi kaydırılabilir');
    await s.tester.scrollUntilVisible(
      pill,
      -300,
      scrollable: scrollable.first,
      maxScrolls: 80,
    );
    await s.settle();
  }
  await s.tapText(pill, reason: 'Görevler → Zaman çizelgesi hapı');
}

/// Görünür sohbet sayfasının torunu: çift bölmede sağ bölme, tek bölmede (600–839, bölme
/// kapsamı `role == null`) tam ekran sohbet. Sol gelen kutusu önizlemesi `ChatPage` altında
/// değildir.
Finder inChat(Finder f) =>
    find.descendant(of: find.byType(ChatPage), matching: f);

/// Varsayılan sohbette k2 mesajına UI ile "Yanıtla" (uzun bas → işlem sayfası → Yanıtla).
Future<void> startReplyToK2(TabletSession s) async {
  await s.tester.longPress(
    find
        .ancestor(
          of: inChat(find.textContaining('trafo onayı bugün')).first,
          matching: find.byType(NzChatBubble),
        )
        .first,
  );
  await s.settle();
  await s.tapText(find.text(_l.uiMessagesReply));
  expectReplyChip(present: true);
}

/// Yanıt bağlamı çipi ("… kişisine yanıt") görünür mü.
void expectReplyChip({required bool present}) => expect(
  find.textContaining(_l.uiMessagesReplyTo),
  present ? findsWidgets : findsNothing,
  reason: present
      ? 'yanıt bağlamı çipi var'
      : 'yanıt bağlamı temizlenmiş olmalı',
);

/// "okunmamış mesajlar" ayırıcısı (kaynak literal; HTML 3252). Kaynakta kurucu
/// `load('koord')` `_newBefore='k2'` hesaplar (3213–3215: unread 1 → `msgs[len-unread]`), ilk
/// Mesajlar ray seçimi (`tgo`) `load` ÇAĞIRMAZ → ayırıcı k1 ile k2 arasındadır. Aynı satırın
/// yeniden seçilmesi `load`'u tekrar çağırır (unread 0 → `nb=null`) ve ayırıcı kaybolur; yeniden
/// boyut `load` çağırmaz. `present` true ise ayırıcı tam bir kez ve k1 ile k2 arasında olmalı.
void expectUnreadDivider(TabletSession s, {required bool present}) {
  final divider = inChat(find.text(_l.uiMessagesNewMessages));
  if (!present) {
    expect(
      divider,
      findsNothing,
      reason: 'okunmamış mesajlar ayırıcısı kalkmış olmalı',
    );
    return;
  }
  expect(
    divider,
    findsOneWidget,
    reason: 'ayırıcı varsayılan sohbette görünür',
  );
  // Sol bölmedeki sohbet önizlemesi aynı metni taşır: bulucular sağ bölmeyle sınırlı.
  final k1 = s.tester.getRect(
    inChat(find.textContaining('haftalık raporu cuma')).first,
  );
  final k2 = s.tester.getRect(
    inChat(find.textContaining('trafo onayı bugün')).first,
  );
  final d = s.tester.getRect(divider);
  expect(
    d.top,
    greaterThanOrEqualTo(k1.bottom),
    reason: 'ayırıcı k1\'den sonra',
  );
  expect(d.bottom, lessThanOrEqualTo(k2.top), reason: 'ayırıcı k2\'den önce');
}

// ---------------------------------------------------------------------------------------------
// Kaynak DOM geometrisi (/tmp/nizamio-tablet-reference/{messages,inbox-row,home,tasks-select}
// .metrics.json; 1180×820 tarayıcı). Beklentiler JSON'daki mutlak koordinatlardan, ilgili
// bölmenin kaynak başlangıcına (master x=100, detay x=491) göre BÖLME-GÖRELİ yazılmıştır;
// ölçüm bölmenin gerçek kökünden alınır, böylece native güvenli alan (`pane.top`) kendiliğinden
// eklenir. Metin satırı kutusu yuvarlaması için ~1.5 pt tolerans; 400 px gibi sapmalar
// gizlenmez. Beklentiler sabit literaldir: üretim sabitleri/yardımcıları kopyalanmaz.
// ---------------------------------------------------------------------------------------------

const _geoTol = 1.5;

/// [actual] rect'ini bölme kökü [pane]'e göre [l, t, w, h] beklentisiyle karşılaştırır.
void expectPaneRect(
  Rect actual,
  Rect pane,
  ({double l, double t, double w, double h}) want,
  String what, {
  double tol = _geoTol,
}) {
  final r = actual.shift(-pane.topLeft);
  String msg(String k) =>
      '$what.$k: bölme-göreli ${r.left}, ${r.top}, ${r.width}×${r.height}';
  expect(r.left, closeTo(want.l, tol), reason: msg('left'));
  expect(r.top, closeTo(want.t, tol), reason: msg('top'));
  expect(r.width, closeTo(want.w, tol), reason: msg('width'));
  expect(r.height, closeTo(want.h, tol), reason: msg('height'));
}

Rect _firstRect(TabletSession s, Finder f, String what) {
  expect(f, findsWidgets, reason: '$what bulunamadı');
  return s.tester.getRect(f.first);
}

/// Sağ bölme genişliği kaynak artboard'ındakiyle (1180 − 491 = 689) aynı mı? Yalnız o zaman
/// kaynağın mutlak boyut literal'leri geçerlidir; iPad Pro 13" yatayda (sağ bölme ≈885, satır
/// ≈861) gerçek duyarlı uyarlama yapılır ve daha az metin satırı sığar. Cihaz görünümü hiçbir
/// durumda 1180'e zorlanmaz, assert gevşetilmez: genişliğe bağlı olmayan kurallar HER
/// genişlikte, mutlak literal'ler yalnız kanonik 689'da denetlenir.
const _canonicalDetailWidth = 689.0;

/// Sohbet (detay) kaynağı: `messages.metrics.json`.
///
/// Her genişlikte (CSS değişmezleri, bölme kökünden): satır sol 12 ve genişlik `pane−24`; ilk
/// satır üstü 126 (başlık 64 + üst boşluk 8 + gün dolgusu 12/8 + hap 26 + ilk mesaj `mt 8`);
/// k2.top − k1.bottom = 52 (ayırıcı 28 + kenar boşluğu 10/6 + mesaj `mt 8`); saat balonun
/// SAĞINDA ve gövde metniyle aynı sağ kenarda (balon iç dolgusu 12), solda değil.
/// Yalnız kanonik 689'da: k1 665×102.5, k2 üst 280.5 / 665×103.5, saat sağı `satır.left + 558`.
/// Satır yüksekliği metin sarmasına bağlıdır; native yükseklik 102.5 sayılmaz.
void expectChatSourceGeometry(TabletSession s) {
  final pane = s.detailRect!.shift(Offset(0, s.safeTop));
  final canonical = (pane.width - _canonicalDetailWidth).abs() <= 0.5;
  final bodyK1 = inChat(find.textContaining('haftalık raporu cuma'));
  final k1 = _firstRect(
    s,
    find.ancestor(of: bodyK1, matching: find.byType(NzChatBubble)),
    'k1 balon satırı',
  );
  final k2 = _firstRect(
    s,
    find.ancestor(
      of: inChat(find.textContaining('trafo onayı bugün')),
      matching: find.byType(NzChatBubble),
    ),
    'k2 balon satırı',
  );
  // --- genişlikten bağımsız kurallar ---
  expect(k1.left - pane.left, closeTo(12, _geoTol), reason: 'satır sol 12');
  expect(
    k1.width,
    closeTo(pane.width - 24, _geoTol),
    reason: 'satır genişliği pane−24',
  );
  expect(
    k1.top - pane.top,
    closeTo(126, _geoTol),
    reason: 'ilk satır üstü 126',
  );
  expect(
    k2.top - k1.bottom,
    closeTo(52, _geoTol),
    reason: 'k2.top − k1.bottom (ayırıcı 28 + 10/6 + mt 8)',
  );
  final time = _firstRect(s, inChat(find.text('08:40')), 'k1 saati');
  final text = _firstRect(s, bodyK1, 'k1 gövde metni');
  expect(
    time.right,
    closeTo(text.right, _geoTol),
    reason: 'saat gövde metniyle aynı sağ kenarda (balon iç dolgu 12)',
  );
  expect(time.left, greaterThan(text.left), reason: 'saat solda değil sağda');
  // --- yalnız kanonik 689: kaynak mutlak literal'leri ---
  if (canonical) {
    expectPaneRect(k1, pane, (l: 12, t: 126, w: 665, h: 102.5), 'k1');
    expectPaneRect(k2, pane, (l: 12, t: 280.5, w: 665, h: 103.5), 'k2');
    expect(
      time.right,
      closeTo(k1.left + (1073 - 12 - 503), _geoTol),
      reason: 'kanonik: saat sağı = satır.left + 558',
    );
  }
}

/// Liste bölmesi her pencerede 390 sabittir (kaynak `.tb-pane`): Ana sayfa/Görevler/gelen kutusu
/// geometrisi cihazda da kanonikle AYNI olmalıdır. Genişlik farklıysa karşılaştırma geçersizdir.
void _expectFixedMaster(Rect pane) => expect(
  pane.width,
  closeTo(TabletContract.masterWidth, 0.01),
  reason: 'liste bölmesi 390 sabit; kaynak geometri bu genişliğe bağlı',
);

/// Gelen kutusu ilk satırı: `inbox-row.metrics.json` (Genel). Dolgu 8; satır (108,120,374×71.5);
/// başlık sol 180, üst 132, yükseklik 20; saat sağ kenarı 474 (satır içi sağ 482−8), üst 133.5.
void expectInboxRowSourceGeometry(TabletSession s) {
  final pane = s.masterRect!.shift(Offset(0, s.safeTop));
  _expectFixedMaster(pane);
  final row = _firstRect(
    s,
    s.inPane(NzPaneRole.master, find.bySemanticsLabel(RegExp(r'^Genel'))),
    'gelen kutusu "Genel" satırı',
  );
  expectPaneRect(row, pane, (l: 8, t: 120, w: 374, h: 71.5), 'inbox satırı');
  final title = _firstRect(
    s,
    s.inPane(NzPaneRole.master, find.text('Genel')),
    'başlık',
  );
  expect(
    title.left - pane.left,
    closeTo(80, _geoTol),
    reason: 'başlık sol (180−100)',
  );
  expect(title.top - pane.top, closeTo(132, _geoTol), reason: 'başlık üst');
  expect(
    title.height,
    closeTo(20, _geoTol),
    reason: 'başlık satır yüksekliği 20',
  );
  final time = _firstRect(
    s,
    s.inPane(NzPaneRole.master, find.text('10:02')),
    'saat',
  );
  expect(
    time.right - pane.left,
    closeTo(374, _geoTol),
    reason: 'saat sağ kenarı (474−100)',
  );
  expect(time.top - pane.top, closeTo(133.5, _geoTol), reason: 'saat üst');
}

/// Ana sayfa: `home.metrics.json`. KPI 174×150 (boşluk 10), hızlı işlem 83.5×90 (boşluk 8),
/// rol kartı 114×88 (boşluk 8). Kaynak sol 116/300 ⇒ liste-göreli 16/200.
void expectHomeSourceGeometry(TabletSession s) {
  final pane = s.masterRect!.shift(Offset(0, s.safeTop));
  _expectFixedMaster(pane);
  void card(
    String label,
    RegExp re,
    ({double l, double t, double w, double h}) want,
  ) {
    expectPaneRect(
      _firstRect(
        s,
        s.inPane(NzPaneRole.master, find.bySemanticsLabel(re)),
        label,
      ),
      pane,
      want,
      label,
    );
  }

  card('KPI Tamamlanma', RegExp(r'^Tamamlanma'), (
    l: 16,
    t: 136,
    w: 174,
    h: 150,
  ));
  card('KPI Devam eden', RegExp(r'^Devam eden'), (
    l: 200,
    t: 136,
    w: 174,
    h: 150,
  ));
  card('KPI Gecikmede', RegExp(r'^Gecikmede'), (l: 16, t: 296, w: 174, h: 150));
  card('KPI Onay bekleyen', RegExp(r'^Onay bekleyen'), (
    l: 200,
    t: 296,
    w: 174,
    h: 150,
  ));
  card('Yeni görev', RegExp(r'^Yeni görev$'), (l: 16, t: 496, w: 83.5, h: 90));
  card('Toplantı', RegExp(r'^Toplantı$'), (l: 107.5, t: 496, w: 83.5, h: 90));
  card('Davet et', RegExp(r'^Davet et$'), (l: 199, t: 496, w: 83.5, h: 90));
  card('Rapor', RegExp(r'^Rapor$'), (l: 290.5, t: 496, w: 83.5, h: 90));
  card('Rol Admin', RegExp(r'^2\s*Admin'), (l: 16, t: 636, w: 114, h: 88));
  card('Rol Koordinatör', RegExp(r'^15\s*Koordinatör'), (
    l: 138,
    t: 636,
    w: 114,
    h: 88,
  ));
  card('Rol Üye', RegExp(r'^3\s*Üye'), (l: 260, t: 636, w: 114, h: 88));
  // Etiket 12/16: tek satır yüksekliği kaynak lineHeight'ı.
  final label = _firstRect(
    s,
    s.inPane(NzPaneRole.master, find.text('Yeni görev')),
    '"Yeni görev" etiketi',
  );
  expect(
    label.height,
    closeTo(16, _geoTol),
    reason: 'hızlı işlem etiketi 12/16',
  );
}

/// Görevler kutucukları: `tasks-select.metrics.json`. Tümü 175×78 (4 sütunlu 358 ızgarada iki
/// sütun + 8 boşluk; eski 171 yanlış), Geciken 83.5×78; üst 144; sol 116 ⇒ liste-göreli 16.
void expectTasksSourceGeometry(TabletSession s) {
  final pane = s.masterRect!.shift(Offset(0, s.safeTop));
  _expectFixedMaster(pane);
  expectPaneRect(
    _firstRect(
      s,
      s.inPane(NzPaneRole.master, find.bySemanticsLabel(RegExp(r'Tümü'))),
      'Tümü kutucuğu',
    ),
    pane,
    (l: 16, t: 144, w: 175, h: 78),
    'Tümü',
  );
  expectPaneRect(
    _firstRect(
      s,
      s.inPane(NzPaneRole.master, find.bySemanticsLabel(RegExp(r'Geciken'))),
      'Geciken kutucuğu',
    ),
    pane,
    (l: 199, t: 144, w: 83.5, h: 78),
    'Geciken',
  );
}

Finder _composerField() => find.descendant(
  of: find.byType(NzComposer),
  matching: find.byType(TextField),
);

/// Takvim hücresi (kaynak aria: "22 Ekim, Perşembe[, bugün][, n kayıt]").
Finder calendarCell(String dayTitle) => find.bySemanticsLabel(
  RegExp('^${RegExp.escape(dayTitle)}(, bugün)?(, \\d+ kayıt)?\$'),
);

final tabletInvariantScenes = <TabletScene>[
  // --- Çapraz özellik açma: yalnız sağ yığın değişir, sol modül korunur (HTML 3517–3522, 3823–3830)
  TabletScene('nav-cross-feature-keeps-left-module', (s) async {
    await s.tapRail(TabletModule.coordinatorships);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Mekanik sistemler')),
      reason: 'sol koordinatörlük kartı',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Mekanik sistemler')),
      findsWidgets,
      reason: 'seçilen koordinatörlük sağda (taban yer değiştirir)',
    );
    expect(
      paneBack(s),
      findsNothing,
      reason: 'taban değişimi yığını büyütmez: geri yok',
    );
    await s.tapText(
      s.inPane(NzPaneRole.detail, find.text(_l.uiCoordLinkArchive)),
      reason: 'ayrıntıdaki "Arşiv klasörü" kısayolu',
    );
    expect(
      s.inPane(NzPaneRole.master, find.textContaining('11 koordinatörlük')),
      findsWidgets,
      reason: 'sol modül Koordinatörlükler kalır, Arşiv\'e atlamaz',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Görev klasörleri')),
      findsWidgets,
      reason: 'sağda arşiv klasörü',
    );
    expect(paneBack(s), findsWidgets, reason: 'yığın 2 → geri görünür');
    s.expectSplitGeometry();
    await s.tapText(paneBack(s));
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Mekanik sistemler')),
      findsWidgets,
      reason: 'geri → önceki koordinatörlük (Mekanik), varsayılan ALT değil',
    );
    expect(paneBack(s), findsNothing);
  }),
  // --- Aynı modüle ray basışı: derin yığın tabana döner (HTML 3819)
  TabletScene('nav-same-module-rail-pops-to-base', (s) async {
    await s.tapRail(TabletModule.coordinatorships);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Mekanik sistemler')),
    );
    await s.tapText(
      s.inPane(NzPaneRole.detail, find.text(_l.uiCoordLinkArchive)),
    );
    expect(paneBack(s), findsWidgets);
    await s.tapRail(TabletModule.coordinatorships);
    expect(
      paneBack(s),
      findsNothing,
      reason: 'aynı modüle basış yığını tabana indirir',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Mekanik sistemler')),
      findsWidgets,
      reason: 'taban kaydı (son yüklenen) korunur',
    );
    // Tek kayıtlıyken yeniden basış hiçbir şeyi değiştirmez.
    await s.tapRail(TabletModule.coordinatorships);
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Mekanik sistemler')),
      findsWidgets,
    );
  }),
  // --- Modül değişimi: sağ TÜR varsayılana döner, ALT içerik son yüklenen kalır (HTML 3820, 2401)
  TabletScene('nav-module-roundtrip-keeps-last-loaded-record', (s) async {
    await s.tapRail(TabletModule.coordinatorships);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Mekanik sistemler')),
    );
    await s.tapRail(TabletModule.archive);
    await _expectDefaultDetail(s, TabletModule.archive);
    await s.tapRail(TabletModule.coordinatorships);
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Mekanik sistemler')),
      findsWidgets,
      reason: 'sub ekran durumu kalıcıdır: son yüklenen koordinatörlük (ALT\'ye sıfırlanmaz)',
    );
    expect(paneBack(s), findsNothing, reason: 'rs=[TB_DEF] tek giriş');
  }),
  // --- Liste (master) alt durumu modül gidiş-dönüşünde kalır; yalnız kaydırma sıfırlanır
  TabletScene('master-search-survives-module-roundtrip', (s) async {
    await _openTasks(s);
    await s.tapText(find.bySemanticsLabel(_l.uiTasksSearch));
    final field = s.inPane(NzPaneRole.master, find.byType(TextField));
    await s.tester.enterText(field.first, 'asfalt');
    await s.settle();
    expect(
      s.inPane(NzPaneRole.master, find.text('Faz3 asfalt işlemi')),
      findsWidgets,
    );
    await s.tapRail(TabletModule.archive);
    await s.tapRail(TabletModule.tasks);
    // Kaynakta S_tasks.q kalıcıdır: süzgeç ve alan metni tutarlı biçimde korunur.
    final texts = s
        .inPane(NzPaneRole.master, find.byType(EditableText))
        .evaluate()
        .map((e) => (e.widget as EditableText).controller.text)
        .toList();
    expect(
      texts,
      contains('asfalt'),
      reason: 'arama metni modül dönüşünde kalır',
    );
    expect(
      s.inPane(NzPaneRole.master, find.text('Faz3 asfalt işlemi')),
      findsWidgets,
      reason: 'liste hâlâ süzülü',
    );
    expect(
      s.inPane(NzPaneRole.master, find.text('ULA-1')),
      findsNothing,
      reason: 'süzgeç uygulanır',
    );
  }),
  // --- Sohbet DEĞİŞİMİ sıfırlar (S_chat.load, HTML 3212–3216): A→B→A taslak yok
  TabletScene('chat-switch-resets-draft', (s) async {
    await s.tapRail(TabletModule.messages);
    await _expectDefaultDetail(s, TabletModule.messages);
    await s.tester.enterText(_composerField().last, 'Sohbete özel taslak');
    await s.settle();
    expect(
      s.tester.widget<TextField>(_composerField().last).controller!.text,
      'Sohbete özel taslak',
    );
    await s.tapText(s.inPane(NzPaneRole.master, find.text('Genel')));
    expect(
      s.tester.widget<TextField>(_composerField().last).controller!.text,
      isEmpty,
      reason: 'sohbet değişince taslak temizlenir',
    );
    await s.tapText(s.inPane(NzPaneRole.master, find.text('Koordinatörler')));
    expect(
      s.tester.widget<TextField>(_composerField().last).controller!.text,
      isEmpty,
      reason:
          'ilk sohbete dönünce de boş (prototipte sohbet başına taslak yok)',
    );
    expect(find.textContaining(_l.uiMessagesReplyTo), findsNothing);
  }),
  // --- AYNI sohbet yeniden seçimi: KAYNAK `S_chat.load` koşulsuz sıfırlar (HTML 3212–3216) ve
  // `openChat` her seçimde onu çağırır (3517, 3204): taslak/yanıt temizlenir, mesajlar kalır,
  // yığın büyümez. (Yeniden BOYUT ise ayrı kuraldır: taslak korunur, host testinde.)
  TabletScene('chat-same-reselect-follows-source', (s) async {
    await s.tapRail(TabletModule.messages);
    await _expectDefaultDetail(s, TabletModule.messages);
    expectUnreadDivider(s, present: true);
    // Kaynak `S_chat.load`: draft, reply, edit, refs, info, pin, atQ… hepsi sıfırlanır.
    await startReplyToK2(s);
    await s.tester.enterText(_composerField().last, 'Aynı sohbet taslağı');
    await s.settle();
    expectReplyChip(present: true);
    await s.tapText(s.inPane(NzPaneRole.master, find.text('Koordinatörler')));
    // Sıra: önce işaretçi ve taslak, en sonda yanıt çipi (hepsi aynı `load` sıfırlamasıdır;
    // tek kırmızıda hangisinin kaldığı görünsün diye yanıt çipi sona bırakıldı).
    expectUnreadDivider(s, present: false);
    expect(
      s.tester.widget<TextField>(_composerField().last).controller!.text,
      isEmpty,
      reason: 'kaynak: aynı sohbet seçimi de load ile taslağı sıfırlar',
    );
    expectReplyChip(present: false);
    expect(
      inChat(find.textContaining('trafo onayı')),
      findsWidgets,
      reason: 'sohbet içeriği (mesajlar) kalır',
    );
    expect(paneBack(s), findsNothing, reason: 'yığın büyümez');
    s.expectSplitGeometry();
  }),
  // --- Etiket sütunundan seçim (kaynak: etiket tıklaması da `pick`): BAR seçiminden ayrı sözleşme.
  TabletScene('gantt-label-selects-task', (s) async {
    await _openTasks(s);
    await openTimelineFromTasks(s);
    await s.tapText(
      find.descendant(
        of: find.byKey(GanttChart.labelsKey),
        matching: find.textContaining('Faz3 asfalt işlemi'),
      ),
      reason: 'Gantt etiket sütunu satırı',
    );
    expect(find.bySemanticsLabel('Seçili görev'), findsWidgets);
    expect(find.text('Görev ayrıntısını aç'), findsWidgets);
  }),
  // --- Gantt kapat: mod/rs aynı (HTML 3807); ray aynı modüle basış kapatır (3817–3819)
  TabletScene('gantt-close-keeps-module-and-selection', (s) async {
    await _openTasks(s);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Faz3 asfalt işlemi')),
    );
    await openTimelineFromTasks(s);
    expect(
      s.pane(NzPaneRole.master),
      findsNothing,
      reason: 'Gantt tam genişlik',
    );
    expect(s.railRect, isNotNull, reason: 'ray görünür');
    await s.tapText(find.bySemanticsLabel('Geri: Görevler'));
    expect(
      s.pane(NzPaneRole.master),
      findsOneWidget,
      reason: 'Görevler listesi geri geldi',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Faz3 asfalt işlemi')),
      findsWidgets,
      reason: 'closeGantt sağ yığını değiştirmez',
    );
    s.expectSplitGeometry();
  }),
  TabletScene('gantt-rail-same-module-closes-other-module-leaves', (s) async {
    await _openTasks(s);
    await openTimelineFromTasks(s);
    await s.tapRail(TabletModule.tasks);
    expect(
      s.pane(NzPaneRole.master),
      findsOneWidget,
      reason: 'aynı modüle basış Gantt\'ı kapatır',
    );
    await openTimelineFromTasks(s);
    await s.tapRail(TabletModule.archive);
    expect(
      find.bySemanticsLabel('Geri: Görevler'),
      findsNothing,
      reason: 'başka modül Gantt\'ı bırakır',
    );
    await _expectDefaultDetail(s, TabletModule.archive);
  }),
  // --- openTaskFromGantt: kaynak istisnası (HTML 3776, 3808): Görevler modülü + tek detail, geri yok
  TabletScene('gantt-open-task-resets-stack-to-tasks', (s) async {
    await s.tapRail(TabletModule.coordinatorships);
    await s.tapText(
      s.inPane(NzPaneRole.detail, find.text(_l.uiCoordLinkArchive)),
    );
    await s.tapRail(TabletModule.tasks);
    await openTimelineFromTasks(s);
    await tapGanttBar(s, 'MEK-6');
    await s.tapText(find.text('Görev ayrıntısını aç'));
    expect(s.pane(NzPaneRole.master), findsOneWidget);
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Faz3 asfalt işlemi')),
      findsWidgets,
      reason: 'seçilen görev sağda; Görevler modülü',
    );
    expect(paneBack(s), findsNothing, reason: 'rs=[detail] tek giriş');
    expect(find.bySemanticsLabel('Geri: Görevler'), findsNothing);
  }),
  // --- Takvim (HTML S_cal 3401–3500): bugün, ay/hafta, adım, seçili gün kalıcılığı
  TabletScene('calendar-default-today-and-month', (s) async {
    await s.tapRail(TabletModule.calendar);
    final master = NzPaneRole.master;
    expect(s.inPane(master, find.text('Ekim 2026')), findsWidgets);
    expect(
      s.inPane(master, find.text('21 Ekim, Çarşamba')),
      findsWidgets,
      reason: 'seçili gün = örnek verinin bugünü',
    );
    expect(calendarCell('21 Ekim, Çarşamba'), findsWidgets);
    expect(
      s.inPane(master, find.textContaining('toplantılar · 2')),
      findsWidgets,
    );
    expect(
      s.inPane(NzPaneRole.detail, find.text('Bir kayıt seç')),
      findsWidgets,
    );
  }),
  TabletScene('calendar-mode-step-today', (s) async {
    await s.tapRail(TabletModule.calendar);
    final master = NzPaneRole.master;
    await s.tapText(find.bySemanticsLabel(RegExp(r'^Haftaya daralt')));
    expect(find.bySemanticsLabel(RegExp(r'^Aya genişlet')), findsWidgets);
    expect(
      s.inPane(master, find.textContaining('. hafta')),
      findsWidgets,
      reason: 'hafta kipi başlığı',
    );
    await s.tapText(find.bySemanticsLabel('Sonraki hafta'));
    expect(
      s.inPane(master, find.text('28 Ekim, Çarşamba')),
      findsWidgets,
      reason: 'hafta kipinde ±7 gün',
    );
    await s.tapText(s.inPane(master, find.text('Bugün')));
    expect(s.inPane(master, find.text('21 Ekim, Çarşamba')), findsWidgets);
    await s.tapText(find.bySemanticsLabel(RegExp(r'^Aya genişlet')));
    await s.tapText(find.bySemanticsLabel('Sonraki ay'));
    expect(s.inPane(master, find.text('Kasım 2026')), findsWidgets);
    expect(
      s.inPane(master, find.text('1 Kasım, Pazar')),
      findsWidgets,
      reason: 'bugünün ayı değilse ayın 1\'i',
    );
    await s.tapText(find.bySemanticsLabel('Önceki ay'));
    expect(
      s.inPane(master, find.text('21 Ekim, Çarşamba')),
      findsWidgets,
      reason: 'bugünün ayına dönünce bugün seçili',
    );
  }),
  TabletScene('calendar-selection-survives-module-roundtrip', (s) async {
    await s.tapRail(TabletModule.calendar);
    await s.tapText(calendarCell('22 Ekim, Perşembe'));
    expect(
      s.inPane(NzPaneRole.master, find.text('22 Ekim, Perşembe')),
      findsWidgets,
    );
    await s.tapRail(TabletModule.archive);
    await s.tapRail(TabletModule.calendar);
    expect(
      s.inPane(NzPaneRole.master, find.text('22 Ekim, Perşembe')),
      findsWidgets,
      reason: 'S_cal durumu kalıcı: seçili gün modül gidiş-dönüşünde korunur',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.text('Bir kayıt seç')),
      findsWidgets,
      reason: 'sağ TÜR varsayılana döner',
    );
  }),
  TabletScene('calendar-meeting-preview-and-write-to-group', (s) async {
    await s.tapRail(TabletModule.calendar);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Hidrofor teslim kontrolü')),
    );
    expect(
      find.byType(Dialog),
      findsWidgets,
      reason: 'önizleme tablette merkezi pencere',
    );
    expect(find.text('Havalimanı yerleşkesi'), findsWidgets, reason: 'Yer');
    expect(find.text('Basınç testi sonuçları'), findsWidgets, reason: 'gündem');
    await s.tapText(find.text('Gruba yaz'));
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Hidrofor teslim ekibi')),
      findsWidgets,
      reason: 'sohbet SAĞ yığına açılır',
    );
    expect(
      s.inPane(NzPaneRole.master, find.text('Ekim 2026')),
      findsWidgets,
      reason: 'sol modül Takvim kalır, Mesajlar\'a atlamaz',
    );
    expect(paneBack(s), findsWidgets, reason: 'rs=[empty, chat]');
    await s.tapText(paneBack(s));
    expect(
      s.inPane(NzPaneRole.detail, find.text('Bir kayıt seç')),
      findsWidgets,
    );
  }),
  TabletScene('calendar-task-row-opens-detail-keeps-left', (s) async {
    await s.tapRail(TabletModule.calendar);
    await s.tapText(calendarCell('23 Ekim, Cuma'));
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Yemek planlama takip')),
    );
    expect(
      s.inPane(NzPaneRole.detail, find.textContaining('Yemek planlama takip')),
      findsWidgets,
      reason: 'görev detayı sağda',
    );
    expect(
      s.inPane(NzPaneRole.master, find.text('Ekim 2026')),
      findsWidgets,
      reason: 'takvim solda kalır',
    );
    expect(paneBack(s), findsWidgets);
  }),
  TabletScene('calendar-plan-meeting-modal-prefilled', (s) async {
    await s.tapRail(TabletModule.calendar);
    await s.tapText(calendarCell('22 Ekim, Perşembe'));
    await s.tapText(find.bySemanticsLabel('Seçili güne toplantı planla'));
    final r = s.modalRect;
    expect(r, isNotNull, reason: 'merkezi modal');
    expect(
      r!.width,
      closeTo(TabletContract.modalWidth(s.windowSize.width), 0.01),
    );
    expect(
      find.textContaining('22 Ekim'),
      findsWidgets,
      reason: 'tarih seçili günle dolu',
    );
  }),
];
