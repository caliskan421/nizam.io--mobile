// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_team_people.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ortak görev kataloğundan türetilir (katalog yüklenmeden null; kutu o zaman süzgeçsiz açar).

@ProviderFor(homeTeamPeople)
final homeTeamPeopleProvider = HomeTeamPeopleProvider._();

/// Ortak görev kataloğundan türetilir (katalog yüklenmeden null; kutu o zaman süzgeçsiz açar).

final class HomeTeamPeopleProvider
    extends
        $FunctionalProvider<HomeTeamPeople?, HomeTeamPeople?, HomeTeamPeople?>
    with $Provider<HomeTeamPeople?> {
  /// Ortak görev kataloğundan türetilir (katalog yüklenmeden null; kutu o zaman süzgeçsiz açar).
  HomeTeamPeopleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeTeamPeopleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeTeamPeopleHash();

  @$internal
  @override
  $ProviderElement<HomeTeamPeople?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeTeamPeople? create(Ref ref) {
    return homeTeamPeople(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeTeamPeople? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeTeamPeople?>(value),
    );
  }
}

String _$homeTeamPeopleHash() => r'dfb1713d05b75512d87cfe41befb63708fa21e46';
