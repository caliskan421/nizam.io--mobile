// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görev ayrıntısı denetleyicisi (prototip `S_detail`). Görev değişiklikleri katalog
/// denetleyicisine yazılır (oturum boyunca listede de görünür).

@ProviderFor(TaskDetailController)
final taskDetailControllerProvider = TaskDetailControllerFamily._();

/// Görev ayrıntısı denetleyicisi (prototip `S_detail`). Görev değişiklikleri katalog
/// denetleyicisine yazılır (oturum boyunca listede de görünür).
final class TaskDetailControllerProvider
    extends $NotifierProvider<TaskDetailController, TaskDetailState> {
  /// Görev ayrıntısı denetleyicisi (prototip `S_detail`). Görev değişiklikleri katalog
  /// denetleyicisine yazılır (oturum boyunca listede de görünür).
  TaskDetailControllerProvider._({
    required TaskDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskDetailControllerHash();

  @override
  String toString() {
    return r'taskDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TaskDetailController create() => TaskDetailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskDetailControllerHash() =>
    r'27047ef73c7b590f8fcb310e400deec950d43d44';

/// Görev ayrıntısı denetleyicisi (prototip `S_detail`). Görev değişiklikleri katalog
/// denetleyicisine yazılır (oturum boyunca listede de görünür).

final class TaskDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TaskDetailController,
          TaskDetailState,
          TaskDetailState,
          TaskDetailState,
          String
        > {
  TaskDetailControllerFamily._()
    : super(
        retry: null,
        name: r'taskDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Görev ayrıntısı denetleyicisi (prototip `S_detail`). Görev değişiklikleri katalog
  /// denetleyicisine yazılır (oturum boyunca listede de görünür).

  TaskDetailControllerProvider call(String code) =>
      TaskDetailControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'taskDetailControllerProvider';
}

/// Görev ayrıntısı denetleyicisi (prototip `S_detail`). Görev değişiklikleri katalog
/// denetleyicisine yazılır (oturum boyunca listede de görünür).

abstract class _$TaskDetailController extends $Notifier<TaskDetailState> {
  late final _$args = ref.$arg as String;
  String get code => _$args;

  TaskDetailState build(String code);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TaskDetailState, TaskDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskDetailState, TaskDetailState>,
              TaskDetailState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
