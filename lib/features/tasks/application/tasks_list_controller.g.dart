// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri).

@ProviderFor(TasksListController)
final tasksListControllerProvider = TasksListControllerFamily._();

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri).
final class TasksListControllerProvider
    extends $NotifierProvider<TasksListController, TasksListState> {
  /// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
  /// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri).
  TasksListControllerProvider._({
    required TasksListControllerFamily super.from,
    required (TaskView, String) super.argument,
  }) : super(
         retry: null,
         name: r'tasksListControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksListControllerHash();

  @override
  String toString() {
    return r'tasksListControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TasksListController create() => TasksListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TasksListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TasksListState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TasksListControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksListControllerHash() =>
    r'34dac8b4daf6e591a3183b95d48a72113ed31960';

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri).

final class TasksListControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TasksListController,
          TasksListState,
          TasksListState,
          TasksListState,
          (TaskView, String)
        > {
  TasksListControllerFamily._()
    : super(
        retry: null,
        name: r'tasksListControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
  /// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri).

  TasksListControllerProvider call(TaskView view, String people) =>
      TasksListControllerProvider._(argument: (view, people), from: this);

  @override
  String toString() => r'tasksListControllerProvider';
}

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri).

abstract class _$TasksListController extends $Notifier<TasksListState> {
  late final _$args = ref.$arg as (TaskView, String);
  TaskView get view => _$args.$1;
  String get people => _$args.$2;

  TasksListState build(TaskView view, String people);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TasksListState, TasksListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TasksListState, TasksListState>,
              TasksListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
