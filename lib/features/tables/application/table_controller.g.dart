// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme) ve komutlar.
///
/// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
/// [writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek `set_cells` ile gider.
/// Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün batch'i geri aldırır:
/// tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan hücreler (çakışmayı başka
/// hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının değiştirdiği hücreler
/// [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu bilinmeyen hata
/// (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir ([retryWrites]).
///
/// Canlı senkron (akış → changes → snapshot) bu denetleyicide değildir (sonraki tur).

@ProviderFor(TableController)
final tableControllerProvider = TableControllerFamily._();

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme) ve komutlar.
///
/// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
/// [writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek `set_cells` ile gider.
/// Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün batch'i geri aldırır:
/// tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan hücreler (çakışmayı başka
/// hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının değiştirdiği hücreler
/// [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu bilinmeyen hata
/// (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir ([retryWrites]).
///
/// Canlı senkron (akış → changes → snapshot) bu denetleyicide değildir (sonraki tur).
final class TableControllerProvider
    extends $AsyncNotifierProvider<TableController, TableView> {
  /// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme) ve komutlar.
  ///
  /// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
  /// [writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek `set_cells` ile gider.
  /// Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün batch'i geri aldırır:
  /// tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan hücreler (çakışmayı başka
  /// hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının değiştirdiği hücreler
  /// [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu bilinmeyen hata
  /// (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir ([retryWrites]).
  ///
  /// Canlı senkron (akış → changes → snapshot) bu denetleyicide değildir (sonraki tur).
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

String _$tableControllerHash() => r'f814781f315d40d496abf3eef94adc533c63c2b9';

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme) ve komutlar.
///
/// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
/// [writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek `set_cells` ile gider.
/// Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün batch'i geri aldırır:
/// tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan hücreler (çakışmayı başka
/// hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının değiştirdiği hücreler
/// [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu bilinmeyen hata
/// (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir ([retryWrites]).
///
/// Canlı senkron (akış → changes → snapshot) bu denetleyicide değildir (sonraki tur).

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

  /// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme) ve komutlar.
  ///
  /// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
  /// [writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek `set_cells` ile gider.
  /// Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün batch'i geri aldırır:
  /// tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan hücreler (çakışmayı başka
  /// hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının değiştirdiği hücreler
  /// [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu bilinmeyen hata
  /// (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir ([retryWrites]).
  ///
  /// Canlı senkron (akış → changes → snapshot) bu denetleyicide değildir (sonraki tur).

  TableControllerProvider call(String id) =>
      TableControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'tableControllerProvider';
}

/// Tek tablonun ekranı: snapshot yükleme, hücre yazımı (CAS + birleştirme) ve komutlar.
///
/// Hücre yazımı: düzenleme yerelde hemen görünür, [TableWriteQueue]'da birleşir ve
/// [writeDebounce] sessizlikten sonra (ya da 100 hücre dolunca) tek `set_cells` ile gider.
/// Aynı anda tek batch uçuştadır. 409 `tables.cell_conflict` bütün batch'i geri aldırır:
/// tablo yeniden okunur; sunucu sürümü okunan sürümle aynı kalan hücreler (çakışmayı başka
/// hücre doğurdu) yeni anahtarla yeniden gönderilir, başkasının değiştirdiği hücreler
/// [TableView.conflicts]'e girer ve sunucu değeri gösterilir. Sonucu bilinmeyen hata
/// (zaman aşımı/ağ/5xx) batch'i kuyrukta AYNI anahtarla bekletir ([retryWrites]).
///
/// Canlı senkron (akış → changes → snapshot) bu denetleyicide değildir (sonraki tur).

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
