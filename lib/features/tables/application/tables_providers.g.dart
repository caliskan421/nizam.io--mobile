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
