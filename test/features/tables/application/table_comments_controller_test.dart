// Yorum listesi: satıra göre okunur; tablo görünümünün yorum sayacı artınca (canlı yorum
// olayı ya da kendi yorum komutu) yeniden okunur; yorum komutu add_comment gönderir.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/features/tables/application/table_comments_controller.dart';
import 'package:nizamio/features/tables/application/table_controller.dart';
import 'package:nizamio/features/tables/domain/table_models.dart';
import 'package:nizamio/features/tables/domain/table_operation.dart';

import '../fake_tables_repository.dart';
import '../tables_test_support.dart';

class _Comments extends FakeTablesRepository {
  final reads = <String?>[];
  @override
  Future<PageSlice<TableCommentItem>> comments(
    TableScope scope,
    String tableId, {
    String? rowId,
    PageRequest page = const PageRequest(),
  }) async {
    reads.add(rowId);
    return PageSlice(
      items: [
        TableCommentItem(
          id: 'm${reads.length}',
          rowId: rowId!,
          mine: true,
          body: 'not',
          seq: reads.length,
          createdAt: DateTime(2026),
        ),
      ],
    );
  }
}

void main() {
  test('satır yorumları okunur; kendi yorumu listeyi yeniler', () async {
    final repo = _Comments()..add('t1');
    final c = tablesContainer(repo)
      ..listen(tableControllerProvider('t1'), (_, _) {})
      ..listen(tableCommentsControllerProvider('t1', 'r1'), (_, _) {});
    final first = await c.read(
      tableCommentsControllerProvider('t1', 'r1').future,
    );
    expect(first.items.single.rowId, 'r1');
    expect(repo.reads, ['r1']);
    await c
        .read(tableControllerProvider('t1').notifier)
        .addComment('r1', ' Merhaba ');
    final op = repo.applied.single.$2 as AddComment;
    expect(op.body, 'Merhaba');
    expect(op.rowId, 'r1');
    final again = await c.read(
      tableCommentsControllerProvider('t1', 'r1').future,
    );
    expect(repo.reads, ['r1', 'r1']);
    expect(again.items.single.id, 'm2');
  });
}
