import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tables/data/tables_api_repository.dart';
import 'package:nizamio/features/tables/domain/table_document.dart';
import 'package:nizamio/features/tables/domain/tables_repository.dart';

import '../../tasks/data/work_fake_dio.dart';
import 'tables_api_repository_test.dart' show table;

void main() {
  for (final department in ['', 'd1']) {
    test(
      'tablo referans adları kimliğe bağlı kalır; redakte konumu korunur: $department',
      () async {
        final (dio, _) = fakeDio({
          'table': table(department: department),
          'columns': [
            {
              'id': 'link',
              'name': 'Bağlı',
              'type': 'table_reference',
              'width': 180,
              'multiple': true,
              'position': 1,
            },
          ],
          'rows': [
            {'id': 'r1'},
          ],
          'cells': [
            {
              'row_id': 'r1',
              'column_id': 'link',
              'value': ['t2', null, 't3'],
              'version': 1,
              'redacted': true,
            },
          ],
          'references': {
            'tables': {'t2': 'Birinci · İlişki', 't3': 'İkinci tablo'},
          },
        });
        addTearDown(dio.close);
        final data = await ApiTablesRepository(() => dio)
            .workspace(TableLocation('p1', department), 't1', 'me');
        expect(data.linkedTables, {
          const TableDocumentId('t2'): 'Birinci · İlişki',
          const TableDocumentId('t3'): 'İkinci tablo',
        });
        expect(data.cell('r1', 'link').value, ['t2', null, 't3']);
        expect(data.cell('r1', 'link').redacted, isTrue);
      },
    );
  }
}
