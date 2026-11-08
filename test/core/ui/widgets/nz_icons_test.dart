import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';

// Tek ikon kaynağı değişmezi: NzIcons yalnız Material yazı tipinden okur (telefon ve tablet
// aynı ikonu çizer; tablet SVG ikonları kaldırıldı). Tek tek ikon eşlemesi test edilmez.
void main() {
  test('ikonlar tek kaynaktan (Material yazı tipi) gelir', () {
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
