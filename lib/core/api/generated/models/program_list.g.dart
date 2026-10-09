// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgramList _$ProgramListFromJson(Map<String, dynamic> json) => _ProgramList(
  programs: (json['programs'] as List<dynamic>)
      .map((e) => Program.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProgramListToJson(_ProgramList instance) =>
    <String, dynamic>{
      'programs': instance.programs.map((e) => e.toJson()).toList(),
    };
