// NzComposer / NzRefChip / NzComposerContext: gönder etkinliği, ek düğmesi dönüşü, üst
// şeritler, kaldır/vazgeç dokunuşları, alt boşluk (klavye), 360 / 2.0.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets('boşken gönder kapalı; yazınca açık, dokunuş gönderir', (
    t,
  ) async {
    final c = TextEditingController();
    addTearDown(c.dispose);
    var sent = 0;
    var attach = 0;
    Widget build() => testApp(
      Align(
        alignment: Alignment.bottomCenter,
        child: NzComposer(
          controller: c,
          hint: 'Mesaj',
          canSend: c.text.trim().isNotEmpty,
          onSend: () => sent++,
          sendLabel: 'Gönder',
          onAttach: () => attach++,
          attachLabel: 'Ek',
          bottomInset: 300,
        ),
      ),
    );
    await t.pumpWidget(build());
    await t.tap(find.byIcon(Icons.arrow_upward_rounded));
    expect(sent, 0);
    await t.enterText(find.byType(TextField), 'Merhaba');
    await t.pumpWidget(build());
    await t.tap(find.byIcon(Icons.arrow_upward_rounded));
    expect(sent, 1);
    await t.tap(find.byIcon(Icons.attach_file_rounded));
    expect(attach, 1);
    // Klavye boşluğu: çubuk alt kenardan en az 300 yukarıda.
    final bottom = t.getBottomLeft(find.byType(TextField)).dy;
    expect(bottom, lessThan(600 - 300));
  });

  testWidgets('ek açık: 45° döner; başlık şeritleri, atıf hapı ve bağlam', (
    t,
  ) async {
    final c = TextEditingController();
    addTearDown(c.dispose);
    var removed = 0;
    var cancelled = 0;
    await t.pumpWidget(
      testApp(
        Align(
          alignment: Alignment.bottomCenter,
          child: NzComposer(
            controller: c,
            hint: 'Mesaj',
            canSend: true,
            onSend: () {},
            sendLabel: 'Gönder',
            onAttach: () {},
            attachLabel: 'Ek',
            attachOpen: true,
            header: [
              NzRefChip(
                label: '#ALT-7',
                icon: Icons.checklist_rounded,
                removeLabel: 'Kaldır',
                onRemove: () => removed++,
              ),
              NzComposerContext(
                icon: Icons.reply_rounded,
                title: 'Kadir Özbek kişisine yanıt',
                text: 'Pompalar sahada',
                cancelLabel: 'Vazgeç',
                onCancel: () => cancelled++,
              ),
            ],
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(
      t.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
      0.125,
    );
    await t.tap(find.byIcon(Icons.close_rounded).first);
    await t.tap(find.byTooltip('Vazgeç'));
    expect(removed, 1);
    expect(cancelled, 1);
    expect(find.text('#ALT-7'), findsOneWidget);
  });

  testWidgets('360 / 2.0 taşma yok', (t) async {
    t.view.devicePixelRatio = 1;
    t.view.physicalSize = const Size(compactWidth, 700);
    addTearDown(t.view.reset);
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    final c = TextEditingController(text: 'uzun ' * 40);
    addTearDown(c.dispose);
    await t.pumpWidget(
      testApp(
        Align(
          alignment: Alignment.bottomCenter,
          child: NzComposer(
            controller: c,
            hint: 'Mesaj',
            canSend: true,
            onSend: () {},
            sendLabel: 'Gönder',
            onAttach: () {},
            attachLabel: 'Ek',
            header: [
              NzComposerContext(
                icon: Icons.edit_outlined,
                title: 'Mesajı düzenle',
                text: 'çok uzun bir mesaj metni ' * 4,
                cancelLabel: 'Vazgeç',
                onCancel: () {},
              ),
            ],
          ),
        ),
        dark: true,
      ),
    );
    expect(t.takeException(), isNull);
    expect(
      t.getSize(find.byType(TextField)).height,
      lessThanOrEqualTo(NzComposer.maxInputHeight),
    );
  });
}
