import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/page/nz_shell_events.dart';

void main() {
  test('her yeniden dokunma yeni olay (aynı sekme iki kez de bildirilir)', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final seen = <(int, int)>[];
    c.listen(shellReselectEventsProvider, (_, e) => seen.add((e!.tab, e.seq)));
    expect(c.read(shellReselectEventsProvider), isNull);
    c.read(shellReselectEventsProvider.notifier)
      ..fire(0)
      ..fire(0)
      ..fire(2);
    expect(seen, [(0, 1), (0, 2), (2, 3)]);
  });
}
