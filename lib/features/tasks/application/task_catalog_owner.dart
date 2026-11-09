// Riverpod 3.4.3 için katalog durum uyarlaması; iç API kullanımı bu dosyayla sınırlıdır.
// ignore_for_file: invalid_use_of_internal_member

part of 'task_catalog_controller.dart';

// Riverpod 3.4.3 asReload:true ve state=AsyncLoading önceki değeri birleştirir.
// Bu kataloğa özgü eleman, birleştirmeden ÖNCE önceki durumu mevcut sahibine süzer.
// Böylece value/future/notifier/selectAsync/invalidate yüzü değişmeden kalır.
final taskCatalogControllerProvider = _TaskCatalogProvider();

// Riverpod kod üretiminin kullandığı tabanlar: yalnız pinli 3.4.3 için bu küçük uyarlama.
final class _TaskCatalogProvider
    extends $AsyncNotifierProvider<TaskCatalogController, TaskCatalog> {
  _TaskCatalogProvider()
    : super(
        name: 'taskCatalogControllerProvider',
        from: null,
        argument: null,
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
        retry: null,
      );

  @override
  String? debugGetCreateSourceHash() => null;

  @override
  TaskCatalogController create() => TaskCatalogController();

  @override
  $AsyncNotifierProviderElement<TaskCatalogController, TaskCatalog>
  $createElement($ProviderPointer pointer) => _TaskCatalogElement(pointer);
}

final class _TaskCatalogElement
    extends $AsyncNotifierProviderElement<TaskCatalogController, TaskCatalog> {
  _TaskCatalogElement(super.pointer);

  @override
  AsyncValue<TaskCatalog> get value {
    final currentRef = ref;
    final controller = classListenable.result?.value;
    final held = super.value;
    if (currentRef == null ||
        !currentRef.mounted ||
        controller == null ||
        controller._owner == null) {
      return held;
    }
    return controller._ownership.visible(currentRef, held);
  }
}
