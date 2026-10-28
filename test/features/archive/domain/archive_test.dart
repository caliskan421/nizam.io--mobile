// Arşiv kuralları: sıralama/arama, etiket payı, görev klasörleri ve örnek dosya üretimi.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/data/sample/sample_archive_repository.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/tasks/data/sample/sample_task_catalog_repository.dart';

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

  test(
    'görev klasörleri klasör toplamına tamamlanır; dosyalar üretilir',
    () async {
      final folders = await const SampleArchiveRepository().loadFolders();
      final catalog = await SampleTaskCatalogRepository().load();
      final alt = folders.firstWhere((x) => x.code == 'ALT');
      final groups = taskFolders(alt, catalog);
      expect(groups.fold<int>(0, (t, g) => t + g.files), alt.files);
      final files = folderFiles(alt, catalog);
      expect(files, hasLength(alt.files));
      expect(files.first.name, startsWith('WhatsApp Image 2026-'));
      expect(files.map((x) => x.id).toSet(), hasLength(files.length));
    },
  );
}
