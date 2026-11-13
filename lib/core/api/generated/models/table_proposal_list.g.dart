// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_proposal_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TableProposalList _$TableProposalListFromJson(Map<String, dynamic> json) =>
    _TableProposalList(
      items: (json['items'] as List<dynamic>)
          .map((e) => TableProposal.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$TableProposalListToJson(_TableProposalList instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };
