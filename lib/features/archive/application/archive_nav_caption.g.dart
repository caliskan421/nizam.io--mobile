// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde bu modül etkinken görünen mono alt yazı ("227 dosya"); veri yokken null.

@ProviderFor(archiveNavCaption)
final archiveNavCaptionProvider = ArchiveNavCaptionProvider._();

/// Alt menüde bu modül etkinken görünen mono alt yazı ("227 dosya"); veri yokken null.

final class ArchiveNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde bu modül etkinken görünen mono alt yazı ("227 dosya"); veri yokken null.
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

String _$archiveNavCaptionHash() => r'5d85eda00161901cfc75c4bc9bb96127dc7c13a2';
