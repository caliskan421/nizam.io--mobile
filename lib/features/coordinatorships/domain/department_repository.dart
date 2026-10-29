import '../../../core/domain/page_slice.dart';
import '../../scope/scope.dart' show DepartmentRole;
import 'coordinatorship_overview.dart';
import 'department.dart';

/// Departman, üyelik ve koordinatörlük işlemleri (organization modülü, S1). Yetki sunucudadır
/// (çoğu yalnız şirket yöneticisi; üye listesi koordinatöre de açık); istemci yetki türetmez.
/// Gerçekleştirme `data/`; bütün hatalar `ApiError` olarak fırlar.
abstract interface class DepartmentRepository {
  /// `GET /v1/departments`: imleçsiz; kesilme `PageSlice.truncated`.
  Future<PageSlice<Department>> listDepartments();

  /// `POST /v1/departments`. [kind] [DepartmentKind.unknown] olamaz.
  Future<Department> createDepartment({
    required String name,
    required DepartmentKind kind,
    String? code,
    String? description,
  });

  /// `PATCH /v1/departments/{id}`: `null` alan değişmez.
  Future<Department> updateDepartment(
    String departmentId, {
    String? name,
    DepartmentKind? kind,
    String? code,
    String? description,
  });

  /// `DELETE /v1/departments/{id}` (geri alınabilir silme). Dönen: sunucu sildi mi.
  Future<bool> deleteDepartment(String departmentId);

  /// `GET /v1/departments/{id}/members`: imleçsiz; kesilme `PageSlice.truncated`.
  Future<PageSlice<TeamMember>> listMembers(String departmentId);

  /// `POST /v1/departments/{id}/memberships`.
  Future<Membership> assignMembership(
    String departmentId, {
    required String accountId,
    required DepartmentRole role,
  });

  /// `PATCH /v1/departments/{id}/memberships/{accountId}`. Görev etkisi varsa sunucu
  /// [confirm] olmadan 409 `organization.confirmation_required` döner.
  Future<MembershipChange> changeMembershipRole(
    String departmentId,
    String accountId, {
    required DepartmentRole role,
    bool confirm = false,
  });

  /// `DELETE /v1/departments/{id}/memberships/{accountId}`.
  Future<MembershipChange> removeMember(
    String departmentId,
    String accountId, {
    bool confirm = false,
  });

  /// `GET /v1/departments/{id}/assignable`: imleçsiz; kesilme `PageSlice.truncated`.
  Future<PageSlice<AssignableAccount>> listAssignable(String departmentId);

  /// `POST /v1/departments/{id}/coordinator`.
  Future<Membership> assignCoordinator(String departmentId, String accountId);

  /// `DELETE /v1/departments/{id}/coordinator/{accountId}`.
  Future<MembershipChange> removeCoordinator(
    String departmentId,
    String accountId, {
    bool confirm = false,
  });

  /// `GET /v1/departments/{id}/task-summary`.
  Future<DepartmentTaskSummary> taskSummary(String departmentId);
}
