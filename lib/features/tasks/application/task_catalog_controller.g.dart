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
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog ve
/// henüz sunucuya bağlanmamış P3 yazmaları). Sunucu yazmasından sonra [reload] ile kaynaktan
/// yeniden okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.

@ProviderFor(TaskCatalogController)
final taskCatalogControllerProvider = TaskCatalogControllerProvider._();

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
/// aksi hâlde yeniden yükleme yalnız dokunuşla.
///
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog ve
/// henüz sunucuya bağlanmamış P3 yazmaları). Sunucu yazmasından sonra [reload] ile kaynaktan
/// yeniden okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.
final class TaskCatalogControllerProvider
    extends $AsyncNotifierProvider<TaskCatalogController, TaskCatalog> {
  /// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
  /// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
  /// aksi hâlde yeniden yükleme yalnız dokunuşla.
  ///
  /// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog ve
  /// henüz sunucuya bağlanmamış P3 yazmaları). Sunucu yazmasından sonra [reload] ile kaynaktan
  /// yeniden okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.
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
    r'2fad237ed4b8599f5826a041e7035f5ebd5dd5a3';

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; seçili kapsam değişince yeniden okunur,
/// aksi hâlde yeniden yükleme yalnız dokunuşla.
///
/// Komutlar ([add], [replace], [remove]) değişikliği yalnız bellekte tutar (örnek katalog ve
/// henüz sunucuya bağlanmamış P3 yazmaları). Sunucu yazmasından sonra [reload] ile kaynaktan
/// yeniden okunur (iyimser güncelleme yok). Katalog henüz yüklenmediyse komutlar yok sayılır.

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
