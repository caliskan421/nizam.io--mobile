// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Departman süzgecinin durumu (bellekte). Program değişince sıfırlanır (yeniden kurulum).

@ProviderFor(TaskListFilter)
final taskListFilterProvider = TaskListFilterProvider._();

/// Departman süzgecinin durumu (bellekte). Program değişince sıfırlanır (yeniden kurulum).
final class TaskListFilterProvider
    extends $NotifierProvider<TaskListFilter, TaskListFilterState> {
  /// Departman süzgecinin durumu (bellekte). Program değişince sıfırlanır (yeniden kurulum).
  TaskListFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListFilterHash();

  @$internal
  @override
  TaskListFilter create() => TaskListFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskListFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskListFilterState>(value),
    );
  }
}

String _$taskListFilterHash() => r'fbe107ff31491e6365e875a2494a748d95c3ed32';

/// Departman süzgecinin durumu (bellekte). Program değişince sıfırlanır (yeniden kurulum).

abstract class _$TaskListFilter extends $Notifier<TaskListFilterState> {
  TaskListFilterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TaskListFilterState, TaskListFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskListFilterState, TaskListFilterState>,
              TaskListFilterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Süzgeç seçiliyken görev sayfaları (`loadTasks`, `department_id`); süzgeç yokken null ve
/// istek YOK (görünüm katalogdan). Katalog yeniden okununca (yazma sonrası `reload`, yenileme)
/// bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur ve
/// sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
/// `work.program_scope_invalid`) temizlenir.

@ProviderFor(taskListPage)
final taskListPageProvider = TaskListPageProvider._();

/// Süzgeç seçiliyken görev sayfaları (`loadTasks`, `department_id`); süzgeç yokken null ve
/// istek YOK (görünüm katalogdan). Katalog yeniden okununca (yazma sonrası `reload`, yenileme)
/// bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur ve
/// sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
/// `work.program_scope_invalid`) temizlenir.

final class TaskListPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskListPage?>,
          TaskListPage?,
          FutureOr<TaskListPage?>
        >
    with $FutureModifier<TaskListPage?>, $FutureProvider<TaskListPage?> {
  /// Süzgeç seçiliyken görev sayfaları (`loadTasks`, `department_id`); süzgeç yokken null ve
  /// istek YOK (görünüm katalogdan). Katalog yeniden okununca (yazma sonrası `reload`, yenileme)
  /// bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur ve
  /// sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
  /// `work.program_scope_invalid`) temizlenir.
  TaskListPageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListPageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListPageHash();

  @$internal
  @override
  $FutureProviderElement<TaskListPage?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TaskListPage?> create(Ref ref) {
    return taskListPage(ref);
  }
}

String _$taskListPageHash() => r'fee92d412f1b2777c1cc0aaa3671ebe22afd58d6';

/// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
/// varsa katalogun kişi/rol/departman kümesi + süzgeçli görev sayfaları
/// ([TaskCatalog.filtered]). Katalog yerel güncellemeleri (ayrıntı, yazma) görünüme yansır.

@ProviderFor(taskListCatalog)
final taskListCatalogProvider = TaskListCatalogProvider._();

/// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
/// varsa katalogun kişi/rol/departman kümesi + süzgeçli görev sayfaları
/// ([TaskCatalog.filtered]). Katalog yerel güncellemeleri (ayrıntı, yazma) görünüme yansır.

final class TaskListCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskCatalog>,
          AsyncValue<TaskCatalog>,
          AsyncValue<TaskCatalog>
        >
    with $Provider<AsyncValue<TaskCatalog>> {
  /// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
  /// varsa katalogun kişi/rol/departman kümesi + süzgeçli görev sayfaları
  /// ([TaskCatalog.filtered]). Katalog yerel güncellemeleri (ayrıntı, yazma) görünüme yansır.
  TaskListCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListCatalogHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<TaskCatalog>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<TaskCatalog> create(Ref ref) {
    return taskListCatalog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TaskCatalog> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TaskCatalog>>(value),
    );
  }
}

String _$taskListCatalogHash() => r'1ba1981de933dc0ab0709ecde820c9768d96f07a';
