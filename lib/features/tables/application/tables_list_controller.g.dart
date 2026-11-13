// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TablesFilterController)
final tablesFilterControllerProvider = TablesFilterControllerProvider._();

final class TablesFilterControllerProvider
    extends $NotifierProvider<TablesFilterController, TablesFilter> {
  TablesFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tablesFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tablesFilterControllerHash();

  @$internal
  @override
  TablesFilterController create() => TablesFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TablesFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TablesFilter>(value),
    );
  }
}

String _$tablesFilterControllerHash() =>
    r'5210bca055c2f3aae02159cbacb1b16adf1e7aa5';

abstract class _$TablesFilterController extends $Notifier<TablesFilter> {
  TablesFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TablesFilter, TablesFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TablesFilter, TablesFilter>,
              TablesFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Seçili kapsamın tablo listeleri (`listTables` S3 + `listPersonalTables` S2). Oturum nesli
/// ya da kapsam değişince yeniden kurulur (önceki hesabın/programın verisi görünmez).

@ProviderFor(TablesListController)
final tablesListControllerProvider = TablesListControllerProvider._();

/// Seçili kapsamın tablo listeleri (`listTables` S3 + `listPersonalTables` S2). Oturum nesli
/// ya da kapsam değişince yeniden kurulur (önceki hesabın/programın verisi görünmez).
final class TablesListControllerProvider
    extends $AsyncNotifierProvider<TablesListController, TablesListView> {
  /// Seçili kapsamın tablo listeleri (`listTables` S3 + `listPersonalTables` S2). Oturum nesli
  /// ya da kapsam değişince yeniden kurulur (önceki hesabın/programın verisi görünmez).
  TablesListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tablesListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tablesListControllerHash();

  @$internal
  @override
  TablesListController create() => TablesListController();
}

String _$tablesListControllerHash() =>
    r'257b3b8336811a92e16e4aa5b82f7853627e92a2';

/// Seçili kapsamın tablo listeleri (`listTables` S3 + `listPersonalTables` S2). Oturum nesli
/// ya da kapsam değişince yeniden kurulur (önceki hesabın/programın verisi görünmez).

abstract class _$TablesListController extends $AsyncNotifier<TablesListView> {
  FutureOr<TablesListView> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TablesListView>, TablesListView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TablesListView>, TablesListView>,
              AsyncValue<TablesListView>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
