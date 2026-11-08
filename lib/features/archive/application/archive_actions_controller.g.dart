// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Klasörün sunucu eylemleri (indirme, ZIP, yükleme, silme); durum: eylem sürüyor mu (çift
/// dokunuş tek istek). Yazmadan sonra etkilenen listeler yeniden okunur (iyimser güncelleme
/// yok). Görünüm ve dosya listesi bu sağlayıcıya bağlı değildir (döngü yok).

@ProviderFor(ArchiveActionsController)
final archiveActionsControllerProvider = ArchiveActionsControllerFamily._();

/// Klasörün sunucu eylemleri (indirme, ZIP, yükleme, silme); durum: eylem sürüyor mu (çift
/// dokunuş tek istek). Yazmadan sonra etkilenen listeler yeniden okunur (iyimser güncelleme
/// yok). Görünüm ve dosya listesi bu sağlayıcıya bağlı değildir (döngü yok).
final class ArchiveActionsControllerProvider
    extends $NotifierProvider<ArchiveActionsController, bool> {
  /// Klasörün sunucu eylemleri (indirme, ZIP, yükleme, silme); durum: eylem sürüyor mu (çift
  /// dokunuş tek istek). Yazmadan sonra etkilenen listeler yeniden okunur (iyimser güncelleme
  /// yok). Görünüm ve dosya listesi bu sağlayıcıya bağlı değildir (döngü yok).
  ArchiveActionsControllerProvider._({
    required ArchiveActionsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'archiveActionsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archiveActionsControllerHash();

  @override
  String toString() {
    return r'archiveActionsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ArchiveActionsController create() => ArchiveActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ArchiveActionsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archiveActionsControllerHash() =>
    r'469ed0c194dadc28ca23590005de2e6f91d010ac';

/// Klasörün sunucu eylemleri (indirme, ZIP, yükleme, silme); durum: eylem sürüyor mu (çift
/// dokunuş tek istek). Yazmadan sonra etkilenen listeler yeniden okunur (iyimser güncelleme
/// yok). Görünüm ve dosya listesi bu sağlayıcıya bağlı değildir (döngü yok).

final class ArchiveActionsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ArchiveActionsController,
          bool,
          bool,
          bool,
          String
        > {
  ArchiveActionsControllerFamily._()
    : super(
        retry: null,
        name: r'archiveActionsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Klasörün sunucu eylemleri (indirme, ZIP, yükleme, silme); durum: eylem sürüyor mu (çift
  /// dokunuş tek istek). Yazmadan sonra etkilenen listeler yeniden okunur (iyimser güncelleme
  /// yok). Görünüm ve dosya listesi bu sağlayıcıya bağlı değildir (döngü yok).

  ArchiveActionsControllerProvider call(String code) =>
      ArchiveActionsControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveActionsControllerProvider';
}

/// Klasörün sunucu eylemleri (indirme, ZIP, yükleme, silme); durum: eylem sürüyor mu (çift
/// dokunuş tek istek). Yazmadan sonra etkilenen listeler yeniden okunur (iyimser güncelleme
/// yok). Görünüm ve dosya listesi bu sağlayıcıya bağlı değildir (döngü yok).

abstract class _$ArchiveActionsController extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get code => _$args;

  bool build(String code);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
