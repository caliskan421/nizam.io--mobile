import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/models/assign_membership_request.dart';
import '../../../core/api/generated/models/assign_membership_request_role.dart';
import '../../../core/api/generated/models/assignable_account.dart' as api;
import '../../../core/api/generated/models/change_role_request.dart';
import '../../../core/api/generated/models/change_role_request_role.dart';
import '../../../core/api/generated/models/confirm.dart';
import '../../../core/api/generated/models/coordinator_request.dart';
import '../../../core/api/generated/models/create_department_request.dart';
import '../../../core/api/generated/models/create_department_request_kind.dart';
import '../../../core/api/generated/models/department.dart' as api;
import '../../../core/api/generated/models/membership_change.dart' as api;
import '../../../core/api/generated/models/roster_member.dart';
import '../../../core/api/generated/models/update_department_request.dart';
import '../../../core/api/generated/models/update_department_request_kind.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../scope/scope.dart' show DepartmentRole;
import '../domain/coordinatorship_overview.dart';
import '../domain/department.dart';
import '../domain/department_repository.dart';

/// [DepartmentRepository]'nin organization uçlarıyla gerçekleştirmesi. Üretilmiş istemci
/// burada kurulur (sınır kuralı A2); DTO'lar bu katmanda kalır (A1); her çağrı [apiCall] ile
/// sarılır (hata → [ApiError]). Kapsam başlığı gönderilmez (S1).
class ApiDepartmentRepository implements DepartmentRepository {
  /// [dio]: doğrulanmış bağın API istemcisi.
  ApiDepartmentRepository(Dio dio) : _client = OrganizationClient(dio);

  /// Sözleşmedeki kesilme başlığı (imleçsiz listeler, en çok 200 satır).
  static const truncationHeader = 'X-Result-Truncated';

  final OrganizationClient _client;

  @override
  Future<PageSlice<Department>> listDepartments() async {
    final r = await apiCall(_client.listDepartments);
    return PageSlice(
      items: r.data.departments.map(_department).toList(),
      truncated: _truncated(r.response.headers),
    );
  }

  @override
  Future<Department> createDepartment({
    required String name,
    required DepartmentKind kind,
    String? code,
    String? description,
  }) async {
    final wireKind = switch (kind) {
      DepartmentKind.coordinatorship =>
        CreateDepartmentRequestKind.koordinatorluk,
      DepartmentKind.workingGroup => CreateDepartmentRequestKind.calismaGrubu,
      DepartmentKind.unknown => throw ArgumentError.value(kind, 'kind'),
    };
    return _department(
      await apiCall(
        () => _client.createDepartment(
          body: CreateDepartmentRequest(
            name: name,
            kind: wireKind,
            code: code,
            description: description,
          ),
        ),
      ),
    );
  }

  @override
  Future<Department> updateDepartment(
    String departmentId, {
    String? name,
    DepartmentKind? kind,
    String? code,
    String? description,
  }) async {
    final wireKind = switch (kind) {
      null => null,
      DepartmentKind.coordinatorship =>
        UpdateDepartmentRequestKind.koordinatorluk,
      DepartmentKind.workingGroup => UpdateDepartmentRequestKind.calismaGrubu,
      DepartmentKind.unknown => throw ArgumentError.value(kind, 'kind'),
    };
    return _department(
      await apiCall(
        () => _client.updateDepartment(
          id: departmentId,
          body: UpdateDepartmentRequest(
            name: name,
            kind: wireKind,
            code: code,
            description: description,
          ),
        ),
      ),
    );
  }

  @override
  Future<bool> deleteDepartment(String departmentId) async {
    final r = await apiCall(() => _client.deleteDepartment(id: departmentId));
    return r.deleted;
  }

  @override
  Future<PageSlice<TeamMember>> listMembers(String departmentId) async {
    final r = await apiCall(() => _client.listMembers(id: departmentId));
    return PageSlice(
      items: (r.data.members ?? const <RosterMember>[]).map(_member).toList(),
      truncated: _truncated(r.response.headers),
    );
  }

  @override
  Future<Membership> assignMembership(
    String departmentId, {
    required String accountId,
    required DepartmentRole role,
  }) async {
    final wireRole = switch (role) {
      DepartmentRole.coordinator => AssignMembershipRequestRole.koordinator,
      DepartmentRole.member => AssignMembershipRequestRole.uye,
      DepartmentRole.unknown => throw ArgumentError.value(role, 'role'),
    };
    final r = await apiCall(
      () => _client.assignMembership(
        id: departmentId,
        body: AssignMembershipRequest(accountId: accountId, role: wireRole),
      ),
    );
    return Membership(
      membershipId: r.membershipId,
      departmentId: r.departmentId,
      accountId: r.accountId,
      role: DepartmentRole.fromWire(r.role),
    );
  }

  @override
  Future<MembershipChange> changeMembershipRole(
    String departmentId,
    String accountId, {
    required DepartmentRole role,
    bool confirm = false,
  }) async {
    final wireRole = switch (role) {
      DepartmentRole.coordinator => ChangeRoleRequestRole.koordinator,
      DepartmentRole.member => ChangeRoleRequestRole.uye,
      DepartmentRole.unknown => throw ArgumentError.value(role, 'role'),
    };
    return _change(
      await apiCall(
        () => _client.updateMembershipRole(
          id: departmentId,
          accountId: accountId,
          body: ChangeRoleRequest(
            role: wireRole,
            confirm: confirm ? true : null,
          ),
        ),
      ),
    );
  }

  @override
  Future<MembershipChange> removeMember(
    String departmentId,
    String accountId, {
    bool confirm = false,
  }) async => _change(
    await apiCall(
      () => _client.removeMember(
        id: departmentId,
        accountId: accountId,
        confirm: _confirm(confirm),
      ),
    ),
  );

  @override
  Future<PageSlice<AssignableAccount>> listAssignable(
    String departmentId,
  ) async {
    final r = await apiCall(() => _client.listAssignable(id: departmentId));
    return PageSlice(
      items: (r.data.accounts ?? const <api.AssignableAccount>[])
          .map(
            (a) => AssignableAccount(
              accountId: a.accountId,
              fullName: a.fullName,
              roles: a.roles ?? const [],
            ),
          )
          .toList(),
      truncated: _truncated(r.response.headers),
    );
  }

  @override
  Future<Membership> assignCoordinator(
    String departmentId,
    String accountId,
  ) async {
    final r = await apiCall(
      () => _client.assignCoordinator(
        id: departmentId,
        body: CoordinatorRequest(accountId: accountId),
      ),
    );
    return Membership(
      membershipId: r.membershipId,
      departmentId: r.departmentId,
      accountId: r.accountId,
      role: DepartmentRole.fromWire(r.role),
      changed: r.changed,
    );
  }

  @override
  Future<MembershipChange> removeCoordinator(
    String departmentId,
    String accountId, {
    bool confirm = false,
  }) async => _change(
    await apiCall(
      () => _client.removeCoordinator(
        id: departmentId,
        accountId: accountId,
        confirm: _confirm(confirm),
      ),
    ),
  );

  @override
  Future<DepartmentTaskSummary> taskSummary(String departmentId) async {
    final r = await apiCall(() => _client.taskSummary(id: departmentId));
    return DepartmentTaskSummary(
      departmentId: r.departmentId,
      activeItems: r.activeItems,
      completedItems: r.completedItems,
    );
  }

  /// Onay yalnız verildiğinde gönderilir (`confirm=true`); yokluğu sunucuda "onaysız"dır.
  static Confirm? _confirm(bool confirm) => confirm ? Confirm.valueTrue : null;

  static bool _truncated(Headers headers) {
    final values = headers[truncationHeader];
    return values != null && values.length == 1 && values[0] == 'true';
  }

  static Department _department(api.Department r) => Department(
    id: r.departmentId,
    name: r.name,
    kind: DepartmentKind.fromWire(r.kind),
    code: r.code,
    description: r.description,
  );

  static TeamMember _member(RosterMember r) {
    final role = DepartmentRole.fromWire(r.role);
    return TeamMember(
      name: r.fullName,
      lead: role == DepartmentRole.coordinator,
      accountId: r.accountId,
      membershipId: r.membershipId,
      role: role,
      status: enumFromWire(
        MemberStatus.values,
        r.status.json,
        MemberStatus.unknown,
      ),
    );
  }

  static MembershipChange _change(api.MembershipChange r) => MembershipChange(
    membershipId: r.membershipId,
    unassignedTasks: r.unassignedTasks,
    warning: r.warning,
  );
}
