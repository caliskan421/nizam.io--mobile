/// notifications özelliğinin açık yüzü: zil (okunmamış sayısı, bildirim listesi). Başka
/// feature'lar ve `app/` yalnız bu dosyayı import eder (sınır kuralı B3).
library;

export 'application/notifications_controller.dart'
    show notificationUnreadControllerProvider;
export 'presentation/notification_preferences_card.dart'
    show NotificationPreferencesCard;
export 'presentation/notifications_sheet.dart'
    show showNotifications, watchNotificationBell;
