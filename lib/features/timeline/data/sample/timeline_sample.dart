// Zaman çizelgesi örnek verisi (prototip `reqs` ve `DEP`). Üretim verisi değildir: tarih
// talepleri ve bağımlılıklar sunucuya bağlanınca görev kaynağından gelir.

import '../../domain/timeline.dart';

/// Bekleyen tarih talepleri (görev kodu → istenen bitiş).
final timelineSampleRequests = ByTask<DateTime>([
  ('ALT-7', DateTime(2026, 10, 31)),
  ('ULA-1', DateTime(2026, 11, 15)),
  ('EĞİ-1', DateTime(2026, 10, 27)),
]);

/// Başka göreve bağımlı görevler.
const timelineSampleDependent = <String>{'ALT-5', 'ALT-8'};
