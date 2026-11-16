import '../../../core/i18n/generated/app_localizations.dart';
import '../domain/activity_log.dart';

/// Eylem kodunun görünen adı (istemci sözlüğü; AUDIT-K10): `modül.konu.eylem` →
/// "Konu eylem" ("Görev oluşturuldu"). Sözlükte olmayan konu ya da eylem → ham kod.
/// Kodsuz kayıtta (hazır metin) [ActivityEntry.action]; reddedilen girişime "· başarısız".
extension ActivityActionLabel on AppLocalizations {
  String activityAction(ActivityEntry e) {
    final code = e.actionCode;
    if (code == null) return e.action;
    final parts = code.split('.');
    final noun = parts.length == 3 ? _activityNoun(parts[1]) : null;
    final verb = parts.length == 3 ? _activityVerb(parts[2]) : null;
    final text = noun == null || verb == null ? code : '$noun $verb';
    return e.failed ? '$text · $uiActivityFailed' : text;
  }

  String? _activityNoun(String s) => switch (s) {
    'item' => uiActivityNItem,
    'task' => uiActivityNTask,
    'subtask' => uiActivityNSubtask,
    'note' => uiActivityNNote,
    'dependency' => uiActivityNDependency,
    'date_change' => uiActivityNDateChange,
    'completion' => uiActivityNCompletion,
    'end_date' => uiActivityNEndDate,
    'file' => uiActivityNFile,
    'meeting' => uiActivityNMeeting,
    'agenda' => uiActivityNAgenda,
    'conference' => uiActivityNConference,
    'participant' => uiActivityNParticipant,
    'account' => uiActivityNAccount,
    'user' => uiActivityNUser,
    'session' => uiActivityNSession,
    'login' => uiActivityNLogin,
    'password' => uiActivityNPassword,
    'chat' => uiActivityNChat,
    'message' => uiActivityNMessage,
    'member' => uiActivityNMember,
    'group' => uiActivityNGroup,
    'admin' => uiActivityNAdmin,
    'department' => uiActivityNDepartment,
    'membership' => uiActivityNMembership,
    'program' => uiActivityNProgram,
    'transfer' => uiActivityNTransfer,
    'company_admin' => uiActivityNCompanyAdmin,
    _ => null,
  };

  String? _activityVerb(String s) => switch (s) {
    'created' => uiActivityVCreated,
    'updated' => uiActivityVUpdated,
    'deleted' => uiActivityVDeleted,
    'restored' => uiActivityVRestored,
    'purged' => uiActivityVPurged,
    'added' => uiActivityVAdded,
    'removed' => uiActivityVRemoved,
    'transitioned' => uiActivityVTransitioned,
    'reverted' => uiActivityVReverted,
    'converted' => uiActivityVConverted,
    'sent' => uiActivityVSent,
    'edited' => uiActivityVEdited,
    'renamed' => uiActivityVRenamed,
    'attached' => uiActivityVAttached,
    'tag_changed' => uiActivityVTagChanged,
    'started' => uiActivityVStarted,
    'ended' => uiActivityVEnded,
    'opened' => uiActivityVOpened,
    'closed' => uiActivityVClosed,
    'approved' => uiActivityVApproved,
    'rejected' => uiActivityVRejected,
    'requested' => uiActivityVRequested,
    'reviewed' => uiActivityVReviewed,
    'assigned' => uiActivityVAssigned,
    'unassigned' => uiActivityVUnassigned,
    'claimed' => uiActivityVClaimed,
    'unclaimed' => uiActivityVUnclaimed,
    'done' => uiActivityVDone,
    'reopened' => uiActivityVReopened,
    'locked' => uiActivityVLocked,
    'unlocked' => uiActivityVUnlocked,
    'disabled' => uiActivityVDisabled,
    'enabled' => uiActivityVEnabled,
    'pinned' => uiActivityVPinned,
    'left' => uiActivityVLeft,
    'granted' => uiActivityVGranted,
    'revoked' => uiActivityVRevoked,
    'reminded' => uiActivityVReminded,
    'role_changed' => uiActivityVRoleChanged,
    'succeeded' => uiActivityVSucceeded,
    'denied' => uiActivityVDenied,
    'extended' => uiActivityVExtended,
    'linked' => uiActivityVLinked,
    'unlinked' => uiActivityVUnlinked,
    'pulled' => uiActivityVPulled,
    'set_by_admin' => uiActivityVSetByAdmin,
    'completed' => uiActivityVCompleted,
    'transferred' => uiActivityVTransferred,
    'changed' => uiActivityVChanged,
    _ => null,
  };
}
