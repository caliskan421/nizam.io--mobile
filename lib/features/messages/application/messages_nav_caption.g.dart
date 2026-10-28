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
    r'a51c3cf0d57d6f50bdfbad01bb68ab7f9c9576fe';
