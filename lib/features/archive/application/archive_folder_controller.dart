import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/archive.dart';
import '../domain/records.dart';

part 'archive_folder_controller.g.dart';

/// Klasör ayrıntısı sekmesi.
enum ArchiveFolderTab { tasks, files }

/// Klasör ayrıntısının durumu: sekme ve sunucu süzgeçleri (etiket, görev, yükleyen, sıralama).
@immutable
final class ArchiveFolderViewState {
  const ArchiveFolderViewState({
    this.tab = ArchiveFolderTab.tasks,
    this.tag,
    this.task,
    this.uploader,
    this.mimeCategory,
    this.sort = ArchiveSort.recent,
    this.query = '',
  });

  final ArchiveFolderTab tab;
  final RecordTag? tag;

  /// Görev süzgeci (`work_item_id`).
  final String? task;

  /// Yükleyen süzgeci (hesap kimliği).
  final String? uploader;
  final ArchiveMimeCategory? mimeCategory;
  final ArchiveSort sort;
  final String query;

  bool get hasFileFilters =>
      tag != null || uploader != null || mimeCategory != null;

  /// Sıralama dışında süzgeç var mı (ZIP düğmesi görünen dosyaları indirir).
  bool get filtered =>
      tag != null ||
      task != null ||
      uploader != null ||
      mimeCategory != null ||
      query.trim().isNotEmpty;

  /// Dosya listesinin sunucu süzgeci.
  ArchiveAttachmentFilter get filter => ArchiveAttachmentFilter(
    tag: tag,
    workItemId: task,
    uploaderId: uploader,
    mimeCategory: mimeCategory,
    sort: sort,
    search: query.trim().isEmpty ? null : query.trim(),
  );

  ArchiveFolderViewState copyWith({
    ArchiveFolderTab? tab,
    RecordTag? Function()? tag,
    String? Function()? task,
    String? Function()? uploader,
    ArchiveMimeCategory? Function()? mimeCategory,
    ArchiveSort? sort,
    String? query,
  }) => ArchiveFolderViewState(
    tab: tab ?? this.tab,
    tag: tag == null ? this.tag : tag(),
    task: task == null ? this.task : task(),
    uploader: uploader == null ? this.uploader : uploader(),
    mimeCategory: mimeCategory == null ? this.mimeCategory : mimeCategory(),
    sort: sort ?? this.sort,
    query: query ?? this.query,
  );
}

/// Klasör ayrıntısı görünüm komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme
/// ve süzgeçler sıfırlanır. Sunucu eylemleri `ArchiveActionsController`'dadır.
@riverpod
class ArchiveFolderController extends _$ArchiveFolderController {
  @override
  ArchiveFolderViewState build(String code) => const ArchiveFolderViewState();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setTab(ArchiveFolderTab t) => state = state.copyWith(tab: t);

  void setTag(RecordTag? t) => state = state.copyWith(tag: () => t);

  /// Görev klasörüne dokunuş: dosyalar sekmesi o görevle süzülür.
  void openTask(String workItemId) => state = state.copyWith(
    tab: ArchiveFolderTab.files,
    task: () => workItemId,
  );

  void clearTask() => state = state.copyWith(task: () => null);

  void setUploader(String? accountId) =>
      state = state.copyWith(uploader: () => accountId);

  void setMimeCategory(ArchiveMimeCategory? value) =>
      state = state.copyWith(mimeCategory: () => value);

  void clearFileFilters() => state = state.copyWith(
    tag: () => null,
    uploader: () => null,
    mimeCategory: () => null,
  );

  /// Son yükleme → Ada göre → Boyuta göre → …
  void cycleSort() => state = state.copyWith(
    sort:
        ArchiveSort.values[(state.sort.index + 1) % ArchiveSort.values.length],
  );
}
