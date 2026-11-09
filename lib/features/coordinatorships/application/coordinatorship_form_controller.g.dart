// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Şirket yöneticisi mi: koordinatörlük ekleme ve bilgi düzenleme düğmeleri yalnız ona görünür
/// (`createDepartment`, `updateDepartment`, `linkDepartment`, `renameDepartmentLink` yalnız
/// şirket yöneticisine açık). Gizleme güvenlik değildir; sunucu her istekte denetler.

@ProviderFor(canManageCoordinatorships)
final canManageCoordinatorshipsProvider = CanManageCoordinatorshipsProvider._();

/// Şirket yöneticisi mi: koordinatörlük ekleme ve bilgi düzenleme düğmeleri yalnız ona görünür
/// (`createDepartment`, `updateDepartment`, `linkDepartment`, `renameDepartmentLink` yalnız
/// şirket yöneticisine açık). Gizleme güvenlik değildir; sunucu her istekte denetler.

final class CanManageCoordinatorshipsProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Şirket yöneticisi mi: koordinatörlük ekleme ve bilgi düzenleme düğmeleri yalnız ona görünür
  /// (`createDepartment`, `updateDepartment`, `linkDepartment`, `renameDepartmentLink` yalnız
  /// şirket yöneticisine açık). Gizleme güvenlik değildir; sunucu her istekte denetler.
  CanManageCoordinatorshipsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canManageCoordinatorshipsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canManageCoordinatorshipsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canManageCoordinatorships(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canManageCoordinatorshipsHash() =>
    r'709e16b25376f3f84177a1967dbfb53c51ddf6fd';

/// Koordinatörlük ekle / bilgileri düzenle komutları. Uygulama ömrünce yaşar: oluşturulup
/// bağlanamamış departman ([CoordinatorshipFormState.pending]) form kapanıp açılsa da
/// korunur. Otomatik yeniden deneme yoktur; tekrar kullanıcı eylemiyle.

@ProviderFor(CoordinatorshipFormController)
final coordinatorshipFormControllerProvider =
    CoordinatorshipFormControllerProvider._();

/// Koordinatörlük ekle / bilgileri düzenle komutları. Uygulama ömrünce yaşar: oluşturulup
/// bağlanamamış departman ([CoordinatorshipFormState.pending]) form kapanıp açılsa da
/// korunur. Otomatik yeniden deneme yoktur; tekrar kullanıcı eylemiyle.
final class CoordinatorshipFormControllerProvider
    extends
        $NotifierProvider<
          CoordinatorshipFormController,
          CoordinatorshipFormState
        > {
  /// Koordinatörlük ekle / bilgileri düzenle komutları. Uygulama ömrünce yaşar: oluşturulup
  /// bağlanamamış departman ([CoordinatorshipFormState.pending]) form kapanıp açılsa da
  /// korunur. Otomatik yeniden deneme yoktur; tekrar kullanıcı eylemiyle.
  CoordinatorshipFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipFormControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipFormControllerHash();

  @$internal
  @override
  CoordinatorshipFormController create() => CoordinatorshipFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoordinatorshipFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoordinatorshipFormState>(value),
    );
  }
}

String _$coordinatorshipFormControllerHash() =>
    r'0e7296151bf111a2073bef9c899c1cb2a607a431';

/// Koordinatörlük ekle / bilgileri düzenle komutları. Uygulama ömrünce yaşar: oluşturulup
/// bağlanamamış departman ([CoordinatorshipFormState.pending]) form kapanıp açılsa da
/// korunur. Otomatik yeniden deneme yoktur; tekrar kullanıcı eylemiyle.

abstract class _$CoordinatorshipFormController
    extends $Notifier<CoordinatorshipFormState> {
  CoordinatorshipFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<CoordinatorshipFormState, CoordinatorshipFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoordinatorshipFormState, CoordinatorshipFormState>,
              CoordinatorshipFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
