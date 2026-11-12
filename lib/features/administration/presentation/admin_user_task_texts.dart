import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../tasks/tasks.dart';
import '../domain/admin_user_tasks.dart';

String userTaskStatusLabel(BuildContext context, TaskStatus status) =>
    switch (status) {
      TaskStatus.todo => context.l10n.uiUsersNotStarted,
      TaskStatus.inProgress => context.l10n.uiUsersInProgress,
      TaskStatus.review => context.l10n.uiUsersReview,
      TaskStatus.returned => context.l10n.uiUsersReturned,
      TaskStatus.done => context.l10n.uiUsersDone,
      TaskStatus.unknown => context.l10n.uiUsersUnknownStatus,
    };
Color userTaskStatusColor(BuildContext context, TaskStatus status) =>
    switch (status) {
      TaskStatus.todo || TaskStatus.unknown => context.colors.textMuted,
      TaskStatus.inProgress => context.colors.inProgress,
      TaskStatus.review => context.colors.warning,
      TaskStatus.returned => context.colors.danger,
      TaskStatus.done => context.colors.taskDone,
    };
String userTaskFilterLabel(BuildContext context, UserTaskStatus status) =>
    switch (status) {
      UserTaskStatus.open => context.l10n.uiUsersTaskOpenFilter,
      UserTaskStatus.late => context.l10n.uiUsersTaskLateFilter,
      UserTaskStatus.review => context.l10n.uiUsersTaskReviewFilter,
      UserTaskStatus.done => context.l10n.uiUsersTaskDoneFilter,
    };
String userTaskPriorityLabel(BuildContext context, TaskPriority priority) =>
    switch (priority) {
      TaskPriority.high => context.l10n.uiTasksPrioHigh,
      TaskPriority.medium => context.l10n.uiTasksPrioMedium,
      TaskPriority.low => context.l10n.uiTasksPrioLow,
      TaskPriority.urgent => context.l10n.uiUsersTaskUrgent,
      TaskPriority.unknown => context.l10n.uiUsersTaskUnknownPriority,
    };
String userTaskGroupLabel(BuildContext context, UserTaskGroup group) =>
    switch (group) {
      UserTaskGroup.late => context.l10n.uiUsersTaskGroupLate,
      UserTaskGroup.week => context.l10n.uiUsersTaskGroupWeek,
      UserTaskGroup.later => context.l10n.uiUsersTaskGroupLater,
      UserTaskGroup.done => context.l10n.uiUsersTaskGroupDone,
    };
