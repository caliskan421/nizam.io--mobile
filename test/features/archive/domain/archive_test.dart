// Arşiv kuralları: klasör arama/sıralama, kapsamın departman başlığı, süzgeç eşitliği.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';

void main() {
  const folders = [
    ArchiveFolder(code: 'd3', name: 'Şantiye', files: 1),
    ArchiveFolder(code: 'd1', name: 'İdari işler', files: 4),
    ArchiveFolder(code: 'd2', name: 'Çevre', files: 0),
    ArchiveFolder(code: 'd4', name: 'Altyapı', files: 2),
  ];

  test('klasörler Türkçe alfabe sırasıyla; arama Türkçe harf duyarsız', () {
    expect(visibleFolders(folders).map((f) => f.code), [
      'd4',
      'd2',
      'd1',
      'd3',
    ]);
    expect(visibleFolders(folders, query: 'İDARİ').single.code, 'd1');
    expect(visibleFolders(folders, query: '  şan ').single.code, 'd3');
    expect(visibleFolders(folders, query: 'yok'), isEmpty);
  });

  test('kapsam: gerçek klasör kendi departmanıyla, sanal klasör kapsamla', () {
    const real = ArchiveFolder(code: 'd7', name: 'Saha', files: 1);
    const mine = ArchiveFolder(
      code: 'my-tasks',
      name: 'Görevlerim',
      files: 1,
      isVirtual: true,
    );
    const member = ArchiveScope(department: 'd1', admin: false);
    const admin = ArchiveScope(department: 'd1', admin: true);
    expect(member.departmentFor(real), 'd7');
    expect(member.departmentFor(mine), 'd1');
    // Yalnız yöneticinin liste uçları dönem genelidir (istemci klasörle süzer).
    expect(admin.widerThan(real), isTrue);
    expect(admin.widerThan(mine), isFalse);
    expect(member.widerThan(real), isFalse);
    expect(member, const ArchiveScope(department: 'd1', admin: false));
  });

  test('süzgeç değer eşitliği (aynı süzgeç listeyi yeniden yüklemez)', () {
    const a = ArchiveAttachmentFilter(tag: RecordTag.plan, workItemId: 'w1');
    expect(
      a,
      const ArchiveAttachmentFilter(tag: RecordTag.plan, workItemId: 'w1'),
    );
    expect(a.hashCode, isNot(const ArchiveAttachmentFilter().hashCode));
    expect(
      a ==
          const ArchiveAttachmentFilter(
            tag: RecordTag.plan,
            sort: ArchiveSort.name,
          ),
      isFalse,
    );
  });
}
