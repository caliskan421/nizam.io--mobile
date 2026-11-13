// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: tablolar uçlarının kaynağı (`tables_module.dart`'ta sunucu gerçekleştirmesi
/// bağlanır).

@ProviderFor(tablesRepository)
final tablesRepositoryProvider = TablesRepositoryProvider._();

/// PORT: tablolar uçlarının kaynağı (`tables_module.dart`'ta sunucu gerçekleştirmesi
/// bağlanır).

final class TablesRepositoryProvider
    extends
        $FunctionalProvider<
          TablesRepository,
          TablesRepository,
          TablesRepository
        >
    with $Provider<TablesRepository> {
  /// PORT: tablolar uçlarının kaynağı (`tables_module.dart`'ta sunucu gerçekleştirmesi
  /// bağlanır).
  TablesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tablesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tablesRepositoryHash();

  @$internal
  @override
  $ProviderElement<TablesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TablesRepository create(Ref ref) {
    return tablesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TablesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TablesRepository>(value),
    );
  }
}

String _$tablesRepositoryHash() => r'c716a008d474409e848565686240ea825f00cccc';

/// Uygulama ön planda mı: tablo akışı ve presence yalnız ön plandayken açıktır (yaşam
/// döngüsünü sunum katmanındaki `TableLiveScope` yazar).

@ProviderFor(TablesForeground)
final tablesForegroundProvider = TablesForegroundProvider._();

/// Uygulama ön planda mı: tablo akışı ve presence yalnız ön plandayken açıktır (yaşam
/// döngüsünü sunum katmanındaki `TableLiveScope` yazar).
final class TablesForegroundProvider
    extends $NotifierProvider<TablesForeground, bool> {
  /// Uygulama ön planda mı: tablo akışı ve presence yalnız ön plandayken açıktır (yaşam
  /// döngüsünü sunum katmanındaki `TableLiveScope` yazar).
  TablesForegroundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tablesForegroundProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tablesForegroundHash();

  @$internal
  @override
  TablesForeground create() => TablesForeground();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$tablesForegroundHash() => r'465e188e9142b542f146aafe34c4b5048701f5bc';

/// Uygulama ön planda mı: tablo akışı ve presence yalnız ön plandayken açıktır (yaşam
/// döngüsünü sunum katmanındaki `TableLiveScope` yazar).

abstract class _$TablesForeground extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Tablo akışının saati (bağlantı ömrü, presence aralığı); testte sahte saat verilir.

@ProviderFor(tablesClock)
final tablesClockProvider = TablesClockProvider._();

/// Tablo akışının saati (bağlantı ömrü, presence aralığı); testte sahte saat verilir.

final class TablesClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// Tablo akışının saati (bağlantı ömrü, presence aralığı); testte sahte saat verilir.
  TablesClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tablesClockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tablesClockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return tablesClock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$tablesClockHash() => r'54917c9eed17cce9d6a8e6f81822a81152c3cd5d';

/// Yeniden bağlanma beklemesi (jitter + üstel geri çekilme, `core/domain/stream_reconnect`).

@ProviderFor(tableReconnectDelay)
final tableReconnectDelayProvider = TableReconnectDelayProvider._();

/// Yeniden bağlanma beklemesi (jitter + üstel geri çekilme, `core/domain/stream_reconnect`).

final class TableReconnectDelayProvider
    extends
        $FunctionalProvider<
          Duration Function(int failures),
          Duration Function(int failures),
          Duration Function(int failures)
        >
    with $Provider<Duration Function(int failures)> {
  /// Yeniden bağlanma beklemesi (jitter + üstel geri çekilme, `core/domain/stream_reconnect`).
  TableReconnectDelayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tableReconnectDelayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tableReconnectDelayHash();

  @$internal
  @override
  $ProviderElement<Duration Function(int failures)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Duration Function(int failures) create(Ref ref) {
    return tableReconnectDelay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration Function(int failures) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration Function(int failures)>(
        value,
      ),
    );
  }
}

String _$tableReconnectDelayHash() =>
    r'c7112a190827840ba7fb643603d6a99c01af0506';

@ProviderFor(tableLiveTiming)
final tableLiveTimingProvider = TableLiveTimingProvider._();

final class TableLiveTimingProvider
    extends
        $FunctionalProvider<TableLiveTiming, TableLiveTiming, TableLiveTiming>
    with $Provider<TableLiveTiming> {
  TableLiveTimingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tableLiveTimingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tableLiveTimingHash();

  @$internal
  @override
  $ProviderElement<TableLiveTiming> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TableLiveTiming create(Ref ref) {
    return tableLiveTiming(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TableLiveTiming value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TableLiveTiming>(value),
    );
  }
}

String _$tableLiveTimingHash() => r'd0a589393a2f4541fbe060e110e7410250dd6720';
