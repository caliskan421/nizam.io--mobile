// tool/gen/response_headers.dart: X-Result-Truncated bildiren operasyonların türetilmesi,
// istemci metotlarının sarılması (negatif durumlar) ve üretilmiş istemcilerde kilit (Codex 10).
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/gen/response_headers.dart';

String _spec(String responses2xx) =>
    '''
openapi: 3.0.3
paths:
  /a:
    get:
      operationId: listA
      responses:
$responses2xx
  /b:
    get:
      operationId: readB
      responses:
        '200':
          description: ok
        '429':
          description: x
          headers:
            X-Result-Truncated: {schema: {type: string}}
''';

void main() {
  group('operationsDeclaringHeader', () {
    test(
      'yalnız 2xx yanıtında başlık bildirenler (ref ve satır içi, sıralı)',
      () {
        final ids = operationsDeclaringHeader(
          _spec('''
        '200':
          description: ok
          headers:
            x-result-truncated:
              \$ref: '#/components/headers/ResultTruncated'
'''),
        );
        expect(ids, ['listA']);
      },
    );

    test('2xx dışında bildirilen başlık sayılmaz', () {
      expect(
        operationsDeclaringHeader(
          _spec("        '200':\n          description: ok"),
        ),
        isEmpty,
      );
    });
  });

  group('wrapHeaderResponses', () {
    const client = '''
abstract class C {
  Future<ListA> listA({
  });

  Future<List<ReadB>> readB({
  });
}
''';

    test('yalnız istenen metodun dönüşünü sarar', () {
      final out = wrapHeaderResponses({'c.dart': client}, ['listA'])['c.dart']!;
      expect(out, contains('Future<HttpResponse<ListA>> listA('));
      expect(out, contains('Future<List<ReadB>> readB('));
    });

    test('iç içe tip parametresi korunur', () {
      final out = wrapHeaderResponses({'c.dart': client}, ['readB'])['c.dart']!;
      expect(out, contains('Future<HttpResponse<List<ReadB>>> readB('));
    });

    test('bulunamayan, yinelenen ve zaten sarılı operasyon düşer', () {
      expect(
        () => wrapHeaderResponses({'c.dart': client}, ['yok']),
        throwsStateError,
      );
      expect(
        () => wrapHeaderResponses(
          {'c.dart': client, 'd.dart': client},
          ['listA'],
        ),
        throwsStateError,
      );
      final once = wrapHeaderResponses({'c.dart': client}, ['listA']);
      expect(() => wrapHeaderResponses(once, ['listA']), throwsStateError);
    });
  });

  group('üretilmiş istemciler (v0.3.0-api)', () {
    test(
      'yalnız 11 operasyon HttpResponse döner; diğerlerinin imzası değişmez',
      () {
        final wrapped = <String>{};
        final plain = <String>{};
        final method = RegExp(r'^  Future<(.+)> (\w+)\(\{', multiLine: true);
        for (final f
            in Directory('lib/core/api/generated/clients')
                .listSync(recursive: true)
                .whereType<File>()
                .where((f) => f.path.endsWith('_client.dart'))) {
          for (final m in method.allMatches(f.readAsStringSync())) {
            // İkili yanıtlar da HttpResponse döner (tool/gen/wire_types.dart); burada yalnız
            // kesilme başlığı sarması sayılır.
            if (m[1] == 'HttpResponse<List<int>>') continue;
            (m[1]!.startsWith('HttpResponse<') ? wrapped : plain).add(m[2]!);
          }
        }
        // Yeni etiketle liste değişirse bu test kırılır; bilinçli güncellenir.
        expect(wrapped, {
          'assistantConversations',
          'listAssignable',
          'listDeletedAccounts',
          'listDeletedDepartments',
          'listDepartments',
          'listMembers',
          'listPrograms',
          'listUsers',
          'myDepartments',
          'reportDashboardMeetings',
          'reportDashboardTasks',
        });
        expect(plain, containsAll(['readProgram', 'login', 'refresh', 'me']));
      },
    );
  });
}
