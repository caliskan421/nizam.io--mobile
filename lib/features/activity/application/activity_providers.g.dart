// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: işlem geçmişinin kaynağı (`activity_module.dart`'ta bağlanır; bugün geliştirme örneği).

@ProviderFor(activityLogRepository)
final activityLogRepositoryProvider = ActivityLogRepositoryProvider._();

/// PORT: işlem geçmişinin kaynağı (`activity_module.dart`'ta bağlanır; bugün geliştirme örneği).

final class ActivityLogRepositoryProvider
    extends
        $FunctionalProvider<
          ActivityLogRepository,
          ActivityLogRepository,
          ActivityLogRepository
        >
    with $Provider<ActivityLogRepository> {
  /// PORT: işlem geçmişinin kaynağı (`activity_module.dart`'ta bağlanır; bugün geliştirme örneği).
  ActivityLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityLogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActivityLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivityLogRepository create(Ref ref) {
    return activityLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityLogRepository>(value),
    );
  }
}

String _$activityLogRepositoryHash() =>
    r'66caae28d4e9867725d23d15eb3a0037368e9f79';
