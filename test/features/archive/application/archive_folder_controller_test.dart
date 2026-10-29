// ArchiveFolderController: sekme, etiket ve görev süzgeci, silme; klasör başına ayrı durum.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/application/archive_folder_controller.dart';
import 'package:nizamio/features/archive/domain/archive.dart';

ArchiveFile _f(String id, ArchiveTag tag, String task) => ArchiveFile(
  id: id,
  name: '$id.pdf',
  kind: ArchiveFileKind.pdf,
  tag: tag,
  taskCode: task,
  taskTitle: task,
  uploadedBy: null,
  uploadedAt: DateTime(2026, 10, 1),
  sizeMb: 0.1,
);

void main() {
  test('görev klasörü dosyalar sekmesini o görevle süzer; etiket; silme', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final p = archiveFolderControllerProvider('ALT');
    c.listen(p, (_, _) {});
    final all = [
      _f('a', ArchiveTag.field, 'ALT-1'),
      _f('b', ArchiveTag.result, 'ALT-1'),
      _f('c', ArchiveTag.field, 'ALT-4'),
    ];
    c.read(p.notifier).openTask('ALT-1');
    expect(c.read(p).tab, ArchiveFolderTab.files);
    expect(c.read(p).visible(all).map((f) => f.id), ['a', 'b']);
    c.read(p.notifier).setTag(ArchiveTag.field);
    expect(c.read(p).visible(all).map((f) => f.id), ['a']);
    c.read(p.notifier)
      ..clearTask()
      ..remove('a');
    expect(c.read(p).visible(all).map((f) => f.id), ['c']);
    expect(c.read(p).present(all), hasLength(2));
    c.read(p.notifier).setTab(ArchiveFolderTab.tasks);
    expect(c.read(p).tab, ArchiveFolderTab.tasks);
    expect(
      c.read(archiveFolderControllerProvider('MEK')).tab,
      ArchiveFolderTab.tasks,
    );
  });

  test('ekran kapanınca süzgeçler sıfırlanır, silinenler kalır', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final p = archiveFolderControllerProvider('ALT');
    final sub = c.listen(p, (_, _) {});
    c.read(p.notifier)
      ..openTask('ALT-1')
      ..remove('a');
    sub.close();
    await c.pump(); // autoDispose: durum bırakılır
    final again = c.listen(p, (_, _) {});
    addTearDown(again.close);
    expect(c.read(p).tab, ArchiveFolderTab.tasks);
    expect(c.read(p).task, isNull);
    expect(c.read(p).removed, {'a'});
    expect(c.read(archiveRemovedFilesProvider), {'a'});
  });
}
