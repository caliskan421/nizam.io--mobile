import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/records.dart';
import 'archive_providers.dart';

part 'person_files_controller.g.dart';

/// Profilde yalnız açılan Dosyalar sekmesinin kullandığı imleçli arşiv sonucu.
class PersonFilesState {
  const PersonFilesState({
    required this.files,
    required this.department,
    this.loadingMore = false,
    this.error,
  });
  final PageSlice<RecordFile> files;
  final String department;
  final bool loadingMore;
  final ApiError? error;
}

@riverpod
class PersonFilesController extends _$PersonFilesController {
  var _generation = 0;
  final _owner = CacheOwnership();
  AsyncValue<PersonFilesState> get visible => _owner.visible(ref, state);

  @override
  Future<PersonFilesState> build(String accountId) async {
    _generation++;
    final owner = _owner.watch(ref);
    final scope = await ref.watch(archiveScopeProvider.future);
    final repo = ref.read(archiveRepositoryProvider);
    final files = await repo.archiveAttachments(
      department: scope.department,
      filter: ArchiveAttachmentFilter(uploaderId: accountId),
      page: const PageRequest(limit: 20),
    );
    if (ref.mounted) _owner.markLoaded(ref, owner);
    return PersonFilesState(files: files, department: scope.department);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    if (state.isLoading) return;
    final before = state.value;
    final cursor = before?.files.nextCursor;
    if (before == null || cursor == null || before.loadingMore) return;
    final generation = _generation;
    state = AsyncData(
      PersonFilesState(
        files: before.files,
        department: before.department,
        loadingMore: true,
      ),
    );
    try {
      final page = await ref
          .read(archiveRepositoryProvider)
          .archiveAttachments(
            department: before.department,
            filter: ArchiveAttachmentFilter(uploaderId: accountId),
            page: PageRequest(limit: 20, cursor: cursor),
          );
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(
        PersonFilesState(
          files: before.files.append(page),
          department: before.department,
        ),
      );
    } on Object catch (e, st) {
      // Rapor/çeviri bayat-durum korumasından ÖNCE; yalnız durum yazımı koruma altında.
      final error = toReportedApiError(e, st, source: ReportSource.archive);
      if (!ref.mounted || generation != _generation) return;
      state = AsyncData(
        PersonFilesState(
          files: before.files,
          department: before.department,
          error: error,
        ),
      );
    }
  }
}
