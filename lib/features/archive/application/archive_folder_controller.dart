import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/archive.dart';

part 'archive_folder_controller.g.dart';

/// Klasör ayrıntısı sekmesi.
enum ArchiveFolderTab { tasks, files }

/// Klasör ayrıntısının durumu: sekme, etiket ve görev süzgeci, silinen dosyalar.
@immutable
final class ArchiveFolderViewState {
  const ArchiveFolderViewState({
    this.tab = ArchiveFolderTab.tasks,
    this.tag,
    this.task,
    this.removed = const {},
  });

  final ArchiveFolderTab tab;
  final ArchiveTag? tag;

  /// Görev süzgeci (görev kodu).
  final String? task;

  /// Silinen kayıtlara taşınan dosyaların kimlikleri.
  final Set<String> removed;

  ArchiveFolderViewState copyWith({
    ArchiveFolderTab? tab,
    ArchiveTag? Function()? tag,
    String? Function()? task,
    Set<String>? removed,
  }) => ArchiveFolderViewState(
    tab: tab ?? this.tab,
    tag: tag == null ? this.tag : tag(),
    task: task == null ? this.task : task(),
    removed: removed ?? this.removed,
  );

  /// [all] içinden silinmemiş dosyalar.
  List<ArchiveFile> present(List<ArchiveFile> all) => [
    for (final f in all)
      if (!removed.contains(f.id)) f,
  ];

  /// Süzgeçlerden geçen dosyalar.
  List<ArchiveFile> visible(List<ArchiveFile> all) => [
    for (final f in present(all))
      if ((tag == null || f.tag == tag) && (task == null || f.taskCode == task))
        f,
  ];
}

/// Silinen kayıtlara taşınan dosya kimlikleri (oturum boyunca; prototip `gone` klasör yeniden
/// açılınca da korunur). Dosya kimlikleri klasörler arasında tektir.
@Riverpod(keepAlive: true)
class ArchiveRemovedFiles extends _$ArchiveRemovedFiles {
  @override
  Set<String> build() => const {};

  void add(String fileId) => state = {...state, fileId};
}

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme ve
/// süzgeçler sıfırlanır (prototip `openAFolder`), silinenler [ArchiveRemovedFiles]'ta kalır.
@riverpod
class ArchiveFolderController extends _$ArchiveFolderController {
  @override
  ArchiveFolderViewState build(String code) =>
      ArchiveFolderViewState(removed: ref.read(archiveRemovedFilesProvider));

  void setTab(ArchiveFolderTab t) => state = state.copyWith(tab: t);

  void setTag(ArchiveTag? t) => state = state.copyWith(tag: () => t);

  /// Görev klasörüne dokunuş: dosyalar sekmesi o görevle süzülür.
  void openTask(String taskCode) =>
      state = state.copyWith(tab: ArchiveFolderTab.files, task: () => taskCode);

  void clearTask() => state = state.copyWith(task: () => null);

  /// Dosyayı silinen kayıtlara taşır (yerel).
  void remove(String fileId) {
    ref.read(archiveRemovedFilesProvider.notifier).add(fileId);
    state = state.copyWith(removed: {...state.removed, fileId});
  }
}
