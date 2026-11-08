// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_chat_poll_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VoteChatPollRequest _$VoteChatPollRequestFromJson(Map<String, dynamic> json) =>
    _VoteChatPollRequest(
      optionIndexes: (json['option_indexes'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$VoteChatPollRequestToJson(
  _VoteChatPollRequest instance,
) => <String, dynamic>{'option_indexes': instance.optionIndexes};
