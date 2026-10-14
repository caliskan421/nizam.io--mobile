// Ekran boyutu matrisi: kit bileşenleri ve ekranlar bu dört boyutla sınanır (yol haritası A2).
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/layout.dart';

class ScreenSize {
  const ScreenSize(this.name, this.size, this.windowClass);

  final String name;
  final Size size;
  final WindowClass windowClass;

  @override
  String toString() => '$name ${size.width.toInt()}x${size.height.toInt()}';
}

const screenMatrix = <ScreenSize>[
  ScreenSize('telefon-kucuk', Size(360, 800), WindowClass.compact),
  ScreenSize('telefon-buyuk', Size(412, 915), WindowClass.compact),
  ScreenSize('tablet-kucuk', Size(700, 1000), WindowClass.medium),
  ScreenSize('tablet', Size(1024, 1366), WindowClass.expanded),
];

/// Matrisin her boyutu için ayrı `testWidgets` kaydeder (dpr 1, test sonunda sıfırlanır).
void testScreens(
  String description,
  Future<void> Function(WidgetTester tester, ScreenSize screen) body, {
  List<ScreenSize> sizes = screenMatrix,
}) {
  for (final screen in sizes) {
    testWidgets('$description [$screen]', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = screen.size;
      addTearDown(tester.view.reset);
      await body(tester, screen);
    });
  }
}
