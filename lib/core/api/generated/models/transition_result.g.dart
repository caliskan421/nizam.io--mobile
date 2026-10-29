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
      endOn: _$JsonConverterFromJson<String, DateTime>(
        json['end_on'],
        const DateOnlyConverter().fromJson,
      ),
    );

Map<String, dynamic> _$TransitionResultToJson(_TransitionResult instance) =>
    <String, dynamic>{
      'work_item_id': instance.workItemId,
      'from': instance.from,
      'to': instance.to,
      'actor': _$TransitionResultActorEnumMap[instance.actor]!,
      'end_on': ?_$JsonConverterToJson<String, DateTime>(
        instance.endOn,
        const DateOnlyConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$TransitionResultActorEnumMap = {
  TransitionResultActor.uye: 'uye',
  TransitionResultActor.koordinator: 'koordinator',
  TransitionResultActor.koordinatorKendiGorevi: 'koordinator_kendi_gorevi',
  TransitionResultActor.$unknown: r'$unknown',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
