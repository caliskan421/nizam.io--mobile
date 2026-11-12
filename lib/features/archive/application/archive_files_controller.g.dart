// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_files_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Klasörün arşiv dosyaları (`archiveAttachments`, imleçli). Süzgeç ([ArchiveFolderController])
/// değişince liste baştan yüklenir (eksen değişince eski imleç geçersizdir). Yöneticide uç dönem
/// genelidir: satırlar klasörün görevleriyle süzülür (sayfa süzgeçten sonra kısa kalabilir;
/// "daha fazla" imleç bitene dek açık kalır).

@ProviderFor(ArchiveFilesController)
final archiveFilesControllerProvider = ArchiveFilesControllerFamily._();

/// Klasörün arşiv dosyaları (`archiveAttachments`, imleçli). Süzgeç ([ArchiveFolderController])
/// değişince liste baştan yüklenir (eksen değişince eski imleç geçersizdir). Yöneticide uç dönem
/// genelidir: satırlar klasörün görevleriyle süzülür (sayfa süzgeçten sonra kısa kalabilir;
/// "daha fazla" imleç bitene dek açık kalır).
final class ArchiveFilesControllerProvider
    extends $AsyncNotifierProvider<ArchiveFilesController, ArchiveFilesState> {
  /// Klasörün arşiv dosyaları (`archiveAttachments`, imleçli). Süzgeç ([ArchiveFolderController])
  /// değişince liste baştan yüklenir (eksen değişince eski imleç geçersizdir). Yöneticide uç dönem
  /// genelidir: satırlar klasörün görevleriyle süzülür (sayfa süzgeçten sonra kısa kalabilir;
  /// "daha fazla" imleç bitene dek açık kalır).
  ArchiveFilesControllerProvider._({
    required ArchiveFilesControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'archiveFilesControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archiveFilesControllerHash();

  @override
  String toString() {
    return r'archiveFilesControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ArchiveFilesController create() => ArchiveFilesController();

  @override
  bool operator ==(Object other) {
    return other is ArchiveFilesControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archiveFilesControllerHash() =>
    r'06164bf677fa1d14d55e417dc9e6163200f69c5c';

/// Klasörün arşiv dosyaları (`archiveAttachments`, imleçli). Süzgeç ([ArchiveFolderController])
/// değişince liste baştan yüklenir (eksen değişince eski imleç geçersizdir). Yöneticide uç dönem
/// genelidir: satırlar klasörün görevleriyle süzülür (sayfa süzgeçten sonra kısa kalabilir;
/// "daha fazla" imleç bitene dek açık kalır).

final class ArchiveFilesControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ArchiveFilesController,
          AsyncValue<ArchiveFilesState>,
          ArchiveFilesState,
          FutureOr<ArchiveFilesState>,
          String
        > {
  ArchiveFilesControllerFamily._()
    : super(
        retry: null,
        name: r'archiveFilesControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Klasörün arşiv dosyaları (`archiveAttachments`, imleçli). Süzgeç ([ArchiveFolderController])
  /// değişince liste baştan yüklenir (eksen değişince eski imleç geçersizdir). Yöneticide uç dönem
  /// genelidir: satırlar klasörün görevleriyle süzülür (sayfa süzgeçten sonra kısa kalabilir;
  /// "daha fazla" imleç bitene dek açık kalır).

  ArchiveFilesControllerProvider call(String code) =>
      ArchiveFilesControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFilesControllerProvider';
}

/// Klasörün arşiv dosyaları (`archiveAttachments`, imleçli). Süzgeç ([ArchiveFolderController])
/// değişince liste baştan yüklenir (eksen değişince eski imleç geçersizdir). Yöneticide uç dönem
/// genelidir: satırlar klasörün görevleriyle süzülür (sayfa süzgeçten sonra kısa kalabilir;
/// "daha fazla" imleç bitene dek açık kalır).

abstract class _$ArchiveFilesController
    extends $AsyncNotifier<ArchiveFilesState> {
  late final _$args = ref.$arg as String;
  String get code => _$args;

  FutureOr<ArchiveFilesState> build(String code);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ArchiveFilesState>, ArchiveFilesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ArchiveFilesState>, ArchiveFilesState>,
              AsyncValue<ArchiveFilesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
