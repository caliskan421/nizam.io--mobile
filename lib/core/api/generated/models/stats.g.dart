// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stats _$StatsFromJson(Map<String, dynamic> json) => _Stats(
  totalTasks: (json['total_tasks'] as num).toInt(),
  completedTasks: (json['completed_tasks'] as num).toInt(),
  completionRate: json['completion_rate'] as num,
  overdueTasks: (json['overdue_tasks'] as num).toInt(),
  totalNotes: (json['total_notes'] as num).toInt(),
  totalAttachments: (json['total_attachments'] as num).toInt(),
  totalMeetings: (json['total_meetings'] as num).toInt(),
  totalMessages: (json['total_messages'] as num).toInt(),
  totalCoordinatorships: (json['total_coordinatorships'] as num).toInt(),
  totalUsers: (json['total_users'] as num).toInt(),
  totalMembers: (json['total_members'] as num).toInt(),
);

Map<String, dynamic> _$StatsToJson(_Stats instance) => <String, dynamic>{
  'total_tasks': instance.totalTasks,
  'completed_tasks': instance.completedTasks,
  'completion_rate': instance.completionRate,
  'overdue_tasks': instance.overdueTasks,
  'total_notes': instance.totalNotes,
  'total_attachments': instance.totalAttachments,
  'total_meetings': instance.totalMeetings,
  'total_messages': instance.totalMessages,
  'total_coordinatorships': instance.totalCoordinatorships,
  'total_users': instance.totalUsers,
  'total_members': instance.totalMembers,
};
