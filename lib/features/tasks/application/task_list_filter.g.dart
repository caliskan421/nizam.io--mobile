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
/// istek YOK (görünüm katalogdan). Tek depo kuralı: okunan satırlar paylaşılan kataloğa
/// işlenir ([TaskCatalogController.upsert]; taze alanlar katalogda güncellenir, katalogda
/// olmayan görev eklenir — ayrıntısı açılabilir; okuma sürerken yerelde güncellenen satır
/// ezilmez), sonuç yalnız kimlik listesidir. Katalog yeniden okununca (yazma sonrası `reload`,
/// yenileme) bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur
/// ve sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
/// `work.program_scope_invalid`) temizlenir; 404'te paylaşılan katalog BİR KEZ yeniden okunur
/// (silinmiş departmanın satırları/seçenekleri kalmasın; süzgeç artık null → döngü yok).

@ProviderFor(taskListPage)
final taskListPageProvider = TaskListPageProvider._();

/// Süzgeç seçiliyken görev sayfaları (`loadTasks`, `department_id`); süzgeç yokken null ve
/// istek YOK (görünüm katalogdan). Tek depo kuralı: okunan satırlar paylaşılan kataloğa
/// işlenir ([TaskCatalogController.upsert]; taze alanlar katalogda güncellenir, katalogda
/// olmayan görev eklenir — ayrıntısı açılabilir; okuma sürerken yerelde güncellenen satır
/// ezilmez), sonuç yalnız kimlik listesidir. Katalog yeniden okununca (yazma sonrası `reload`,
/// yenileme) bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur
/// ve sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
/// `work.program_scope_invalid`) temizlenir; 404'te paylaşılan katalog BİR KEZ yeniden okunur
/// (silinmiş departmanın satırları/seçenekleri kalmasın; süzgeç artık null → döngü yok).

final class TaskListPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskListIds?>,
          TaskListIds?,
          FutureOr<TaskListIds?>
        >
    with $FutureModifier<TaskListIds?>, $FutureProvider<TaskListIds?> {
  /// Süzgeç seçiliyken görev sayfaları (`loadTasks`, `department_id`); süzgeç yokken null ve
  /// istek YOK (görünüm katalogdan). Tek depo kuralı: okunan satırlar paylaşılan kataloğa
  /// işlenir ([TaskCatalogController.upsert]; taze alanlar katalogda güncellenir, katalogda
  /// olmayan görev eklenir — ayrıntısı açılabilir; okuma sürerken yerelde güncellenen satır
  /// ezilmez), sonuç yalnız kimlik listesidir. Katalog yeniden okununca (yazma sonrası `reload`,
  /// yenileme) bu okuma da yenilenir. Okuma eskirse (süzgeç/program değişti) sayfa döngüsü durur
  /// ve sonucu hiçbir duruma yazılmaz. Geçersiz süzgeç (seçeneklerde yok ya da 404
  /// `work.program_scope_invalid`) temizlenir; 404'te paylaşılan katalog BİR KEZ yeniden okunur
  /// (silinmiş departmanın satırları/seçenekleri kalmasın; süzgeç artık null → döngü yok).
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
  $FutureProviderElement<TaskListIds?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TaskListIds?> create(Ref ref) {
    return taskListPage(ref);
  }
}

String _$taskListPageHash() => r'988bc37fa2b66c14cae4982709f8573a92a22305';

/// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
/// varsa katalogun satırları süzgeçli okumanın kimlik sırasıyla ([TaskCatalog.filtered]).
/// Katalog güncellemeleri (ayrıntı, yazma, upsert) görünüme yansır.

@ProviderFor(taskListCatalog)
final taskListCatalogProvider = TaskListCatalogProvider._();

/// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
/// varsa katalogun satırları süzgeçli okumanın kimlik sırasıyla ([TaskCatalog.filtered]).
/// Katalog güncellemeleri (ayrıntı, yazma, upsert) görünüme yansır.

final class TaskListCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskCatalog>,
          AsyncValue<TaskCatalog>,
          AsyncValue<TaskCatalog>
        >
    with $Provider<AsyncValue<TaskCatalog>> {
  /// Görevler ekranının görünümü: süzgeç yoksa paylaşılan katalog (ek istek yok); süzgeç
  /// varsa katalogun satırları süzgeçli okumanın kimlik sırasıyla ([TaskCatalog.filtered]).
  /// Katalog güncellemeleri (ayrıntı, yazma, upsert) görünüme yansır.
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

String _$taskListCatalogHash() => r'0e838a622358e1cf63483ae03df257f3831625f9';
