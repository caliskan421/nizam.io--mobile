// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// PORT: toplantı uçlarının kaynağı (`meetings_module.dart`'ta sunucu gerçekleştirmesi bağlanır).

@ProviderFor(meetingsRepository)
final meetingsRepositoryProvider = MeetingsRepositoryProvider._();

/// PORT: toplantı uçlarının kaynağı (`meetings_module.dart`'ta sunucu gerçekleştirmesi bağlanır).

final class MeetingsRepositoryProvider
    extends
        $FunctionalProvider<
          MeetingsRepository,
          MeetingsRepository,
          MeetingsRepository
        >
    with $Provider<MeetingsRepository> {
  /// PORT: toplantı uçlarının kaynağı (`meetings_module.dart`'ta sunucu gerçekleştirmesi bağlanır).
  MeetingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeetingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeetingsRepository create(Ref ref) {
    return meetingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingsRepository>(value),
    );
  }
}

String _$meetingsRepositoryHash() =>
    r'4260dd898147c05ee71795a937b79e18b06a815a';
