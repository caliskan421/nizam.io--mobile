// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_catalog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
/// aksi hâlde yeniden yükleme yalnız dokunuşla.
///
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog).
/// Sunucu yazmasından sonra etkilenen görev tekil okumayla ([applyDetails]) değişir; liste
/// yalnız görev kümesi değişince (oluşturma, silme, zincirli tarih onayı) [reload] ile yeniden
/// okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.

@ProviderFor(TaskCatalogController)
final taskCatalogControllerProvider = TaskCatalogControllerProvider._();

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
/// aksi hâlde yeniden yükleme yalnız dokunuşla.
///
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog).
/// Sunucu yazmasından sonra etkilenen görev tekil okumayla ([applyDetails]) değişir; liste
/// yalnız görev kümesi değişince (oluşturma, silme, zincirli tarih onayı) [reload] ile yeniden
/// okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.
final class TaskCatalogControllerProvider
    extends $AsyncNotifierProvider<TaskCatalogController, TaskCatalog> {
  /// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
  /// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
  /// aksi hâlde yeniden yükleme yalnız dokunuşla.
  ///
  /// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog).
  /// Sunucu yazmasından sonra etkilenen görev tekil okumayla ([applyDetails]) değişir; liste
  /// yalnız görev kümesi değişince (oluşturma, silme, zincirli tarih onayı) [reload] ile yeniden
  /// okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.
  TaskCatalogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskCatalogControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskCatalogControllerHash();

  @$internal
  @override
  TaskCatalogController create() => TaskCatalogController();
}

String _$taskCatalogControllerHash() =>
    r'c77f47e627794b11a6c15a1ae41b04e02e6722ae';

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
/// aksi hâlde yeniden yükleme yalnız dokunuşla.
///
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog).
/// Sunucu yazmasından sonra etkilenen görev tekil okumayla ([applyDetails]) değişir; liste
/// yalnız görev kümesi değişince (oluşturma, silme, zincirli tarih onayı) [reload] ile yeniden
/// okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.

abstract class _$TaskCatalogController extends $AsyncNotifier<TaskCatalog> {
  FutureOr<TaskCatalog> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TaskCatalog>, TaskCatalog>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TaskCatalog>, TaskCatalog>,
              AsyncValue<TaskCatalog>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Seçili kapsamda "Yeni görev" açılabilir mi (giriş noktalarının görünürlüğü ve formun
/// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yalnız seçili (program, departman)
/// kapsamında yönetici ya da koordinatör ([TaskAccess.canCreateIn]; üye hayır — WORK-K05).
/// Katalog yokken ya da departman seçilmemişken hayır (fail-closed).

@ProviderFor(canCreateTask)
final canCreateTaskProvider = CanCreateTaskProvider._();

/// Seçili kapsamda "Yeni görev" açılabilir mi (giriş noktalarının görünürlüğü ve formun
/// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yalnız seçili (program, departman)
/// kapsamında yönetici ya da koordinatör ([TaskAccess.canCreateIn]; üye hayır — WORK-K05).
/// Katalog yokken ya da departman seçilmemişken hayır (fail-closed).

final class CanCreateTaskProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Seçili kapsamda "Yeni görev" açılabilir mi (giriş noktalarının görünürlüğü ve formun
  /// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yalnız seçili (program, departman)
  /// kapsamında yönetici ya da koordinatör ([TaskAccess.canCreateIn]; üye hayır — WORK-K05).
  /// Katalog yokken ya da departman seçilmemişken hayır (fail-closed).
  CanCreateTaskProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canCreateTaskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canCreateTaskHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canCreateTask(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canCreateTaskHash() => r'5ece2c3a095caac4e0df642ab2d37af24ab62c78';
