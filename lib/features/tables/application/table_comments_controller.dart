import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../domain/table_models.dart';
import 'table_controller.dart';
import 'table_view.dart';
import 'tables_providers.dart';

part 'table_comments_controller.g.dart';

@immutable
final class TableCommentsView {
  TableCommentsView({required List<TableCommentItem> items, this.nextCursor})
    : items = List.unmodifiable(items);
  final List<TableCommentItem> items;
  final String? nextCursor;
  bool get hasMore => nextCursor != null;
}

/// Bir satırın yorumları (`GET …/comments?row_id=`; `seq` artan). Snapshot yorum taşımaz
/// (K-26): liste, tablo görünümünün [TableView.commentsRevision] sayacı artınca (canlı akışta
/// yorum olayı ya da kendi yorum komutumuz) yeniden okunur. Yazım [TableController]
/// üzerinden (`add_comment`/`edit_comment`/`delete_comment`).
@riverpod
class TableCommentsController extends _$TableCommentsController {
  static const pageSize = 50;

  @override
  Future<TableCommentsView> build(String tableId, String rowId) async {
    ref.listen<AsyncValue<TableView>>(tableControllerProvider(tableId), (
      prev,
      next,
    ) {
      final before = prev?.value?.commentsRevision;
      final now = next.value?.commentsRevision;
      if (before != null && now != null && before != now) ref.invalidateSelf();
    });
    await ref.read(tableControllerProvider(tableId).future);
    final scope = ref.read(tableControllerProvider(tableId).notifier).scope;
    final page = await ref
        .read(tablesRepositoryProvider)
        .comments(
          scope,
          tableId,
          rowId: rowId,
          page: const PageRequest(limit: pageSize),
        );
    return TableCommentsView(items: page.items, nextCursor: page.nextCursor);
  }

  /// Sonraki sayfa (imleç son tüketilen yorumun `seq`'i).
  Future<void> loadMore() async {
    final v = state.value;
    if (v == null || !v.hasMore) return;
    final scope = ref.read(tableControllerProvider(tableId).notifier).scope;
    final page = await ref
        .read(tablesRepositoryProvider)
        .comments(
          scope,
          tableId,
          rowId: rowId,
          page: PageRequest(limit: pageSize, cursor: v.nextCursor),
        );
    if (!ref.mounted) return;
    state = AsyncData(
      TableCommentsView(
        items: [...v.items, ...page.items],
        nextCursor: page.nextCursor,
      ),
    );
  }
}
