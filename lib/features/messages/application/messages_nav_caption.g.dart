// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

@ProviderFor(messagesNavCaption)
final messagesNavCaptionProvider = MessagesNavCaptionProvider._();

/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

final class MessagesNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.
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
    r'3f85c748883b244cd0d0351162ac1d0c4c3eddf0';
