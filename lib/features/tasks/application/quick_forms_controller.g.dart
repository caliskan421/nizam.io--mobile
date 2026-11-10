// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_forms_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Yeni görev formunun koordinatörlük seçenekleri: yalnız görev açılabilen departmanlar ([TaskAccess.canCreateIn]: yönetici programın bütün
/// departmanları, karma rolde yalnız koordinatörlükler; üyelik departmanı listelenmez).

@ProviderFor(newTaskCoordinatorships)
final newTaskCoordinatorshipsProvider = NewTaskCoordinatorshipsProvider._();

/// Yeni görev formunun koordinatörlük seçenekleri: yalnız görev açılabilen departmanlar ([TaskAccess.canCreateIn]: yönetici programın bütün
/// departmanları, karma rolde yalnız koordinatörlükler; üyelik departmanı listelenmez).

final class NewTaskCoordinatorshipsProvider
    extends
        $FunctionalProvider<
          List<CoordinatorshipRef>,
          List<CoordinatorshipRef>,
          List<CoordinatorshipRef>
        >
    with $Provider<List<CoordinatorshipRef>> {
  /// Yeni görev formunun koordinatörlük seçenekleri: yalnız görev açılabilen departmanlar ([TaskAccess.canCreateIn]: yönetici programın bütün
  /// departmanları, karma rolde yalnız koordinatörlükler; üyelik departmanı listelenmez).
  NewTaskCoordinatorshipsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newTaskCoordinatorshipsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newTaskCoordinatorshipsHash();

  @$internal
  @override
  $ProviderElement<List<CoordinatorshipRef>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<CoordinatorshipRef> create(Ref ref) {
    return newTaskCoordinatorships(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CoordinatorshipRef> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CoordinatorshipRef>>(value),
    );
  }
}

String _$newTaskCoordinatorshipsHash() =>
    r'5719067f7b2e63e902a48f6db2c7d369376affbf';

@ProviderFor(NewTaskFormController)
final newTaskFormControllerProvider = NewTaskFormControllerProvider._();

final class NewTaskFormControllerProvider
    extends $NotifierProvider<NewTaskFormController, NewTaskForm> {
  NewTaskFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newTaskFormControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newTaskFormControllerHash();

  @$internal
  @override
  NewTaskFormController create() => NewTaskFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NewTaskForm value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NewTaskForm>(value),
    );
  }
}

String _$newTaskFormControllerHash() =>
    r'3e6b4eda170585bb81482d04ea927c2f9e283683';

abstract class _$NewTaskFormController extends $Notifier<NewTaskForm> {
  NewTaskForm build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NewTaskForm, NewTaskForm>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NewTaskForm, NewTaskForm>,
              NewTaskForm,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
