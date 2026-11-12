// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Zil rozeti: okunmamış bildirim sayısı (`countUnreadNotifications`). Kabuğun üst çubuğu ve
/// tablet rayı izledikçe yaşar. Zamanlayıcıyla yoklama YOK (v1: push yok, arka planda iş yok):
/// uygulama ön plana dönünce (`ForegroundRefresh`) ve bildirim listesi kapanınca [refresh];
/// liste ve yazma uçları sayıyı [NotificationsController] üzerinden günceller.

@ProviderFor(NotificationUnreadController)
final notificationUnreadControllerProvider =
    NotificationUnreadControllerProvider._();

/// Zil rozeti: okunmamış bildirim sayısı (`countUnreadNotifications`). Kabuğun üst çubuğu ve
/// tablet rayı izledikçe yaşar. Zamanlayıcıyla yoklama YOK (v1: push yok, arka planda iş yok):
/// uygulama ön plana dönünce (`ForegroundRefresh`) ve bildirim listesi kapanınca [refresh];
/// liste ve yazma uçları sayıyı [NotificationsController] üzerinden günceller.
final class NotificationUnreadControllerProvider
    extends $AsyncNotifierProvider<NotificationUnreadController, int> {
  /// Zil rozeti: okunmamış bildirim sayısı (`countUnreadNotifications`). Kabuğun üst çubuğu ve
  /// tablet rayı izledikçe yaşar. Zamanlayıcıyla yoklama YOK (v1: push yok, arka planda iş yok):
  /// uygulama ön plana dönünce (`ForegroundRefresh`) ve bildirim listesi kapanınca [refresh];
  /// liste ve yazma uçları sayıyı [NotificationsController] üzerinden günceller.
  NotificationUnreadControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationUnreadControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationUnreadControllerHash();

  @$internal
  @override
  NotificationUnreadController create() => NotificationUnreadController();
}

String _$notificationUnreadControllerHash() =>
    r'7e1fed1b9d96fd0e83ba2a22600a464837679958';

/// Zil rozeti: okunmamış bildirim sayısı (`countUnreadNotifications`). Kabuğun üst çubuğu ve
/// tablet rayı izledikçe yaşar. Zamanlayıcıyla yoklama YOK (v1: push yok, arka planda iş yok):
/// uygulama ön plana dönünce (`ForegroundRefresh`) ve bildirim listesi kapanınca [refresh];
/// liste ve yazma uçları sayıyı [NotificationsController] üzerinden günceller.

abstract class _$NotificationUnreadController extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Bildirim listesi (`listNotifications`, en yeni önce, imleçli). Çan açıkken yaşar; her
/// açılışta ilk sayfa yeniden okunur. Her liste yanıtının `unread_count`'u ve başarılı yazma
/// (tek okundu, tümü okundu) zil rozetine ([NotificationUnreadController]) yansır: sayaç ve
/// satırlar aynı anda tutarlıdır. Otomatik yeniden deneme YOK (A3).

@ProviderFor(NotificationsController)
final notificationsControllerProvider = NotificationsControllerProvider._();

/// Bildirim listesi (`listNotifications`, en yeni önce, imleçli). Çan açıkken yaşar; her
/// açılışta ilk sayfa yeniden okunur. Her liste yanıtının `unread_count`'u ve başarılı yazma
/// (tek okundu, tümü okundu) zil rozetine ([NotificationUnreadController]) yansır: sayaç ve
/// satırlar aynı anda tutarlıdır. Otomatik yeniden deneme YOK (A3).
final class NotificationsControllerProvider
    extends $AsyncNotifierProvider<NotificationsController, NotificationsView> {
  /// Bildirim listesi (`listNotifications`, en yeni önce, imleçli). Çan açıkken yaşar; her
  /// açılışta ilk sayfa yeniden okunur. Her liste yanıtının `unread_count`'u ve başarılı yazma
  /// (tek okundu, tümü okundu) zil rozetine ([NotificationUnreadController]) yansır: sayaç ve
  /// satırlar aynı anda tutarlıdır. Otomatik yeniden deneme YOK (A3).
  NotificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsControllerHash();

  @$internal
  @override
  NotificationsController create() => NotificationsController();
}

String _$notificationsControllerHash() =>
    r'347e6a6811a573195c62c164f12c0e6eed90e8ad';

/// Bildirim listesi (`listNotifications`, en yeni önce, imleçli). Çan açıkken yaşar; her
/// açılışta ilk sayfa yeniden okunur. Her liste yanıtının `unread_count`'u ve başarılı yazma
/// (tek okundu, tümü okundu) zil rozetine ([NotificationUnreadController]) yansır: sayaç ve
/// satırlar aynı anda tutarlıdır. Otomatik yeniden deneme YOK (A3).

abstract class _$NotificationsController
    extends $AsyncNotifier<NotificationsView> {
  FutureOr<NotificationsView> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<NotificationsView>, NotificationsView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NotificationsView>, NotificationsView>,
              AsyncValue<NotificationsView>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
