// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_nav_caption.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

@ProviderFor(tasksNavCaption)
final tasksNavCaptionProvider = TasksNavCaptionProvider._();

/// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.

final class TasksNavCaptionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Alt menüde bu modül etkinken görünen mono alt yazı (ör. "76 görev"); null → yok.
  TasksNavCaptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksNavCaptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksNavCaptionHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return tasksNavCaption(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$tasksNavCaptionHash() => r'2d13508708aec13808342c653d1a25b5467b88a4';
