// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bir toplantının görüntülü görüşmesi: katılım token'ı (`joinConference`) → adres doğrulama
/// ([conferenceUrl]) → oda bağı ([ConferenceLink]) → mikrofon ve kamera. Token yalnız bağa
/// verilir; durumda, log'da ve hata metninde yoktur. Kopan bağlantıyı sağlayıcı kendisi yeniden
/// kurar (durum "yeniden bağlanıyor"); kalıcı kopuş nedeniyle "bitti"ye geçer. Oda ekran
/// kapansa da sürer (mini pencere, [ActiveConference]); yalnız ayrılınca, bitirilince ya da
/// sağlayıcı kabı atılınca (oturum kapanışı) kapanır. Aynı anda tek oda: başka toplantıya
/// katılmak öncekinden ayrılır.

@ProviderFor(ConferenceController)
final conferenceControllerProvider = ConferenceControllerFamily._();

/// Bir toplantının görüntülü görüşmesi: katılım token'ı (`joinConference`) → adres doğrulama
/// ([conferenceUrl]) → oda bağı ([ConferenceLink]) → mikrofon ve kamera. Token yalnız bağa
/// verilir; durumda, log'da ve hata metninde yoktur. Kopan bağlantıyı sağlayıcı kendisi yeniden
/// kurar (durum "yeniden bağlanıyor"); kalıcı kopuş nedeniyle "bitti"ye geçer. Oda ekran
/// kapansa da sürer (mini pencere, [ActiveConference]); yalnız ayrılınca, bitirilince ya da
/// sağlayıcı kabı atılınca (oturum kapanışı) kapanır. Aynı anda tek oda: başka toplantıya
/// katılmak öncekinden ayrılır.
final class ConferenceControllerProvider
    extends $NotifierProvider<ConferenceController, ConferenceView> {
  /// Bir toplantının görüntülü görüşmesi: katılım token'ı (`joinConference`) → adres doğrulama
  /// ([conferenceUrl]) → oda bağı ([ConferenceLink]) → mikrofon ve kamera. Token yalnız bağa
  /// verilir; durumda, log'da ve hata metninde yoktur. Kopan bağlantıyı sağlayıcı kendisi yeniden
  /// kurar (durum "yeniden bağlanıyor"); kalıcı kopuş nedeniyle "bitti"ye geçer. Oda ekran
  /// kapansa da sürer (mini pencere, [ActiveConference]); yalnız ayrılınca, bitirilince ya da
  /// sağlayıcı kabı atılınca (oturum kapanışı) kapanır. Aynı anda tek oda: başka toplantıya
  /// katılmak öncekinden ayrılır.
  ConferenceControllerProvider._({
    required ConferenceControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'conferenceControllerProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conferenceControllerHash();

  @override
  String toString() {
    return r'conferenceControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ConferenceController create() => ConferenceController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConferenceView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConferenceView>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConferenceControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conferenceControllerHash() =>
    r'0c1ec13feaf6c6e918b5bd68ec2276bb3c0f7d7a';

/// Bir toplantının görüntülü görüşmesi: katılım token'ı (`joinConference`) → adres doğrulama
/// ([conferenceUrl]) → oda bağı ([ConferenceLink]) → mikrofon ve kamera. Token yalnız bağa
/// verilir; durumda, log'da ve hata metninde yoktur. Kopan bağlantıyı sağlayıcı kendisi yeniden
/// kurar (durum "yeniden bağlanıyor"); kalıcı kopuş nedeniyle "bitti"ye geçer. Oda ekran
/// kapansa da sürer (mini pencere, [ActiveConference]); yalnız ayrılınca, bitirilince ya da
/// sağlayıcı kabı atılınca (oturum kapanışı) kapanır. Aynı anda tek oda: başka toplantıya
/// katılmak öncekinden ayrılır.

final class ConferenceControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ConferenceController,
          ConferenceView,
          ConferenceView,
          ConferenceView,
          String
        > {
  ConferenceControllerFamily._()
    : super(
        retry: null,
        name: r'conferenceControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// Bir toplantının görüntülü görüşmesi: katılım token'ı (`joinConference`) → adres doğrulama
  /// ([conferenceUrl]) → oda bağı ([ConferenceLink]) → mikrofon ve kamera. Token yalnız bağa
  /// verilir; durumda, log'da ve hata metninde yoktur. Kopan bağlantıyı sağlayıcı kendisi yeniden
  /// kurar (durum "yeniden bağlanıyor"); kalıcı kopuş nedeniyle "bitti"ye geçer. Oda ekran
  /// kapansa da sürer (mini pencere, [ActiveConference]); yalnız ayrılınca, bitirilince ya da
  /// sağlayıcı kabı atılınca (oturum kapanışı) kapanır. Aynı anda tek oda: başka toplantıya
  /// katılmak öncekinden ayrılır.

  ConferenceControllerProvider call(String id) =>
      ConferenceControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'conferenceControllerProvider';
}

/// Bir toplantının görüntülü görüşmesi: katılım token'ı (`joinConference`) → adres doğrulama
/// ([conferenceUrl]) → oda bağı ([ConferenceLink]) → mikrofon ve kamera. Token yalnız bağa
/// verilir; durumda, log'da ve hata metninde yoktur. Kopan bağlantıyı sağlayıcı kendisi yeniden
/// kurar (durum "yeniden bağlanıyor"); kalıcı kopuş nedeniyle "bitti"ye geçer. Oda ekran
/// kapansa da sürer (mini pencere, [ActiveConference]); yalnız ayrılınca, bitirilince ya da
/// sağlayıcı kabı atılınca (oturum kapanışı) kapanır. Aynı anda tek oda: başka toplantıya
/// katılmak öncekinden ayrılır.

abstract class _$ConferenceController extends $Notifier<ConferenceView> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  ConferenceView build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ConferenceView, ConferenceView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConferenceView, ConferenceView>,
              ConferenceView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
