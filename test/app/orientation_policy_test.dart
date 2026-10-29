// Yön politikası: Android'de fiziksel ekranın kısa kenarı <600 dp ise
// yalnız dikey, aksi halde OS varsayılanı. Pencere boyutu karara girmez.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/orientation_policy.dart';

const _method = 'SystemChrome.setPreferredOrientations';
const _portrait = ['DeviceOrientation.portraitUp'];
const _free = <String>[];

/// `SystemChrome.setPreferredOrientations` çağrılarını kaydeder; [respond] verilirse yanıtı o
/// belirler.
List<List<String>> _recordCalls(
  WidgetTester tester, {
  Future<Object?> Function(int index)? respond,
}) {
  final calls = <List<String>>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method != _method) return null;
      calls.add((call.arguments as List).cast<String>());
      return respond == null ? null : respond(calls.length - 1);
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return calls;
}

/// Fiziksel ekranı (pencereden bağımsız) ayarlar.
void _display(WidgetTester tester, Size logical, {double dpr = 2}) {
  tester.view.display.devicePixelRatio = dpr;
  tester.view.display.size = logical * dpr;
}

void _resetView(WidgetTester tester) {
  addTearDown(tester.view.reset);
  addTearDown(tester.view.display.reset);
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

Widget _host() => const OrientationPolicyHost(child: _Counter());

void main() {
  group('orientationPolicyFor', () {
    test('fiziksel boyut DPR ile mantıksal dp\'ye çevrilir', () {
      // 1080x2340 px @3 = 360x780 dp → telefon.
      expect(
        orientationPolicyFor(const Size(1080, 2340), 3),
        OrientationPolicy.portraitOnly,
      );
      // Aynı pikseller @1 = 1080 dp → kilit yok.
      expect(
        orientationPolicyFor(const Size(1080, 2340), 1),
        OrientationPolicy.systemDefault,
      );
    });

    test('kısa kenar sınırı: 599.9 kilitli, 600 serbest', () {
      expect(
        orientationPolicyFor(const Size(1199.8, 2000), 2),
        OrientationPolicy.portraitOnly,
      );
      expect(
        orientationPolicyFor(const Size(1200, 2000), 2),
        OrientationPolicy.systemDefault,
      );
    });

    test(
      'genişlik değil kısa kenar belirler: 600 geniş yatay telefon kilitli',
      () {
        // 844x390 dp yatay telefon: genişlik ≥600 ama kısa kenar 390.
        expect(
          orientationPolicyFor(const Size(844, 390), 1),
          OrientationPolicy.portraitOnly,
        );
        expect(
          orientationPolicyFor(const Size(390, 844), 1),
          OrientationPolicy.portraitOnly,
        );
      },
    );

    test('tablet ve açık katlanabilir serbest', () {
      expect(
        orientationPolicyFor(const Size(1600, 2560), 2),
        OrientationPolicy.systemDefault,
      );
      expect(
        orientationPolicyFor(const Size(2560, 1600), 2),
        OrientationPolicy.systemDefault,
      );
      // Açık katlanabilir ~ 673x841 dp.
      expect(
        orientationPolicyFor(const Size(1812, 2176), 2.625),
        OrientationPolicy.systemDefault,
      );
    });

    test('geçersiz ölçü kilitlemez', () {
      const bad = [double.nan, double.infinity, 0.0, -1.0];
      for (final v in bad) {
        expect(
          orientationPolicyFor(const Size(1080, 2340), v),
          OrientationPolicy.systemDefault,
          reason: 'dpr $v',
        );
        expect(
          orientationPolicyFor(Size(v, 2340), 3),
          OrientationPolicy.systemDefault,
          reason: 'width $v',
        );
        expect(
          orientationPolicyFor(Size(1080, v), 3),
          OrientationPolicy.systemDefault,
          reason: 'height $v',
        );
      }
    });

    test('platform karşılığı', () {
      expect(orientationsFor(OrientationPolicy.portraitOnly), [
        DeviceOrientation.portraitUp,
      ]);
      expect(orientationsFor(OrientationPolicy.systemDefault), isEmpty);
    });
  });

  group('OrientationPolicyHost (Android)', () {
    testWidgets(
      'ilk bağlanmada telefon dikey kilitlenir; aynı ölçü tekrar çağırmaz',
      (tester) async {
        _resetView(tester);
        final calls = _recordCalls(tester);
        _display(tester, const Size(390, 844));
        await tester.pumpWidget(_host());
        expect(calls, [_portrait]);

        // Aynı ekranla gelen metrik olayı (ör. pencere yeniden düzeni) çağrı üretmez.
        tester.view.physicalSize = const Size(780, 1600);
        _display(tester, const Size(390, 844));
        await tester.pump();
        expect(calls, [_portrait]);
      },
    );

    testWidgets(
      'telefon → tablet → telefon: politika değişir, alt durum korunur',
      (tester) async {
        _resetView(tester);
        final calls = _recordCalls(tester);
        _display(tester, const Size(390, 844));
        await tester.pumpWidget(_host());
        final state = tester.state(find.byType(_Counter));

        _display(tester, const Size(800, 1280));
        await tester.pump();
        _display(tester, const Size(390, 844));
        await tester.pump();

        expect(calls, [_portrait, _free, _portrait]);
        expect(tester.state(find.byType(_Counter)), same(state));
      },
    );

    testWidgets('pencere daralsa ya da klavye açılsa tablet serbest kalır', (
      tester,
    ) async {
      _resetView(tester);
      final calls = _recordCalls(tester);
      _display(tester, const Size(800, 1280));
      tester.view.physicalSize = const Size(1600, 2560);
      await tester.pumpWidget(_host());
      expect(calls, [_free]);

      // Bölünmüş ekran: pencere telefon genişliğine iner, ekran aynı tablet.
      tester.view.physicalSize = const Size(640, 2560);
      await tester.pump();
      // Klavye: alt iç boşluk büyür.
      tester.view.viewInsets = const FakeViewPadding(bottom: 1200);
      await tester.pump();
      addTearDown(tester.view.resetViewInsets);

      expect(calls, [_free]);
    });

    testWidgets('başarısız ilk çağrı sonraki metrik olayında yeniden denenir', (
      tester,
    ) async {
      _resetView(tester);
      final calls = _recordCalls(
        tester,
        respond: (i) async =>
            i == 0 ? throw PlatformException(code: 'boom') : null,
      );
      _display(tester, const Size(390, 844));
      await tester.pumpWidget(_host());
      await tester.pump();
      expect(calls, [_portrait]);
      expect(tester.takeException(), isNull);

      tester.view.physicalSize = const Size(700, 1500);
      await tester.pump();
      expect(calls, [_portrait, _portrait]);

      // Başarılı tekrar sonrası aynı ölçü yeni çağrı üretmez.
      tester.view.physicalSize = const Size(780, 1600);
      await tester.pump();
      expect(calls, [_portrait, _portrait]);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'geç düşen eski hata yeni başarılı politikanın kaydını silmez',
      (tester) async {
        _resetView(tester);
        final first = Completer<Object?>();
        final calls = _recordCalls(
          tester,
          respond: (i) => i == 0 ? first.future : Future.value(),
        );
        _display(tester, const Size(390, 844));
        await tester.pumpWidget(_host());
        _display(tester, const Size(800, 1280));
        await tester.pump();
        expect(calls, [_portrait, _free]);

        first.completeError(PlatformException(code: 'late'));
        await tester.pump();

        // Tablet politikası hâlâ kayıtlı: aynı ekran yeni çağrı üretmez.
        tester.view.physicalSize = const Size(1000, 1000);
        await tester.pump();
        expect(calls, [_portrait, _free]);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('dispose sonrası metrik olayı çağrı üretmez', (tester) async {
      _resetView(tester);
      final calls = _recordCalls(tester);
      _display(tester, const Size(390, 844));
      await tester.pumpWidget(_host());
      await tester.pumpWidget(const SizedBox.shrink());

      _display(tester, const Size(800, 1280));
      await tester.pump();
      expect(calls, [_portrait]);
    });
  });

  testWidgets('iOS: platform çağrısı yok (Info.plist kilitler)', (
    tester,
  ) async {
    _resetView(tester);
    final calls = _recordCalls(tester);
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      _display(tester, const Size(390, 844));
      await tester.pumpWidget(_host());
      expect(find.byType(_Counter), findsOneWidget);
      _display(tester, const Size(800, 1280));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
    expect(calls, isEmpty);
  });
}
