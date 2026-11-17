// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_files_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PersonFilesController)
final personFilesControllerProvider = PersonFilesControllerFamily._();

final class PersonFilesControllerProvider
    extends $AsyncNotifierProvider<PersonFilesController, PersonFilesState> {
  PersonFilesControllerProvider._({
    required PersonFilesControllerFamily super.from,
    required (String, {bool filterArchive}) super.argument,
  }) : super(
         retry: null,
         name: r'personFilesControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personFilesControllerHash();

  @override
  String toString() {
    return r'personFilesControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PersonFilesController create() => PersonFilesController();

  @override
  bool operator ==(Object other) {
    return other is PersonFilesControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personFilesControllerHash() =>
    r'e3852387ce145dcbeb278d2f0859b65b37ef335c';

final class PersonFilesControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PersonFilesController,
          AsyncValue<PersonFilesState>,
          PersonFilesState,
          FutureOr<PersonFilesState>,
          (String, {bool filterArchive})
        > {
  PersonFilesControllerFamily._()
    : super(
        retry: null,
        name: r'personFilesControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonFilesControllerProvider call(
    String accountId, {
    bool filterArchive = false,
  }) => PersonFilesControllerProvider._(
    argument: (accountId, filterArchive: filterArchive),
    from: this,
  );

  @override
  String toString() => r'personFilesControllerProvider';
}

abstract class _$PersonFilesController
    extends $AsyncNotifier<PersonFilesState> {
  late final _$args = ref.$arg as (String, {bool filterArchive});
  String get accountId => _$args.$1;
  bool get filterArchive => _$args.filterArchive;

  FutureOr<PersonFilesState> build(
    String accountId, {
    bool filterArchive = false,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PersonFilesState>, PersonFilesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PersonFilesState>, PersonFilesState>,
              AsyncValue<PersonFilesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, filterArchive: _$args.filterArchive),
    );
  }
}
