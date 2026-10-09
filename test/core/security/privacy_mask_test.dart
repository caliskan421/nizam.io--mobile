// Arka plan ekran maskesi altyapısı (F14 kapsam 9).
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/security/privacy_mask.dart';

void main() {
  testWidgets('ön plan dışında maske açılır, geri gelince kalkar', (
    tester,
  ) async {
    final controller = PrivacyMaskController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      PrivacyMask(
        controller: controller,
        child: const Text('gizli', textDirection: TextDirection.ltr),
      ),
    );
    final mask = find.byKey(const ValueKey('privacy-mask'));
    expect(mask, findsNothing);

    for (final s in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
      await tester.pump();
      expect(mask, findsOneWidget, reason: '$s');
    }
    for (final s in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(s);
    }
    await tester.pump();
    expect(mask, findsNothing);
  });
}
