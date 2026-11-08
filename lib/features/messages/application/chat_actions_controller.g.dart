// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_actions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
/// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
/// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
/// istek gitmez (yazma kovası 60/dk). Hata önceki (sunucuda doğrulanmış) duruma geri alır ve
/// dokunuşun Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
/// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.

@ProviderFor(ChatActionsController)
final chatActionsControllerProvider = ChatActionsControllerFamily._();

/// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
/// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
/// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
/// istek gitmez (yazma kovası 60/dk). Hata önceki (sunucuda doğrulanmış) duruma geri alır ve
/// dokunuşun Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
/// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.
final class ChatActionsControllerProvider
    extends $NotifierProvider<ChatActionsController, int> {
  /// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
  /// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
  /// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
  /// istek gitmez (yazma kovası 60/dk). Hata önceki (sunucuda doğrulanmış) duruma geri alır ve
  /// dokunuşun Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
  /// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.
  ChatActionsControllerProvider._({
    required ChatActionsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatActionsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatActionsControllerHash();

  @override
  String toString() {
    return r'chatActionsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatActionsController create() => ChatActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatActionsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatActionsControllerHash() =>
    r'25f2b1ecbba572995c0181923315069b6ff69b7a';

/// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
/// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
/// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
/// istek gitmez (yazma kovası 60/dk). Hata önceki (sunucuda doğrulanmış) duruma geri alır ve
/// dokunuşun Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
/// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.

final class ChatActionsControllerFamily extends $Family
    with $ClassFamilyOverride<ChatActionsController, int, int, int, String> {
  ChatActionsControllerFamily._()
    : super(
        retry: null,
        name: r'chatActionsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
  /// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
  /// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
  /// istek gitmez (yazma kovası 60/dk). Hata önceki (sunucuda doğrulanmış) duruma geri alır ve
  /// dokunuşun Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
  /// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.

  ChatActionsControllerProvider call(String chatId) =>
      ChatActionsControllerProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatActionsControllerProvider';
}

/// Mesaj eylemleri (istemci akışları §10.10): tepki, oy, sabitleme, anket bitirme ve indirmeler.
/// Tepki ve oy iyimser uygulanır; aynı mesajdaki ardışık dokunuşlar [settle] süresince
/// birleştirilip TEK istekte (son istenen durum) gider — istenen durum sunucudakiyle aynıysa
/// istek gitmez (yazma kovası 60/dk). Hata önceki (sunucuda doğrulanmış) duruma geri alır ve
/// dokunuşun Future'ı hatayla biter. Sabitleme mesaj başına tek istek; sonuçta şerit yeniden
/// okunur. Otomatik yeniden deneme yoktur. Durum: uçuştaki istek sayısı.

abstract class _$ChatActionsController extends $Notifier<int> {
  late final _$args = ref.$arg as String;
  String get chatId => _$args;

  int build(String chatId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
