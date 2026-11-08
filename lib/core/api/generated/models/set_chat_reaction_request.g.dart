// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_chat_reaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SetChatReactionRequest _$SetChatReactionRequestFromJson(
  Map<String, dynamic> json,
) => _SetChatReactionRequest(
  kind: SetChatReactionRequestKind.fromJson(json['kind'] as String),
);

Map<String, dynamic> _$SetChatReactionRequestToJson(
  _SetChatReactionRequest instance,
) => <String, dynamic>{
  'kind': _$SetChatReactionRequestKindEnumMap[instance.kind]!,
};

const _$SetChatReactionRequestKindEnumMap = {
  SetChatReactionRequestKind.like: 'like',
  SetChatReactionRequestKind.heart: 'heart',
  SetChatReactionRequestKind.check: 'check',
  SetChatReactionRequestKind.star: 'star',
  SetChatReactionRequestKind.$unknown: r'$unknown',
};
