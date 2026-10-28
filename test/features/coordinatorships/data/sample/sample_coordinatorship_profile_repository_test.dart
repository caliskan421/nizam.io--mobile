// SampleCoordinatorshipProfileRepository: 11 koordinatörlük; birim sayıları tutarlı; sohbet
// kimliği ve etkinlik dolu; gerçek kişi adı yok (kimlikler katalogla aynı).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/coordinatorships/data/sample/sample_coordinatorship_profile_repository.dart';

void main() {
  test('örnek kaynak sözleşmeyi uygular', () async {
    final p = await SampleCoordinatorshipProfileRepository().load();
    expect(p.map((e) => e.code), [
      'ALT',
      'MEK',
      'ULA',
      'ELE',
      'İDA',
      'EĞİ',
      'OPE',
      'SAT',
      'MİM',
      'FUA',
      'SİS',
    ]);
    for (final e in p) {
      expect(e.units, isNotEmpty, reason: e.code);
      for (final u in e.units) {
        expect(u.done, inInclusiveRange(0, u.total), reason: u.name);
      }
      expect(e.events, isNotEmpty);
      expect(e.chatId, isNotEmpty);
    }
    expect(
      p.firstWhere((e) => e.code == 'OPE').extraMembers.toSet(),
      hasLength(13),
    );
    final text = p.map((e) => '${e.about} ${e.events.map((x) => x.target)}');
    expect(text.join(), isNot(contains('Teknofest')));
  });
}
