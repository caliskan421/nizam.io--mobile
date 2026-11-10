// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRoleCounts _$UserRoleCountsFromJson(Map<String, dynamic> json) =>
    _UserRoleCounts(
      all: (json['all'] as num).toInt(),
      companyAdmin: (json['company_admin'] as num).toInt(),
      koordinator: (json['koordinator'] as num).toInt(),
      uye: (json['uye'] as num).toInt(),
    );

Map<String, dynamic> _$UserRoleCountsToJson(_UserRoleCounts instance) =>
    <String, dynamic>{
      'all': instance.all,
      'company_admin': instance.companyAdmin,
      'koordinator': instance.koordinator,
      'uye': instance.uye,
    };
