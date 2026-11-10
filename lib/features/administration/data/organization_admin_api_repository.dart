import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/organization_client.dart';
import '../../../core/api/generated/models/account_result.dart';
import '../../../core/api/generated/models/create_user_request.dart';
import '../../../core/api/generated/models/known_user.dart' as api;
import '../../../core/api/generated/models/open_account_request.dart';
import '../../../core/api/generated/models/update_account_request.dart';
import '../../../core/api/generated/models/update_user_request.dart';
import '../../../core/api/generated/models/user_result.dart';
import '../../../core/domain/enum_parse.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../coordinatorships/coordinatorships.dart' show DepartmentKind;
import '../../scope/scope.dart' show DepartmentRole;
import '../domain/organization_admin.dart';
import '../domain/organization_admin_repository.dart';

/// [OrganizationAdminRepository]'nin organization yönetim uçlarıyla gerçekleştirmesi.
/// Üretilmiş istemci burada kurulur (sınır kuralı A2); DTO'lar bu katmanda kalır (A1); her
/// çağrı [apiCall] ile sarılır (hata → [ApiError]). Silinmiş departman uçları S2'dir: program
/// başlığı ara katmandan (seçili kapsam) gelir; diğerleri S1.
class ApiOrganizationAdminRepository implements OrganizationAdminRepository {
  /// [dio]: doğrulanmış bağın API istemcisi.
  ApiOrganizationAdminRepository(Dio dio) : _client = OrganizationClient(dio);

  /// Sözleşmedeki kesilme başlığı.
  static const truncationHeader = 'X-Result-Truncated';

  final OrganizationClient _client;

  @override
  Future<UserDirectoryPage> listUsers({
    PageRequest page = const PageRequest(),
    DepartmentRole? role,
    bool companyAdminOnly = false,
    String? programId,
    String? departmentId,
    String? search,
    UserSortField? sortBy,
    SortDirection? sortOrder,
  }) async {
    final wireRole = role == null ? null : _roleWire(role);
    final r = await apiCall(
      () => _client.listUsers(
        role: companyAdminOnly ? 'company_admin' : wireRole,
        programId: programId,
        departmentId: departmentId,
        search: search,
        sortBy: sortBy?.wire,
        sortOrder: sortOrder?.name,
        limit: page.limit,
        cursor: page.cursor,
      ),
    );
    return UserDirectoryPage(
      total: r.data.total,
      roleCounts: UserRoleCounts(
        all: r.data.roleCounts.all,
        admins: r.data.roleCounts.companyAdmin,
        coordinators: r.data.roleCounts.koordinator,
        members: r.data.roleCounts.uye,
      ),
      items: (r.data.users ?? const <api.KnownUser>[]).map(_knownUser).toList(),
      nextCursor: r.data.nextCursor,
      truncated: _truncated(r.response.headers),
    );
  }

  static AccountStatus _accountStatus(String? wire) => switch (wire) {
    'active' => AccountStatus.active,
    'disabled' => AccountStatus.disabled,
    _ => AccountStatus.unknown,
  };

  static KnownUser _knownUser(api.KnownUser u) => KnownUser(
    accountId: u.accountId,
    fullName: u.fullName,
    email: u.email,
    companyAdmin: u.companyAdmin,
    accountStatus: _accountStatus(u.accountStatus.json),
    loginLocked: u.loginLocked,
    memberships: u.memberships ?? const [],
    teams: [
      for (final t in u.teams)
        UserMembership(
          programId: t.programId,
          programName: t.programName,
          departmentId: t.departmentId,
          displayName: t.displayName,
          role: DepartmentRole.fromWire(t.role.json ?? ''),
        ),
    ],
  );

  @override
  Future<KnownUser> readUser(String accountId) async =>
      _knownUser(await apiCall(() => _client.readUser(id: accountId)));

  @override
  Future<AccountStatusChange> disableAccount(String accountId) async {
    final r = await apiCall(() => _client.disableAccount(id: accountId));
    return AccountStatusChange(
      status: _accountStatus(r.accountStatus.json),
      changed: r.changed,
      revokedSessions: r.revokedSessions,
    );
  }

  @override
  Future<AccountStatusChange> enableAccount(String accountId) async {
    final r = await apiCall(() => _client.enableAccount(id: accountId));
    return AccountStatusChange(
      status: _accountStatus(r.accountStatus.json),
      changed: r.changed,
      revokedSessions: r.revokedSessions,
    );
  }

  @override
  Future<UserChange> createUser({
    required String email,
    required String programId,
    required String departmentId,
    String? fullName,
    DepartmentRole? role,
    String? transferAccountId,
    bool? companyAdmin,
  }) async {
    final wireRole = role == null ? null : _roleWire(role);
    return _user(
      await apiCall(
        () => _client.createUser(
          body: CreateUserRequest(
            email: email,
            programId: programId,
            departmentId: departmentId,
            fullName: fullName,
            role: wireRole,
            transferAccountId: transferAccountId,
            companyAdmin: companyAdmin,
          ),
        ),
      ),
    );
  }

  @override
  Future<UserChange> updateUser(
    String accountId, {
    String? email,
    String? fullName,
    bool? resetPassword,
    bool? forcePasswordChange,
    bool? companyAdmin,
  }) async => _user(
    await apiCall(
      () => _client.updateUser(
        id: accountId,
        body: UpdateUserRequest(
          email: email,
          fullName: fullName,
          resetPassword: resetPassword,
          forcePasswordChange: forcePasswordChange,
          companyAdmin: companyAdmin,
        ),
      ),
    ),
  );

  @override
  Future<UserChange> deleteUser(String accountId) async =>
      _user(await apiCall(() => _client.deleteUser(id: accountId)));

  @override
  Future<AccountChange> openAccount({
    required String email,
    required String password,
    String? fullName,
    bool? forcePasswordChange,
  }) async => _account(
    await apiCall(
      () => _client.openAccount(
        body: OpenAccountRequest(
          email: email,
          password: password,
          fullName: fullName,
          forcePasswordChange: forcePasswordChange,
        ),
      ),
    ),
  );

  @override
  Future<AccountChange> updateAccount(
    String accountId, {
    String? email,
    String? fullName,
    String? password,
    bool? forcePasswordChange,
  }) async => _account(
    await apiCall(
      () => _client.updateAccount(
        id: accountId,
        body: UpdateAccountRequest(
          email: email,
          fullName: fullName,
          password: password,
          forcePasswordChange: forcePasswordChange,
        ),
      ),
    ),
  );

  @override
  Future<AccountChange> deleteAccount(String accountId) async =>
      _account(await apiCall(() => _client.deleteAccount(id: accountId)));

  @override
  Future<AccountChange> unlockAccount(String accountId) async =>
      _account(await apiCall(() => _client.unlockAccount(id: accountId)));

  @override
  Future<LockoutReset> resetLockouts() async {
    final r = await apiCall(_client.resetLockouts);
    return LockoutReset(
      accountsReset: r.accountsReset,
      attemptsCleared: r.attemptsCleared,
    );
  }

  @override
  Future<PageSlice<DeletedDepartment>> listDeletedDepartments({
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => _client.listDeletedDepartments(
        limit: page.limit,
        cursor: page.cursor,
      ),
    );
    return PageSlice(
      items: r.data.departments
          .map(
            (d) => DeletedDepartment(
              departmentId: d.departmentId,
              name: d.name,
              kind: DepartmentKind.fromWire(d.kind),
              deletedAt: DateTime.tryParse(d.deletedAt),
              code: d.code,
            ),
          )
          .toList(),
      nextCursor: r.data.nextCursor,
      truncated: _truncated(r.response.headers),
    );
  }

  @override
  Future<LifecycleStatus> restoreDepartment(String departmentId) async {
    final r = await apiCall(() => _client.restoreDepartment(id: departmentId));
    return _status(r.status.json);
  }

  @override
  Future<LifecycleStatus> permanentDeleteDepartment(String departmentId) async {
    final r = await apiCall(
      () => _client.permanentDeleteDepartment(id: departmentId),
    );
    return _status(r.status.json);
  }

  @override
  Future<PageSlice<DeletedAccount>> listDeletedAccounts({
    PageRequest page = const PageRequest(),
  }) async {
    final r = await apiCall(
      () => _client.listDeletedAccounts(limit: page.limit, cursor: page.cursor),
    );
    return PageSlice(
      items: r.data.accounts
          .map(
            (a) => DeletedAccount(accountId: a.accountId, fullName: a.fullName),
          )
          .toList(),
      nextCursor: r.data.nextCursor,
      truncated: _truncated(r.response.headers),
    );
  }

  @override
  Future<LifecycleStatus> restoreAccount(String accountId) async {
    final r = await apiCall(() => _client.restoreAccount(id: accountId));
    return _status(r.status.json);
  }

  @override
  Future<LifecycleStatus> permanentDeleteAccount(String accountId) async {
    final r = await apiCall(
      () => _client.permanentDeleteAccount(id: accountId),
    );
    return _status(r.status.json);
  }

  /// Giden rol: [DepartmentRole.unknown] programlama hatasıdır; istek atılmadan
  /// [ArgumentError] fırlar ([apiCall] dışında hesaplanır ki `ApiError`'a dönüşmesin).
  static String _roleWire(DepartmentRole role) =>
      role.wire ?? (throw ArgumentError.value(role, 'role'));

  static bool _truncated(Headers headers) {
    final values = headers[truncationHeader];
    return values != null && values.length == 1 && values[0] == 'true';
  }

  static LifecycleStatus _status(String? wire) =>
      enumFromWire(LifecycleStatus.values, wire, LifecycleStatus.unknown);

  static UserChange _user(UserResult r) => UserChange(
    accountId: r.accountId,
    membershipId: r.membershipId,
    created: r.created ?? false,
    transferred: r.transferred ?? false,
    changedFields: r.changedFields ?? const [],
    revokedSessions: r.revokedSessions ?? 0,
  );

  static AccountChange _account(AccountResult r) => AccountChange(
    accountId: r.accountId,
    revokedSessions: r.revokedSessions ?? 0,
  );
}
