// BU DOSYA ÜRETİLMİŞTİR — elle düzenlenmez. `make gen` (tool/gen.dart) ile yeniden üretilir.
// Kaynak: nizam.io--backend etiket v0.1.0-api (8c8c83b33e90aef4e8e3edd82713fc709c39c518) — docs/api/error-codes.json

import '../api_meta.dart';

const errorCatalogVersion = 1;

/// Sunucu hata kodu → HTTP durum(lar)ı, alan kodları, mesaj anahtarı.
const errorCatalog = <String, ErrorCatalogEntry>{
  'audit.entry_rejected': ErrorCatalogEntry(
    statuses: [500],
    fields: [],
    messageKey: 'errors.audit.entry_rejected',
  ),
  'collaboration.agenda_item_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.collaboration.agenda_item_not_found',
  ),
  'collaboration.agenda_limit_reached': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.collaboration.agenda_limit_reached',
  ),
  'collaboration.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: ['collaboration.input_invalid'],
    messageKey: 'errors.collaboration.input_invalid',
  ),
  'collaboration.invalid_cursor': ErrorCatalogEntry(
    statuses: [422],
    fields: ['collaboration.invalid_cursor'],
    messageKey: 'errors.collaboration.invalid_cursor',
  ),
  'collaboration.meeting_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.collaboration.meeting_not_found',
  ),
  'collaboration.message_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.collaboration.message_not_found',
  ),
  'collaboration.message_unread': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.collaboration.message_unread',
  ),
  'collaboration.not_authorized': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.collaboration.not_authorized',
  ),
  'collaboration.not_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.collaboration.not_deleted',
  ),
  'collaboration.note_converted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.collaboration.note_converted',
  ),
  'collaboration.note_immutable': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.collaboration.note_immutable',
  ),
  'collaboration.note_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.collaboration.note_not_found',
  ),
  'collaboration.participant_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: ['collaboration.participant_invalid'],
    messageKey: 'errors.collaboration.participant_invalid',
  ),
  'collaboration.permanent_requires_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.collaboration.permanent_requires_deleted',
  ),
  'collaboration.scope_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.collaboration.scope_invalid',
  ),
  'collaboration.target_department_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: ['collaboration.target_department_invalid'],
    messageKey: 'errors.collaboration.target_department_invalid',
  ),
  'identity.account_email_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.identity.account_email_deleted',
  ),
  'identity.account_exists': ErrorCatalogEntry(
    statuses: [409],
    fields: ['organization.transfer_available'],
    messageKey: 'errors.identity.account_exists',
  ),
  'identity.account_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.identity.account_not_found',
  ),
  'identity.account_not_locked': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.identity.account_not_locked',
  ),
  'identity.account_referenced': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.identity.account_referenced',
  ),
  'identity.captcha_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: ['identity.captcha_invalid'],
    messageKey: 'errors.identity.captcha_invalid',
  ),
  'identity.captcha_required': ErrorCatalogEntry(
    statuses: [422],
    fields: ['identity.captcha_required'],
    messageKey: 'errors.identity.captcha_required',
  ),
  'identity.credentials_invalid': ErrorCatalogEntry(
    statuses: [401],
    fields: [],
    messageKey: 'errors.identity.credentials_invalid',
  ),
  'identity.force_password_change_required': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.identity.force_password_change_required',
  ),
  'identity.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [
      'identity.invalid_email',
      'identity.invalid_full_name',
      'identity.password_needs_digit',
      'identity.password_needs_lower',
      'identity.password_needs_upper',
      'identity.password_too_short',
      'identity.weak_password',
    ],
    messageKey: 'errors.identity.input_invalid',
  ),
  'identity.invalid_cursor': ErrorCatalogEntry(
    statuses: [422],
    fields: ['identity.invalid_cursor'],
    messageKey: 'errors.identity.invalid_cursor',
  ),
  'identity.ip_blocked': ErrorCatalogEntry(
    statuses: [429],
    fields: [],
    messageKey: 'errors.identity.ip_blocked',
  ),
  'identity.login_locked': ErrorCatalogEntry(
    statuses: [429],
    fields: [],
    messageKey: 'errors.identity.login_locked',
  ),
  'identity.not_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.identity.not_deleted',
  ),
  'identity.permanent_requires_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.identity.permanent_requires_deleted',
  ),
  'identity.session_invalid': ErrorCatalogEntry(
    statuses: [401],
    fields: [],
    messageKey: 'errors.identity.session_invalid',
  ),
  'notifications.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.notifications.input_invalid',
  ),
  'notifications.invalid_cursor': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.notifications.invalid_cursor',
  ),
  'notifications.notification_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.notifications.notification_not_found',
  ),
  'notifications.scope_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.notifications.scope_invalid',
  ),
  'notifications.subscription_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.notifications.subscription_not_found',
  ),
  'notifications.subscription_owner_conflict': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.notifications.subscription_owner_conflict',
  ),
  'notifications.target_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.notifications.target_invalid',
  ),
  'organization.account_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.organization.account_not_found',
  ),
  'organization.assignment_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.organization.assignment_not_found',
  ),
  'organization.authority_unavailable': ErrorCatalogEntry(
    statuses: [503],
    fields: [],
    messageKey: 'errors.organization.authority_unavailable',
  ),
  'organization.company_exists': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.company_exists',
  ),
  'organization.company_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.organization.company_not_found',
  ),
  'organization.confirmation_required': ErrorCatalogEntry(
    statuses: [409],
    fields: ['organization.task_title'],
    messageKey: 'errors.organization.confirmation_required',
  ),
  'organization.department_code_conflict': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.department_code_conflict',
  ),
  'organization.department_exists': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.department_exists',
  ),
  'organization.department_in_use': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.department_in_use',
  ),
  'organization.department_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.organization.department_not_found',
  ),
  'organization.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [
      'organization.invalid_code',
      'organization.invalid_kind',
      'organization.invalid_name',
      'organization.invalid_role',
      'organization.invalid_sort',
    ],
    messageKey: 'errors.organization.input_invalid',
  ),
  'organization.last_admin': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.last_admin',
  ),
  'organization.membership_exists': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.membership_exists',
  ),
  'organization.membership_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.organization.membership_not_found',
  ),
  'organization.membership_required': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.organization.membership_required',
  ),
  'organization.not_authorized': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.organization.not_authorized',
  ),
  'organization.not_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.not_deleted',
  ),
  'organization.permanent_requires_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.permanent_requires_deleted',
  ),
  'organization.task_title': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.task_title',
  ),
  'organization.transfer_available': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.transfer_available',
  ),
  'organization.transfer_unavailable': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.organization.transfer_unavailable',
  ),
  'platform.body_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.platform.body_invalid',
  ),
  'platform.body_too_large': ErrorCatalogEntry(
    statuses: [413],
    fields: [],
    messageKey: 'errors.platform.body_too_large',
  ),
  'platform.body_unknown_field': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.platform.body_unknown_field',
  ),
  'platform.conflict_retry': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.platform.conflict_retry',
  ),
  'platform.csrf_header_missing': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.platform.csrf_header_missing',
  ),
  'platform.internal': ErrorCatalogEntry(
    statuses: [500],
    fields: [],
    messageKey: 'errors.platform.internal',
  ),
  'platform.method_not_allowed': ErrorCatalogEntry(
    statuses: [405],
    fields: [],
    messageKey: 'errors.platform.method_not_allowed',
  ),
  'platform.not_ready': ErrorCatalogEntry(
    statuses: [503],
    fields: [],
    messageKey: 'errors.platform.not_ready',
  ),
  'platform.panic': ErrorCatalogEntry(
    statuses: [500],
    fields: [],
    messageKey: 'errors.platform.panic',
  ),
  'platform.rate_limited': ErrorCatalogEntry(
    statuses: [429],
    fields: [],
    messageKey: 'errors.platform.rate_limited',
  ),
  'platform.route_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.platform.route_not_found',
  ),
  'platform.scope_missing': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.platform.scope_missing',
  ),
  'platform.unauthenticated': ErrorCatalogEntry(
    statuses: [401],
    fields: [],
    messageKey: 'errors.platform.unauthenticated',
  ),
  'program.already_exists': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.already_exists',
  ),
  'program.department_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.program.department_not_found',
  ),
  'program.idempotency_key_reused': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.idempotency_key_reused',
  ),
  'program.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [
      'program.invalid_description',
      'program.invalid_limit',
      'program.invalid_name',
      'program.invalid_year',
      'program.password_required',
    ],
    messageKey: 'errors.program.input_invalid',
  ),
  'program.invalid_cursor': ErrorCatalogEntry(
    statuses: [422],
    fields: ['program.invalid_cursor'],
    messageKey: 'errors.program.invalid_cursor',
  ),
  'program.not_authorized': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.program.not_authorized',
  ),
  'program.not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.program.not_found',
  ),
  'program.password_invalid': ErrorCatalogEntry(
    statuses: [401],
    fields: [],
    messageKey: 'errors.program.password_invalid',
  ),
  'program.program_in_use': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.program_in_use',
  ),
  'program.transfer_already_reversed': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.transfer_already_reversed',
  ),
  'program.transfer_blocked': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.transfer_blocked',
  ),
  'program.transfer_conflict': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.transfer_conflict',
  ),
  'program.transfer_input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [
      'program.duplicate_transfer_item',
      'program.invalid_transfer',
      'program.request_key_invalid',
      'program.request_key_required',
    ],
    messageKey: 'errors.program.transfer_input_invalid',
  ),
  'program.transfer_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.program.transfer_not_found',
  ),
  'program.transfer_not_reversible': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.transfer_not_reversible',
  ),
  'program.transfer_preview_stale': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.program.transfer_preview_stale',
  ),
  'provisioning.version_mismatch': ErrorCatalogEntry(
    statuses: [500],
    fields: [],
    messageKey: 'errors.provisioning.version_mismatch',
  ),
  'provisioning.write_not_allowed': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.provisioning.write_not_allowed',
  ),
  'records.busy': ErrorCatalogEntry(
    statuses: [429],
    fields: [],
    messageKey: 'errors.records.busy',
  ),
  'records.content_rejected': ErrorCatalogEntry(
    statuses: [422, 500],
    fields: ['records.content_rejected'],
    messageKey: 'errors.records.content_rejected',
  ),
  'records.file_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.records.file_not_found',
  ),
  'records.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: ['records.invalid_file'],
    messageKey: 'errors.records.input_invalid',
  ),
  'records.invalid_cursor': ErrorCatalogEntry(
    statuses: [422],
    fields: ['records.invalid_cursor'],
    messageKey: 'errors.records.invalid_cursor',
  ),
  'records.moved': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.records.moved',
  ),
  'records.name_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: ['records.name_invalid'],
    messageKey: 'errors.records.name_invalid',
  ),
  'records.name_taken': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.records.name_taken',
  ),
  'records.not_authorized': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.records.not_authorized',
  ),
  'records.too_large': ErrorCatalogEntry(
    statuses: [422],
    fields: ['records.too_large'],
    messageKey: 'errors.records.too_large',
  ),
  'records.too_many_files': ErrorCatalogEntry(
    statuses: [422],
    fields: ['records.too_many_files'],
    messageKey: 'errors.records.too_many_files',
  ),
  'records.transfer_active': ErrorCatalogEntry(
    statuses: [422],
    fields: ['records.transfer_active'],
    messageKey: 'errors.records.transfer_active',
  ),
  'reporting.capacity_full': ErrorCatalogEntry(
    statuses: [503],
    fields: [],
    messageKey: 'errors.reporting.capacity_full',
  ),
  'reporting.export_in_progress': ErrorCatalogEntry(
    statuses: [429],
    fields: [],
    messageKey: 'errors.reporting.export_in_progress',
  ),
  'reporting.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: ['reporting.input_invalid'],
    messageKey: 'errors.reporting.input_invalid',
  ),
  'reporting.not_authorized': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.reporting.not_authorized',
  ),
  'reporting.not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.reporting.not_found',
  ),
  'storage.inconsistent': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.storage.inconsistent',
  ),
  'storage.invalid_key': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.storage.invalid_key',
  ),
  'storage.not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.storage.not_found',
  ),
  'storage.permanent': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.storage.permanent',
  ),
  'storage.quota': ErrorCatalogEntry(
    statuses: [422],
    fields: [],
    messageKey: 'errors.storage.quota',
  ),
  'storage.transient': ErrorCatalogEntry(
    statuses: [500],
    fields: [],
    messageKey: 'errors.storage.transient',
  ),
  'work.assignee_not_member': ErrorCatalogEntry(
    statuses: [422],
    fields: ['work.assignee_not_member'],
    messageKey: 'errors.work.assignee_not_member',
  ),
  'work.assignment_duplicate': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.assignment_duplicate',
  ),
  'work.attachment_required': ErrorCatalogEntry(
    statuses: [422],
    fields: ['work.attachment_required'],
    messageKey: 'errors.work.attachment_required',
  ),
  'work.claim_not_available': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.claim_not_available',
  ),
  'work.constraint_violation': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.constraint_violation',
  ),
  'work.date_request_already_reviewed': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.date_request_already_reviewed',
  ),
  'work.date_request_pending_exists': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.date_request_pending_exists',
  ),
  'work.date_request_pending_undeletable': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.date_request_pending_undeletable',
  ),
  'work.department_unavailable': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.department_unavailable',
  ),
  'work.dependency_cycle': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.dependency_cycle',
  ),
  'work.dependency_duplicate': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.dependency_duplicate',
  ),
  'work.dependency_not_completed': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.dependency_not_completed',
  ),
  'work.input_invalid': ErrorCatalogEntry(
    statuses: [422],
    fields: [
      'work.completion_date_future',
      'work.completion_date_missing',
      'work.completion_window',
      'work.date_request_invalid',
      'work.dependency_date_order',
      'work.extend_days_out_of_range',
      'work.invalid_input',
      'work.protected_field',
    ],
    messageKey: 'errors.work.input_invalid',
  ),
  'work.item_completed': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.item_completed',
  ),
  'work.item_not_completed': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.item_not_completed',
  ),
  'work.item_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.work.item_not_found',
  ),
  'work.not_assigned': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.work.not_assigned',
  ),
  'work.not_authorized': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.work.not_authorized',
  ),
  'work.not_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.not_deleted',
  ),
  'work.note_not_found': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.work.note_not_found',
  ),
  'work.note_not_yours': ErrorCatalogEntry(
    statuses: [403],
    fields: [],
    messageKey: 'errors.work.note_not_yours',
  ),
  'work.note_rate_limited': ErrorCatalogEntry(
    statuses: [429],
    fields: [],
    messageKey: 'errors.work.note_rate_limited',
  ),
  'work.permanent_requires_deleted': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.permanent_requires_deleted',
  ),
  'work.program_scope_invalid': ErrorCatalogEntry(
    statuses: [404],
    fields: [],
    messageKey: 'errors.work.program_scope_invalid',
  ),
  'work.revert_reason_required': ErrorCatalogEntry(
    statuses: [422],
    fields: ['work.revert_reason_required'],
    messageKey: 'errors.work.revert_reason_required',
  ),
  'work.stale_completion': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.stale_completion',
  ),
  'work.stale_transition': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.stale_transition',
  ),
  'work.transfer_active': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.transfer_active',
  ),
  'work.transition_not_allowed': ErrorCatalogEntry(
    statuses: [409],
    fields: [],
    messageKey: 'errors.work.transition_not_allowed',
  ),
};
