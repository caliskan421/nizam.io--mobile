// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinatorship_stat_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoordinatorshipStatList _$CoordinatorshipStatListFromJson(
  Map<String, dynamic> json,
) => _CoordinatorshipStatList(
  coordinatorships: (json['coordinatorships'] as List<dynamic>)
      .map((e) => CoordinatorshipStat.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CoordinatorshipStatListToJson(
  _CoordinatorshipStatList instance,
) => <String, dynamic>{
  'coordinatorships': instance.coordinatorships.map((e) => e.toJson()).toList(),
};
