import 'package:meta/meta.dart';

import '../../../core/domain/page_slice.dart';

/// Bildirimin kaynak olay türü (`Notification.type`; liste `docs/api/events.md`'deki
/// "kuyruğa → notifications: bildirim" satırlarıdır). Sunucu metin taşımaz: başlık bu türden
/// ARB anahtarıyla üretilir. Yeni tür [unknown] olur (uygulamayı kırmaz).
enum NotificationType {
  workItemCreated('work.item.created'),
  workItemTransitioned('work.item.transitioned'),
  workItemAssignmentChanged('work.item.assignment_changed'),
  workItemDateChanged('work.item.date_changed'),
  workDateChangeRequested('work.date_change.requested'),
  workDateChangeReviewed('work.date_change.reviewed'),
  collaborationMessageSent('collaboration.message.sent'),
  collaborationMeetingCreated('collaboration.meeting.created'),
  collaborationMeetingUpdated('collaboration.meeting.updated'),
  organizationMembershipAssigned('organization.membership.assigned'),
  organizationMembershipRemoved('organization.membership.removed'),
  organizationMembershipRoleChanged('organization.membership.role_changed'),
  programTransferCompleted('program.transfer.completed'),
  unknown(null);

  const NotificationType(this.wire);

  /// Sunucudaki olay türü adı; [unknown] için `null`.
  final String? wire;

  /// [wire] değerinden tür; `null` ya da tanınmayan değer [unknown].
  static NotificationType fromWire(String? wire) {
    if (wire == null) return unknown;
    for (final t in values) {
      if (t.wire == wire) return t;
    }
    return unknown;
  }
}

/// Bildirimin konusu (`NotificationSubject`). [kind] değer kümesi sözleşmede tanımsızdır;
/// opak dize olarak taşınır (gezinme kararı entegrasyonda).
@immutable
final class NotificationSubject {
  const NotificationSubject({required this.kind, required this.id});

  final String kind;
  final String id;

  @override
  bool operator ==(Object other) =>
      other is NotificationSubject && other.kind == kind && other.id == id;

  @override
  int get hashCode => Object.hash(kind, id);
}

/// Uygulama içi bildirim (`Notification`). Metin, aktör ve program kimliği taşımaz (S1).
@immutable
final class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.rawType,
    required this.subject,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final NotificationType type;

  /// Sunucunun gönderdiği tür dizgesi ([type] [NotificationType.unknown] iken tanı için).
  final String rawType;
  final NotificationSubject subject;
  final bool isRead;
  final DateTime createdAt;
}

/// Çan listesinin bir sayfası (`NotificationList`): satırlar + okunmamış toplamı.
@immutable
final class NotificationFeed {
  const NotificationFeed({required this.page, required this.unreadCount});

  final PageSlice<AppNotification> page;

  /// Çağıranın bütün okunmamış bildirimleri (sayfadan bağımsız).
  final int unreadCount;
}

/// Web push açık anahtarı (`PushPublicKey`). `enabled=false` hata değildir.
@immutable
final class PushPublicKeyInfo {
  const PushPublicKeyInfo({required this.publicKey, required this.enabled});

  final String publicKey;
  final bool enabled;
}

/// Cihaz aboneliğinin durumu (`TargetResult.status`; sunucu: `active`, `dropped`).
enum PushTargetStatus { active, dropped, unknown }

/// Abonelik kaydı sonucu (`TargetResult`).
@immutable
final class PushTarget {
  const PushTarget({required this.id, required this.status});

  final String id;
  final PushTargetStatus status;
}
