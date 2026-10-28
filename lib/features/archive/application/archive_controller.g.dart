// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arşiv ekranı komutları (yerel durum; sunucuya yazmaz).

@ProviderFor(ArchiveController)
final archiveControllerProvider = ArchiveControllerProvider._();

/// Arşiv ekranı komutları (yerel durum; sunucuya yazmaz).
final class ArchiveControllerProvider
    extends $NotifierProvider<ArchiveController, ArchiveViewState> {
  /// Arşiv ekranı komutları (yerel durum; sunucuya yazmaz).
  ArchiveControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveControllerHash();

  @$internal
  @override
  ArchiveController create() => ArchiveController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArchiveViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArchiveViewState>(value),
    );
  }
}

String _$archiveControllerHash() => r'dff11e1d18555cc9033e8521954e54803a042c67';

/// Arşiv ekranı komutları (yerel durum; sunucuya yazmaz).

abstract class _$ArchiveController extends $Notifier<ArchiveViewState> {
  ArchiveViewState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ArchiveViewState, ArchiveViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ArchiveViewState, ArchiveViewState>,
              ArchiveViewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
