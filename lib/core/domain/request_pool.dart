import 'dart:async';
import 'dart:collection';

/// Eşzamanlı iş sınırı: aynı anda en çok [max] iş koşar, fazlası sırayla bekler (ör. liste
/// kartları başına ayrıntı isteği sunucuyu boğmasın). Saf Dart.
class RequestPool {
  RequestPool(this.max) : assert(max >= 1, 'max >= 1');

  final int max;
  var _running = 0;
  final _waiting = Queue<Completer<void>>();

  Future<T> run<T>(Future<T> Function() job) async {
    if (_running >= max) {
      final turn = Completer<void>();
      _waiting.add(turn);
      await turn.future;
    }
    _running++;
    try {
      return await job();
    } finally {
      _running--;
      if (_waiting.isNotEmpty) _waiting.removeFirst().complete();
    }
  }
}
