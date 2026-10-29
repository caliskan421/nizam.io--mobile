import '../../../core/domain/page_slice.dart';
import '../../scope/scope.dart' show DepartmentRole;
import 'organization_admin.dart';

/// Şirket yöneticisi işlemleri: kullanıcılar, hesaplar, giriş kilitleri, silinmiş departman ve
/// hesapların geri yüklenmesi/kalıcı silinmesi (organization modülü, S1). Yetki sunucudadır;
/// istemci yetki türetmez. Gerçekleştirme `data/`; bütün hatalar `ApiError` olarak fırlar.
/// Parolalar yalnız istek gövdesine girer; hiçbir yerde saklanmaz.
abstract interface class OrganizationAdminRepository {
  /// `GET /v1/admin/users` (imleçli). [search] Türkçe büyük/küçük harf duyarsızdır; sıralama
  /// ekseni değişince eski imleç 422 `identity.invalid_cursor` alır.
  Future<PageSlice<KnownUser>> listUsers({
    PageRequest page = const PageRequest(),
    DepartmentRole? role,
    String? search,
    UserSortField? sortBy,
    SortDirection? sortOrder,
  });

  /// `POST /v1/admin/users`: kullanıcı oluşturur ya da [transferAccountId] verilirse mevcut
  /// hesabı [departmentId]'ye aktarır.
  Future<UserChange> createUser({
    required String email,
    required String departmentId,
    String? fullName,
    DepartmentRole? role,
    String? transferAccountId,
    bool? companyAdmin,
  });

  /// `PATCH /v1/admin/users/{id}`: `null` alan değişmez.
  Future<UserChange> updateUser(
    String accountId, {
    String? email,
    String? fullName,
    bool? resetPassword,
    bool? forcePasswordChange,
    bool? companyAdmin,
  });

  /// `DELETE /v1/admin/users/{id}` (geri alınabilir silme).
  Future<UserChange> deleteUser(String accountId);

  /// `POST /v1/admin/accounts`: parolayı çağıran verir.
  Future<AccountChange> openAccount({
    required String email,
    required String password,
    String? fullName,
    bool? forcePasswordChange,
  });

  /// `PATCH /v1/admin/accounts/{id}`: parola atanırsa hedefin oturumları düşer.
  Future<AccountChange> updateAccount(
    String accountId, {
    String? email,
    String? fullName,
    String? password,
    bool? forcePasswordChange,
  });

  /// `DELETE /v1/admin/accounts/{id}` (yumuşak silme; oturumlar düşer).
  Future<AccountChange> deleteAccount(String accountId);

  /// `POST /v1/admin/accounts/{id}/unlock`.
  Future<AccountChange> unlockAccount(String accountId);

  /// `POST /v1/admin/security/reset-lockouts`.
  Future<LockoutReset> resetLockouts();

  /// `GET /v1/admin/deleted/departments` (imleçli).
  Future<PageSlice<DeletedDepartment>> listDeletedDepartments({
    PageRequest page = const PageRequest(),
  });

  /// `PATCH /v1/admin/restore/departments/{id}`.
  Future<LifecycleStatus> restoreDepartment(String departmentId);

  /// `DELETE /v1/admin/permanent/departments/{id}`.
  Future<LifecycleStatus> permanentDeleteDepartment(String departmentId);

  /// `GET /v1/admin/deleted/accounts` (imleçli).
  Future<PageSlice<DeletedAccount>> listDeletedAccounts({
    PageRequest page = const PageRequest(),
  });

  /// `PATCH /v1/admin/restore/accounts/{id}`.
  Future<LifecycleStatus> restoreAccount(String accountId);

  /// `DELETE /v1/admin/permanent/accounts/{id}`.
  Future<LifecycleStatus> permanentDeleteAccount(String accountId);
}
