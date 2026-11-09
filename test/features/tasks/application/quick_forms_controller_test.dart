// Hızlı işlem formlarının koordinatörlük seçenekleri (yeni görev ve kullanıcı ekle ortak):
// yönetici programın bütün koordinatörlüklerini, koordinatör yalnız kendininkileri görür.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../coordinatorships/coord_backend.dart';
import '../../pilot_support.dart';

Future<List<String>> _options({required bool admin}) async {
  final h = await pilotHarness(CoordBackend()..admin = admin, signedIn: true);
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  await h.read(taskCatalogControllerProvider.future);
  return [for (final c in h.read(newTaskCoordinatorshipsProvider)) c.code];
}

void main() {
  test('seçenekler: yönetici hepsi, koordinatör yalnız kendininki', () async {
    expect(
      await _options(admin: true),
      unorderedEquals([dAlt, dEle, dEgi, dIda]),
    );
    expect(await _options(admin: false), [dAlt]);
  });
}
