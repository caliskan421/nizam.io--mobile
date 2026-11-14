// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_proposal.dart';

part 'table_proposal_list.freezed.dart';
part 'table_proposal_list.g.dart';

@Freezed()
abstract class TableProposalList with _$TableProposalList {
  const factory TableProposalList({
    required List<TableProposal> items,

    /// Sonraki sayfa; son sayfada yoktur.
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _TableProposalList;

  factory TableProposalList.fromJson(Map<String, Object?> json) =>
      _$TableProposalListFromJson(json);
}
