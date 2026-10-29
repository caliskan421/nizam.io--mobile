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

/// Yatay çizelgenin koordinatörlük sırası (tablet prototipi `S_hgantt` `CN` anahtar sırası;
/// katalog sırasından farklıdır). Listede olmayan koordinatörlük katalog sırasıyla sona eklenir.
const timelineSampleGanttOrder = <String>[
  'ALT',
  'MEK',
  'ULA',
  'ELE',
  'İDA',
  'EĞİ',
  'OPE',
  'SAT',
  'MİM',
  'FUA',
  'SİS',
];

/// Teknofest günleri (prototip `fest`: 12 Kasım'dan 4 gün). Sezon takvimi sunucuya bağlanınca
/// oradan gelir.
final timelineSampleFestivalStart = DateTime(2026, 11, 12);
const timelineSampleFestivalDays = 4;
