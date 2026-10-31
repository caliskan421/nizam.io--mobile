// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/account_lifecycle_result.dart';
import '../models/account_result.dart';
import '../models/assign_membership_request.dart';
import '../models/assignable_list.dart';
import '../models/change_role_request.dart';
import '../models/confirm.dart';
import '../models/coordinator_request.dart';
import '../models/coordinator_result.dart';
import '../models/create_department_request.dart';
import '../models/create_user_request.dart';
import '../models/delete_department_result.dart';
import '../models/deleted_account_list.dart';
import '../models/deleted_department_list.dart';
import '../models/department.dart';
import '../models/department_lifecycle_result.dart';
import '../models/department_list.dart';
import '../models/lockout_reset_result.dart';
import '../models/membership.dart';
import '../models/membership_change.dart';
import '../models/my_department_list.dart';
import '../models/open_account_request.dart';
import '../models/roster_list.dart';
import '../models/task_summary.dart';
import '../models/update_account_request.dart';
import '../models/update_department_request.dart';
import '../models/update_user_request.dart';
import '../models/user_list.dart';
import '../models/user_result.dart';

part 'organization_client.g.dart';

@RestApi()
abstract class OrganizationClient {
  factory OrganizationClient(Dio dio, {String? baseUrl}) = _OrganizationClient;

  static const Map<String, dynamic> myDepartmentsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "myDepartments",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listDepartmentsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "listDepartments",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> createDepartmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "createDepartment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateDepartmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "updateDepartment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteDepartmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "deleteDepartment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listMembersOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "listMembers",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> assignMembershipOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "assignMembership",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateMembershipRoleOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "updateMembershipRole",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> removeMemberOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "removeMember",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listAssignableOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "listAssignable",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> assignCoordinatorOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "assignCoordinator",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> removeCoordinatorOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "removeCoordinator",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> taskSummaryOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "taskSummary",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listUsersOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["organization"],
      'operationId': "listUsers",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> createUserOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["organization"],
      'operationId': "createUser",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> updateUserOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["organization"],
      'operationId': "updateUser",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> deleteUserOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["organization"],
      'operationId': "deleteUser",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> openAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "openAccount",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "updateAccount",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "deleteAccount",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> unlockAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "unlockAccount",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> resetLockoutsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "resetLockouts",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listDeletedDepartmentsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "listDeletedDepartments",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> restoreDepartmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "restoreDepartment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> permanentDeleteDepartmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "permanentDeleteDepartment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listDeletedAccountsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "listDeletedAccounts",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> restoreAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "restoreAccount",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> permanentDeleteAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "permanentDeleteAccount",
          'externalDocsUrl': null,
        },
      };

  /// Hesabın departmanları ve rolleri.
  ///
  /// Çağıranın bütün programlardaki ekip satırları: her öğe bir.
  /// `(program, departman)` çiftidir (`program_id`, `program_name`,.
  /// `department_id`, programdaki ad `display_name`, `role`). Aynı departman.
  /// iki programda ekipteyse iki ayrı öğe döner; rol öğenin programına.
  /// göredir. Kapsam başlığı gerekmez (S1).
  @GET('/v1/me/departments')
  Future<HttpResponse<MyDepartmentList>> myDepartments({
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.myDepartmentsOpenapiExtras,
  });

  /// Departman listesi.
  @GET('/v1/departments')
  Future<HttpResponse<DepartmentList>> listDepartments({
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.listDepartmentsOpenapiExtras,
  });

  /// Departman oluşturur.
  @POST('/v1/departments')
  Future<Department> createDepartment({
    @Body() required CreateDepartmentRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.createDepartmentOpenapiExtras,
  });

  /// Departman günceller.
  @PATCH('/v1/departments/{id}')
  Future<Department> updateDepartment({
    @Path('id') required String id,
    @Body() required UpdateDepartmentRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.updateDepartmentOpenapiExtras,
  });

  /// Departmanı siler (geri alınabilir silme).
  @DELETE('/v1/departments/{id}')
  Future<DeleteDepartmentResult> deleteDepartment({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.deleteDepartmentOpenapiExtras,
  });

  /// Departman üye listesi (yönetim yüzü).
  ///
  /// Ekip programa göredir (ADR-0023): liste birebir `X-Nizamio-Program`.
  /// programındaki bu departmanın ekibidir; roller bu programa göredir.
  /// Şirket yöneticisine ve bu programda bu departmanın koordinatörüne.
  /// açıktır; başka programdaki koordinatörlük yetki vermez. Departman.
  /// programa bağlı değilse (program yoksa da) 422.
  /// `organization.department_not_linked`.
  @GET('/v1/departments/{id}/members')
  Future<HttpResponse<RosterList>> listMembers({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.listMembersOpenapiExtras,
  });

  /// Hesabı departmana rolle bağlar.
  ///
  /// Ekip programa göredir (ADR-0023): hesap yalnız `X-Nizamio-Program`.
  /// programındaki bu departmanın ekibine eklenir; aynı hesap başka.
  /// programlarda ayrı satırlarla bulunabilir ve onlar etkilenmez. Departman.
  /// bu programa bağlı değilse `422 organization.department_not_linked`.
  /// Şirket yöneticisi ya da bu programda bu departmanın koordinatörü.
  /// çağırır; koordinatörün atadığı rol `uye`'ye zorlanır ve koordinatör.
  /// şirket yöneticisini ya da herhangi bir programda `uye` dışında ekip.
  /// satırı olan hesabı ekleyemez (403).
  @POST('/v1/departments/{id}/memberships')
  Future<Membership> assignMembership({
    @Path('id') required String id,
    @Body() required AssignMembershipRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.assignMembershipOpenapiExtras,
  });

  /// Üyelik rolünü değiştirir; görev etkisi varsa onay ister.
  ///
  /// Ekip programa göredir (ADR-0023): yalnız `X-Nizamio-Program` programındaki.
  /// ekip satırının rolü değişir. Onay kapısı ve devir yalnız bu programın bu.
  /// departmanındaki aktif görev atamalarını sayar; diğer programların.
  /// atamalarına dokunulmaz. Yalnız şirket yöneticisi.
  @PATCH('/v1/departments/{id}/memberships/{accountId}')
  Future<MembershipChange> updateMembershipRole({
    @Path('id') required String id,
    @Path('accountId') required String accountId,
    @Body() required ChangeRoleRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.updateMembershipRoleOpenapiExtras,
  });

  /// Üyeyi departmandan çıkarır; görev etkisi varsa onay ister.
  ///
  /// Ekip programa göredir (ADR-0023): yalnız `X-Nizamio-Program` programındaki ekip.
  /// satırı silinir; hesabın başka programlardaki ekip satırları kalır. Onay.
  /// kapısı (`?confirm=true`) ve devir yalnız bu programın bu departmanındaki.
  /// aktif atamalar içindir. Şirket yöneticisi ya da bu programda bu.
  /// departmanın koordinatörü çağırır.
  ///
  /// [confirm] - `true` ise görev etkisi onaylanmış sayılır (aksi hâlde 409 organization.confirmation_required).
  @DELETE('/v1/departments/{id}/memberships/{accountId}')
  Future<MembershipChange> removeMember({
    @Path('id') required String id,
    @Path('accountId') required String accountId,
    @Query('confirm') Confirm? confirm,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.removeMemberOpenapiExtras,
  });

  /// Departmana atanabilir hesap havuzu.
  ///
  /// Bu programda bu departmanın koordinatörüne açıktır. Havuz =.
  /// herhangi bir programda ekip satırı olan canlı hesaplar − bu.
  /// `(program, departman)` ekibi; `roles` etiketleri yalnız seçili programdaki.
  /// diğer departman rolleridir (ADR-0023 kural 17).
  @GET('/v1/departments/{id}/assignable')
  Future<HttpResponse<AssignableList>> listAssignable({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.listAssignableOpenapiExtras,
  });

  /// Departman koordinatörünü atar.
  ///
  /// Ekip programa göredir (ADR-0023): koordinatörlük yalnız.
  /// `X-Nizamio-Program` programındaki bu departman için yazılır; başka.
  /// programda koordinatörlük vermez. Departman bu programa bağlı değilse.
  /// `422 organization.department_not_linked`. Yalnız şirket yöneticisi.
  @POST('/v1/departments/{id}/coordinator')
  Future<CoordinatorResult> assignCoordinator({
    @Path('id') required String id,
    @Body() required CoordinatorRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.assignCoordinatorOpenapiExtras,
  });

  /// Koordinatörlüğü kaldırır; görev etkisi varsa onay ister.
  ///
  /// Ekip programa göredir (ADR-0023): yalnız `X-Nizamio-Program` programındaki.
  /// koordinatörlük kaldırılır. Onay kapısı ve devir bu programın bu.
  /// departmanındaki aktif atamalarla sınırlıdır. Yalnız şirket yöneticisi.
  ///
  /// [confirm] - `true` ise görev etkisi onaylanmış sayılır (aksi hâlde 409 organization.confirmation_required).
  @DELETE('/v1/departments/{id}/coordinator/{accountId}')
  Future<MembershipChange> removeCoordinator({
    @Path('id') required String id,
    @Path('accountId') required String accountId,
    @Query('confirm') Confirm? confirm,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.removeCoordinatorOpenapiExtras,
  });

  /// Departmanın seçili programdaki görev özeti.
  ///
  /// Sayım `(program, departman)` kapsamlıdır: yalnız `X-Nizamio-Program`.
  /// programının kalemleri sayılır. Departman programa bağlı değilse.
  /// (program yoksa da) 422 `organization.department_not_linked`.
  /// Kalıcı departman silme engeli bu uçtan.
  /// bağımsız, bütün programları sayan katalog geneli sayımdır.
  @GET('/v1/departments/{id}/task-summary')
  Future<TaskSummary> taskSummary({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.taskSummaryOpenapiExtras,
  });

  /// Bilinen kullanıcı listesi (imleçli).
  ///
  /// `memberships` her ekip satırını `program:departman:rol` etiketiyle.
  /// taşır. `role` süzgeci "herhangi bir programda bu rol" demektir.
  /// (ADR-0023 kural 18).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/admin/users')
  Future<HttpResponse<UserList>> listUsers({
    @Query('role') String? role,
    @Query('search') String? search,
    @Query('sort_by') String? sortBy,
    @Query('sort_order') String? sortOrder,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.listUsersOpenapiExtras,
  });

  /// Kullanıcı oluşturur veya mevcut hesabı aktarır.
  ///
  /// Hesap açar (ya da `transfer_account_id` ile var olan hesabı aktarır).
  /// ve `program_id` programındaki departman ekibine ekler; `program_id`.
  /// zorunludur ve departman bu programa bağlı olmalıdır.
  /// (`422 organization.department_not_linked`). Koordinatör yalnız bu.
  /// programda koordine ettiği departmana `uye` ekler (ADR-0023 kural 18).
  @POST('/v1/admin/users')
  Future<UserResult> createUser({
    @Body() required CreateUserRequest body,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.createUserOpenapiExtras,
  });

  /// Kullanıcı günceller.
  ///
  /// Koordinatör yalnız silebileceği hesabı günceller: hedef şirket.
  /// yöneticisi değildir ve hedefin her ekip satırı (her programda),.
  /// çağıranın koordinatör olduğu bir `(program, departman)` içinde `uye`.
  /// rolündedir (ADR-0023 kural 8).
  @PATCH('/v1/admin/users/{id}')
  Future<UserResult> updateUser({
    @Path('id') required String id,
    @Body() required UpdateUserRequest body,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.updateUserOpenapiExtras,
  });

  /// Kullanıcıyı siler (geri alınabilir silme).
  ///
  /// Koordinatörün silme kapsamı güncellemeyle aynıdır: hedefin her ekip.
  /// satırı, çağıranın koordinatör olduğu bir `(program, departman)` içinde.
  /// `uye` rolündedir. Silinen hesabın aktif atamaları her `(program,.
  /// departman)` için silmeyi yapana devredilir; ekip satırları yetki vermez.
  /// (ADR-0023 kural 7, 8).
  @DELETE('/v1/admin/users/{id}')
  Future<UserResult> deleteUser({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.deleteUserOpenapiExtras,
  });

  /// Yönetici hesap açma (parola çağıran verir).
  @POST('/v1/admin/accounts')
  Future<AccountResult> openAccount({
    @Body() required OpenAccountRequest body,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.openAccountOpenapiExtras,
  });

  /// Yönetici hesap güncelleme; parola atanırsa hedefin oturumları düşer.
  @PATCH('/v1/admin/accounts/{id}')
  Future<AccountResult> updateAccount({
    @Path('id') required String id,
    @Body() required UpdateAccountRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.updateAccountOpenapiExtras,
  });

  /// Yönetici hesap silme (yumuşak); oturumlar düşer.
  ///
  /// Silinen hesabın aktif atamaları her `(program, departman)` için.
  /// silmeyi yapana devredilir; tamamlanmış atamalar kalır, ekip satırları.
  /// yetki vermez (ADR-0023 kural 7).
  @DELETE('/v1/admin/accounts/{id}')
  Future<AccountResult> deleteAccount({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.deleteAccountOpenapiExtras,
  });

  /// Kilitli hesabın kilidini açar.
  @POST('/v1/admin/accounts/{id}/unlock')
  Future<AccountResult> unlockAccount({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.unlockAccountOpenapiExtras,
  });

  /// Bütün giriş kilitlerini ve başarısız deneme kayıtlarını sıfırlar.
  @POST('/v1/admin/security/reset-lockouts')
  Future<LockoutResetResult> resetLockouts({
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.resetLockoutsOpenapiExtras,
  });

  /// Silinmiş departmanlar (imleçli).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/admin/deleted/departments')
  Future<HttpResponse<DeletedDepartmentList>> listDeletedDepartments({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.listDeletedDepartmentsOpenapiExtras,
  });

  /// Silinmiş departmanı geri yükler.
  @PATCH('/v1/admin/restore/departments/{id}')
  Future<DepartmentLifecycleResult> restoreDepartment({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.restoreDepartmentOpenapiExtras,
  });

  /// Silinmiş departmanı kalıcı siler.
  @DELETE('/v1/admin/permanent/departments/{id}')
  Future<DepartmentLifecycleResult> permanentDeleteDepartment({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.permanentDeleteDepartmentOpenapiExtras,
  });

  /// Silinmiş hesaplar (imleçli).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/admin/deleted/accounts')
  Future<HttpResponse<DeletedAccountList>> listDeletedAccounts({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.listDeletedAccountsOpenapiExtras,
  });

  /// Silinmiş hesabı geri yükler.
  @PATCH('/v1/admin/restore/accounts/{id}')
  Future<AccountLifecycleResult> restoreAccount({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.restoreAccountOpenapiExtras,
  });

  /// Silinmiş hesabı kalıcı siler.
  @DELETE('/v1/admin/permanent/accounts/{id}')
  Future<AccountLifecycleResult> permanentDeleteAccount({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.permanentDeleteAccountOpenapiExtras,
  });
}
