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

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum (ekran kapanınca sıfırlanır).
@riverpod
class ArchiveFolderController extends _$ArchiveFolderController {
  @override
  ArchiveFolderViewState build(String code) => const ArchiveFolderViewState();

  void setTab(ArchiveFolderTab t) => state = state.copyWith(tab: t);

  void setTag(ArchiveTag? t) => state = state.copyWith(tag: () => t);

  /// Görev klasörüne dokunuş: dosyalar sekmesi o görevle süzülür.
  void openTask(String taskCode) =>
      state = state.copyWith(tab: ArchiveFolderTab.files, task: () => taskCode);

  void clearTask() => state = state.copyWith(task: () => null);

  /// Dosyayı silinen kayıtlara taşır (yerel).
  void remove(String fileId) =>
      state = state.copyWith(removed: {...state.removed, fileId});
}
