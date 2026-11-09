// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde bu modül etkinken görünen mono alt yazı ("5 okunmamış"); veri yokken null.

@ProviderFor(messagesNavCaption)
final messagesNavCaptionProvider = MessagesNavCaptionProvider._();

/// Alt menüde bu modül etkinken görünen mono alt yazı ("5 okunmamış"); veri yokken null.

final class MessagesNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde bu modül etkinken görünen mono alt yazı ("5 okunmamış"); veri yokken null.
  MessagesNavCaptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagesNavCaptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagesNavCaptionHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return messagesNavCaption(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$messagesNavCaptionHash() =>
    r'a3f94ab20724f20d8a43195fb4ccc37c91575a4b';

/// Tablet rayındaki Mesajlar rozeti: okunmamış ya da anılan sohbet sayısı (prototip
/// `unread || mention`); veri yokken null.

@ProviderFor(messagesNavBadge)
final messagesNavBadgeProvider = MessagesNavBadgeProvider._();

/// Tablet rayındaki Mesajlar rozeti: okunmamış ya da anılan sohbet sayısı (prototip
/// `unread || mention`); veri yokken null.

final class MessagesNavBadgeProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// Tablet rayındaki Mesajlar rozeti: okunmamış ya da anılan sohbet sayısı (prototip
  /// `unread || mention`); veri yokken null.
  MessagesNavBadgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagesNavBadgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagesNavBadgeHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return messagesNavBadge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$messagesNavBadgeHash() => r'fe6cdac9d1e7e06f9dd5d229627de5459a1c1e71';
