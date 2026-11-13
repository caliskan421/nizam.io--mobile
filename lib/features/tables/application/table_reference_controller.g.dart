// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_reference_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Referans sütununun aday listesi (tablonun kendi kapsamıyla). Kişi/departman/görev sahip
/// modülün uçlarından ([TableReferenceSources]), tablo referansı aynı alanın tablo
/// listesinden gelir. Dosya iki adımlıdır: görev seçilir ([tableRefFilesProvider]).
/// Ek sütunu bu seçicide yoktur.

@ProviderFor(tableRefCandidates)
final tableRefCandidatesProvider = TableRefCandidatesFamily._();

/// Referans sütununun aday listesi (tablonun kendi kapsamıyla). Kişi/departman/görev sahip
/// modülün uçlarından ([TableReferenceSources]), tablo referansı aynı alanın tablo
/// listesinden gelir. Dosya iki adımlıdır: görev seçilir ([tableRefFilesProvider]).
/// Ek sütunu bu seçicide yoktur.

final class TableRefCandidatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TableRefCandidate>>,
          List<TableRefCandidate>,
          FutureOr<List<TableRefCandidate>>
        >
    with
        $FutureModifier<List<TableRefCandidate>>,
        $FutureProvider<List<TableRefCandidate>> {
  /// Referans sütununun aday listesi (tablonun kendi kapsamıyla). Kişi/departman/görev sahip
  /// modülün uçlarından ([TableReferenceSources]), tablo referansı aynı alanın tablo
  /// listesinden gelir. Dosya iki adımlıdır: görev seçilir ([tableRefFilesProvider]).
  /// Ek sütunu bu seçicide yoktur.
  TableRefCandidatesProvider._({
    required TableRefCandidatesFamily super.from,
    required (String, TableColumnKind) super.argument,
  }) : super(
         retry: null,
         name: r'tableRefCandidatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tableRefCandidatesHash();

  @override
  String toString() {
    return r'tableRefCandidatesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TableRefCandidate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TableRefCandidate>> create(Ref ref) {
    final argument = this.argument as (String, TableColumnKind);
    return tableRefCandidates(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is TableRefCandidatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tableRefCandidatesHash() =>
    r'd786dfe5d12d64943f059566022fbbceb567b026';

/// Referans sütununun aday listesi (tablonun kendi kapsamıyla). Kişi/departman/görev sahip
/// modülün uçlarından ([TableReferenceSources]), tablo referansı aynı alanın tablo
/// listesinden gelir. Dosya iki adımlıdır: görev seçilir ([tableRefFilesProvider]).
/// Ek sütunu bu seçicide yoktur.

final class TableRefCandidatesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TableRefCandidate>>,
          (String, TableColumnKind)
        > {
  TableRefCandidatesFamily._()
    : super(
        retry: null,
        name: r'tableRefCandidatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Referans sütununun aday listesi (tablonun kendi kapsamıyla). Kişi/departman/görev sahip
  /// modülün uçlarından ([TableReferenceSources]), tablo referansı aynı alanın tablo
  /// listesinden gelir. Dosya iki adımlıdır: görev seçilir ([tableRefFilesProvider]).
  /// Ek sütunu bu seçicide yoktur.

  TableRefCandidatesProvider call(String tableId, TableColumnKind kind) =>
      TableRefCandidatesProvider._(argument: (tableId, kind), from: this);

  @override
  String toString() => r'tableRefCandidatesProvider';
}

/// Dosya referansı ikinci adımı: seçilen görevin dosyaları.

@ProviderFor(tableRefFiles)
final tableRefFilesProvider = TableRefFilesFamily._();

/// Dosya referansı ikinci adımı: seçilen görevin dosyaları.

final class TableRefFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TableRefCandidate>>,
          List<TableRefCandidate>,
          FutureOr<List<TableRefCandidate>>
        >
    with
        $FutureModifier<List<TableRefCandidate>>,
        $FutureProvider<List<TableRefCandidate>> {
  /// Dosya referansı ikinci adımı: seçilen görevin dosyaları.
  TableRefFilesProvider._({
    required TableRefFilesFamily super.from,
    required (String, String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tableRefFilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tableRefFilesHash();

  @override
  String toString() {
    return r'tableRefFilesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TableRefCandidate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TableRefCandidate>> create(Ref ref) {
    final argument = this.argument as (String, String, String, String);
    return tableRefFiles(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TableRefFilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tableRefFilesHash() => r'951e3666763c517231e11be7b70219f0158771ea';

/// Dosya referansı ikinci adımı: seçilen görevin dosyaları.

final class TableRefFilesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TableRefCandidate>>,
          (String, String, String, String)
        > {
  TableRefFilesFamily._()
    : super(
        retry: null,
        name: r'tableRefFilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Dosya referansı ikinci adımı: seçilen görevin dosyaları.

  TableRefFilesProvider call(
    String tableId,
    String taskId,
    String taskDepartmentId,
    String taskName,
  ) => TableRefFilesProvider._(
    argument: (tableId, taskId, taskDepartmentId, taskName),
    from: this,
  );

  @override
  String toString() => r'tableRefFilesProvider';
}
