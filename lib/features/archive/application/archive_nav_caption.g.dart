// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

@ProviderFor(archiveNavCaption)
final archiveNavCaptionProvider = ArchiveNavCaptionProvider._();

/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

final class ArchiveNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.
  ArchiveNavCaptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveNavCaptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveNavCaptionHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return archiveNavCaption(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$archiveNavCaptionHash() => r'5f2a3414a2aec6ce90a5aa6dd472468940017fe2';
