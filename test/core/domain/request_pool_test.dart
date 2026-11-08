// RequestPool: aynı anda en çok `max` iş; fazlası sırayla, hata sırayı kilitlemez.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/request_pool.dart';

void main() {
  test('eşzamanlı iş sınırı ve sıra', () async {
    final pool = RequestPool(2);
    final gates = List.generate(4, (_) => Completer<void>());
    var running = 0;
    var peak = 0;
    final started = <int>[];
    final jobs = [
      for (var i = 0; i < 4; i++)
        pool.run(() async {
          started.add(i);
          peak = (++running) > peak ? running : peak;
          await gates[i].future;
          running--;
          if (i == 1) throw StateError('x');
          return i;
        }),
    ];
    await Future<void>.delayed(Duration.zero);
    expect(started, [0, 1]);
    gates[1].complete();
    await expectLater(jobs[1], throwsStateError);
    await Future<void>.delayed(Duration.zero);
    expect(started, [0, 1, 2], reason: 'hata sırayı açar');
    for (final g in gates) {
      if (!g.isCompleted) g.complete();
    }
    expect(await Future.wait([jobs[0], jobs[2], jobs[3]]), [0, 2, 3]);
    expect(peak, 2);
  });
}
