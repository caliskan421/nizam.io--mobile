// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [TasksListPrefs] deposu: oturum boyunca yaşar; her yeni liste denetleyicisi (KPI kartı,
/// ekip kutusu, çekmece rozeti `view`/`people` ile açılan liste) buradan başlar.

@ProviderFor(TasksListPrefsStore)
final tasksListPrefsStoreProvider = TasksListPrefsStoreProvider._();

/// [TasksListPrefs] deposu: oturum boyunca yaşar; her yeni liste denetleyicisi (KPI kartı,
/// ekip kutusu, çekmece rozeti `view`/`people` ile açılan liste) buradan başlar.
final class TasksListPrefsStoreProvider
    extends $NotifierProvider<TasksListPrefsStore, TasksListPrefs> {
  /// [TasksListPrefs] deposu: oturum boyunca yaşar; her yeni liste denetleyicisi (KPI kartı,
  /// ekip kutusu, çekmece rozeti `view`/`people` ile açılan liste) buradan başlar.
  TasksListPrefsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksListPrefsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksListPrefsStoreHash();

  @$internal
  @override
  TasksListPrefsStore create() => TasksListPrefsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TasksListPrefs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TasksListPrefs>(value),
    );
  }
}

String _$tasksListPrefsStoreHash() =>
    r'7aab44e6e7f49a35372e1c3b7ee5914166b7bf69';

/// [TasksListPrefs] deposu: oturum boyunca yaşar; her yeni liste denetleyicisi (KPI kartı,
/// ekip kutusu, çekmece rozeti `view`/`people` ile açılan liste) buradan başlar.

abstract class _$TasksListPrefsStore extends $Notifier<TasksListPrefs> {
  TasksListPrefs build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TasksListPrefs, TasksListPrefs>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TasksListPrefs, TasksListPrefs>,
              TasksListPrefs,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri). Ömür: sayfa
/// (autoDispose; aynı rota sayfası yığında/sekmede durdukça durum korunur), tercihler
/// [TasksListPrefsStore]'da.

@ProviderFor(TasksListController)
final tasksListControllerProvider = TasksListControllerFamily._();

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri). Ömür: sayfa
/// (autoDispose; aynı rota sayfası yığında/sekmede durdukça durum korunur), tercihler
/// [TasksListPrefsStore]'da.
final class TasksListControllerProvider
    extends $NotifierProvider<TasksListController, TasksListState> {
  /// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
  /// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri). Ömür: sayfa
  /// (autoDispose; aynı rota sayfası yığında/sekmede durdukça durum korunur), tercihler
  /// [TasksListPrefsStore]'da.
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
    r'97f044c6025f73db75d8cf4a3bc48e8048a5d3b4';

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri). Ömür: sayfa
/// (autoDispose; aynı rota sayfası yığında/sekmede durdukça durum korunur), tercihler
/// [TasksListPrefsStore]'da.

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
  /// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri). Ömür: sayfa
  /// (autoDispose; aynı rota sayfası yığında/sekmede durdukça durum korunur), tercihler
  /// [TasksListPrefsStore]'da.

  TasksListControllerProvider call(TaskView view, String people) =>
      TasksListControllerProvider._(argument: (view, people), from: this);

  @override
  String toString() => r'tasksListControllerProvider';
}

/// Görevler listesi denetleyicisi. [view] ve [people] (virgülle ayrılmış kişi kimlikleri)
/// başlangıç süzgecidir (ana sayfa özet/ekip kutuları, çekmece rozetleri). Ömür: sayfa
/// (autoDispose; aynı rota sayfası yığında/sekmede durdukça durum korunur), tercihler
/// [TasksListPrefsStore]'da.

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

/// Seçili görünümün süzülmüş/sıralı listesi ve görünüm sayıları; yalnız sorguyu etkileyen
/// alanlar (görünüm, sıralama, yön, süzgeç) ya da katalog değişince yeniden hesaplanır
/// (arama alanını açmak, sayfalamak, grup açmak hesaplamaz). Katalog yokken null.

@ProviderFor(tasksListResult)
final tasksListResultProvider = TasksListResultFamily._();

/// Seçili görünümün süzülmüş/sıralı listesi ve görünüm sayıları; yalnız sorguyu etkileyen
/// alanlar (görünüm, sıralama, yön, süzgeç) ya da katalog değişince yeniden hesaplanır
/// (arama alanını açmak, sayfalamak, grup açmak hesaplamaz). Katalog yokken null.

final class TasksListResultProvider
    extends
        $FunctionalProvider<
          TaskQueryResult?,
          TaskQueryResult?,
          TaskQueryResult?
        >
    with $Provider<TaskQueryResult?> {
  /// Seçili görünümün süzülmüş/sıralı listesi ve görünüm sayıları; yalnız sorguyu etkileyen
  /// alanlar (görünüm, sıralama, yön, süzgeç) ya da katalog değişince yeniden hesaplanır
  /// (arama alanını açmak, sayfalamak, grup açmak hesaplamaz). Katalog yokken null.
  TasksListResultProvider._({
    required TasksListResultFamily super.from,
    required (TaskView, String) super.argument,
  }) : super(
         retry: null,
         name: r'tasksListResultProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksListResultHash();

  @override
  String toString() {
    return r'tasksListResultProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<TaskQueryResult?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskQueryResult? create(Ref ref) {
    final argument = this.argument as (TaskView, String);
    return tasksListResult(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskQueryResult? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskQueryResult?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TasksListResultProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksListResultHash() => r'8b48d56b88a7b7a7b3b7be490752a50523c9946a';

/// Seçili görünümün süzülmüş/sıralı listesi ve görünüm sayıları; yalnız sorguyu etkileyen
/// alanlar (görünüm, sıralama, yön, süzgeç) ya da katalog değişince yeniden hesaplanır
/// (arama alanını açmak, sayfalamak, grup açmak hesaplamaz). Katalog yokken null.

final class TasksListResultFamily extends $Family
    with $FunctionalFamilyOverride<TaskQueryResult?, (TaskView, String)> {
  TasksListResultFamily._()
    : super(
        retry: null,
        name: r'tasksListResultProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Seçili görünümün süzülmüş/sıralı listesi ve görünüm sayıları; yalnız sorguyu etkileyen
  /// alanlar (görünüm, sıralama, yön, süzgeç) ya da katalog değişince yeniden hesaplanır
  /// (arama alanını açmak, sayfalamak, grup açmak hesaplamaz). Katalog yokken null.

  TasksListResultProvider call(TaskView view, String people) =>
      TasksListResultProvider._(argument: (view, people), from: this);

  @override
  String toString() => r'tasksListResultProvider';
}

/// Filtre alt sayfasının seçenek sayıları; katalog değişince bir kez hesaplanır.

@ProviderFor(taskFilterOptions)
final taskFilterOptionsProvider = TaskFilterOptionsProvider._();

/// Filtre alt sayfasının seçenek sayıları; katalog değişince bir kez hesaplanır.

final class TaskFilterOptionsProvider
    extends
        $FunctionalProvider<
          TaskFilterOptions?,
          TaskFilterOptions?,
          TaskFilterOptions?
        >
    with $Provider<TaskFilterOptions?> {
  /// Filtre alt sayfasının seçenek sayıları; katalog değişince bir kez hesaplanır.
  TaskFilterOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskFilterOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskFilterOptionsHash();

  @$internal
  @override
  $ProviderElement<TaskFilterOptions?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskFilterOptions? create(Ref ref) {
    return taskFilterOptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFilterOptions? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFilterOptions?>(value),
    );
  }
}

String _$taskFilterOptionsHash() => r'9a85029098fd6a951db89078a8743abcc59aa23c';
