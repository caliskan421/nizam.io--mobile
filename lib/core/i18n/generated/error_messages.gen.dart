// BU DOSYA ÜRETİLMİŞTİR — elle düzenlenmez. `make gen` (tool/gen.dart) ile yeniden üretilir.
// Kaynak: lib/core/i18n/arb/app_tr.arb

import 'app_localizations.dart';

/// Metni olan bütün hata kodları (sunucu kataloğu ∪ alan kodları ∪ istemci kodları).
const localizedErrorCodes = <String>{
  'audit.entry_rejected',
  'collaboration.agenda_item_not_found',
  'collaboration.agenda_limit_reached',
  'collaboration.input_invalid',
  'collaboration.invalid_cursor',
  'collaboration.meeting_not_found',
  'collaboration.message_not_found',
  'collaboration.message_unread',
  'collaboration.not_authorized',
  'collaboration.not_deleted',
  'collaboration.note_converted',
  'collaboration.note_immutable',
  'collaboration.note_not_found',
  'collaboration.participant_invalid',
  'collaboration.permanent_requires_deleted',
  'collaboration.scope_invalid',
  'collaboration.target_department_invalid',
  'identity.account_email_deleted',
  'identity.account_exists',
  'identity.account_not_found',
  'identity.account_not_locked',
  'identity.account_referenced',
  'identity.captcha_invalid',
  'identity.captcha_required',
  'identity.credentials_invalid',
  'identity.force_password_change_required',
  'identity.input_invalid',
  'identity.invalid_cursor',
  'identity.invalid_email',
  'identity.invalid_full_name',
  'identity.ip_blocked',
  'identity.login_locked',
  'identity.not_deleted',
  'identity.password_needs_digit',
  'identity.password_needs_lower',
  'identity.password_needs_upper',
  'identity.password_too_short',
  'identity.permanent_requires_deleted',
  'identity.session_invalid',
  'identity.weak_password',
  'notifications.input_invalid',
  'notifications.invalid_cursor',
  'notifications.notification_not_found',
  'notifications.scope_invalid',
  'notifications.subscription_not_found',
  'notifications.subscription_owner_conflict',
  'notifications.target_invalid',
  'organization.account_not_found',
  'organization.assignment_not_found',
  'organization.authority_unavailable',
  'organization.company_exists',
  'organization.company_not_found',
  'organization.confirmation_required',
  'organization.department_code_conflict',
  'organization.department_exists',
  'organization.department_in_use',
  'organization.department_not_found',
  'organization.input_invalid',
  'organization.invalid_code',
  'organization.invalid_kind',
  'organization.invalid_name',
  'organization.invalid_role',
  'organization.invalid_sort',
  'organization.last_admin',
  'organization.membership_exists',
  'organization.membership_not_found',
  'organization.membership_required',
  'organization.not_authorized',
  'organization.not_deleted',
  'organization.permanent_requires_deleted',
  'organization.task_title',
  'organization.transfer_available',
  'organization.transfer_unavailable',
  'platform.body_invalid',
  'platform.body_too_large',
  'platform.body_unknown_field',
  'platform.conflict_retry',
  'platform.csrf_header_missing',
  'platform.internal',
  'platform.method_not_allowed',
  'platform.not_ready',
  'platform.panic',
  'platform.rate_limited',
  'platform.route_not_found',
  'platform.scope_missing',
  'platform.unauthenticated',
  'program.already_exists',
  'program.department_not_found',
  'program.duplicate_transfer_item',
  'program.idempotency_key_reused',
  'program.input_invalid',
  'program.invalid_cursor',
  'program.invalid_description',
  'program.invalid_limit',
  'program.invalid_name',
  'program.invalid_transfer',
  'program.invalid_year',
  'program.not_authorized',
  'program.not_found',
  'program.password_invalid',
  'program.password_required',
  'program.program_in_use',
  'program.request_key_invalid',
  'program.request_key_required',
  'program.transfer_already_reversed',
  'program.transfer_blocked',
  'program.transfer_conflict',
  'program.transfer_input_invalid',
  'program.transfer_not_found',
  'program.transfer_not_reversible',
  'program.transfer_preview_stale',
  'provisioning.version_mismatch',
  'provisioning.write_not_allowed',
  'records.busy',
  'records.content_rejected',
  'records.file_not_found',
  'records.input_invalid',
  'records.invalid_cursor',
  'records.invalid_file',
  'records.moved',
  'records.name_invalid',
  'records.name_taken',
  'records.not_authorized',
  'records.too_large',
  'records.too_many_files',
  'records.transfer_active',
  'reporting.capacity_full',
  'reporting.export_in_progress',
  'reporting.input_invalid',
  'reporting.not_authorized',
  'reporting.not_found',
  'storage.inconsistent',
  'storage.invalid_key',
  'storage.not_found',
  'storage.permanent',
  'storage.quota',
  'storage.transient',
  'work.assignee_not_member',
  'work.assignment_duplicate',
  'work.attachment_required',
  'work.claim_not_available',
  'work.completion_date_future',
  'work.completion_date_missing',
  'work.completion_window',
  'work.constraint_violation',
  'work.date_request_already_reviewed',
  'work.date_request_invalid',
  'work.date_request_pending_exists',
  'work.date_request_pending_undeletable',
  'work.department_unavailable',
  'work.dependency_cycle',
  'work.dependency_date_order',
  'work.dependency_duplicate',
  'work.dependency_not_completed',
  'work.extend_days_out_of_range',
  'work.input_invalid',
  'work.invalid_input',
  'work.item_completed',
  'work.item_not_completed',
  'work.item_not_found',
  'work.not_assigned',
  'work.not_authorized',
  'work.not_deleted',
  'work.note_not_found',
  'work.note_not_yours',
  'work.note_rate_limited',
  'work.permanent_requires_deleted',
  'work.program_scope_invalid',
  'work.protected_field',
  'work.revert_reason_required',
  'work.stale_completion',
  'work.stale_transition',
  'work.transfer_active',
  'work.transition_not_allowed',
  'client.insecure_server',
  'client.invalid_response',
  'client.invalid_server_address',
  'client.network_error',
  'client.not_signed_in',
  'client.reauth_required',
  'client.scope_missing',
  'client.secure_storage_error',
  'client.server_not_verified',
  'client.server_unrecognized',
  'client.session_ended',
  'client.timeout',
  'client.tls_error',
  'client.unknown_operation',
  'client.unsupported_api_version',
  'client.update_required',
};

/// Hata kodu → yerelleştirilmiş metin; bilinmeyen kod `null`.
String? localizedErrorText(AppLocalizations l, String code) {
  switch (code) {
    case 'audit.entry_rejected':
      return l.errAuditEntryRejected;
    case 'collaboration.agenda_item_not_found':
      return l.errCollaborationAgendaItemNotFound;
    case 'collaboration.agenda_limit_reached':
      return l.errCollaborationAgendaLimitReached;
    case 'collaboration.input_invalid':
      return l.errCollaborationInputInvalid;
    case 'collaboration.invalid_cursor':
      return l.errCollaborationInvalidCursor;
    case 'collaboration.meeting_not_found':
      return l.errCollaborationMeetingNotFound;
    case 'collaboration.message_not_found':
      return l.errCollaborationMessageNotFound;
    case 'collaboration.message_unread':
      return l.errCollaborationMessageUnread;
    case 'collaboration.not_authorized':
      return l.errCollaborationNotAuthorized;
    case 'collaboration.not_deleted':
      return l.errCollaborationNotDeleted;
    case 'collaboration.note_converted':
      return l.errCollaborationNoteConverted;
    case 'collaboration.note_immutable':
      return l.errCollaborationNoteImmutable;
    case 'collaboration.note_not_found':
      return l.errCollaborationNoteNotFound;
    case 'collaboration.participant_invalid':
      return l.errCollaborationParticipantInvalid;
    case 'collaboration.permanent_requires_deleted':
      return l.errCollaborationPermanentRequiresDeleted;
    case 'collaboration.scope_invalid':
      return l.errCollaborationScopeInvalid;
    case 'collaboration.target_department_invalid':
      return l.errCollaborationTargetDepartmentInvalid;
    case 'identity.account_email_deleted':
      return l.errIdentityAccountEmailDeleted;
    case 'identity.account_exists':
      return l.errIdentityAccountExists;
    case 'identity.account_not_found':
      return l.errIdentityAccountNotFound;
    case 'identity.account_not_locked':
      return l.errIdentityAccountNotLocked;
    case 'identity.account_referenced':
      return l.errIdentityAccountReferenced;
    case 'identity.captcha_invalid':
      return l.errIdentityCaptchaInvalid;
    case 'identity.captcha_required':
      return l.errIdentityCaptchaRequired;
    case 'identity.credentials_invalid':
      return l.errIdentityCredentialsInvalid;
    case 'identity.force_password_change_required':
      return l.errIdentityForcePasswordChangeRequired;
    case 'identity.input_invalid':
      return l.errIdentityInputInvalid;
    case 'identity.invalid_cursor':
      return l.errIdentityInvalidCursor;
    case 'identity.invalid_email':
      return l.errIdentityInvalidEmail;
    case 'identity.invalid_full_name':
      return l.errIdentityInvalidFullName;
    case 'identity.ip_blocked':
      return l.errIdentityIpBlocked;
    case 'identity.login_locked':
      return l.errIdentityLoginLocked;
    case 'identity.not_deleted':
      return l.errIdentityNotDeleted;
    case 'identity.password_needs_digit':
      return l.errIdentityPasswordNeedsDigit;
    case 'identity.password_needs_lower':
      return l.errIdentityPasswordNeedsLower;
    case 'identity.password_needs_upper':
      return l.errIdentityPasswordNeedsUpper;
    case 'identity.password_too_short':
      return l.errIdentityPasswordTooShort;
    case 'identity.permanent_requires_deleted':
      return l.errIdentityPermanentRequiresDeleted;
    case 'identity.session_invalid':
      return l.errIdentitySessionInvalid;
    case 'identity.weak_password':
      return l.errIdentityWeakPassword;
    case 'notifications.input_invalid':
      return l.errNotificationsInputInvalid;
    case 'notifications.invalid_cursor':
      return l.errNotificationsInvalidCursor;
    case 'notifications.notification_not_found':
      return l.errNotificationsNotificationNotFound;
    case 'notifications.scope_invalid':
      return l.errNotificationsScopeInvalid;
    case 'notifications.subscription_not_found':
      return l.errNotificationsSubscriptionNotFound;
    case 'notifications.subscription_owner_conflict':
      return l.errNotificationsSubscriptionOwnerConflict;
    case 'notifications.target_invalid':
      return l.errNotificationsTargetInvalid;
    case 'organization.account_not_found':
      return l.errOrganizationAccountNotFound;
    case 'organization.assignment_not_found':
      return l.errOrganizationAssignmentNotFound;
    case 'organization.authority_unavailable':
      return l.errOrganizationAuthorityUnavailable;
    case 'organization.company_exists':
      return l.errOrganizationCompanyExists;
    case 'organization.company_not_found':
      return l.errOrganizationCompanyNotFound;
    case 'organization.confirmation_required':
      return l.errOrganizationConfirmationRequired;
    case 'organization.department_code_conflict':
      return l.errOrganizationDepartmentCodeConflict;
    case 'organization.department_exists':
      return l.errOrganizationDepartmentExists;
    case 'organization.department_in_use':
      return l.errOrganizationDepartmentInUse;
    case 'organization.department_not_found':
      return l.errOrganizationDepartmentNotFound;
    case 'organization.input_invalid':
      return l.errOrganizationInputInvalid;
    case 'organization.invalid_code':
      return l.errOrganizationInvalidCode;
    case 'organization.invalid_kind':
      return l.errOrganizationInvalidKind;
    case 'organization.invalid_name':
      return l.errOrganizationInvalidName;
    case 'organization.invalid_role':
      return l.errOrganizationInvalidRole;
    case 'organization.invalid_sort':
      return l.errOrganizationInvalidSort;
    case 'organization.last_admin':
      return l.errOrganizationLastAdmin;
    case 'organization.membership_exists':
      return l.errOrganizationMembershipExists;
    case 'organization.membership_not_found':
      return l.errOrganizationMembershipNotFound;
    case 'organization.membership_required':
      return l.errOrganizationMembershipRequired;
    case 'organization.not_authorized':
      return l.errOrganizationNotAuthorized;
    case 'organization.not_deleted':
      return l.errOrganizationNotDeleted;
    case 'organization.permanent_requires_deleted':
      return l.errOrganizationPermanentRequiresDeleted;
    case 'organization.task_title':
      return l.errOrganizationTaskTitle;
    case 'organization.transfer_available':
      return l.errOrganizationTransferAvailable;
    case 'organization.transfer_unavailable':
      return l.errOrganizationTransferUnavailable;
    case 'platform.body_invalid':
      return l.errPlatformBodyInvalid;
    case 'platform.body_too_large':
      return l.errPlatformBodyTooLarge;
    case 'platform.body_unknown_field':
      return l.errPlatformBodyUnknownField;
    case 'platform.conflict_retry':
      return l.errPlatformConflictRetry;
    case 'platform.csrf_header_missing':
      return l.errPlatformCsrfHeaderMissing;
    case 'platform.internal':
      return l.errPlatformInternal;
    case 'platform.method_not_allowed':
      return l.errPlatformMethodNotAllowed;
    case 'platform.not_ready':
      return l.errPlatformNotReady;
    case 'platform.panic':
      return l.errPlatformPanic;
    case 'platform.rate_limited':
      return l.errPlatformRateLimited;
    case 'platform.route_not_found':
      return l.errPlatformRouteNotFound;
    case 'platform.scope_missing':
      return l.errPlatformScopeMissing;
    case 'platform.unauthenticated':
      return l.errPlatformUnauthenticated;
    case 'program.already_exists':
      return l.errProgramAlreadyExists;
    case 'program.department_not_found':
      return l.errProgramDepartmentNotFound;
    case 'program.duplicate_transfer_item':
      return l.errProgramDuplicateTransferItem;
    case 'program.idempotency_key_reused':
      return l.errProgramIdempotencyKeyReused;
    case 'program.input_invalid':
      return l.errProgramInputInvalid;
    case 'program.invalid_cursor':
      return l.errProgramInvalidCursor;
    case 'program.invalid_description':
      return l.errProgramInvalidDescription;
    case 'program.invalid_limit':
      return l.errProgramInvalidLimit;
    case 'program.invalid_name':
      return l.errProgramInvalidName;
    case 'program.invalid_transfer':
      return l.errProgramInvalidTransfer;
    case 'program.invalid_year':
      return l.errProgramInvalidYear;
    case 'program.not_authorized':
      return l.errProgramNotAuthorized;
    case 'program.not_found':
      return l.errProgramNotFound;
    case 'program.password_invalid':
      return l.errProgramPasswordInvalid;
    case 'program.password_required':
      return l.errProgramPasswordRequired;
    case 'program.program_in_use':
      return l.errProgramProgramInUse;
    case 'program.request_key_invalid':
      return l.errProgramRequestKeyInvalid;
    case 'program.request_key_required':
      return l.errProgramRequestKeyRequired;
    case 'program.transfer_already_reversed':
      return l.errProgramTransferAlreadyReversed;
    case 'program.transfer_blocked':
      return l.errProgramTransferBlocked;
    case 'program.transfer_conflict':
      return l.errProgramTransferConflict;
    case 'program.transfer_input_invalid':
      return l.errProgramTransferInputInvalid;
    case 'program.transfer_not_found':
      return l.errProgramTransferNotFound;
    case 'program.transfer_not_reversible':
      return l.errProgramTransferNotReversible;
    case 'program.transfer_preview_stale':
      return l.errProgramTransferPreviewStale;
    case 'provisioning.version_mismatch':
      return l.errProvisioningVersionMismatch;
    case 'provisioning.write_not_allowed':
      return l.errProvisioningWriteNotAllowed;
    case 'records.busy':
      return l.errRecordsBusy;
    case 'records.content_rejected':
      return l.errRecordsContentRejected;
    case 'records.file_not_found':
      return l.errRecordsFileNotFound;
    case 'records.input_invalid':
      return l.errRecordsInputInvalid;
    case 'records.invalid_cursor':
      return l.errRecordsInvalidCursor;
    case 'records.invalid_file':
      return l.errRecordsInvalidFile;
    case 'records.moved':
      return l.errRecordsMoved;
    case 'records.name_invalid':
      return l.errRecordsNameInvalid;
    case 'records.name_taken':
      return l.errRecordsNameTaken;
    case 'records.not_authorized':
      return l.errRecordsNotAuthorized;
    case 'records.too_large':
      return l.errRecordsTooLarge;
    case 'records.too_many_files':
      return l.errRecordsTooManyFiles;
    case 'records.transfer_active':
      return l.errRecordsTransferActive;
    case 'reporting.capacity_full':
      return l.errReportingCapacityFull;
    case 'reporting.export_in_progress':
      return l.errReportingExportInProgress;
    case 'reporting.input_invalid':
      return l.errReportingInputInvalid;
    case 'reporting.not_authorized':
      return l.errReportingNotAuthorized;
    case 'reporting.not_found':
      return l.errReportingNotFound;
    case 'storage.inconsistent':
      return l.errStorageInconsistent;
    case 'storage.invalid_key':
      return l.errStorageInvalidKey;
    case 'storage.not_found':
      return l.errStorageNotFound;
    case 'storage.permanent':
      return l.errStoragePermanent;
    case 'storage.quota':
      return l.errStorageQuota;
    case 'storage.transient':
      return l.errStorageTransient;
    case 'work.assignee_not_member':
      return l.errWorkAssigneeNotMember;
    case 'work.assignment_duplicate':
      return l.errWorkAssignmentDuplicate;
    case 'work.attachment_required':
      return l.errWorkAttachmentRequired;
    case 'work.claim_not_available':
      return l.errWorkClaimNotAvailable;
    case 'work.completion_date_future':
      return l.errWorkCompletionDateFuture;
    case 'work.completion_date_missing':
      return l.errWorkCompletionDateMissing;
    case 'work.completion_window':
      return l.errWorkCompletionWindow;
    case 'work.constraint_violation':
      return l.errWorkConstraintViolation;
    case 'work.date_request_already_reviewed':
      return l.errWorkDateRequestAlreadyReviewed;
    case 'work.date_request_invalid':
      return l.errWorkDateRequestInvalid;
    case 'work.date_request_pending_exists':
      return l.errWorkDateRequestPendingExists;
    case 'work.date_request_pending_undeletable':
      return l.errWorkDateRequestPendingUndeletable;
    case 'work.department_unavailable':
      return l.errWorkDepartmentUnavailable;
    case 'work.dependency_cycle':
      return l.errWorkDependencyCycle;
    case 'work.dependency_date_order':
      return l.errWorkDependencyDateOrder;
    case 'work.dependency_duplicate':
      return l.errWorkDependencyDuplicate;
    case 'work.dependency_not_completed':
      return l.errWorkDependencyNotCompleted;
    case 'work.extend_days_out_of_range':
      return l.errWorkExtendDaysOutOfRange;
    case 'work.input_invalid':
      return l.errWorkInputInvalid;
    case 'work.invalid_input':
      return l.errWorkInvalidInput;
    case 'work.item_completed':
      return l.errWorkItemCompleted;
    case 'work.item_not_completed':
      return l.errWorkItemNotCompleted;
    case 'work.item_not_found':
      return l.errWorkItemNotFound;
    case 'work.not_assigned':
      return l.errWorkNotAssigned;
    case 'work.not_authorized':
      return l.errWorkNotAuthorized;
    case 'work.not_deleted':
      return l.errWorkNotDeleted;
    case 'work.note_not_found':
      return l.errWorkNoteNotFound;
    case 'work.note_not_yours':
      return l.errWorkNoteNotYours;
    case 'work.note_rate_limited':
      return l.errWorkNoteRateLimited;
    case 'work.permanent_requires_deleted':
      return l.errWorkPermanentRequiresDeleted;
    case 'work.program_scope_invalid':
      return l.errWorkProgramScopeInvalid;
    case 'work.protected_field':
      return l.errWorkProtectedField;
    case 'work.revert_reason_required':
      return l.errWorkRevertReasonRequired;
    case 'work.stale_completion':
      return l.errWorkStaleCompletion;
    case 'work.stale_transition':
      return l.errWorkStaleTransition;
    case 'work.transfer_active':
      return l.errWorkTransferActive;
    case 'work.transition_not_allowed':
      return l.errWorkTransitionNotAllowed;
    case 'client.insecure_server':
      return l.errClientInsecureServer;
    case 'client.invalid_response':
      return l.errClientInvalidResponse;
    case 'client.invalid_server_address':
      return l.errClientInvalidServerAddress;
    case 'client.network_error':
      return l.errClientNetworkError;
    case 'client.not_signed_in':
      return l.errClientNotSignedIn;
    case 'client.reauth_required':
      return l.errClientReauthRequired;
    case 'client.scope_missing':
      return l.errClientScopeMissing;
    case 'client.secure_storage_error':
      return l.errClientSecureStorageError;
    case 'client.server_not_verified':
      return l.errClientServerNotVerified;
    case 'client.server_unrecognized':
      return l.errClientServerUnrecognized;
    case 'client.session_ended':
      return l.errClientSessionEnded;
    case 'client.timeout':
      return l.errClientTimeout;
    case 'client.tls_error':
      return l.errClientTlsError;
    case 'client.unknown_operation':
      return l.errClientUnknownOperation;
    case 'client.unsupported_api_version':
      return l.errClientUnsupportedApiVersion;
    case 'client.update_required':
      return l.errClientUpdateRequired;
  }
  return null;
}
