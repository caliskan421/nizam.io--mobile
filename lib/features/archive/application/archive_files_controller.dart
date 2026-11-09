import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/records.dart';
import 'archive_folder_controller.dart';
import 'archive_folder_sources.dart';
import 'archive_providers.dart';

part 'archive_files_controller.g.dart';

/// Klasörün dosya listesi: yüklenmiş satırlar, sonraki sayfanın imleci ve sonraki sayfa durumu.
@immutable
final class ArchiveFilesState {
  const ArchiveFilesState({
    required this.items,
    this.nextCursor,
    this.loadingMore = false,
    this.moreError,
  });

  final List<RecordFile> items;

  /// null → son sayfa.
  final String? nextCursor;
  final bool loadingMore;

  /// Sonraki sayfa hatası (otomatik yeniden deneme yok; yalnız dokunuşla).
  final ApiError? moreError;

  bool get hasMore => nextCursor != null;

  ArchiveFilesState copyWith({
    List<RecordFile>? items,
    String? Function()? nextCursor,
    bool? loadingMore,
    ApiError? Function()? moreError,
  }) => ArchiveFilesState(
    items: items ?? this.items,
    nextCursor: nextCursor == null ? this.nextCursor : nextCursor(),
    loadingMore: loadingMore ?? this.loadingMore,
    moreError: moreError == null ? this.moreError : moreError(),
  );
}

/// Klasörün arşiv dosyaları (`archiveAttachments`, imleçli). Süzgeç ([ArchiveFolderController])
/// değişince liste baştan yüklenir (eksen değişince eski imleç geçersizdir). Yöneticide uç dönem
/// genelidir: satırlar klasörün görevleriyle süzülür (sayfa süzgeçten sonra kısa kalabilir;
/// "daha fazla" imleç bitene dek açık kalır).
@riverpod
class ArchiveFilesController extends _$ArchiveFilesController {
  /// İstek başına satır.
  static const pageSize = 50;

  @override
  Future<ArchiveFilesState> build(String code) async {
    // Süzgeç değişince liste baştan yüklenir (değer [_page]'de okunur).
    ref.watch(archiveFolderControllerProvider(code).select((v) => v.filter));
    final ctx = await ref.watch(archiveFolderContextProvider(code).future);
    if (ctx == null) return const ArchiveFilesState(items: []);
    final page = await _page(const PageRequest(limit: pageSize));
    return ArchiveFilesState(items: page.items, nextCursor: page.nextCursor);
  }

  /// Bir sayfa: istek isteğin başladığı süzgeç ve kapsamla gider.
  Future<PageSlice<RecordFile>> _page(PageRequest request) async {
    final ctx = await ref.read(archiveFolderContextProvider(code).future);
    if (ctx == null) return PageSlice.empty();
    final filter = ref.read(archiveFolderControllerProvider(code)).filter;
    final page = await ref
        .read(archiveRepositoryProvider)
        .archiveAttachments(
          department: ctx.department,
          filter: filter,
          page: request,
        );
    if (!ctx.scope.widerThan(ctx.folder)) return page;
    final tasks = await ref.read(archiveFolderTasksProvider(code).future);
    final ids = {for (final t in tasks) t.workItemId};
    return PageSlice(
      items: [
        for (final f in page.items)
          if (ids.contains(f.workItemId)) f,
      ],
      nextCursor: page.nextCursor,
    );
  }

  /// Sonraki sayfa; sürmekte olan istek varken ya da son sayfada bir şey yapmaz.
  Future<void> loadMore() async {
    final s = state.value;
    final cursor = s?.nextCursor;
    if (s == null || cursor == null || s.loadingMore) return;
    state = AsyncData(s.copyWith(loadingMore: true, moreError: () => null));
    try {
      final page = await _page(PageRequest(limit: pageSize, cursor: cursor));
      // Süzgeç bu arada değiştiyse liste baştan yüklenmiştir: eski sonuç atılır.
      final now = state.value;
      if (!ref.mounted || now == null || now.nextCursor != cursor) return;
      state = AsyncData(
        now.copyWith(
          items: [...now.items, ...page.items],
          nextCursor: () => page.nextCursor,
          loadingMore: false,
        ),
      );
    } on Object catch (e) {
      final now = state.value;
      if (!ref.mounted || now == null || now.nextCursor != cursor) return;
      state = AsyncData(
        now.copyWith(loadingMore: false, moreError: () => toApiError(e)),
      );
    }
  }
}
