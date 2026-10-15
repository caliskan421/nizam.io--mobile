// ScopeSelectionController: seçim ve kaldırma; sonuç faz makinesindedir.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/scope/application/scope_selection_controller.dart';

import '../../pilot_support.dart';

void main() {
  test('select → scoped; clear → sessionOpen', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    h.container.listen(scopeSelectionControllerProvider, (_, _) {});
    final c = h.container.read(scopeSelectionControllerProvider.notifier);
    await c.select('prog-1');
    expect(h.read(appPhaseProvider), AppPhase.scoped);
    expect(h.read(scopeStateProvider).programId, 'prog-1');
    await c.clear();
    expect(h.read(appPhaseProvider), AppPhase.sessionOpen);
    expect(h.read(scopeSelectionControllerProvider).hasError, isFalse);
  });

  test('oturum yokken seçim hata olur, kapsam değişmez', () async {
    final h = await pilotHarness(PilotBackend());
    h.container.listen(scopeSelectionControllerProvider, (_, _) {});
    await h.container
        .read(scopeSelectionControllerProvider.notifier)
        .select('prog-1');
    expect(
      h.read(scopeSelectionControllerProvider).error,
      apiCode('client.not_signed_in'),
    );
    expect(h.read(scopeStateProvider).hasProgram, isFalse);
  });
}
