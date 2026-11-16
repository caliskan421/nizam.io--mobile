import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/features/tables/data/tables_api_repository.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/table_edit.dart';
import 'package:nizamio/features/tables/domain/table_workspace.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/tasks/data/work_fake_dio.dart';
import 'router_test_support.dart';
import 'table_workspace_flow_test.dart' show WorkspaceServer, openWorkspace;

class CommentServer extends WorkspaceServer {
  CommentServer() {
    rows.add(TableRecord(id: 'r1'));
    cells.add(
      const TableCellState(
        row: 'r1',
        column: 'c1',
        value: 'Kontrol',
        display: 'Kontrol',
        version: 1,
      ),
    );
  }
  String? body;
  bool edited = false;
  @override
  Future<TableOperationReceipt> execute(
    TableLocation l,
    String id,
    TableEdit edit,
    String key,
  ) async {
    if (edit is EditTableComment) {
      body = edit.body;
      edited = edit.action == TableCommentAction.edit;
    }
    return super.execute(l, id, edit, key);
  }

  @override
  Future<TablePageSlice<TableCommentEntry>> comments(
    TableLocation l,
    String id, {
    String? row,
    String? cursor,
  }) async {
    // Exercise the actual HTTP mapping, including the visible author object.
    final (dio, _) = fakeDio({
      'items': [
        if (body != null)
          {
            'id': 'comment1',
            'row_id': 'r1',
            'column_id': 'c1',
            'author': {'id': 'me', 'name': 'Ayşe Yılmaz'},
            'mine': true,
            'body': body,
            'seq': 2,
            'created_at': '2026-11-16T00:00:00Z',
            'edited_at': edited ? '2026-11-16T01:00:00Z' : null,
          },
      ],
      'next_cursor': null,
    });
    try {
      return await ApiTablesRepository(() => dio)
          .comments(l, id, row: row, cursor: cursor);
    } finally {
      dio.close();
    }
  }
}

void main() {
  setUpFonts();
  for (final size in [const Size(390, 844), const Size(1180, 820)]) {
    testWidgets('hücre yorumu eklenir ve yazarıyla okunup düzenlenir: $size', (
      tester,
    ) async {
      final server = CommentServer();
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      await openWorkspace(tester, server, phase, size);
      await tester.tap(find.text('Kontrol'));
      await settle(tester);
      await tester.ensureVisible(find.text('Hücre yorumları'));
      await tester.tap(find.text('Hücre yorumları'));
      await settle(tester);
      expect(find.text('Henüz yorum yok.'), findsOneWidget);
      await tester.tap(find.text('Yorum ekle'));
      await settle(tester);
      await tester.enterText(
        find.byType(EditableText).last,
        'Teslim doğrulandı.',
      );
      await tester.pump();
      await tester.tap(find.text('Kaydet').last);
      await settle(tester);
      expect(find.text('Teslim doğrulandı.'), findsOneWidget);
      expect(find.text('Ayşe Yılmaz'), findsOneWidget);
      expect(find.text('Henüz yorum yok.'), findsNothing);
      expect(find.text('Sunucudan beklenmeyen bir yanıt geldi.'), findsNothing);
      await tester.tap(find.text('Düzenle'));
      await settle(tester);
      await tester.enterText(
        find.byType(EditableText).last,
        'Teslim ve test doğrulandı.',
      );
      await tester.pump();
      await tester.tap(find.text('Kaydet').last);
      await settle(tester);
      expect(find.text('Teslim ve test doğrulandı.'), findsOneWidget);
      expect(find.text('Düzenlendi'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
