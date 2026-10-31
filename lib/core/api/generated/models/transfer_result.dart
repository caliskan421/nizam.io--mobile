// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'granted_membership.dart';

part 'transfer_result.freezed.dart';
part 'transfer_result.g.dart';

@Freezed()
abstract class TransferResult with _$TransferResult {
  const factory TransferResult({
    @JsonKey(name: 'transfer_id') required String transferId,
    @JsonKey(name: 'moved_work_item_ids')
    required List<String>? movedWorkItemIds,
    @JsonKey(name: 'moved_file_count') required int movedFileCount,
    @JsonKey(name: 'cut_dependency_count') required int cutDependencyCount,
    @JsonKey(name: 'restored_dependency_count')
    required int restoredDependencyCount,
    @JsonKey(name: 'granted_links') required List<String> grantedLinks,
    @JsonKey(name: 'revoked_links') required List<String> revokedLinks,

    /// Ters aktarımda tersine çevrilen aktarımın kurduğu ama geri alınmayan bağların departman kimlikleri. Bağ, çiftte canlı görev kaldıysa ya da aktarımın eklediği satırlar silindikten sonra çiftin ekibinde aktarım dışı satır (elle eklenen, yeniden eklenen ya da artık `uye` olmayan) kaldıysa korunur (ADR-0023 kural 12).
    @JsonKey(name: 'retained_links') required List<String> retainedLinks,

    /// Aktarımın hedef programın departman ekibine `uye` olarak eklediği (ön izlemede ekleyeceği) atanan kişiler (ADR-0023 kural 12).
    @JsonKey(name: 'granted_memberships')
    required List<GrantedMembership> grantedMemberships,
    required bool replayed,
    @JsonKey(name: 'skipped_work_item_ids') List<String>? skippedWorkItemIds,
  }) = _TransferResult;

  factory TransferResult.fromJson(Map<String, Object?> json) =>
      _$TransferResultFromJson(json);
}
