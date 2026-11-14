import 'package:meta/meta.dart';

import 'app_notification.dart';

/// Bildirim listesinin başlıkları (istemci tarafı gruplama; iPad 28). Sıra ekrandaki sıradır.
enum NotificationGroup { tasks, dateRequests, meetings, team, other }

/// Olay türünün başlığı: görev olayları → Görevler, tarih talebi → Tarih talepleri,
/// toplantı/mesaj → Toplantılar, üyelik ve program aktarımı → Ekip, bilinmeyen → Diğer.
NotificationGroup notificationGroupOf(NotificationType t) => switch (t) {
  NotificationType.workItemCreated ||
  NotificationType.workItemTransitioned ||
  NotificationType.workItemAssignmentChanged ||
  NotificationType.workItemDateChanged ||
  NotificationType.workTaskReminder => NotificationGroup.tasks,
  NotificationType.workDateChangeRequested ||
  NotificationType.workDateChangeReviewed => NotificationGroup.dateRequests,
  NotificationType.collaborationMessageSent ||
  NotificationType.collaborationMeetingCreated ||
  NotificationType.collaborationMeetingUpdated => NotificationGroup.meetings,
  NotificationType.organizationMembershipAssigned ||
  NotificationType.organizationMembershipRemoved ||
  NotificationType.organizationMembershipRoleChanged ||
  NotificationType.programTransferCompleted => NotificationGroup.team,
  NotificationType.unknown => NotificationGroup.other,
};

/// Art arda gelen aynı olay (aynı tür ve aynı konu) tek satır: [latest] en yenisi, [items]
/// birleşenlerin hepsi (en yeni önce). Ekranda "×N".
@immutable
final class NotificationBundle {
  NotificationBundle(List<AppNotification> items)
    : assert(items.isNotEmpty),
      items = List.unmodifiable(items);

  final List<AppNotification> items;

  AppNotification get latest => items.first;
  int get count => items.length;
  bool get hasUnread => items.any((n) => !n.isRead);

  /// Okunmamış kayıtların kimlikleri (dokunuşta hepsi okundu yapılır).
  List<String> get unreadIds => [
    for (final n in items)
      if (!n.isRead) n.id,
  ];
}

/// Bir başlığın satırları.
@immutable
final class NotificationSection {
  NotificationSection(this.group, List<NotificationBundle> bundles)
    : bundles = List.unmodifiable(bundles);

  final NotificationGroup group;
  final List<NotificationBundle> bundles;
}

/// [items]'ı (en yeni önce) başlıklara ayırır; her başlıkta liste sırası korunur ve art arda
/// aynı tür + aynı konudaki kayıtlar birleşir. Boş başlık dönmez; başlık sırası
/// [NotificationGroup] sırasıdır.
List<NotificationSection> groupNotifications(List<AppNotification> items) {
  final byGroup = <NotificationGroup, List<List<AppNotification>>>{};
  for (final n in items) {
    final runs = byGroup.putIfAbsent(notificationGroupOf(n.type), () => []);
    final last = runs.isEmpty ? null : runs.last.first;
    if (last != null && last.type == n.type && last.subject == n.subject) {
      runs.last.add(n);
    } else {
      runs.add([n]);
    }
  }
  return [
    for (final g in NotificationGroup.values)
      if (byGroup[g] case final runs?)
        NotificationSection(g, [for (final r in runs) NotificationBundle(r)]),
  ];
}
