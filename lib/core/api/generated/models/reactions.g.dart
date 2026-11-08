// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reactions _$ReactionsFromJson(Map<String, dynamic> json) => _Reactions(
  kind: Kind2.fromJson(json['kind'] as String),
  count: (json['count'] as num).toInt(),
  mine: json['mine'] as bool,
);

Map<String, dynamic> _$ReactionsToJson(_Reactions instance) =>
    <String, dynamic>{
      'kind': _$Kind2EnumMap[instance.kind]!,
      'count': instance.count,
      'mine': instance.mine,
    };

const _$Kind2EnumMap = {
  Kind2.like: 'like',
  Kind2.heart: 'heart',
  Kind2.check: 'check',
  Kind2.star: 'star',
  Kind2.$unknown: r'$unknown',
};
