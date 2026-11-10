import '../../../core/errors/api_error.dart';
import '../../scope/scope.dart';

class AccountTeamDraft {
  const AccountTeamDraft({required this.departmentId, required this.role});
  final String departmentId;
  final DepartmentRole role;
}

class AccountDraftValues {
  AccountDraftValues({
    required this.fullName,
    required this.email,
    required this.companyAdmin,
    required List<AccountTeamDraft> teams,
  }) : teams = List.unmodifiable(teams);
  final String fullName;
  final String? email;
  final bool? companyAdmin;
  final List<AccountTeamDraft> teams;
  AccountDraftValues copyWith({
    String? fullName,
    String? Function()? email,
    bool? Function()? companyAdmin,
    List<AccountTeamDraft>? teams,
  }) => AccountDraftValues(
    fullName: fullName ?? this.fullName,
    email: email == null ? this.email : email(),
    companyAdmin: companyAdmin == null ? this.companyAdmin : companyAdmin(),
    teams: teams ?? this.teams,
  );
}

class UserAccountDraft {
  const UserAccountDraft({
    required this.base,
    required this.value,
    this.password = '',
    this.roleForNew = DepartmentRole.member,
    this.busy = false,
    this.error,
  });
  final AccountDraftValues base;
  final AccountDraftValues value;

  /// Only an unsaved replacement. Cleared immediately after the server accepts it.
  final String password;
  final DepartmentRole roleForNew;
  final bool busy;
  final ApiError? error;
  bool get basicChanged =>
      base.fullName != value.fullName ||
      base.email != value.email ||
      password.isNotEmpty;
  bool get adminChanged => base.companyAdmin != value.companyAdmin;
  bool get dirty =>
      basicChanged || adminChanged || !sameTeams(base.teams, value.teams);
  bool get valid =>
      value.fullName.trim().isNotEmpty &&
      (value.email == base.email ||
          value.email != null &&
              RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.email!));
  UserAccountDraft copyWith({
    AccountDraftValues? base,
    AccountDraftValues? value,
    String? password,
    DepartmentRole? roleForNew,
    bool? busy,
    ApiError? Function()? error,
  }) => UserAccountDraft(
    base: base ?? this.base,
    value: value ?? this.value,
    password: password ?? this.password,
    roleForNew: roleForNew ?? this.roleForNew,
    busy: busy ?? this.busy,
    error: error == null ? this.error : error(),
  );
  static bool sameTeams(List<AccountTeamDraft> a, List<AccountTeamDraft> b) =>
      a.length == b.length &&
      a.every(
        (x) =>
            b.any((y) => x.departmentId == y.departmentId && x.role == y.role),
      );
}

enum AccountSaveResult { saved, cancelled, failed, unchanged }
