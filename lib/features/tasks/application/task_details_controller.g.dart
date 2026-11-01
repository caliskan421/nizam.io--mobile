// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz. Rol (tarih talebi yüzü)
/// katalogdaki [TaskCatalog.access]'ten.
///
/// Katalog yeniden kurulunca (invalidate, kapsam değişimi) ayrıntı katalogla birlikte gider;
/// bu yüzden katalog YÜKLEMEYE geçtiğinde ayrıntı da kendini geçersiz kılar ve yeni katalog
/// gelince yeniden okunur. [TaskCatalogController.applyDetails] yükleme üretmez → döngü yok.

@ProviderFor(taskDetails)
final taskDetailsProvider = TaskDetailsFamily._();

/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz. Rol (tarih talebi yüzü)
/// katalogdaki [TaskCatalog.access]'ten.
///
/// Katalog yeniden kurulunca (invalidate, kapsam değişimi) ayrıntı katalogla birlikte gider;
/// bu yüzden katalog YÜKLEMEYE geçtiğinde ayrıntı da kendini geçersiz kılar ve yeni katalog
/// gelince yeniden okunur. [TaskCatalogController.applyDetails] yükleme üretmez → döngü yok.

final class TaskDetailsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
  /// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
  /// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz. Rol (tarih talebi yüzü)
  /// katalogdaki [TaskCatalog.access]'ten.
  ///
  /// Katalog yeniden kurulunca (invalidate, kapsam değişimi) ayrıntı katalogla birlikte gider;
  /// bu yüzden katalog YÜKLEMEYE geçtiğinde ayrıntı da kendini geçersiz kılar ve yeni katalog
  /// gelince yeniden okunur. [TaskCatalogController.applyDetails] yükleme üretmez → döngü yok.
  TaskDetailsProvider._({
    required TaskDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskDetailsHash();

  @override
  String toString() {
    return r'taskDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as String;
    return taskDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskDetailsHash() => r'd87435219c79b2a771445d5a82bc10dd76ec54eb';

/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz. Rol (tarih talebi yüzü)
/// katalogdaki [TaskCatalog.access]'ten.
///
/// Katalog yeniden kurulunca (invalidate, kapsam değişimi) ayrıntı katalogla birlikte gider;
/// bu yüzden katalog YÜKLEMEYE geçtiğinde ayrıntı da kendini geçersiz kılar ve yeni katalog
/// gelince yeniden okunur. [TaskCatalogController.applyDetails] yükleme üretmez → döngü yok.

final class TaskDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, String> {
  TaskDetailsFamily._()
    : super(
        retry: null,
        name: r'taskDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
  /// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
  /// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz. Rol (tarih talebi yüzü)
  /// katalogdaki [TaskCatalog.access]'ten.
  ///
  /// Katalog yeniden kurulunca (invalidate, kapsam değişimi) ayrıntı katalogla birlikte gider;
  /// bu yüzden katalog YÜKLEMEYE geçtiğinde ayrıntı da kendini geçersiz kılar ve yeni katalog
  /// gelince yeniden okunur. [TaskCatalogController.applyDetails] yükleme üretmez → döngü yok.

  TaskDetailsProvider call(String code) =>
      TaskDetailsProvider._(argument: code, from: this);

  @override
  String toString() => r'taskDetailsProvider';
}
