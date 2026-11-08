// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folder_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [code] klasörü (klasör listesinden); listede yoksa null (ekran "bulunamadı" der).

@ProviderFor(archiveFolderContext)
final archiveFolderContextProvider = ArchiveFolderContextFamily._();

/// [code] klasörü (klasör listesinden); listede yoksa null (ekran "bulunamadı" der).

final class ArchiveFolderContextProvider
    extends
        $FunctionalProvider<
          AsyncValue<ArchiveFolderContext?>,
          ArchiveFolderContext?,
          FutureOr<ArchiveFolderContext?>
        >
    with
        $FutureModifier<ArchiveFolderContext?>,
        $FutureProvider<ArchiveFolderContext?> {
  /// [code] klasörü (klasör listesinden); listede yoksa null (ekran "bulunamadı" der).
  ArchiveFolderContextProvider._({
    required ArchiveFolderContextFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'archiveFolderContextProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archiveFolderContextHash();

  @override
  String toString() {
    return r'archiveFolderContextProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ArchiveFolderContext?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ArchiveFolderContext?> create(Ref ref) {
    final argument = this.argument as String;
    return archiveFolderContext(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArchiveFolderContextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archiveFolderContextHash() =>
    r'28ded1a7c87fba9d6d8c65e162423afdf7794daa';

/// [code] klasörü (klasör listesinden); listede yoksa null (ekran "bulunamadı" der).

final class ArchiveFolderContextFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ArchiveFolderContext?>, String> {
  ArchiveFolderContextFamily._()
    : super(
        retry: null,
        name: r'archiveFolderContextProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [code] klasörü (klasör listesinden); listede yoksa null (ekran "bulunamadı" der).

  ArchiveFolderContextProvider call(String code) =>
      ArchiveFolderContextProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFolderContextProvider';
}

/// Klasörün dosyalı görevleri (`archiveTasks`). Yöneticide uç dönem genelidir: görev
/// kataloğunda departmanı bu klasör olan görevler kalır (katalogda olmayan görev düşer).

@ProviderFor(archiveFolderTasks)
final archiveFolderTasksProvider = ArchiveFolderTasksFamily._();

/// Klasörün dosyalı görevleri (`archiveTasks`). Yöneticide uç dönem genelidir: görev
/// kataloğunda departmanı bu klasör olan görevler kalır (katalogda olmayan görev düşer).

final class ArchiveFolderTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ArchiveTaskSummary>>,
          List<ArchiveTaskSummary>,
          FutureOr<List<ArchiveTaskSummary>>
        >
    with
        $FutureModifier<List<ArchiveTaskSummary>>,
        $FutureProvider<List<ArchiveTaskSummary>> {
  /// Klasörün dosyalı görevleri (`archiveTasks`). Yöneticide uç dönem genelidir: görev
  /// kataloğunda departmanı bu klasör olan görevler kalır (katalogda olmayan görev düşer).
  ArchiveFolderTasksProvider._({
    required ArchiveFolderTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'archiveFolderTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archiveFolderTasksHash();

  @override
  String toString() {
    return r'archiveFolderTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ArchiveTaskSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ArchiveTaskSummary>> create(Ref ref) {
    final argument = this.argument as String;
    return archiveFolderTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArchiveFolderTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archiveFolderTasksHash() =>
    r'f87ceeb3bd133e4d7d3c69719a46c6f538ee65d9';

/// Klasörün dosyalı görevleri (`archiveTasks`). Yöneticide uç dönem genelidir: görev
/// kataloğunda departmanı bu klasör olan görevler kalır (katalogda olmayan görev düşer).

final class ArchiveFolderTasksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ArchiveTaskSummary>>, String> {
  ArchiveFolderTasksFamily._()
    : super(
        retry: null,
        name: r'archiveFolderTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Klasörün dosyalı görevleri (`archiveTasks`). Yöneticide uç dönem genelidir: görev
  /// kataloğunda departmanı bu klasör olan görevler kalır (katalogda olmayan görev düşer).

  ArchiveFolderTasksProvider call(String code) =>
      ArchiveFolderTasksProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFolderTasksProvider';
}

/// Klasörde süzgeç olarak seçilebilen yükleyenler (`archiveUploaders`; yalnız kimlik).

@ProviderFor(archiveFolderUploaders)
final archiveFolderUploadersProvider = ArchiveFolderUploadersFamily._();

/// Klasörde süzgeç olarak seçilebilen yükleyenler (`archiveUploaders`; yalnız kimlik).

final class ArchiveFolderUploadersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Klasörde süzgeç olarak seçilebilen yükleyenler (`archiveUploaders`; yalnız kimlik).
  ArchiveFolderUploadersProvider._({
    required ArchiveFolderUploadersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'archiveFolderUploadersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archiveFolderUploadersHash();

  @override
  String toString() {
    return r'archiveFolderUploadersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return archiveFolderUploaders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ArchiveFolderUploadersProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archiveFolderUploadersHash() =>
    r'0c53114e9a7cef35f957b87c72779da0c0e2325c';

/// Klasörde süzgeç olarak seçilebilen yükleyenler (`archiveUploaders`; yalnız kimlik).

final class ArchiveFolderUploadersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  ArchiveFolderUploadersFamily._()
    : super(
        retry: null,
        name: r'archiveFolderUploadersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Klasörde süzgeç olarak seçilebilen yükleyenler (`archiveUploaders`; yalnız kimlik).

  ArchiveFolderUploadersProvider call(String code) =>
      ArchiveFolderUploadersProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFolderUploadersProvider';
}
