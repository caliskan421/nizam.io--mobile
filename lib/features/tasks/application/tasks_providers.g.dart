// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır; bugün geliştirme örneği).

@ProviderFor(taskCatalogRepository)
final taskCatalogRepositoryProvider = TaskCatalogRepositoryProvider._();

/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır; bugün geliştirme örneği).

final class TaskCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          TaskCatalogRepository,
          TaskCatalogRepository,
          TaskCatalogRepository
        >
    with $Provider<TaskCatalogRepository> {
  /// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır; bugün geliştirme örneği).
  TaskCatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskCatalogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskCatalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskCatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskCatalogRepository create(Ref ref) {
    return taskCatalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskCatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskCatalogRepository>(value),
    );
  }
}

String _$taskCatalogRepositoryHash() =>
    r'6d0e23a696c86368f3caff7e70c58abf30142216';
