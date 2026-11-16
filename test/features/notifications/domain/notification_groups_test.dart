// Bildirim gruplama (iPad 28): tür → başlık, başlık sırası sabit, art arda aynı tür + konu
// birleşir ("×N"), araya başka konu girince yeni satır; okunmamış kimlikleri.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/notifications/domain/app_notification.dart';
import 'package:nizamio/features/notifications/domain/notification_groups.dart';

AppNotification _n(
  String id,
  NotificationType t, {
  String subject = 'w1',
  bool read = false,
}) => AppNotification(
  id: id,
  type: t,
  rawType: t.wire ?? 'x',
  subject: NotificationSubject(kind: 'work_item', id: subject),
  isRead: read,
  createdAt: DateTime(2026, 11, 14),
);

void main() {
  test('tür → başlık', () {
    expect(
      notificationGroupOf(NotificationType.workItemTransitioned),
      NotificationGroup.tasks,
    );
    expect(
      notificationGroupOf(NotificationType.workDateChangeReviewed),
      NotificationGroup.dateRequests,
    );
    expect(
      notificationGroupOf(NotificationType.collaborationMeetingUpdated),
      NotificationGroup.meetings,
    );
    expect(
      notificationGroupOf(NotificationType.programTransferCompleted),
      NotificationGroup.team,
    );
    expect(
      notificationGroupOf(NotificationType.unknown),
      NotificationGroup.other,
    );
  });

  test('başlıklar sabit sırada; art arda aynı olay birleşir', () {
    const tr = NotificationType.workItemTransitioned;
    final sections = groupNotifications([
      _n('m1', NotificationType.collaborationMeetingCreated, subject: 'm'),
      _n('a', tr),
      _n('b', tr, read: true),
      _n('c', tr),
      _n('d', tr, subject: 'w2'),
      _n('e', tr),
      _n('r1', NotificationType.workDateChangeRequested),
    ]);
    expect(sections.map((s) => s.group), [
      NotificationGroup.tasks,
      NotificationGroup.dateRequests,
      NotificationGroup.meetings,
    ]);
    final tasks = sections.first.bundles;
    expect(tasks.map((b) => b.count), [3, 1, 1]);
    expect(tasks.first.latest.id, 'a');
    expect(tasks.first.unreadIds, ['a', 'c']);
    expect(tasks.first.hasUnread, isTrue);
  });

  test('farklı tür aynı konuda birleşmez; boş liste boş', () {
    final sections = groupNotifications([
      _n('a', NotificationType.workItemCreated),
      _n('b', NotificationType.workItemTransitioned),
    ]);
    expect(sections.single.bundles.map((b) => b.count), [1, 1]);
    expect(groupNotifications(const []), isEmpty);
  });
}
