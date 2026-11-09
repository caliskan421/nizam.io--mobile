// Bayat veri saati: yalnız değer taşıyan, yüklenmeyen, hatasız ve süresi geçmiş durumda
// tazeler; hata yutulur (otomatik yol sessiz, hata sonrası tekrar yok).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/stale_clock.dart';

void main() {
  test(
    'hiç okunmamış saat bayattır; okumadan sonra süre dolana kadar tazedir',
    () {
      final clock = StaleClock();
      expect(clock.isStale(), isTrue);
      clock.markFresh();
      expect(clock.isStale(), isFalse);
      expect(clock.isStale(Duration.zero), isTrue);
    },
  );

  test(
    'refreshIfStale: yalnız değer varken, yüklenmiyorken ve bayatken',
    () async {
      var calls = 0;
      Future<void> refresh() async => calls++;
      final clock = StaleClock()..markFresh();

      await clock.refreshIfStale(const AsyncData(1), refresh);
      expect(calls, 0, reason: 'taze');

      await clock.refreshIfStale(
        const AsyncLoading<int>(),
        refresh,
        maxAge: Duration.zero,
      );
      await clock.refreshIfStale(
        const AsyncError<int>('x', StackTrace.empty),
        refresh,
        maxAge: Duration.zero,
      );
      expect(calls, 0, reason: 'hiç yüklenmemiş: ilk yükleme hatası dokunuşla');

      // Değer taşıyan yenileme (isRefreshing): gerçek sağlayıcıdan.
      final pending = Completer<int>();
      var reads = 0;
      final source = FutureProvider<int>(
        (ref) => ++reads == 1 ? Future.value(1) : pending.future,
      );
      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.listen(source, (_, _) {});
      await c.read(source.future);
      c.invalidate(source);
      final refreshing = c.read(source);
      expect((refreshing.isLoading, refreshing.hasValue), (true, true));
      await clock.refreshIfStale(refreshing, refresh, maxAge: Duration.zero);
      expect(calls, 0, reason: 'zaten yükleniyor');

      await clock.refreshIfStale(
        const AsyncData(1),
        refresh,
        maxAge: Duration.zero,
      );
      expect(calls, 1);
    },
  );

  test('refreshIfStale: son okuma hatalıysa (önceki değer olsa da; 429 dahil) '
      'otomatik yol istek atmaz', () async {
    var calls = 0;
    final clock = StaleClock()..markFresh();
    // Gerçek sağlayıcı: değer taşıyan AsyncError (yenileme hatası).
    var fail = false;
    final source = FutureProvider<int>(
      (ref) => fail ? Future.error(StateError('429')) : Future.value(1),
    );
    final c = ProviderContainer(retry: (_, _) => null);
    addTearDown(c.dispose);
    c.listen(source, (_, _) {});
    await c.read(source.future);
    fail = true;
    c.invalidate(source);
    await expectLater(c.read(source.future), throwsStateError);
    final failed = c.read(source);
    expect((failed.hasError, failed.hasValue), (true, true));
    await clock.refreshIfStale(
      failed,
      () async => calls++,
      maxAge: Duration.zero,
    );
    expect(calls, 0);
  });

  test('refreshIfStale: yenileme hatası yutulur', () async {
    await expectLater(
      StaleClock().refreshIfStale(
        const AsyncData(1),
        () => Future.error(StateError('ağ')),
      ),
      completes,
    );
  });
}
