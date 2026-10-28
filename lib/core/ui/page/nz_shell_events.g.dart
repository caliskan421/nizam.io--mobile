// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nz_shell_events.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShellReselectEvents)
final shellReselectEventsProvider = ShellReselectEventsProvider._();

final class ShellReselectEventsProvider
    extends $NotifierProvider<ShellReselectEvents, ShellReselect?> {
  ShellReselectEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shellReselectEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shellReselectEventsHash();

  @$internal
  @override
  ShellReselectEvents create() => ShellReselectEvents();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShellReselect? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShellReselect?>(value),
    );
  }
}

String _$shellReselectEventsHash() =>
    r'27e86ab91797098d735604e43ad54580873c61e6';

abstract class _$ShellReselectEvents extends $Notifier<ShellReselect?> {
  ShellReselect? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ShellReselect?, ShellReselect?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShellReselect?, ShellReselect?>,
              ShellReselect?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
