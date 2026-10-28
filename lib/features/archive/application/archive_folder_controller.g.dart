// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_folder_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum (ekran kapanınca sıfırlanır).

@ProviderFor(ArchiveFolderController)
final archiveFolderControllerProvider = ArchiveFolderControllerFamily._();

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum (ekran kapanınca sıfırlanır).
final class ArchiveFolderControllerProvider
    extends $NotifierProvider<ArchiveFolderController, ArchiveFolderViewState> {
  /// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum (ekran kapanınca sıfırlanır).
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
    r'547c8553913a831828f71ff633749f7f032b6f33';

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum (ekran kapanınca sıfırlanır).

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

  /// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum (ekran kapanınca sıfırlanır).

  ArchiveFolderControllerProvider call(String code) =>
      ArchiveFolderControllerProvider._(argument: code, from: this);

  @override
  String toString() => r'archiveFolderControllerProvider';
}

/// Klasör ayrıntısı komutları; klasör kodu başına ayrı durum (ekran kapanınca sıfırlanır).

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
