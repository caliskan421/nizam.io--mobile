import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/archive_summary.dart';
import 'package:nizamio/features/archive/domain/records.dart';

RecordFile _file(String id, String type, int size) => RecordFile(
  id: id,
  workItemId: 'w',
  displayName: id,
  contentType: type,
  sizeBytes: size,
  tag: RecordTag.plan,
);

void main() {
  test('boyut toplanır, türler sayılır, aynı dosya bir kez', () {
    final s = summarizeArchive([
      _file('a', 'image/png', 100),
      _file('b', 'application/pdf', 200),
      _file('c', 'text/plain', 50),
      _file('a', 'image/png', 100),
    ], partial: true);
    expect(s.files, 3);
    expect(s.bytes, 350);
    expect(s.kinds, {
      ArchiveFileKind.image: 1,
      ArchiveFileKind.document: 1,
      ArchiveFileKind.pdf: 1,
    });
    expect(s.partial, isTrue);
  });

  test('boş arşivde bütün türler sıfır', () {
    final s = summarizeArchive(const []);
    expect(s.files, 0);
    expect(s.kinds.values, everyElement(0));
  });
}
