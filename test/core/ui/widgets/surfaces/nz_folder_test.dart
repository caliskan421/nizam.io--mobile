// NzFolder: ad + açıklama, dokunma, token renkleri, küçük boy, dar ekran / 2.0 metin.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/theme/generated/tokens.gen.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_folder.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('ad, açıklama, dokunma ve tek düğme semantiği', (t) async {
    final handle = t.ensureSemantics();
    var n = 0;
    await t.pumpWidget(
      testApp(
        Center(
          child: NzFolder(
            name: 'Operasyon',
            caption: '78 dosya',
            onTap: () => n++,
          ),
        ),
      ),
    );
    expect(find.text('Operasyon'), findsOneWidget);
    expect(find.text('78 dosya'), findsOneWidget);
    await t.tap(find.byType(NzFolder));
    expect(n, 1);
    expect(
      t.getSemantics(find.byType(NzFolder)),
      matchesSemantics(
        label: 'Operasyon, 78 dosya',
        isButton: true,
        hasTapAction: true,
      ),
    );
    final art = t.getSize(find.byType(NzFolderArt));
    expect(art, NzFolder.artSize);
    handle.dispose();
  });

  testWidgets('küçük görev klasörü 64×54; koyu tema arka kapak rengi', (
    t,
  ) async {
    await t.pumpWidget(
      testApp(
        const Center(
          child: NzFolder(
            small: true,
            name: 'Hidrofor sistemi kurulumu',
            caption: '2 dosya',
            onTap: null,
          ),
        ),
        dark: true,
      ),
    );
    expect(t.getSize(find.byType(NzFolderArt)), NzFolder.artSizeSmall);
    expect(
      NizamioColors.dark.folderBack,
      isNot(NizamioColors.light.folderBack),
    );
  });

  testWidgets('360 / 2.0 üç sütunda taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 400);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(
      testApp(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final n in ['Sistem koordinatörlüğü', 'Fuar', 'Mekanik'])
              Expanded(
                child: NzFolder(name: n, caption: '12 dosya', onTap: () {}),
              ),
          ],
        ),
      ),
    );
    expect(t.takeException(), isNull);
  });
}
