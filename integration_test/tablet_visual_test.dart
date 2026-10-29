// Gerçek cihaz (iPad Pro 13" M5 simülatörü, iPadOS 26.3; hedef ED5DCAAF-2A7E-480E-8316-E1B9A96DD9BC)
// görsel + ölçü koşumu. Gerçek `NizamioApp`, gerçek bileşim kökü, `Flavor.dev` prototip modu,
// sahte HTTP; gerçek backend'e bağlanmaz. Görünüm boyutu AYARLANMAZ: gerçek yüzey çizilir,
// ölçüler (fiziksel/mantıksal boyut, dpr, güvenli alan, ray/liste/sağ bölme dikdörtgenleri)
// çalışma anında okunur ve `Directory.systemTemp/nizamio-tablet-shots/<sahne>.json` yazılır.
// PNG'ler `takeScreenshot` ile aynı köke `<sahne>.png` olarak yazılır (simülatörde
// `xcrun simctl get_app_container <udid> <bundle> data` altından kopyalanır).
//
// Yön (yatay/dikey) cihazda koordinatörce ayarlanır; test yönü zorlamaz. Dikey yeniden
// koşumda dosyaların ezilmemesi için `--dart-define=NIZAMIO_SHOT_TAG=portrait` kullanılabilir.
// Kullanıcı arayüzü eylemleri yalnız `WidgetTester` (tap/enterText/longPress); AppleScript ya da
// CGEvent yok. Eksik özellik (takvim, yatay Gantt, merkezi modal) sahneyi kırmızı bırakır.
//
// Koşum (bu turda ÇALIŞTIRILMADI):
//   flutter test integration_test/tablet_visual_test.dart -d ED5DCAAF-2A7E-480E-8316-E1B9A96DD9BC
// (test dosyası uygulamanın girişidir; `Flavor.dev` kod içinde verilir, `--flavor` gerekmez.)
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/tablet_harness.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// PNG baytlarını döndürür; SDK bağlayıcısı `reportData`'ya aynı baytları da ekler, dosya
  /// yazıldıktan sonra bellekte büyümesin diye temizlenir (SDK deposu normal çalışır).
  Future<List<int>> shot(String name) async {
    final bytes = await binding.takeScreenshot(name);
    final shots = binding.reportData?['screenshots'];
    if (shots is List) shots.clear();
    return bytes;
  }

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // Ekran görüntüsüz değişmezler: gerçek yüzeyde gezinme/durum kuralları.
  group('değişmezler (native, görüntüsüz)', () {
    for (final scene in tabletInvariantScenes) {
      testWidgets(scene.name, (tester) async {
        final s = await TabletSession.launch(tester);
        await s.signIn();
        await scene.run(s);
      });
    }
  });

  for (final light in [false, true]) {
    final theme = light ? ThemeMode.light : ThemeMode.dark;
    final suffix = light ? '-light' : '';
    group(light ? 'açık tema' : 'koyu tema', () {
      for (final scene in tabletScenes) {
        testWidgets('${scene.name}$suffix', (tester) async {
          // hostSize YOK: gerçek cihaz yüzeyi.
          final s = await TabletSession.launch(tester, theme: theme);
          if (scene.needsSignIn) await s.signIn();
          await scene.run(s);
          final m = await captureScene(
            s,
            '${scene.name}$suffix',
            takeScreenshot: shot,
          );
          expect(
            m['hostControlled'],
            isFalse,
            reason: 'native koşum görünümü ayarlamaz',
          );
        });
      }
    });
  }
}
