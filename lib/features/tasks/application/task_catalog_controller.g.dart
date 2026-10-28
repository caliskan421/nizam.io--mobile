// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_catalog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; yeniden yükleme yalnız dokunuşla.

@ProviderFor(TaskCatalogController)
final taskCatalogControllerProvider = TaskCatalogControllerProvider._();

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; yeniden yükleme yalnız dokunuşla.
final class TaskCatalogControllerProvider
    extends $AsyncNotifierProvider<TaskCatalogController, TaskCatalog> {
  /// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
  /// koordinatörlük ve arşiv ekranları bunu okur; yeniden yükleme yalnız dokunuşla.
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
    r'484ad2f4aaaf292bbf96d75d49c4de4782c6b5bc';

/// Görev kataloğu (görevler, kişiler, koordinatörlükler). Görevler, zaman çizelgesi,
/// koordinatörlük ve arşiv ekranları bunu okur; yeniden yükleme yalnız dokunuşla.

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
