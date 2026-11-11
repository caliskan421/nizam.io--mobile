// ArchiveFolderController: sekme, görev klasörü → dosyalar sekmesi, süzgeçler ve sıralama döngüsü.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/archive/application/archive_files_controller.dart';
import 'package:nizamio/features/archive/application/archive_folder_controller.dart';
import 'package:nizamio/features/archive/domain/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart';

import '../archive_fixture.dart';

ArchiveFolderController _ctrl(ProviderContainer c, [String code = 'd1']) {
  c
    ..listen(archiveFolderControllerProvider(code), (_, _) {})
    ..listen(archiveFilesControllerProvider(code), (_, _) {});
  return c.read(archiveFolderControllerProvider(code).notifier);
}

void main() {
  test('görev klasörü dosyalar sekmesini o görevle açar; süzgeçler', () {
    final c = archiveContainer(FakeArchiveRepository());
    final ctrl = _ctrl(c)..openTask('w1');
    ArchiveFolderViewState s() => c.read(archiveFolderControllerProvider('d1'));
    expect(s().tab, ArchiveFolderTab.files);
    expect(s().task, 'w1');
    expect(s().filtered, isTrue);
    ctrl
      ..clearTask()
      ..setTag(RecordTag.ister);
    expect(s().filter, const ArchiveAttachmentFilter(tag: RecordTag.ister));
    ctrl
      ..setTag(null)
      ..cycleSort()
      ..cycleSort()
      ..cycleSort();
    expect(s().sort, ArchiveSort.recent);
    expect(s().filtered, isFalse);
    ctrl.setQuery(' dosya ');
    expect(s().filter.search, 'dosya');
    expect(s().filtered, isTrue);
    ctrl.setQuery('');
    expect(s().filter.search, isNull);
    expect(s().filtered, isFalse);
    ctrl.setTab(ArchiveFolderTab.tasks);
    expect(s().tab, ArchiveFolderTab.tasks);
  });
  test('dosya filtrelerini temizlemek görev ve aramayı korur', () {
    final c = archiveContainer(FakeArchiveRepository());
    final ctrl = _ctrl(c)
      ..openTask('w1')
      ..setQuery('rapor')
      ..setTag(RecordTag.plan)
      ..setUploader('u1')
      ..setMimeCategory(ArchiveMimeCategory.tablo);
    var state = c.read(archiveFolderControllerProvider('d1'));
    expect(state.hasFileFilters, isTrue);
    expect(state.filter.mimeCategory, ArchiveMimeCategory.tablo);
    expect(state.filter.uploaderId, 'u1');
    ctrl.clearFileFilters();
    state = c.read(archiveFolderControllerProvider('d1'));
    expect(state.hasFileFilters, isFalse);
    expect(
      state.filter,
      const ArchiveAttachmentFilter(workItemId: 'w1', search: 'rapor'),
    );
  });
}
