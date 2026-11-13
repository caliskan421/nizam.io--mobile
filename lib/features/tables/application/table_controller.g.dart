// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme; parça dosya
/// `table_cell_writes.dart`), komutlar ve olay günlüğünden yakalama ([catchUp]).
///
/// Olay imleci [cursor]: yalnız tutarlı bir snapshot'ın `table.sequence`'i ya da başarılı
/// `changes` yanıtının `cursor`'ı ile ilerler; kendi makbuzlarımız imleci ilerletmez (aradaki
/// yabancı olay atlanmasın). Akış döngüsü `table_sync_controller.dart`'tadır.

@ProviderFor(TableController)
final tableControllerProvider = TableControllerFamily._();

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme; parça dosya
/// `table_cell_writes.dart`), komutlar ve olay günlüğünden yakalama ([catchUp]).
///
/// Olay imleci [cursor]: yalnız tutarlı bir snapshot'ın `table.sequence`'i ya da başarılı
/// `changes` yanıtının `cursor`'ı ile ilerler; kendi makbuzlarımız imleci ilerletmez (aradaki
/// yabancı olay atlanmasın). Akış döngüsü `table_sync_controller.dart`'tadır.
final class TableControllerProvider
    extends $AsyncNotifierProvider<TableController, TableView> {
  /// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme; parça dosya
  /// `table_cell_writes.dart`), komutlar ve olay günlüğünden yakalama ([catchUp]).
  ///
  /// Olay imleci [cursor]: yalnız tutarlı bir snapshot'ın `table.sequence`'i ya da başarılı
  /// `changes` yanıtının `cursor`'ı ile ilerler; kendi makbuzlarımız imleci ilerletmez (aradaki
  /// yabancı olay atlanmasın). Akış döngüsü `table_sync_controller.dart`'tadır.
  TableControllerProvider._({
    required TableControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tableControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tableControllerHash();

  @override
  String toString() {
    return r'tableControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TableController create() => TableController();

  @override
  bool operator ==(Object other) {
    return other is TableControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tableControllerHash() => r'bea2fabe416ecd9ad69b5da5a94ce3080197b2e9';

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme; parça dosya
/// `table_cell_writes.dart`), komutlar ve olay günlüğünden yakalama ([catchUp]).
///
/// Olay imleci [cursor]: yalnız tutarlı bir snapshot'ın `table.sequence`'i ya da başarılı
/// `changes` yanıtının `cursor`'ı ile ilerler; kendi makbuzlarımız imleci ilerletmez (aradaki
/// yabancı olay atlanmasın). Akış döngüsü `table_sync_controller.dart`'tadır.

final class TableControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TableController,
          AsyncValue<TableView>,
          TableView,
          FutureOr<TableView>,
          String
        > {
  TableControllerFamily._()
    : super(
        retry: null,
        name: r'tableControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme; parça dosya
  /// `table_cell_writes.dart`), komutlar ve olay günlüğünden yakalama ([catchUp]).
  ///
  /// Olay imleci [cursor]: yalnız tutarlı bir snapshot'ın `table.sequence`'i ya da başarılı
  /// `changes` yanıtının `cursor`'ı ile ilerler; kendi makbuzlarımız imleci ilerletmez (aradaki
  /// yabancı olay atlanmasın). Akış döngüsü `table_sync_controller.dart`'tadır.

  TableControllerProvider call(String id) =>
      TableControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'tableControllerProvider';
}

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme; parça dosya
/// `table_cell_writes.dart`), komutlar ve olay günlüğünden yakalama ([catchUp]).
///
/// Olay imleci [cursor]: yalnız tutarlı bir snapshot'ın `table.sequence`'i ya da başarılı
/// `changes` yanıtının `cursor`'ı ile ilerler; kendi makbuzlarımız imleci ilerletmez (aradaki
/// yabancı olay atlanmasın). Akış döngüsü `table_sync_controller.dart`'tadır.

abstract class _$TableController extends $AsyncNotifier<TableView> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<TableView> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TableView>, TableView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TableView>, TableView>,
              AsyncValue<TableView>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
