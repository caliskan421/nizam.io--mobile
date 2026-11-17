import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/records.dart';
import 'archive_controller.dart';
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
  Set<RecordTag> _tags = const {};
  String _query = '';
  final _owner = CacheOwnership();
  AsyncValue<PersonFilesState> get visible => _owner.visible(ref, state);

  @override
  Future<PersonFilesState> build(
    String accountId, {
    bool filterArchive = false,
  }) async {
    _generation++;
    await ref.watch(archiveViewFilterProvider.future);
    _tags = filterArchive
        ? ref.watch(archiveControllerProvider.select((s) => s.tags))
        : const {};
    _query = filterArchive
        ? ref.watch(archiveControllerProvider.select((s) => s.query)).trim()
        : '';
    final tags = _tags;
    final query = _query;
    final owner = _owner.watch(ref);
    final scope = await ref.watch(archiveScopeProvider.future);
    final files = await _loadPage(scope.department, tags: tags, query: query);
    if (ref.mounted) _owner.markLoaded(ref, owner);
    return PersonFilesState(files: files, department: scope.department);
  }

  // Tek etiket sunucuda süzülür. Çoklu seçim OR'dur; eşleşmeyen sayfaları atlar,
  // en çok beş okumadan sonra devam imlecini korur (sınırsız tarama yok).
  Future<PageSlice<RecordFile>> _loadPage(
    String department, {
    required Set<RecordTag> tags,
    required String query,
    String? cursor,
  }) async {
    final repo = ref.read(archiveRepositoryProvider);
    final projection = await ref.read(archiveViewFilterProvider.future);
    for (var i = 0; i < 5; i++) {
      final page = await repo.archiveAttachments(
        department: department,
        filter: ArchiveAttachmentFilter(
          uploaderId: accountId,
          tag: tags.length == 1 ? tags.single : null,
          search: query.isEmpty ? null : query,
        ),
        page: PageRequest(limit: 20, cursor: cursor),
      );
      final files = [
        for (final file in page.items)
          if ((tags.isEmpty || tags.contains(file.tag)) &&
              (projection == null ||
                  projection.taskIds.contains(file.workItemId)))
            file,
      ];
      if (files.isNotEmpty || !page.hasMore || i == 4) {
        return PageSlice(
          items: files,
          nextCursor: page.nextCursor,
          truncated: page.truncated,
        );
      }
      cursor = page.nextCursor;
    }
    throw StateError('unreachable');
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
      final page = await _loadPage(
        before.department,
        tags: _tags,
        query: _query,
        cursor: cursor,
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
