import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/api/generated/clients/reporting_client.dart';
import '../../../core/api/generated/models/coordinatorship_stat.dart';
import '../../../core/api/generated/models/report_department.dart' as api;
import '../../../core/api/generated/models/report_meeting.dart' as api;
import '../../../core/api/generated/models/report_meeting_created_by_role.dart';
import '../../../core/api/generated/models/report_meeting_detail.dart' as api;
import '../../../core/api/generated/models/report_meeting_note.dart' as api;
import '../../../core/api/generated/models/report_meeting_note_author_role.dart';
import '../../../core/api/generated/models/report_person.dart' as api;
import '../../../core/api/generated/models/report_task.dart' as api;
import '../../../core/api/generated/models/report_task_detail.dart' as api;
import '../../../core/api/generated/models/report_task_priority.dart';
import '../../../core/api/generated/models/season_report.dart' as api;
import '../../../core/api/generated/models/workload_pdf_request.dart';
import '../../../core/api/generated/models/workload_report.dart' as api;
import '../../../core/api/generated/models/workload_task.dart' as api;
import '../../../core/api/generated/models/workload_task_priority.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../domain/report_common.dart';
import '../domain/report_download.dart';
import '../domain/report_meeting.dart';
import '../domain/report_task.dart';
import '../domain/reports_repository.dart';
import '../domain/season_report.dart';
import '../domain/workload_report.dart';

/// reporting uçlarına üretilmiş istemciyle erişim. DTO'lar bu katmanda kalır; dışarıya
/// domain varlıkları döner (A1/A2). Bütün hatalar [ApiError] olarak fırlar.
///
/// PDF uçları burada çağrılmaz: üretilmiş akış imzası (`Stream<String>`) ikili gövdeyi
/// UTF-8 olarak çözer. PDF metotları yalnız indirme bileti hedefini üretir.
class ApiReportsRepository implements ReportsRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (program kapsam başlığını ara katman ekler).
  ApiReportsRepository(Dio dio) : _client = ReportingClient(dio);

  /// Sözleşmedeki kesilme başlığı; yalnız kesildiğinde ve yalnız `true` ile gönderilir.
  static const truncationHeader = 'X-Result-Truncated';

  final ReportingClient _client;

  @override
  Future<ReportTaskList> dashboardTasks() async {
    final r = await apiCall(_client.reportDashboardTasks);
    return ReportTaskList(
      tasks: r.data.tasks.map(_task).toList(),
      total: r.data.total,
      truncated: _truncated(r),
    );
  }

  @override
  Future<PageSlice<ReportMeeting>> dashboardMeetings() async {
    final r = await apiCall(_client.reportDashboardMeetings);
    return PageSlice(
      items: r.data.meetings.map(_meeting).toList(),
      truncated: _truncated(r),
    );
  }

  @override
  Future<ReportTaskDetail> taskDetail(String workItemId) async => _taskDetail(
    await apiCall(() => _client.reportTaskDetail(id: workItemId)),
  );

  @override
  Future<ReportMeetingDetail> meetingDetail(String meetingId) async =>
      _meetingDetail(
        await apiCall(() => _client.reportMeetingDetail(id: meetingId)),
      );

  @override
  Future<WorkloadReport> workload() async =>
      _workload(await apiCall(_client.reportWorkload));

  @override
  Future<SeasonReport> season() async =>
      _season(await apiCall(_client.reportSeason));

  @override
  ReportDownloadTarget taskPdf(String workItemId) => ReportDownloadTarget(
    method: ReportDownloadMethod.get,
    path: '/v1/reports/tasks/${Uri.encodeComponent(workItemId)}/pdf',
  );

  @override
  ReportDownloadTarget meetingPdf(String meetingId) => ReportDownloadTarget(
    method: ReportDownloadMethod.get,
    path: '/v1/reports/meetings/${Uri.encodeComponent(meetingId)}/pdf',
  );

  @override
  ReportDownloadTarget workloadPdf(List<String> memberIds) =>
      ReportDownloadTarget(
        method: ReportDownloadMethod.post,
        path: '/v1/reports/workload',
        body: WorkloadPdfRequest(memberIds: [...memberIds]).toJson(),
      );

  @override
  ReportDownloadTarget seasonPdf() => const ReportDownloadTarget(
    method: ReportDownloadMethod.get,
    path: '/v1/reports/season/pdf',
  );

  // --- eşleme ---

  static bool _truncated(HttpResponse<Object?> r) {
    final values = r.response.headers[truncationHeader];
    return values != null && values.length == 1 && values[0] == 'true';
  }

  static ReportTaskStatus _status(String? wire) => switch (wire) {
    'baslanmadi' => ReportTaskStatus.notStarted,
    'devam_ediyor' => ReportTaskStatus.inProgress,
    'onaya_sunuldu' => ReportTaskStatus.submitted,
    'iade_edildi' => ReportTaskStatus.returned,
    'tamamlandi' => ReportTaskStatus.completed,
    _ => ReportTaskStatus.unknown,
  };

  static ReportPriority _priority(String? wire) => switch (wire) {
    'dusuk' => ReportPriority.low,
    'orta' => ReportPriority.medium,
    'yuksek' => ReportPriority.high,
    'acil' => ReportPriority.urgent,
    _ => ReportPriority.unknown,
  };

  static ReportRole _role(String? wire) => switch (wire) {
    'admin' => ReportRole.admin,
    'coordinator' => ReportRole.coordinator,
    'member' => ReportRole.member,
    _ => ReportRole.unknown,
  };

  static ReportDepartmentKind _kind(String? wire) => switch (wire) {
    'koordinatorluk' => ReportDepartmentKind.coordinatorship,
    'calisma_grubu' => ReportDepartmentKind.workingGroup,
    _ => ReportDepartmentKind.unknown,
  };

  /// Sözleşmenin tanımlamadığı anahtarlar `unknown` üyesi altında toplanır.
  static Map<E, int> _distribution<E extends Enum>(
    Iterable<MapEntry<String, int>> wire,
    E Function(String) parse,
  ) {
    final out = <E, int>{};
    for (final MapEntry(:key, :value) in wire) {
      final k = parse(key);
      out[k] = (out[k] ?? 0) + value;
    }
    return Map.unmodifiable(out);
  }

  static ReportPerson _person(api.ReportPerson p) =>
      ReportPerson(accountId: p.accountId, fullName: p.fullName);

  static ReportDepartment _department(api.ReportDepartment d) =>
      ReportDepartment(
        departmentId: d.departmentId,
        name: d.name,
        kind: d.kind == null ? null : _kind(d.kind),
      );

  static ReportTask _task(api.ReportTask t) => ReportTask(
    workItemId: t.workItemId,
    title: t.title,
    departmentId: t.departmentId,
    departmentName: t.departmentName,
    status: _status(t.status),
    priority: _priority(
      t.priority == ReportTaskPriority.$unknown ? null : t.priority.json,
    ),
    startOn: t.startOn,
    endOn: t.endOn,
    plannedEndOn: t.plannedEndOn,
    completedOn: t.completedOn,
    createdBy: _person(t.createdBy),
    assignees: t.assignees.map(_person).toList(),
    isOverdue: t.isOverdue,
    daysOverdue: t.daysOverdue,
    isCompletedLate: t.isCompletedLate,
    daysLate: t.daysLate,
    isCompletedEarly: t.isCompletedEarly,
    daysEarly: t.daysEarly,
    hasPendingDependency: t.hasPendingDependency,
    dependencyCount: t.dependencyCount,
    noteCount: t.noteCount,
    createdAt: t.createdAt,
  );

  static ReportTaskDetail _taskDetail(api.ReportTaskDetail d) =>
      ReportTaskDetail(
        task: _task(d.task),
        description: d.description,
        dependencies: [
          for (final r in d.dependencies)
            ReportTaskRef(
              workItemId: r.workItemId,
              title: r.title,
              status: _status(r.status),
              departmentName: r.departmentName,
            ),
        ],
        recentNotes: [
          for (final n in d.recentNotes)
            ReportTaskNote(
              content: n.content,
              author: _person(n.author),
              createdAt: n.createdAt,
            ),
        ],
      );

  static ReportMeeting _meeting(api.ReportMeeting m) => ReportMeeting(
    meetingId: m.meetingId,
    title: m.title,
    meetingDate: m.meetingDate,
    ownerDepartmentId: m.ownerDepartmentId,
    coordinatorships: [
      for (final d in m.coordinatorships)
        ReportMeetingDepartment(
          departmentId: d.departmentId,
          name: d.name,
          deleted: d.deleted,
        ),
    ],
    createdBy: _person(m.createdBy),
    createdByRole: _role(
      m.createdByRole == ReportMeetingCreatedByRole.$unknown
          ? null
          : m.createdByRole.json,
    ),
    membersIncluded: m.membersIncluded,
    participants: m.participants.map(_person).toList(),
    participantCount: m.participantCount,
    noteCount: m.noteCount,
  );

  static ReportMeetingNote _meetingNote(api.ReportMeetingNote n) =>
      ReportMeetingNote(
        noteId: n.noteId,
        content: n.content,
        author: _person(n.author),
        authorRole: switch (n.authorRole) {
          ReportMeetingNoteAuthorRole.empty => null,
          ReportMeetingNoteAuthorRole.$unknown => ReportRole.unknown,
          final r => _role(r.json),
        },
        createdAt: n.createdAt,
        convertedToTaskId: n.convertedToTaskId,
        convertedTaskTitle: n.convertedTaskTitle,
      );

  static ReportMeetingDetail _meetingDetail(api.ReportMeetingDetail d) =>
      ReportMeetingDetail(
        meeting: _meeting(d.meeting),
        participants: [
          for (final p in d.participants)
            ReportParticipant(
              accountId: p.accountId,
              fullName: p.fullName,
              role: _role(p.role),
            ),
        ],
        agenda: [
          for (final a in d.agenda)
            ReportAgendaItem(title: a.title, isChecked: a.isChecked),
        ],
        notes: d.notes.map(_meetingNote).toList(),
      );

  static WorkloadTask _workloadTask(api.WorkloadTask t) => WorkloadTask(
    workItemId: t.workItemId,
    title: t.title,
    status: _status(t.status),
    priority: _priority(
      t.priority == WorkloadTaskPriority.$unknown ? null : t.priority.json,
    ),
    startOn: t.startOn,
    endOn: t.endOn,
    completedOn: t.completedOn,
    departmentId: t.departmentId,
    departmentName: t.departmentName,
    isOverdue: t.isOverdue,
    daysOverdue: t.daysOverdue,
    attachmentCount: t.attachmentCount,
    hasAttachment: t.hasAttachment,
    latestNote: t.latestNote,
  );

  static WorkloadReport _workload(api.WorkloadReport r) => WorkloadReport(
    programId: r.programId,
    programName: r.programName,
    members: [
      for (final m in r.members)
        WorkloadMember(
          accountId: m.accountId,
          fullName: m.fullName,
          coordinatorships: m.coordinatorships.map(_department).toList(),
          tasks: m.tasks.map(_workloadTask).toList(),
        ),
    ],
    coordinatorships: r.coordinatorships.map(_department).toList(),
    total: r.total,
    generatedAt: r.generatedAt,
  );

  static ReportCoordinatorshipStat _coordinatorship(CoordinatorshipStat s) =>
      ReportCoordinatorshipStat(
        departmentId: s.departmentId,
        name: s.name,
        kind: _kind(s.kind),
        coordinators: s.coordinators.map(_person).toList(),
        totalTasks: s.totalTasks,
        completedTasks: s.completedTasks,
        inProgressTasks: s.inProgressTasks,
        notStartedTasks: s.notStartedTasks,
        overdueTasks: s.overdueTasks,
        completionRate: s.completionRate,
        memberCount: s.memberCount,
        meetingCount: s.meetingCount,
        lastActivityAt: s.lastActivityAt == null
            ? null
            : DateTime.tryParse(s.lastActivityAt!),
        description: s.description,
      );

  static SeasonReport _season(api.SeasonReport r) {
    final s = r.stats;
    final m = r.meetingStats;
    return SeasonReport(
      programId: r.programId,
      programName: r.programName,
      stats: SeasonStats(
        totalTasks: s.totalTasks,
        completedTasks: s.completedTasks,
        completionRate: s.completionRate.toDouble(),
        overdueTasks: s.overdueTasks,
        totalNotes: s.totalNotes,
        totalAttachments: s.totalAttachments,
        totalMeetings: s.totalMeetings,
        totalMessages: s.totalMessages,
        totalCoordinatorships: s.totalCoordinatorships,
        totalUsers: s.totalUsers,
        totalMembers: s.totalMembers,
      ),
      coordinatorshipPerformance: r.coordinatorshipPerformance
          .map(_coordinatorship)
          .toList(),
      statusDistribution: _distribution(
        r.taskStatusDistribution.entries,
        _status,
      ),
      priorityDistribution: _distribution(
        r.priorityDistribution.entries,
        _priority,
      ),
      tasks: r.tasks.map(_task).toList(),
      meetingStats: SeasonMeetingStats(
        totalMeetings: m.totalMeetings,
        totalNotes: m.totalNotes,
        convertedToTask: m.convertedToTask,
        totalParticipants: m.totalParticipants,
      ),
      messageStats: SeasonMessageStats(
        total: r.messageStats.total,
        fromAdmins: r.messageStats.fromAdmins,
        fromOthers: r.messageStats.fromOthers,
      ),
      dateChangeStats: SeasonDateChangeStats(
        total: r.dateChangeStats.total,
        approved: r.dateChangeStats.approved,
        rejected: r.dateChangeStats.rejected,
        pending: r.dateChangeStats.pending,
      ),
      monthlyActivity: [
        for (final a in r.monthlyActivity)
          SeasonMonthlyActivity(
            month: a.month,
            createdTasks: a.createdTasks,
            completedTasks: a.completedTasks,
            meetings: a.meetings,
            messages: a.messages,
            count: a.count,
          ),
      ],
      generatedAt: r.generatedAt,
    );
  }
}
