// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_program_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kapsamdaki program (`GET /v1/program`, S2): ana sayfada seçili programın adı BU yanıttan
/// gelir — kapsam başlığının isteğe girdiğinin kanıtı. Seçim yoksa (`null`) istek atılmaz;
/// seçim değişince yeniden okunur. Yeniden yükleme yalnız kullanıcı dokunuşuyla.

@ProviderFor(CurrentProgramController)
final currentProgramControllerProvider = CurrentProgramControllerProvider._();

/// Kapsamdaki program (`GET /v1/program`, S2): ana sayfada seçili programın adı BU yanıttan
/// gelir — kapsam başlığının isteğe girdiğinin kanıtı. Seçim yoksa (`null`) istek atılmaz;
/// seçim değişince yeniden okunur. Yeniden yükleme yalnız kullanıcı dokunuşuyla.
final class CurrentProgramControllerProvider
    extends $AsyncNotifierProvider<CurrentProgramController, Program?> {
  /// Kapsamdaki program (`GET /v1/program`, S2): ana sayfada seçili programın adı BU yanıttan
  /// gelir — kapsam başlığının isteğe girdiğinin kanıtı. Seçim yoksa (`null`) istek atılmaz;
  /// seçim değişince yeniden okunur. Yeniden yükleme yalnız kullanıcı dokunuşuyla.
  CurrentProgramControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProgramControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProgramControllerHash();

  @$internal
  @override
  CurrentProgramController create() => CurrentProgramController();
}

String _$currentProgramControllerHash() =>
    r'057a4498191854265f168f72b90b71eb966d3825';

/// Kapsamdaki program (`GET /v1/program`, S2): ana sayfada seçili programın adı BU yanıttan
/// gelir — kapsam başlığının isteğe girdiğinin kanıtı. Seçim yoksa (`null`) istek atılmaz;
/// seçim değişince yeniden okunur. Yeniden yükleme yalnız kullanıcı dokunuşuyla.

abstract class _$CurrentProgramController extends $AsyncNotifier<Program?> {
  FutureOr<Program?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Program?>, Program?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Program?>, Program?>,
              AsyncValue<Program?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
