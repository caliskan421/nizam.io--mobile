// Arşiv kuralları: sıralama/arama, etiket payı.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/data/sample/sample_archive_repository.dart';
import 'package:nizamio/features/archive/domain/archive.dart';

void main() {
  test('sıralama: son yükleme, Türkçe ada göre, boyuta göre; arama', () async {
    final f = await const SampleArchiveRepository().loadFolders();
    expect(
      visibleFolders(f, sort: ArchiveSort.recent).take(3).map((x) => x.code),
      ['İDA', 'OPE', 'MİM'],
    );
    expect(
      visibleFolders(f, sort: ArchiveSort.name).take(4).map((x) => x.name),
      ['Altyapı ve tesisat', 'Eğitim ve Arge', 'Elektrik ve enerji', 'Fuar'],
    );
    expect(visibleFolders(f, sort: ArchiveSort.size).first.code, 'MEK');
    expect(
      visibleFolders(f, sort: ArchiveSort.recent, query: 'İDARİ').single.code,
      'İDA',
    );
    expect(tagCount(227, ArchiveTag.field), 114);
    expect(folderFilesFor(f.first, tag: ArchiveTag.data), 16);
    expect(folderFilesFor(f.first, customTag: true), 0);
  });
}
