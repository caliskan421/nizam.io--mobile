// CurrentProgramController: seçim varsa S2 GET /v1/program (X-Nizamio-Program ile); yoksa istek yok.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/scope/application/current_program_controller.dart';
import 'package:nizamio/features/scope/domain/program.dart';

import '../../pilot_support.dart';

void main() {
  test('seçim yok: null, S2 isteği çıkmaz', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    h.container.listen(currentProgramControllerProvider, (_, _) {});
    expect(
      await h.container.read(currentProgramControllerProvider.future),
      isNull,
    );
    expect(h.backend.count('GET', '/v1/program'), 0);
  });

  test('seçili programın adı S2 yanıtından gelir; başlık taşınır', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    h.read(scopeControllerProvider).selectProgram('prog-2');
    h.container.listen(currentProgramControllerProvider, (_, _) {});
    final program = await h.container.read(
      currentProgramControllerProvider.future,
    );
    expect(
      program,
      const Program(id: 'prog-2', name: 'Program İki', year: 2026),
    );
    expect(h.backend.requests.last.header('X-Nizamio-Program'), 'prog-2');
  });

  test('seçim değişince yeniden okunur', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    final scope = h.read(scopeControllerProvider)..selectProgram('prog-1');
    h.container.listen(currentProgramControllerProvider, (_, _) {});
    await h.container.read(currentProgramControllerProvider.future);
    scope.selectProgram('prog-2');
    final program = await h.container.read(
      currentProgramControllerProvider.future,
    );
    expect(program!.id, 'prog-2');
  });

  test('sunucu hatası AsyncError(ApiError)', () async {
    final backend = PilotBackend();
    final h = await pilotHarness(backend, signedIn: true);
    h.read(scopeControllerProvider).selectProgram('prog-1');
    h.backend.handler = (r) => r.path == '/v1/program'
        ? errorBody(403, 'program.not_authorized')
        : backend.handle(r);
    h.container.listen(currentProgramControllerProvider, (_, _) {});
    await expectLater(
      h.container.read(currentProgramControllerProvider.future),
      throwsA(apiCode('program.not_authorized')),
    );
  });
}
