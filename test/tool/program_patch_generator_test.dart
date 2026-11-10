import 'package:flutter_test/flutter_test.dart';

import '../../tool/gen/wire_types.dart';

void main() {
  test('üç hâlli alanlarda null atlama dönüştürmeden önce yapılır', () {
    const source =
        "'short_name': ?programPatchStringToJson(instance.shortName),\n"
        "'color': ?programPatchColorToJson(instance.color),";
    final result = rewriteProgramPatchJson(source);
    expect(
      result,
      contains(
        "if (instance.shortName != null) 'short_name': programPatchStringToJson(instance.shortName)",
      ),
    );
    expect(
      result,
      contains(
        "if (instance.color != null) 'color': programPatchColorToJson(instance.color)",
      ),
    );
    expect(
      () => rewriteProgramPatchJson('farklı çıktı'),
      throwsFormatException,
    );
  });
}
