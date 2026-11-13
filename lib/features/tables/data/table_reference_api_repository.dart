import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/collaboration_client.dart';
import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/clients/program_client.dart';
import '../../../core/api/generated/clients/records_client.dart';
import '../../../core/api/generated/clients/work_client.dart';
import '../../../core/api/generated/models/my_department.dart';
import '../../../core/api/generated/models/roster_member.dart';
import '../../../core/api/generated/models/roster_member_status.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/table_models.dart';
import '../domain/table_reference_sources.dart';

/// Referans adaylarını sahip modüllerin mevcut uçlarından okur (üretilmiş istemciler; DTO
/// bu katmanda kalır, A1). Her istek kapsamı açıkça sabitlenir.
class ApiTableReferenceSources implements TableReferenceSources {
  ApiTableReferenceSources(this._dio);

  final Dio? Function() _dio;

  /// Kişisel alanda kişi adaylarının en çok sayfa sayısı (sayfa başına 200).
  static const maxPages = 10;

  Dio get _http {
    final d = _dio();
    if (d == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return d;
  }

  static String? _cursor(String? c) => c == null || c.isEmpty ? null : c;

  @override
  Future<List<TableRefCandidate>> people(TableScope scope) async {
    final department = scope.departmentId;
    if (department != null && department.isNotEmpty) {
      final r = await apiCall(
        () => OrganizationClient(_http).listMembers(
          id: department,
          extras: withProgram(
            OrganizationClient.listMembersOpenapiExtras,
            scope.programId,
          ),
        ),
      );
      return [
        for (final m in r.data.members ?? const <RosterMember>[])
          if (m.status == RosterMemberStatus.active)
            TableRefCandidate(id: m.accountId, name: m.fullName),
      ];
    }
    final out = <TableRefCandidate>[];
    String? cursor;
    for (var i = 0; i < maxPages; i++) {
      final page = await apiCall(
        () => CollaborationClient(_http).listMeetingParticipantCandidates(
          limit: 200,
          cursor: cursor,
          extras: withProgram(
            CollaborationClient.listMeetingParticipantCandidatesOpenapiExtras,
            scope.programId,
          ),
        ),
      );
      out.addAll([
        for (final c in page.items)
          TableRefCandidate(id: c.accountId, name: c.fullName),
      ]);
      cursor = _cursor(page.nextCursor);
      if (cursor == null) break;
    }
    return out;
  }

  @override
  Future<List<TableRefCandidate>> departments(TableScope scope) async {
    final me = await apiCall(IdentityClient(_http).me);
    if (me.companyAdmin) {
      final r = await apiCall(
        () => ProgramClient(_http).listProgramDepartments(
          extras: withProgram(
            ProgramClient.listProgramDepartmentsOpenapiExtras,
            scope.programId,
          ),
        ),
      );
      return [
        for (final d in r.data.departments)
          TableRefCandidate(id: d.departmentId, name: d.displayName),
      ];
    }
    final r = await apiCall(OrganizationClient(_http).myDepartments);
    final seen = <String>{};
    return [
      for (final d in r.data.departments ?? const <MyDepartment>[])
        if (d.programId == scope.programId && seen.add(d.departmentId))
          TableRefCandidate(id: d.departmentId, name: d.displayName),
    ];
  }

  @override
  Future<PageSlice<TableRefCandidate>> tasks(
    TableScope scope, {
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => WorkClient(_http).listProgramWorkItems(
        limit: page.limit,
        cursor: page.cursor,
        extras: withProgram(
          WorkClient.listProgramWorkItemsOpenapiExtras,
          scope.programId,
        ),
      ),
    );
    return PageSlice(
      items: [
        for (final w in r.items)
          TableRefCandidate(
            id: w.workItemId,
            name: w.title,
            departmentId: w.departmentId,
          ),
      ],
      nextCursor: _cursor(r.nextCursor),
    );
  }

  @override
  Future<List<TableRefCandidate>> files(
    TableScope scope,
    TableRefCandidate task,
  ) async {
    final department = task.departmentId;
    if (department == null || department.isEmpty) {
      throw ApiError(ClientErrorCode.scopeMissing);
    }
    final r = await apiCall(
      () => RecordsClient(_http).listWorkItemFiles(
        id: task.id,
        extras: withScope(
          RecordsClient.listWorkItemFilesOpenapiExtras,
          scope.programId,
          department,
        ),
      ),
    );
    return [
      for (final f in r.files)
        TableRefCandidate(id: f.fileId, name: f.displayName, detail: task.name),
    ];
  }
}
