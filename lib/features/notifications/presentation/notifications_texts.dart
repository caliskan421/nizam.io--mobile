import 'package:intl/intl.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../domain/app_notification.dart';
import '../domain/notification_groups.dart';

/// Bildirim ekranının metinleri. Sunucu bildirim metni taşımaz: başlık olay türünden gelir.
/// UI metin kaynağı yer tutucu kabul etmediği için sayılı cümleler burada birleşir.
extension NotificationsTexts on AppLocalizations {
  static final _when = DateFormat('d MMM · HH:mm', 'tr');

  /// Satır başlığı (olay türü); tanınmayan tür genel başlıkla gösterilir.
  String notificationTitle(NotificationType t) => switch (t) {
    NotificationType.workItemCreated => uiNotificationsTypeWorkItemCreated,
    NotificationType.workItemTransitioned =>
      uiNotificationsTypeWorkItemTransitioned,
    NotificationType.workItemAssignmentChanged =>
      uiNotificationsTypeWorkItemAssignmentChanged,
    NotificationType.workItemDateChanged =>
      uiNotificationsTypeWorkItemDateChanged,
    NotificationType.workDateChangeRequested =>
      uiNotificationsTypeWorkDateChangeRequested,
    NotificationType.workDateChangeReviewed =>
      uiNotificationsTypeWorkDateChangeReviewed,
    NotificationType.collaborationMessageSent =>
      uiNotificationsTypeCollaborationMessageSent,
    NotificationType.collaborationMeetingCreated =>
      uiNotificationsTypeCollaborationMeetingCreated,
    NotificationType.collaborationMeetingUpdated =>
      uiNotificationsTypeCollaborationMeetingUpdated,
    NotificationType.organizationMembershipAssigned =>
      uiNotificationsTypeMembershipAssigned,
    NotificationType.organizationMembershipRemoved =>
      uiNotificationsTypeMembershipRemoved,
    NotificationType.organizationMembershipRoleChanged =>
      uiNotificationsTypeMembershipRoleChanged,
    NotificationType.programTransferCompleted =>
      uiNotificationsTypeProgramTransferCompleted,
    NotificationType.unknown => uiNotificationsTypeUnknown,
  };

  /// Liste başlığı.
  String notificationGroupLabel(NotificationGroup g) => switch (g) {
    NotificationGroup.tasks => uiNotificationsGroupTasks,
    NotificationGroup.dateRequests => uiNotificationsGroupDateRequests,
    NotificationGroup.meetings => uiNotificationsGroupMeetings,
    NotificationGroup.team => uiNotificationsGroupTeam,
    NotificationGroup.other => uiNotificationsGroupOther,
  };

  /// "12 Kas · 14:05" (yerel).
  String notificationWhen(DateTime at) => _when.format(at.toLocal());

  /// Zil etiketi: "Bildirimler · 3 okunmamış"; okunmamış yoksa ya da bilinmiyorsa "Bildirimler".
  String notificationBellLabel(int? unread) => unread == null || unread <= 0
      ? uiNotificationsTitle
      : '$uiNotificationsTitle · $unread $uiNotificationsUnreadTail';
}
