import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/enum_parse.dart';

enum _Kind { a, b, unknown }

void main() {
  test('bilinen değer', () {
    expect(enumFromWire(_Kind.values, 'b', _Kind.unknown), _Kind.b);
  });

  test('bilinmeyen değer unknown olur', () {
    expect(enumFromWire(_Kind.values, 'yeni', _Kind.unknown), _Kind.unknown);
  });

  test('null girdi unknown olur', () {
    expect(enumFromWire(_Kind.values, null, _Kind.unknown), _Kind.unknown);
  });
}
