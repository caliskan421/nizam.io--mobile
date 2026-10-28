// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde işlem geçmişindeyken görünen mono alt yazı ("38 kayıt"); yüklenmeden null.

@ProviderFor(activityNavCaption)
final activityNavCaptionProvider = ActivityNavCaptionProvider._();

/// Alt menüde işlem geçmişindeyken görünen mono alt yazı ("38 kayıt"); yüklenmeden null.

final class ActivityNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde işlem geçmişindeyken görünen mono alt yazı ("38 kayıt"); yüklenmeden null.
  ActivityNavCaptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityNavCaptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityNavCaptionHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return activityNavCaption(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activityNavCaptionHash() =>
    r'9f46340b67e876a276e4184166ba3017b1630d40';
