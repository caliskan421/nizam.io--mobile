// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetings_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde Toplantılar etkinken görünen mono alt yazı ("11 yaklaşan"); liste yüklenmeden null.

@ProviderFor(meetingsNavCaption)
final meetingsNavCaptionProvider = MeetingsNavCaptionProvider._();

/// Alt menüde Toplantılar etkinken görünen mono alt yazı ("11 yaklaşan"); liste yüklenmeden null.

final class MeetingsNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde Toplantılar etkinken görünen mono alt yazı ("11 yaklaşan"); liste yüklenmeden null.
  MeetingsNavCaptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingsNavCaptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingsNavCaptionHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return meetingsNavCaption(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$meetingsNavCaptionHash() =>
    r'782a99a139693164d0d5dd0bc13aa23a807ab75c';
