// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folder_contents.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Klasör içeriği bir kez türetilir (klasör ya da görev kataloğu değişene dek); ekran her
/// kurulumda, süzgeç değişiminde ya da önizlemede dosya listesini yeniden üretmez. Kaynaklardan
/// biri yüklenmemişse null (yükleme/hata durumunu ekran kaynakların kendisinden gösterir).

@ProviderFor(archiveFolderContents)
final archiveFolderContentsProvider = ArchiveFolderContentsFamily._();

/// Klasör içeriği bir kez türetilir (klasör ya da görev kataloğu değişene dek); ekran her
/// kurulumda, süzgeç değişiminde ya da önizlemede dosya listesini yeniden üretmez. Kaynaklardan
/// biri yüklenmemişse null (yükleme/hata durumunu ekran kaynakların kendisinden gösterir).

final class ArchiveFolderContentsProvider
    extends
        $FunctionalProvider<
          ArchiveFolderContents?,
          ArchiveFolderContents?,
          ArchiveFolderContents?
        >
    with $Provider<ArchiveFolderContents?> {
  /// Klasör içeriği bir kez türetilir (klasör ya da görev kataloğu değişene dek); ekran her
  /// kurulumda, süzgeç değişiminde ya da önizlemede dosya listesini yeniden üretmez. Kaynaklardan
  /// biri yüklenmemişse null (yükleme/hata durumunu ekran kaynakların kendisinden gösterir).
  ArchiveFolderContentsProvider._({
    required ArchiveFolderContentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'archiveFolderContentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archiveFolderContentsHash();

  @override
  String toString() {
    return r'archiveFolderContentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ArchiveFolderContents?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ArchiveFolderContents? create(Ref ref) {
    final argument = this.argument as String;
    return archiveFolderContents(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArchiveFolderContents? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArchiveFolderContents?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ArchiveFolderContentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archiveFolderContentsHash() =>
    r'6af006b0bd8de73eb077f37618d453bef813e6c1';

/// Klasör içeriği bir kez türetilir (klasör ya da görev kataloğu değişene dek); ekran her
/// kurulumda, süzgeç değişiminde ya da önizlemede dosya listesini yeniden üretmez. Kaynaklardan
/// biri yüklenmemişse null (yükleme/hata durumunu ekran kaynakların kendisinden gösterir).

final class ArchiveFolderContentsFamily extends $Family
    with $FunctionalFamilyOverride<ArchiveFolderContents?, String> {
  ArchiveFolderContentsFamily._()
    : super(
        retry: null,
        name: r'archiveFolderContentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Klasör içeriği bir kez türetilir (klasör ya da görev kataloğu değişene dek); ekran her
  /// kurulumda, süzgeç değişiminde ya da önizlemede dosya listesini yeniden üretmez. Kaynaklardan
  /// biri yüklenmemişse null (yükleme/hata durumunu ekran kaynakların kendisinden gösterir).

  ArchiveFolderContentsProvider call(String code) =>
      ArchiveFolderContentsProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFolderContentsProvider';
}
