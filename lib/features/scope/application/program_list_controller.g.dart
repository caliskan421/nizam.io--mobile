// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Program seçim ekranının listesi (`GET /v1/programs`, düz liste + `truncated`). Hata
/// [ApiError]'dır (`program.not_authorized` dahil); yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).

@ProviderFor(ProgramListController)
final programListControllerProvider = ProgramListControllerProvider._();

/// Program seçim ekranının listesi (`GET /v1/programs`, düz liste + `truncated`). Hata
/// [ApiError]'dır (`program.not_authorized` dahil); yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).
final class ProgramListControllerProvider
    extends $AsyncNotifierProvider<ProgramListController, PageSlice<Program>> {
  /// Program seçim ekranının listesi (`GET /v1/programs`, düz liste + `truncated`). Hata
  /// [ApiError]'dır (`program.not_authorized` dahil); yeniden yükleme yalnız kullanıcı
  /// dokunuşuyla (`ref.invalidate`).
  ProgramListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programListControllerHash();

  @$internal
  @override
  ProgramListController create() => ProgramListController();
}

String _$programListControllerHash() =>
    r'70d9d67bf9c9929033f1d9c242d571aaa3a3059c';

/// Program seçim ekranının listesi (`GET /v1/programs`, düz liste + `truncated`). Hata
/// [ApiError]'dır (`program.not_authorized` dahil); yeniden yükleme yalnız kullanıcı
/// dokunuşuyla (`ref.invalidate`).

abstract class _$ProgramListController
    extends $AsyncNotifier<PageSlice<Program>> {
  FutureOr<PageSlice<Program>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PageSlice<Program>>, PageSlice<Program>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PageSlice<Program>>, PageSlice<Program>>,
              AsyncValue<PageSlice<Program>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
