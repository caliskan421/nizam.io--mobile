import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/refresh.dart';
import '../../tasks/tasks.dart';
import 'archive_actions_controller.dart';
import 'archive_files_controller.dart';
import 'archive_folder_controller.dart';
import 'archive_folder_sources.dart';
import 'archive_folders_controller.dart';
import 'archive_providers.dart';

part 'archive_controller.g.dart';

/// Arşiv ekranının durumu: klasör araması ve süren indirme.
@immutable
final class ArchiveViewState {
  const ArchiveViewState({
    this.searchOpen = false,
    this.query = '',
    this.busy = false,
  });

  final bool searchOpen;
  final String query;

  /// Tam arşiv indirmesi sürüyor (çift dokunuş tek istek).
  final bool busy;

  ArchiveViewState copyWith({bool? searchOpen, String? query, bool? busy}) =>
      ArchiveViewState(
        searchOpen: searchOpen ?? this.searchOpen,
        query: query ?? this.query,
        busy: busy ?? this.busy,
      );
}

/// Arşiv ekranı komutları: yerel arama ve dönemin tam arşivi.
@Riverpod(keepAlive: true)
class ArchiveController extends _$ArchiveController {
  @override
  ArchiveViewState build() => const ArchiveViewState();

  /// Yeniden denemeyle aynı kaynakları tazeler; açık klasörün okumasını da bekler.
  Future<void> refresh({String? code}) => refreshWithFeedback(
    shown: code == null
        ? ref.read(archiveFoldersControllerProvider).hasValue
        : ref.read(archiveFolderContextProvider(code)).value != null,
    reload: () async {
      if (ref.read(taskCatalogControllerProvider).hasError) {
        await ref.read(taskCatalogControllerProvider.notifier).refresh();
      }
      ref
        ..invalidate(archiveScopeProvider)
        ..invalidate(archiveFoldersControllerProvider);
      await ref.read(archiveFoldersControllerProvider.future);
      if (code == null) return;
      await ref.read(archiveFolderContextProvider(code).future);
      if (ref.read(archiveFolderControllerProvider(code)).tab ==
          ArchiveFolderTab.tasks) {
        await ref.read(archiveFolderTasksProvider(code).future);
      } else {
        await Future.wait([
          ref.read(archiveFilesControllerProvider(code).future),
          ref.read(archiveFolderUploadersProvider(code).future),
        ]);
      }
    },
  );

  /// Arama kutusunu açar/kapatır; kapanınca sorgu temizlenir.
  void toggleSearch() => state = state.copyWith(
    searchOpen: !state.searchOpen,
    query: state.searchOpen ? '' : state.query,
  );

  void setQuery(String q) => state = state.copyWith(query: q);

  /// Dönemin tam arşivi (`archiveFullZip`; yalnız şirket yöneticisi — diğer rollerde istek
  /// gönderilmez, vazgeçme döner). [name] kayıt adı.
  Future<ArchiveOutcome> downloadAll(String name) async {
    if (state.busy) return (ok: false, error: null, path: null);
    state = state.copyWith(busy: true);
    try {
      final scope = await ref.read(archiveScopeProvider.future);
      if (!scope.admin) return (ok: false, error: null, path: null);
      final bytes = await ref
          .read(archiveRepositoryProvider)
          .downloadPeriodZip(department: scope.department);
      final path = await ref.read(downloadSinkProvider).save(name, bytes);
      return (ok: true, error: null, path: path);
    } on Object catch (e) {
      return (ok: false, error: toApiError(e), path: null);
    } finally {
      state = state.copyWith(busy: false);
    }
  }
}
