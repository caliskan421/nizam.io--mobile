// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folder_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Silinen kayıtlara taşınan dosya kimlikleri (oturum boyunca; prototip `gone` klasör yeniden
/// açılınca da korunur). Dosya kimlikleri klasörler arasında tektir.

@ProviderFor(ArchiveRemovedFiles)
final archiveRemovedFilesProvider = ArchiveRemovedFilesProvider._();

/// Silinen kayıtlara taşınan dosya kimlikleri (oturum boyunca; prototip `gone` klasör yeniden
/// açılınca da korunur). Dosya kimlikleri klasörler arasında tektir.
final class ArchiveRemovedFilesProvider
    extends $NotifierProvider<ArchiveRemovedFiles, Set<String>> {
  /// Silinen kayıtlara taşınan dosya kimlikleri (oturum boyunca; prototip `gone` klasör yeniden
  /// açılınca da korunur). Dosya kimlikleri klasörler arasında tektir.
  ArchiveRemovedFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveRemovedFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveRemovedFilesHash();

  @$internal
  @override
  ArchiveRemovedFiles create() => ArchiveRemovedFiles();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$archiveRemovedFilesHash() =>
    r'6c14fe1c2b1f92d76ac5b4080a1e29349ad73f27';

/// Silinen kayıtlara taşınan dosya kimlikleri (oturum boyunca; prototip `gone` klasör yeniden
/// açılınca da korunur). Dosya kimlikleri klasörler arasında tektir.

abstract class _$ArchiveRemovedFiles extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme ve
/// süzgeçler sıfırlanır (prototip `openAFolder`), silinenler [ArchiveRemovedFiles]'ta kalır.

@ProviderFor(ArchiveFolderController)
final archiveFolderControllerProvider = ArchiveFolderControllerFamily._();

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme ve
/// süzgeçler sıfırlanır (prototip `openAFolder`), silinenler [ArchiveRemovedFiles]'ta kalır.
final class ArchiveFolderControllerProvider
    extends $NotifierProvider<ArchiveFolderController, ArchiveFolderViewState> {
  /// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme ve
  /// süzgeçler sıfırlanır (prototip `openAFolder`), silinenler [ArchiveRemovedFiles]'ta kalır.
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
    r'8b4690b230aa88d4756cf7ae97a6403fcafdcbf6';

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme ve
/// süzgeçler sıfırlanır (prototip `openAFolder`), silinenler [ArchiveRemovedFiles]'ta kalır.

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

  /// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme ve
  /// süzgeçler sıfırlanır (prototip `openAFolder`), silinenler [ArchiveRemovedFiles]'ta kalır.

  ArchiveFolderControllerProvider call(String code) =>
      ArchiveFolderControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFolderControllerProvider';
}

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum. Ekran kapanınca sekme ve
/// süzgeçler sıfırlanır (prototip `openAFolder`), silinenler [ArchiveRemovedFiles]'ta kalır.

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
