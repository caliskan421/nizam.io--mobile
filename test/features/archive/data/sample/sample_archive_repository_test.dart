// SampleArchiveRepository: prototip koordinatörleri, benzersiz kodlar.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/data/sample/sample_archive_repository.dart';

void main() {
  test(
    '11 benzersiz koordinatörlük kodu; İdari işlerde koordinatör yok',
    () async {
      final f = await const SampleArchiveRepository().loadFolders();
      expect(f.map((x) => x.code).toSet(), hasLength(11));
      expect(f.firstWhere((x) => x.code == 'İDA').leads, isEmpty);
      expect(f.firstWhere((x) => x.code == 'ALT').leads, ['aa', 'av', 'ko']);
    },
  );
}
