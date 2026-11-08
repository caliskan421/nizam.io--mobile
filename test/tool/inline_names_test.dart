// Üretim öncesi ad çakışması düzeltmesi: bileşen adıyla çakışan satır içi nesne özelliği
// `<Ebeveyn><Özellik>` bileşenine taşınır (tel adı aynı); çakışma yoksa metin değişmez.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/gen/inline_names.dart';

const _spec = '''
openapi: 3.0.3
components:
  schemas:
    Department:
      type: object
      required: [department_id]
      properties:
        department_id:
          type: string
    ChatRefSummary:
      type: object
      properties:
        department:
          type: object
          required: [name]
          properties:
            name:
              type: string
        file:
          type: object
          properties:
            name:
              type: string
''';

void main() {
  test('çakışan satır içi nesne bileşene taşınır, diğerleri kalır', () {
    final (out, moved) = hoistCollidingInlineObjects(_spec);
    expect(moved, ['ChatRefSummary.department → ChatRefSummaryDepartment']);
    final spec = jsonDecode(out) as Map<String, Object?>;
    final schemas =
        (spec['components']! as Map)['schemas']! as Map<String, Object?>;
    expect((schemas['Department']! as Map)['required'], ['department_id']);
    expect((schemas['ChatRefSummaryDepartment']! as Map)['required'], ['name']);
    final props =
        (schemas['ChatRefSummary']! as Map)['properties']!
            as Map<String, Object?>;
    expect(props['department'], {
      r'$ref': '#/components/schemas/ChatRefSummaryDepartment',
    });
    expect((props['file']! as Map)['type'], 'object');
  });

  test('çakışma yoksa metin aynen döner', () {
    const plain = '''
openapi: 3.0.3
components:
  schemas:
    A:
      type: object
      properties:
        b:
          type: object
          properties:
            x:
              type: string
''';
    final (out, moved) = hoistCollidingInlineObjects(plain);
    expect(moved, isEmpty);
    expect(identical(out, plain), isTrue);
  });
}
