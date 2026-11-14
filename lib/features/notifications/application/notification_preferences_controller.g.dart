// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bildirim tercihleri (`GET/PUT /v1/notifications/preferences`; ayarlar ekranı). Değişiklik
/// tek grup için sunucuya yazılır, sunucunun döndürdüğü küme durum olur (iyimser güncelleme
/// yok); uçuştaki yazma varken yeni yazma gönderilmez.

@ProviderFor(NotificationPreferencesController)
final notificationPreferencesControllerProvider =
    NotificationPreferencesControllerProvider._();

/// Bildirim tercihleri (`GET/PUT /v1/notifications/preferences`; ayarlar ekranı). Değişiklik
/// tek grup için sunucuya yazılır, sunucunun döndürdüğü küme durum olur (iyimser güncelleme
/// yok); uçuştaki yazma varken yeni yazma gönderilmez.
final class NotificationPreferencesControllerProvider
    extends
        $AsyncNotifierProvider<
          NotificationPreferencesController,
          NotificationPreferences
        > {
  /// Bildirim tercihleri (`GET/PUT /v1/notifications/preferences`; ayarlar ekranı). Değişiklik
  /// tek grup için sunucuya yazılır, sunucunun döndürdüğü küme durum olur (iyimser güncelleme
  /// yok); uçuştaki yazma varken yeni yazma gönderilmez.
  NotificationPreferencesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPreferencesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$notificationPreferencesControllerHash();

  @$internal
  @override
  NotificationPreferencesController create() =>
      NotificationPreferencesController();
}

String _$notificationPreferencesControllerHash() =>
    r'3495c823f6587fcad756fb50b240d40ec36acd65';

/// Bildirim tercihleri (`GET/PUT /v1/notifications/preferences`; ayarlar ekranı). Değişiklik
/// tek grup için sunucuya yazılır, sunucunun döndürdüğü küme durum olur (iyimser güncelleme
/// yok); uçuştaki yazma varken yeni yazma gönderilmez.

abstract class _$NotificationPreferencesController
    extends $AsyncNotifier<NotificationPreferences> {
  FutureOr<NotificationPreferences> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationPreferences>,
              NotificationPreferences
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationPreferences>,
                NotificationPreferences
              >,
              AsyncValue<NotificationPreferences>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
