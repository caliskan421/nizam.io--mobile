// Program domain varlığı: değer eşitliği.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/scope/domain/program.dart';

void main() {
  test('kimlik, ad ve yıl eşitliği belirler', () {
    const a = Program(id: 'p1', name: 'A', year: 2026);
    expect(a, const Program(id: 'p1', name: 'A', year: 2026));
    expect(a.hashCode, const Program(id: 'p1', name: 'A', year: 2026).hashCode);
    expect(a, isNot(const Program(id: 'p1', name: 'A')));
    expect(a, isNot(const Program(id: 'p2', name: 'A', year: 2026)));
    expect(a, isNot(const Program(id: 'p1', name: 'B', year: 2026)));
  });
}
