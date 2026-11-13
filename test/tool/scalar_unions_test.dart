// Üretim öncesi skaler `oneOf` düzeltmesi: dalları yalnız skaler/dizi olan bileşen satır içine
// tipsiz şema olarak iner (Dart'ta ham JSON değeri); ayırıcılı nesne birlikleri dokunulmaz.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/gen/scalar_unions.dart';

const _spec = '''
openapi: 3.0.3
components:
  schemas:
    CellValue:
      nullable: true
      description: tipli değer
      oneOf:
        - type: string
        - type: number
        - type: array
          items:
            type: string
    Cell:
      type: object
      properties:
        value:
          \$ref: '#/components/schemas/CellValue'
    Rename:
      type: object
      properties:
        kind:
          type: string
    Command:
      oneOf:
        - \$ref: '#/components/schemas/Rename'
      discriminator:
        propertyName: kind
''';

void main() {
  test('skaler birlik bileşeni kaldırılır, başvurusu tipsiz şemaya iner', () {
    final (out, inlined) = inlineScalarUnions(_spec);
    expect(inlined, ['CellValue']);
    final spec = jsonDecode(out) as Map<String, Object?>;
    final schemas =
        (spec['components']! as Map<String, Object?>)['schemas']!
            as Map<String, Object?>;
    expect(schemas.containsKey('CellValue'), isFalse);
    expect(schemas.containsKey('Command'), isTrue);
    final value =
        ((schemas['Cell']! as Map<String, Object?>)['properties']!
                as Map<String, Object?>)['value']!
            as Map<String, Object?>;
    expect(value, {'description': 'tipli değer', 'nullable': true});
  });

  test('skaler birlik yoksa metin aynen döner', () {
    const plain = '''
openapi: 3.0.3
components:
  schemas:
    A:
      type: object
''';
    final (out, inlined) = inlineScalarUnions(plain);
    expect(inlined, isEmpty);
    expect(out, plain);
  });
}
