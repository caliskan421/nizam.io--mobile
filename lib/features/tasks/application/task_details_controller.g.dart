// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz.

@ProviderFor(taskDetails)
final taskDetailsProvider = TaskDetailsFamily._();

/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz.

final class TaskDetailsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
  /// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
  /// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz.
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

String _$taskDetailsHash() => r'fc1ff8a01f79d507e4ec4e1f24ed79afcfb8662b';

/// Görev ayrıntısını ([code]) kaynağından okur ve katalogdaki göreve ekler. Ayrıntı ekranı
/// izler; kapsam değişince ya da dokunuşla (`ref.invalidate`) yeniden okunur. Görev katalogda
/// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz.

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
  /// yoksa ya da kaynak ayrıntı taşımıyorsa (örnek) bir şey yapmaz.

  TaskDetailsProvider call(String code) =>
      TaskDetailsProvider._(argument: code, from: this);

  @override
  String toString() => r'taskDetailsProvider';
}
