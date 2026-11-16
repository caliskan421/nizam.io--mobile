/// Bildirim tercih grubu (sunucu `NotificationPreference.group`; NOTIFICATIONS-K36): olay türü
/// önekinden türer (work → görev, collaboration/meetings → toplantı, mesaj olayları → mesaj,
/// diğer → sistem). Sessize alınan grubun olayı dış kanala (web push, FCM) gitmez; uygulama içi
/// kayıt yine yazılır.
enum NotificationPrefGroup { gorev, mesaj, toplanti, sistem }

/// Grup → sessize alındı mı (`push_muted`). Sunucunun dönmediği grup açık sayılır.
typedef NotificationPreferences = Map<NotificationPrefGroup, bool>;
