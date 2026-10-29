// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extend_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtendResult _$ExtendResultFromJson(Map<String, dynamic> json) =>
    _ExtendResult(
      cascadeCount: (json['cascade_count'] as num).toInt(),
      newEndOn: const DateOnlyConverter().fromJson(
        json['new_end_on'] as String,
      ),
    );

Map<String, dynamic> _$ExtendResultToJson(_ExtendResult instance) =>
    <String, dynamic>{
      'cascade_count': instance.cascadeCount,
      'new_end_on': const DateOnlyConverter().toJson(instance.newEndOn),
    };
