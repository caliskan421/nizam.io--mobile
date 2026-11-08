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

/// Backend'in taşımadığı toplantı olguları (geçici; bkz. [MeetingExtras]). Bağlanmamışsa boş:
/// üretimde hiçbir olgu yok. Bileşim kökü dev'de örnek kaynağı bağlar.

@ProviderFor(meetingExtrasRepository)
final meetingExtrasRepositoryProvider = MeetingExtrasRepositoryProvider._();

/// Backend'in taşımadığı toplantı olguları (geçici; bkz. [MeetingExtras]). Bağlanmamışsa boş:
/// üretimde hiçbir olgu yok. Bileşim kökü dev'de örnek kaynağı bağlar.

final class MeetingExtrasRepositoryProvider
    extends
        $FunctionalProvider<
          MeetingExtrasRepository,
          MeetingExtrasRepository,
          MeetingExtrasRepository
        >
    with $Provider<MeetingExtrasRepository> {
  /// Backend'in taşımadığı toplantı olguları (geçici; bkz. [MeetingExtras]). Bağlanmamışsa boş:
  /// üretimde hiçbir olgu yok. Bileşim kökü dev'de örnek kaynağı bağlar.
  MeetingExtrasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingExtrasRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingExtrasRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeetingExtrasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeetingExtrasRepository create(Ref ref) {
    return meetingExtrasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingExtrasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingExtrasRepository>(value),
    );
  }
}

String _$meetingExtrasRepositoryHash() =>
    r'5bb879534d143fe0d5892740fe4c0e609656fe72';
