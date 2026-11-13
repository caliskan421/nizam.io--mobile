import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/stream_reconnect.dart';
import '../domain/table_reference_sources.dart';
import '../domain/tables_repository.dart';

part 'tables_providers.g.dart';

/// PORT: tablolar uçlarının kaynağı (`tables_module.dart`'ta sunucu gerçekleştirmesi
/// bağlanır).
@Riverpod(keepAlive: true)
TablesRepository tablesRepository(Ref ref) => throw UnimplementedError(
  'tablesRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: referans hedef adayları (`tables_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
TableReferenceSources tableReferenceSources(Ref ref) =>
    throw UnimplementedError(
      'tableReferenceSourcesProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// Uygulama ön planda mı: tablo akışı ve presence yalnız ön plandayken açıktır (yaşam
/// döngüsünü sunum katmanındaki `TableLiveScope` yazar).
@Riverpod(keepAlive: true)
class TablesForeground extends _$TablesForeground {
  @override
  bool build() => true;

  void set(bool value) {
    if (state != value) state = value;
  }
}

/// Tablo akışının saati (bağlantı ömrü, presence aralığı); testte sahte saat verilir.
@Riverpod(keepAlive: true)
DateTime Function() tablesClock(Ref ref) => DateTime.now;

/// Yeniden bağlanma beklemesi (jitter + üstel geri çekilme, `core/domain/stream_reconnect`).
@Riverpod(keepAlive: true)
Duration Function(int failures) tableReconnectDelay(Ref ref) {
  final random = Random.secure();
  return (failures) => reconnectDelay(failures, random);
}

/// Canlı tablonun zamanlaması. [coalesce]: ardışık `changed` ipuçlarının birleştirildiği
/// süre (okuma kotası 600/dk); [presenceInterval]: presence yenileme aralığı (TTL 30 sn);
/// [presenceMinGap]: aynı oturumdan iki presence arası en kısa süre (sunucu 1 sn'den sık
/// isteği 429 ile reddeder). Testte kısaltılır.
typedef TableLiveTiming = ({
  Duration coalesce,
  Duration presenceInterval,
  Duration presenceMinGap,
});

@Riverpod(keepAlive: true)
TableLiveTiming tableLiveTiming(Ref ref) => (
  coalesce: const Duration(seconds: 1),
  presenceInterval: const Duration(seconds: 10),
  presenceMinGap: const Duration(seconds: 1),
);
