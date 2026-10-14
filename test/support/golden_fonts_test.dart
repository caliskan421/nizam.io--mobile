// loadAppFonts kanıtı (her platformda, etiketsiz): MaterialIcons yüklenir ve ikonlar tofu değildir.
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'golden.dart';

const _key = ValueKey('icon');

Future<Uint8List> _render(WidgetTester tester, IconData icon) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: _key,
          child: ColoredBox(
            color: const Color(0xFFFFFFFF),
            child: Icon(icon, size: 48, color: const Color(0xFF000000)),
          ),
        ),
      ),
    ),
  );
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_key));
  final data = await tester.runAsync(() async {
    final image = await boundary.toImage();
    return image.toByteData(format: ui.ImageByteFormat.rawRgba);
  });
  return data!.buffer.asUint8List();
}

void main() {
  testWidgets(
    'MaterialIcons yüklenir; farklı ikonlar farklı çizilir (tofu değil)',
    (tester) async {
      final families = (await tester.runAsync(loadAppFonts))!;
      expect(families, contains('MaterialIcons'));

      final a = await _render(tester, Icons.error_outline);
      final b = await _render(tester, Icons.inbox_outlined);
      // İkon çizilmiş: kutuda siyah (mürekkep) piksel var.
      bool hasInk(Uint8List px) {
        for (var i = 0; i < px.length; i += 4) {
          if (px[i] < 128) return true;
        }
        return false;
      }

      expect(hasInk(a), isTrue);
      expect(hasInk(b), isTrue);
      // Tofu'da her ikon aynı kutuyu çizer; gerçek yazı tipinde bitmap'ler farklıdır.
      expect(a, isNot(equals(b)));
    },
  );

  test('loadAppFonts memoize edilir', () async {
    expect(identical(loadAppFonts(), loadAppFonts()), isTrue);
  });
}
