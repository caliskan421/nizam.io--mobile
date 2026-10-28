// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İşlem geçmişi kayıtları (yeniden yükleme yalnız dokunuşla).

@ProviderFor(ActivityLogController)
final activityLogControllerProvider = ActivityLogControllerProvider._();

/// İşlem geçmişi kayıtları (yeniden yükleme yalnız dokunuşla).
final class ActivityLogControllerProvider
    extends $AsyncNotifierProvider<ActivityLogController, ActivityLog> {
  /// İşlem geçmişi kayıtları (yeniden yükleme yalnız dokunuşla).
  ActivityLogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityLogControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityLogControllerHash();

  @$internal
  @override
  ActivityLogController create() => ActivityLogController();
}

String _$activityLogControllerHash() =>
    r'e93744e8f4242e8c17ced490211635cacdf4d1dd';

/// İşlem geçmişi kayıtları (yeniden yükleme yalnız dokunuşla).

abstract class _$ActivityLogController extends $AsyncNotifier<ActivityLog> {
  FutureOr<ActivityLog> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ActivityLog>, ActivityLog>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ActivityLog>, ActivityLog>,
              AsyncValue<ActivityLog>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
