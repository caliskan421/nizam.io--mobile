import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' show HttpResponse;

import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/clients/program_client.dart';
import '../../../core/api/generated/models/assignable_account.dart' as api;
import '../../../core/api/generated/models/assignable_list.dart';
import '../../../core/api/generated/models/program_department_list.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/interceptors.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/meeting_invitees.dart';
import '../domain/task_catalog.dart';

/// Kişi kipindeki toplantının program havuzu (yönetici olmayan koordinatör). Yönetim yüzlerinden
/// yalnız koordinatöre açık olan iki okuma birleşir (program açıkça sabitlenir, S2):
/// `listAssignable` (`GET /v1/departments/{id}/assignable`: herhangi bir programda ekip satırı
/// olan canlı hesaplar − bu departmanın ekibi; `roles` seçili programdaki diğer departman
/// bağları, `departman:rol`) ve `listProgramDepartments` (programdaki departman adları).
/// `roles` boş olan hesap bu programda ekip satırı taşımaz, havuza girmez (sunucu onu 422 ile
/// reddederdi, COLLABORATION-K21). İki uçtan birinde `X-Result-Truncated` ya da adı okunamayan
/// departman varsa [MeetingInvitees.partial].
class ApiMeetingInviteeRepository implements MeetingInviteeRepository {
  ApiMeetingInviteeRepository(this._dio, {required this.programId});

  /// Doğrulanmış bağın API istemcisi; bağ yoksa null.
  final Dio? Function() _dio;

  /// Seçili programın kimliği (istek anında okunur).
  final String? Function() programId;

  static const truncationHeader = 'X-Result-Truncated';

  @override
  Future<MeetingInvitees> programPeople(String departmentId) async {
    final dio = _dio();
    if (dio == null) throw ApiError(ClientErrorCode.serverNotVerified);
    final program = programId();
    if (program == null || program.isEmpty) {
      throw ApiError(ClientErrorCode.scopeMissing);
    }
    final org = OrganizationClient(dio);
    final prog = ProgramClient(dio);
    // eagerError: ilk hata fırlar, diğerleri yutulur (işlenmemiş hata kalmaz).
    final r = await Future.wait<Object>([
      apiCall(
        () => org.listAssignable(
          id: departmentId,
          extras: withProgram(
            OrganizationClient.listAssignableOpenapiExtras,
            program,
          ),
        ),
      ),
      apiCall(
        () => prog.listProgramDepartments(
          extras: withProgram(
            ProgramClient.listProgramDepartmentsOpenapiExtras,
            program,
          ),
        ),
      ),
    ], eagerError: true);
    final pool = r[0] as HttpResponse<AssignableList>;
    final depts = r[1] as HttpResponse<ProgramDepartmentList>;
    var partial =
        _truncated(pool.response.headers) || _truncated(depts.response.headers);

    // (departman, hesap, koordinatör mü) bağları; `roles` öğesi `departman:rol`.
    final accounts = pool.data.accounts ?? const <api.AssignableAccount>[];
    final seats = [
      for (final a in accounts)
        for (final role in a.roles ?? const <String>[])
          if (role.lastIndexOf(':') case final i when i > 0)
            (
              dept: role.substring(0, i),
              id: a.accountId,
              lead: role.substring(i + 1) == 'koordinator',
            ),
    ];
    final known = {for (final d in depts.data.departments) d.departmentId};
    if (seats.any((s) => !known.contains(s.dept))) partial = true;
    List<String> ids(String dept, {required bool lead}) => [
      for (final s in seats)
        if (s.dept == dept && s.lead == lead) s.id,
    ];
    return MeetingInvitees(
      groups: [
        for (final d in depts.data.departments)
          CoordinatorshipRef(
            code: d.departmentId,
            name: d.displayName,
            shortCode: d.code,
            leads: ids(d.departmentId, lead: true),
            members: ids(d.departmentId, lead: false),
          ),
      ],
      names: [
        for (final a in accounts)
          if (a.roles?.isNotEmpty ?? false) PersonName(a.accountId, a.fullName),
      ],
      partial: partial,
    );
  }

  static bool _truncated(Headers h) {
    final v = h[truncationHeader];
    return v != null && v.length == 1 && v[0] == 'true';
  }
}
