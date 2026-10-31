// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).

@ProviderFor(taskCatalogRepository)
final taskCatalogRepositoryProvider = TaskCatalogRepositoryProvider._();

/// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).

final class TaskCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          TaskCatalogRepository,
          TaskCatalogRepository,
          TaskCatalogRepository
        >
    with $Provider<TaskCatalogRepository> {
  /// PORT: görev kataloğunun kaynağı (`tasks_module.dart`'ta bağlanır: sunucu ya da örnek).
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

/// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).

@ProviderFor(taskDetailsRepository)
final taskDetailsRepositoryProvider = TaskDetailsRepositoryProvider._();

/// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).

final class TaskDetailsRepositoryProvider
    extends
        $FunctionalProvider<
          TaskDetailsRepository,
          TaskDetailsRepository,
          TaskDetailsRepository
        >
    with $Provider<TaskDetailsRepository> {
  /// PORT: görev ayrıntısının kaynağı (`tasks_module.dart`'ta bağlanır).
  TaskDetailsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskDetailsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskDetailsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskDetailsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskDetailsRepository create(Ref ref) {
    return taskDetailsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskDetailsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskDetailsRepository>(value),
    );
  }
}

String _$taskDetailsRepositoryHash() =>
    r'b978f27c0a256d8c8b40088a981c52a6d63892d1';
