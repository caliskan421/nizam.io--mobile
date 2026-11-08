// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_unread_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatUnreadProgram _$ChatUnreadProgramFromJson(Map<String, dynamic> json) =>
    _ChatUnreadProgram(
      programId: json['program_id'] as String,
      programName: json['program_name'] as String,
      unreadChats: (json['unread_chats'] as num).toInt(),
      mentioned: json['mentioned'] as bool,
    );

Map<String, dynamic> _$ChatUnreadProgramToJson(_ChatUnreadProgram instance) =>
    <String, dynamic>{
      'program_id': instance.programId,
      'program_name': instance.programName,
      'unread_chats': instance.unreadChats,
      'mentioned': instance.mentioned,
    };
