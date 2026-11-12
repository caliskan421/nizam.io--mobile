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
  test('profil ataması yalnız seçilen koordinatörlüğün güncel ekip üyesini hazırlar', () async {
    final h = await pilotHarness(CoordBackend(), signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    await h.read(taskCatalogControllerProvider.future);
    final form = h.read(newTaskFormControllerProvider.notifier);
    form.prepare(coordinatorship: dAlt, initialAssignee: pKadir);
    expect(h.read(newTaskFormControllerProvider).assignees, [pKadir]);
    form.prepare(coordinatorship: dAlt, initialAssignee: pBurak);
    expect(h.read(newTaskFormControllerProvider).assignees, isEmpty);
  });

  test('takvimden açılış: tarih aralığı verilen günlerle (ters sırada yer değiştirir)', () async {
    final h = await pilotHarness(CoordBackend(), signedIn: true);
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    await h.read(taskCatalogControllerProvider.future);
    final form = h.read(newTaskFormControllerProvider.notifier);
    form.prepare(start: DateTime(2026, 11, 20, 15), end: DateTime(2026, 12, 4));
    var f = h.read(newTaskFormControllerProvider);
    expect(
      (f.start, f.end, f.month),
      (DateTime(2026, 11, 20), DateTime(2026, 12, 4), DateTime(2026, 11)),
    );
    form.prepare(start: DateTime(2026, 11, 9), end: DateTime(2026, 11, 2));
    f = h.read(newTaskFormControllerProvider);
    expect((f.start, f.end), (DateTime(2026, 11, 2), DateTime(2026, 11, 9)));
  });

  test('seçenekler: yönetici hepsi, koordinatör yalnız kendininki', () async {
    expect(
      await _options(admin: true),
      unorderedEquals([dAlt, dEle, dEgi, dIda]),
    );
    expect(await _options(admin: false), [dAlt]);
  });
}
