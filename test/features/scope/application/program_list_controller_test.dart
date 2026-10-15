// ProgramListController: GET /v1/programs → PageSlice<Program>; hata ApiError.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/features/scope/application/program_list_controller.dart';
import 'package:nizamio/features/scope/domain/program.dart';

import '../../pilot_support.dart';

void main() {
  test('programlar yüklenir', () async {
    final h = await pilotHarness(PilotBackend(), signedIn: true);
    h.container.listen(programListControllerProvider, (_, _) {});
    final slice = await h.container.read(programListControllerProvider.future);
    expect(slice.items.map((p) => p.id), ['prog-1', 'prog-2']);
  });

  test(
    'program.not_authorized: AsyncError(ApiError); yeniden yükleme dokunuşla',
    () async {
      final backend = PilotBackend()..programsError = 'program.not_authorized';
      final h = await pilotHarness(backend, signedIn: true);
      h.container.listen(programListControllerProvider, (_, _) {});
      await expectLater(
        h.container.read(programListControllerProvider.future),
        throwsA(apiCode('program.not_authorized')),
      );
      expect(
        h.container.read(programListControllerProvider),
        isA<AsyncError<PageSlice<Program>>>(),
      );
      // Otomatik yeniden deneme yok: tek istek.
      expect(h.backend.count('GET', '/v1/programs'), 1);
      backend.programsError = null;
      h.container.invalidate(programListControllerProvider);
      final slice = await h.container.read(
        programListControllerProvider.future,
      );
      expect(slice.items, hasLength(2));
      expect(h.backend.count('GET', '/v1/programs'), 2);
    },
  );
}
