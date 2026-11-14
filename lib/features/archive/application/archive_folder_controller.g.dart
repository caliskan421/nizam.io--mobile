// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folder_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Klasör ayrıntısı görünüm komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme
/// ve süzgeçler sıfırlanır. Sunucu eylemleri `ArchiveActionsController`'dadır.

@ProviderFor(ArchiveFolderController)
final archiveFolderControllerProvider = ArchiveFolderControllerFamily._();

/// Klasör ayrıntısı görünüm komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme
/// ve süzgeçler sıfırlanır. Sunucu eylemleri `ArchiveActionsController`'dadır.
final class ArchiveFolderControllerProvider
    extends $NotifierProvider<ArchiveFolderController, ArchiveFolderViewState> {
  /// Klasör ayrıntısı görünüm komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme
  /// ve süzgeçler sıfırlanır. Sunucu eylemleri `ArchiveActionsController`'dadır.
  ArchiveFolderControllerProvider._({
    required ArchiveFolderControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'archiveFolderControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archiveFolderControllerHash();

  @override
  String toString() {
    return r'archiveFolderControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ArchiveFolderController create() => ArchiveFolderController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArchiveFolderViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArchiveFolderViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ArchiveFolderControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archiveFolderControllerHash() =>
    r'dc07a8b8e0385b5a8222c1e13cc9f8245d32d4f8';

/// Klasör ayrıntısı görünüm komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme
/// ve süzgeçler sıfırlanır. Sunucu eylemleri `ArchiveActionsController`'dadır.

final class ArchiveFolderControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ArchiveFolderController,
          ArchiveFolderViewState,
          ArchiveFolderViewState,
          ArchiveFolderViewState,
          String
        > {
  ArchiveFolderControllerFamily._()
    : super(
        retry: null,
        name: r'archiveFolderControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Klasör ayrıntısı görünüm komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme
  /// ve süzgeçler sıfırlanır. Sunucu eylemleri `ArchiveActionsController`'dadır.

  ArchiveFolderControllerProvider call(String code) =>
      ArchiveFolderControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFolderControllerProvider';
}

/// Klasör ayrıntısı görünüm komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme
/// ve süzgeçler sıfırlanır. Sunucu eylemleri `ArchiveActionsController`'dadır.

abstract class _$ArchiveFolderController
    extends $Notifier<ArchiveFolderViewState> {
  late final _$args = ref.$arg as String;
  String get code => _$args;

  ArchiveFolderViewState build(String code);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<ArchiveFolderViewState, ArchiveFolderViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ArchiveFolderViewState, ArchiveFolderViewState>,
              ArchiveFolderViewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
