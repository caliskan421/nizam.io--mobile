// Akışın yeniden bağlanma kuralları (§10.5): jitter 0–5 sn, üstel geri çekilme (60 sn tavan),
// hata kararı ve ardışık başarısızlık sayacı.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/messages/domain/chat_stream_policy.dart';

/// nextInt her zaman [value] (sınır içinde) döner.
class _Fixed implements Random {
  _Fixed(this.value);
  final int value;
  @override
  int nextInt(int max) => value < max ? value : max - 1;
  @override
  bool nextBool() => false;
  @override
  double nextDouble() => 0;
}

void main() {
  test('ucuz sinyal kovası: dakikada en çok tavan kadar, pencere kayar', () {
    final b = SignalBudget(limit: 3);
    final t0 = DateTime(2026, 11, 9, 10);
    expect([for (var i = 0; i < 4; i++) b.take(t0)], [true, true, true, false]);
    expect(b.take(t0.add(const Duration(seconds: 59))), isFalse);
    expect(b.take(t0.add(const Duration(minutes: 1))), isTrue);
  });

  test('gecikme: jitter 0–5 sn, üstel 1-2-4… en çok 60 sn', () {
    expect(reconnectDelay(0, _Fixed(0)), Duration.zero);
    expect(reconnectDelay(0, _Fixed(1 << 30)), const Duration(seconds: 5));
    final secs = [
      for (var f = 1; f <= 9; f++) reconnectDelay(f, _Fixed(0)).inSeconds,
    ];
    expect(secs, [1, 2, 4, 8, 16, 32, 60, 60, 60]);
    expect(reconnectDelay(3, _Fixed(2500)), const Duration(milliseconds: 6500));
  });

  test('hata kararı: yetki/kapsam/oturum durur, ağ/5xx/429 yeniden dener', () {
    StreamErrorAction a(int? status, String code) =>
        streamErrorAction(status: status, code: code);
    expect(a(401, 'platform.unauthenticated'), StreamErrorAction.stop);
    expect(a(403, 'messaging.not_authorized'), StreamErrorAction.stop);
    expect(a(422, 'platform.scope_missing'), StreamErrorAction.stop);
    expect(a(null, 'client.session_ended'), StreamErrorAction.stop);
    expect(a(null, 'client.scope_missing'), StreamErrorAction.stop);
    expect(a(429, 'platform.rate_limited'), StreamErrorAction.retry);
    expect(a(503, 'platform.unavailable'), StreamErrorAction.retry);
    expect(a(null, 'client.network_error'), StreamErrorAction.retry);
    expect(a(null, 'client.timeout'), StreamErrorAction.retry);
  });

  test(
    'sayaç: sağlıklı bağlantı sıfırlar, açılamayan ya da kısa ömürlü artırır',
    () {
      expect(nextFailures(3, lived: const Duration(minutes: 5)), 0);
      expect(nextFailures(3, lived: const Duration(seconds: 2)), 4);
      expect(nextFailures(3, lived: null), 4);
    },
  );
}
