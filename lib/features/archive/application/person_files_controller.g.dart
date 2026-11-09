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
    required String super.argument,
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
        '($argument)';
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
    r'21561dc7c79fec97fce0b964a17582faf6aa3d48';

final class PersonFilesControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PersonFilesController,
          AsyncValue<PersonFilesState>,
          PersonFilesState,
          FutureOr<PersonFilesState>,
          String
        > {
  PersonFilesControllerFamily._()
    : super(
        retry: null,
        name: r'personFilesControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonFilesControllerProvider call(String accountId) =>
      PersonFilesControllerProvider._(argument: accountId, from: this);

  @override
  String toString() => r'personFilesControllerProvider';
}

abstract class _$PersonFilesController
    extends $AsyncNotifier<PersonFilesState> {
  late final _$args = ref.$arg as String;
  String get accountId => _$args;

  FutureOr<PersonFilesState> build(String accountId);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
