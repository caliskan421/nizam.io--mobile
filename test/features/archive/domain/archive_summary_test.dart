import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/archive_summary.dart';
import 'package:nizamio/features/archive/domain/records.dart';

RecordFile _file(
  String id,
  String type,
  int size, {
  String task = 'w',
  RecordTag tag = RecordTag.plan,
}) => RecordFile(
  id: id,
  workItemId: task,
  displayName: id,
  contentType: type,
  sizeBytes: size,
  tag: tag,
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

  group('archiveStats', () {
    final files = [
      _file('a', 'image/png', 100, task: 't1'),
      _file('b', 'application/pdf', 200, task: 't1', tag: RecordTag.sonuc),
      _file('c', 'text/plain', 50, task: 't2'),
      _file('d', 'image/png', 30, task: 'gone'),
      _file('a', 'image/png', 100, task: 't1'),
    ];
    String? folderOf(String task) => switch (task) {
      't1' => 'ALT',
      't2' => 'OPE',
      _ => null,
    };

    test('toplam, tür baytı, görev ve klasör özeti; bilinmeyen görev yalnız toplamda', () {
      final s = archiveStats(files, folderOf: folderOf, partial: true);
      expect((s.files, s.bytes, s.tasks), (4, 380, 3));
      expect(s.kindBytes, {
        ArchiveFileKind.image: 130,
        ArchiveFileKind.document: 50,
        ArchiveFileKind.pdf: 200,
      });
      final alt = s.folder('ALT');
      expect((alt.files, alt.bytes, alt.tasks), (2, 300, 1));
      expect(s.folder('OPE').bytes, 50);
      expect(s.folder('YOK').files, 0);
      expect(s.partial, isTrue);
    });

    test('etiket süzgeci yalnız seçili etiketli dosyaları sayar', () {
      final s = archiveStats(
        files,
        folderOf: folderOf,
        tags: {RecordTag.sonuc},
      );
      expect((s.files, s.bytes), (1, 200));
      expect(s.folder('OPE').files, 0);
    });

    test('sıralama: boyut ve dosya azalan/artan, eşitlikte ad; ad sırası', () {
      final s = archiveStats(files, folderOf: folderOf);
      const folders = [
        ArchiveFolder(code: 'OPE', name: 'Operasyon', files: 1),
        ArchiveFolder(code: 'ALT', name: 'Altyapı', files: 2),
        ArchiveFolder(code: 'FUA', name: 'Fuar', files: 0),
      ];
      List<String> codes(ArchiveFolderSort sort, {bool desc = true}) => [
        for (final f in sortArchiveFolders(
          folders,
          stats: s,
          sort: sort,
          descending: desc,
        ))
          f.code,
      ];
      expect(codes(ArchiveFolderSort.size), ['ALT', 'OPE', 'FUA']);
      expect(codes(ArchiveFolderSort.size, desc: false), ['FUA', 'OPE', 'ALT']);
      expect(codes(ArchiveFolderSort.files), ['ALT', 'OPE', 'FUA']);
      expect(codes(ArchiveFolderSort.name, desc: false), ['ALT', 'FUA', 'OPE']);
    });
  });
}
