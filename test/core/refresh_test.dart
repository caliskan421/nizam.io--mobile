import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/refresh.dart';

void main() {
  for (final shown in [true, false]) {
    test('yenileme hatası: önceki veri $shown', () async {
      var fail = !shown;
      var reads = 0;
      final source = FutureProvider<int>((ref) async {
        reads++;
        if (fail) throw StateError('offline');
        return reads;
      });
      final c = ProviderContainer(retry: (_, _) => null);
      addTearDown(c.dispose);
      c.listen(source, (_, _) {});
      if (shown) {
        await c.read(source.future);
      } else {
        await expectLater(c.read(source.future), throwsStateError);
      }
      fail = true;
      final done = refreshWithFeedback(
        shown: c.read(source).hasValue,
        reload: () async {
          c.invalidate(source);
          await c.read(source.future);
        },
      );
      if (shown) {
        await expectLater(done, throwsStateError);
        expect(c.read(source).value, 1);
      } else {
        await done;
        expect(c.read(source).hasValue, isFalse);
      }
      expect(c.read(source).hasError, isTrue);
      expect(reads, 2);
    });
  }

  test('başarıda yeniden okur ve tamamlanmasını bekler', () async {
    var reads = 0;
    final source = FutureProvider<int>((ref) async => ++reads);
    final c = ProviderContainer(retry: (_, _) => null);
    addTearDown(c.dispose);
    c.listen(source, (_, _) {});
    await c.read(source.future);
    await refreshWithFeedback(
      shown: true,
      reload: () async {
        c.invalidate(source);
        await c.read(source.future);
      },
    );
    expect(c.read(source).requireValue, 2);
  });
}
