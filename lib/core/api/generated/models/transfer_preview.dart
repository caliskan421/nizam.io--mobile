// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'granted_membership.dart';

part 'transfer_preview.freezed.dart';
part 'transfer_preview.g.dart';

@Freezed()
abstract class TransferPreview with _$TransferPreview {
  const factory TransferPreview({
    @JsonKey(name: 'resolved_work_item_ids')
    required List<String>? resolvedWorkItemIds,
    @JsonKey(name: 'file_count') required int fileCount,
    @JsonKey(name: 'file_total_bytes') required int fileTotalBytes,
    @JsonKey(name: 'preserved_dependency_count')
    required int preservedDependencyCount,
    @JsonKey(name: 'missing_access') required bool missingAccess,

    /// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
    @JsonKey(name: 'granted_memberships')
    required List<GrantedMembership> grantedMemberships,
    required List<String> blockers,
    required List<String> warnings,
    @JsonKey(name: 'can_execute') required bool canExecute,
    @JsonKey(name: 'preview_fingerprint') required String previewFingerprint,
    @JsonKey(name: 'unresolved_work_item_ids')
    List<String>? unresolvedWorkItemIds,
    @JsonKey(name: 'missing_file_ids') List<String>? missingFileIds,
    @JsonKey(name: 'cut_dependency_ids') List<String>? cutDependencyIds,
    @JsonKey(name: 'cycle_work_item_ids') List<String>? cycleWorkItemIds,
  }) = _TransferPreview;

  factory TransferPreview.fromJson(Map<String, Object?> json) =>
      _$TransferPreviewFromJson(json);
}
