// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transition_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransitionResult _$TransitionResultFromJson(Map<String, dynamic> json) =>
    _TransitionResult(
      workItemId: json['work_item_id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      actor: TransitionResultActor.fromJson(json['actor'] as String),
      endOn: json['end_on'] == null
          ? null
          : DateTime.parse(json['end_on'] as String),
    );

Map<String, dynamic> _$TransitionResultToJson(_TransitionResult instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'from': instance.from,
      'to': instance.to,
      'actor': _$TransitionResultActorEnumMap[instance.actor]!,
      'end_on': ?instance.endOn?.toIso8601String(),
    };

const _$TransitionResultActorEnumMap = {
  TransitionResultActor.uye: 'uye',
  TransitionResultActor.koordinator: 'koordinator',
  TransitionResultActor.koordinatorKendiGorevi: 'koordinator_kendi_gorevi',
  TransitionResultActor.$unknown: r'$unknown',
};
