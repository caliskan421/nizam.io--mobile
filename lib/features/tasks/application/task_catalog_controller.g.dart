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
    r'969c65ae9dfc0a13798ace4461450188aef4d38a';

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
/// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yönetici ya da programda en az bir
/// departmanın koordinatörü ([TaskAccess.canCreateAnyIn]; üye hayır — WORK-K05; departman
/// formda açılabilenlerden seçilir). Katalog ya da program yokken hayır (fail-closed).

@ProviderFor(canCreateTask)
final canCreateTaskProvider = CanCreateTaskProvider._();

/// Seçili kapsamda "Yeni görev" açılabilir mi (giriş noktalarının görünürlüğü ve formun
/// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yönetici ya da programda en az bir
/// departmanın koordinatörü ([TaskAccess.canCreateAnyIn]; üye hayır — WORK-K05; departman
/// formda açılabilenlerden seçilir). Katalog ya da program yokken hayır (fail-closed).

final class CanCreateTaskProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Seçili kapsamda "Yeni görev" açılabilir mi (giriş noktalarının görünürlüğü ve formun
  /// kapısı). Örnek katalogda her zaman; sunucu kataloğunda yönetici ya da programda en az bir
  /// departmanın koordinatörü ([TaskAccess.canCreateAnyIn]; üye hayır — WORK-K05; departman
  /// formda açılabilenlerden seçilir). Katalog ya da program yokken hayır (fail-closed).
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

String _$canCreateTaskHash() => r'f19c7dee84b9733bf1b077ca4f02749290afd81e';
