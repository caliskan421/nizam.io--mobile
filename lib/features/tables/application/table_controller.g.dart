// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tek tablonun ekranı: snapshot yükleme, olay günlüğünden yakalama ([catchUp]), hücre
/// yazımı (`table_cell_writes.dart`) ve komutlar (`table_commands.dart`).
///
/// Görünüm iki katmandır: sunucudan türeyen taban [_base] (snapshot + kendi makbuzlarımız) ve
/// üstüne uygulanan bekleyen/uçuştaki hücre düzenlemeleri. Taban monotondur: daha eski bir
/// snapshot (sırası uygulanmış snapshot'tan küçük) uygulanmaz; snapshot ya da makbuz bir hücreyi
/// daha küçük sürüme geri almaz. Snapshot okumaları sıraya dizilir (tek zincir).
///
/// Olay imleci [cursor]: yalnız changes sayfalarının gerektirdiği yeniden okuma/yorum
/// güncellemesi BAŞARIYLA bitince ya da tutarlı snapshot uygulanınca ilerler; kendi
/// makbuzlarımız imleci ilerletmez. Komut sonrası yan okuma düşerse [_needsReload] kalıcıdır;
/// sonraki yakalama tabloyu yeniden okur.

@ProviderFor(TableController)
final tableControllerProvider = TableControllerFamily._();

/// Tek tablonun ekranı: snapshot yükleme, olay günlüğünden yakalama ([catchUp]), hücre
/// yazımı (`table_cell_writes.dart`) ve komutlar (`table_commands.dart`).
///
/// Görünüm iki katmandır: sunucudan türeyen taban [_base] (snapshot + kendi makbuzlarımız) ve
/// üstüne uygulanan bekleyen/uçuştaki hücre düzenlemeleri. Taban monotondur: daha eski bir
/// snapshot (sırası uygulanmış snapshot'tan küçük) uygulanmaz; snapshot ya da makbuz bir hücreyi
/// daha küçük sürüme geri almaz. Snapshot okumaları sıraya dizilir (tek zincir).
///
/// Olay imleci [cursor]: yalnız changes sayfalarının gerektirdiği yeniden okuma/yorum
/// güncellemesi BAŞARIYLA bitince ya da tutarlı snapshot uygulanınca ilerler; kendi
/// makbuzlarımız imleci ilerletmez. Komut sonrası yan okuma düşerse [_needsReload] kalıcıdır;
/// sonraki yakalama tabloyu yeniden okur.
final class TableControllerProvider
    extends $AsyncNotifierProvider<TableController, TableView> {
  /// Tek tablonun ekranı: snapshot yükleme, olay günlüğünden yakalama ([catchUp]), hücre
  /// yazımı (`table_cell_writes.dart`) ve komutlar (`table_commands.dart`).
  ///
  /// Görünüm iki katmandır: sunucudan türeyen taban [_base] (snapshot + kendi makbuzlarımız) ve
  /// üstüne uygulanan bekleyen/uçuştaki hücre düzenlemeleri. Taban monotondur: daha eski bir
  /// snapshot (sırası uygulanmış snapshot'tan küçük) uygulanmaz; snapshot ya da makbuz bir hücreyi
  /// daha küçük sürüme geri almaz. Snapshot okumaları sıraya dizilir (tek zincir).
  ///
  /// Olay imleci [cursor]: yalnız changes sayfalarının gerektirdiği yeniden okuma/yorum
  /// güncellemesi BAŞARIYLA bitince ya da tutarlı snapshot uygulanınca ilerler; kendi
  /// makbuzlarımız imleci ilerletmez. Komut sonrası yan okuma düşerse [_needsReload] kalıcıdır;
  /// sonraki yakalama tabloyu yeniden okur.
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

String _$tableControllerHash() => r'c86c2899802506313bf12aa420cfd069d6e4cea6';

/// Tek tablonun ekranı: snapshot yükleme, olay günlüğünden yakalama ([catchUp]), hücre
/// yazımı (`table_cell_writes.dart`) ve komutlar (`table_commands.dart`).
///
/// Görünüm iki katmandır: sunucudan türeyen taban [_base] (snapshot + kendi makbuzlarımız) ve
/// üstüne uygulanan bekleyen/uçuştaki hücre düzenlemeleri. Taban monotondur: daha eski bir
/// snapshot (sırası uygulanmış snapshot'tan küçük) uygulanmaz; snapshot ya da makbuz bir hücreyi
/// daha küçük sürüme geri almaz. Snapshot okumaları sıraya dizilir (tek zincir).
///
/// Olay imleci [cursor]: yalnız changes sayfalarının gerektirdiği yeniden okuma/yorum
/// güncellemesi BAŞARIYLA bitince ya da tutarlı snapshot uygulanınca ilerler; kendi
/// makbuzlarımız imleci ilerletmez. Komut sonrası yan okuma düşerse [_needsReload] kalıcıdır;
/// sonraki yakalama tabloyu yeniden okur.

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

  /// Tek tablonun ekranı: snapshot yükleme, olay günlüğünden yakalama ([catchUp]), hücre
  /// yazımı (`table_cell_writes.dart`) ve komutlar (`table_commands.dart`).
  ///
  /// Görünüm iki katmandır: sunucudan türeyen taban [_base] (snapshot + kendi makbuzlarımız) ve
  /// üstüne uygulanan bekleyen/uçuştaki hücre düzenlemeleri. Taban monotondur: daha eski bir
  /// snapshot (sırası uygulanmış snapshot'tan küçük) uygulanmaz; snapshot ya da makbuz bir hücreyi
  /// daha küçük sürüme geri almaz. Snapshot okumaları sıraya dizilir (tek zincir).
  ///
  /// Olay imleci [cursor]: yalnız changes sayfalarının gerektirdiği yeniden okuma/yorum
  /// güncellemesi BAŞARIYLA bitince ya da tutarlı snapshot uygulanınca ilerler; kendi
  /// makbuzlarımız imleci ilerletmez. Komut sonrası yan okuma düşerse [_needsReload] kalıcıdır;
  /// sonraki yakalama tabloyu yeniden okur.

  TableControllerProvider call(String id) =>
      TableControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'tableControllerProvider';
}

/// Tek tablonun ekranı: snapshot yükleme, olay günlüğünden yakalama ([catchUp]), hücre
/// yazımı (`table_cell_writes.dart`) ve komutlar (`table_commands.dart`).
///
/// Görünüm iki katmandır: sunucudan türeyen taban [_base] (snapshot + kendi makbuzlarımız) ve
/// üstüne uygulanan bekleyen/uçuştaki hücre düzenlemeleri. Taban monotondur: daha eski bir
/// snapshot (sırası uygulanmış snapshot'tan küçük) uygulanmaz; snapshot ya da makbuz bir hücreyi
/// daha küçük sürüme geri almaz. Snapshot okumaları sıraya dizilir (tek zincir).
///
/// Olay imleci [cursor]: yalnız changes sayfalarının gerektirdiği yeniden okuma/yorum
/// güncellemesi BAŞARIYLA bitince ya da tutarlı snapshot uygulanınca ilerler; kendi
/// makbuzlarımız imleci ilerletmez. Komut sonrası yan okuma düşerse [_needsReload] kalıcıdır;
/// sonraki yakalama tabloyu yeniden okur.

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
