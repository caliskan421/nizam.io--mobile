// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorships_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

@ProviderFor(coordinatorshipsNavCaption)
final coordinatorshipsNavCaptionProvider =
    CoordinatorshipsNavCaptionProvider._();

/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

final class CoordinatorshipsNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.
  CoordinatorshipsNavCaptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coordinatorshipsNavCaptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coordinatorshipsNavCaptionHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return coordinatorshipsNavCaption(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$coordinatorshipsNavCaptionHash() =>
    r'1ca7edf4c1caa25f32735e34a7a40f693c214014';
