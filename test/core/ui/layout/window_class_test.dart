import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/layout.dart';

void main() {
  test('eşikler: 599 compact, 600 medium, 839 medium, 840 expanded', () {
    expect(WindowClass.fromWidth(0), WindowClass.compact);
    expect(WindowClass.fromWidth(599.9), WindowClass.compact);
    expect(WindowClass.fromWidth(600), WindowClass.medium);
    expect(WindowClass.fromWidth(839.9), WindowClass.medium);
    expect(WindowClass.fromWidth(840), WindowClass.expanded);
    expect(WindowClass.fromWidth(2000), WindowClass.expanded);
  });

  test('yardımcı bayraklar', () {
    expect(WindowClass.compact.isCompact, isTrue);
    expect(WindowClass.medium.isMedium, isTrue);
    expect(WindowClass.expanded.isExpanded, isTrue);
    expect(WindowClass.medium.isExpanded, isFalse);
  });
}
