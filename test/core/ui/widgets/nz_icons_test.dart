import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';

// NzIcons kararlı IconData kimlikleridir; NzIcon bunları çizimde özel SVG ile çözer.
// Burada çizim tercihi değil katalog kimliklerinin Flutter ile uyumu doğrulanır.
void main() {
  test('ikon kataloğu Flutter IconData kimliklerini korur', () {
    for (final icon in [
      NzIcons.add,
      NzIcons.back,
      NzIcons.eventAvailable,
      NzIcons.search,
      NzIcons.warning,
    ]) {
      expect(icon.fontFamily, Icons.add.fontFamily);
    }
  });
}
