// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/account_lifecycle_result.dart';
import '../models/account_result.dart';
import '../models/account_status_result.dart';
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
import '../models/known_user.dart';
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
  static const Map<String, dynamic> readUserOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["organization"],
      'operationId': "readUser",
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
  static const Map<String, dynamic> disableAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "disableAccount",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> enableAccountOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["organization"],
          'operationId': "enableAccount",
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
  ///
  /// Ad şirkette büyük/küçük harf duyarsız tekildir (silinmiş departmanlar.
  /// dahil). Çakışmada 409 `organization.department_exists` zarfı adı taşıyan.
  /// mevcut departmanı alan girdileriyle taşır: `fields[]` içinde.
  /// `{field: department_id, code: organization.existing_department, message: <kimlik>}`.
  /// ve `{field: deleted, code: organization.existing_department, message: "true"|"false"}`.
  /// (silinmişse geri yükleme ucuyla döndürülebilir). İsteğe bağlı.
  /// `Idempotency-Key` (aktör kapsamlı; parmak izi normalize ad, tür, kod,.
  /// açıklama): tekrar 200 + departmanın bugünkü hâli, tekrarlanan departman.
  /// silinmişse 404 `organization.department_not_found`, farklı istek 409.
  /// `organization.idempotency_key_reused`.
  ///
  /// [idempotencyKey] - İsteğe bağlı işlem anahtarı (ADR-0027 kalıbı). Verilmezse uç anahtarsız davranır (mevcut davranış). Verilirse (boş ya da yalnız boşluk dahil) kırpılmış uzunluk 22–200 bayttır, aksi 422 `<mod>.input_invalid` (alan `idempotency_key`, kod `<mod>.invalid_request_key`). Anahtar aktör + uç tablosu kapsamındadır ve kaynak satırında yaşar. Aynı anahtar + aynı normalize istek ilk kaynağın bugünkü temsilini 200 ile döndürür; farklı istek 409 `<mod>.idempotency_key_reused`; aynı anahtarlı eşzamanlı istek ilk isteğin bitişini bekler ve tekrar olarak döner.
  @POST('/v1/departments')
  Future<Department> createDepartment({
    @Body() required CreateDepartmentRequest body,
    @Header('Idempotency-Key') String? idempotencyKey,
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

  /// Kullanıcı listesi (imleçli, sayaçlı).
  ///
  /// Yalnız şirket yöneticisi. Süzgeçsiz liste ("Tümü") şirketteki bütün.
  /// canlı hesaplardır: ekip satırı olmayan yönetici, üyeliksiz hesap ve.
  /// yalnız silinmiş departmanda ekip satırı olan hesap dahil; silinmiş.
  /// hesap yoktur. `memberships` her canlı ekip satırını.
  /// `program:departman:rol` etiketiyle taşır. `role` süzgeci (`uye`,.
  /// `koordinator`) "herhangi bir programda bu rol" demektir (ADR-0023.
  /// kural 18); `program_id`/`department_id` verilirse o kapsamdaki rol.
  /// `total` ve `role_counts` her istekte aynı süzgeçlerle hesaplanır.
  ///
  /// [role] - `uye` / `koordinator`: herhangi bir programda bu ekip rolü; `company_admin`: şirket yöneticisi. Küme dışı değer 422 `organization.input_invalid`.
  ///
  /// [search] - Görünen adda (Türkçe büyük/küçük harf duyarsız) ya da e-postada (küçük harf) geçen metin; `%` ve `_` joker değil metindir.
  ///
  /// [programId] - Verilirse yalnız bu programda (canlı departmanda) ekip satırı olan hesaplar; rol süzgeci de bu programın rollerine daralır. Kimlik harf, rakam, `-` ve `_` taşır, en çok 64 bayttır (aksi 422 `organization.input_invalid`).
  ///
  /// [departmentId] - Verilirse yalnız bu departmanda (program verilmişse o programda) ekip satırı olan hesaplar. Biçim `program_id` ile aynıdır.
  ///
  /// [sortBy] - Sıralama alanı (ORGANIZATION-K33); değer kümesi `name` | `created_at`. Boş ya da.
  /// verilmemiş değer `created_at`'tir; baştaki/sondaki boşluk kırpılır. `name` görünen adın.
  /// küçük harfe ve Türkçe harf katlamasıyla (ç→c, ğ→g, ı→i, ö→o, ş→s, ü→u) normalize.
  /// hâline göre, `created_at` hesabın oluşturulma zamanına göre sıralar; eşitlikte hesap.
  /// kimliği ikincil anahtardır (imleç kararlı). Küme dışı değer 422 `organization.input_invalid`.
  /// (alan `sort_by`, kod `organization.invalid_sort`); sessizce varsayılana düşmez. Değer kümesi.
  /// `enum` olarak yazılmaz (eklemek sözleşmede kırıcıdır); kümeyi bu açıklama tanımlar.
  ///
  ///
  /// [sortOrder] - Sıralama yönü (ORGANIZATION-K33); değer kümesi `asc` | `desc`. Boş ya da verilmemiş.
  /// değer `asc`'tir; baştaki/sondaki boşluk kırpılır. Küme dışı değer 422.
  /// `organization.input_invalid` (alan `sort_order`, kod `organization.invalid_sort`).
  ///
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/admin/users')
  Future<HttpResponse<UserList>> listUsers({
    @Query('sort_by') String? sortBy = 'created_at',
    @Query('sort_order') String? sortOrder = 'asc',
    @Query('role') String? role,
    @Query('search') String? search,
    @Query('program_id') String? programId,
    @Query('department_id') String? departmentId,
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
  ///
  /// **Aktarım teklifi (ORGANIZATION-K22).** E-posta başka bir hesaba aitse cevap 409.
  /// `identity.account_exists`'tir (kod ve zarf biçimi her çağırana aynı). Çağıran şirket.
  /// yöneticisiyse ve çakışan hesap hedef `(program_id, department_id)` ekibinde zaten yoksa.
  /// zarfın `fields[]` dizisi aktarım teklifini taşır; üç girdinin hepsinin `code` değeri.
  /// `organization.transfer_available`'dır ve `field` anlamı, `message` değeri taşır:.
  ///
  /// - `{field: "email", message: <sabit açıklama metni>}` — teklifin varlığı;.
  /// - `{field: "account_id", message: <çakışan hesabın kimliği>}`;.
  /// - `{field: "user_full_name", message: <çakışan hesabın görünen adı>}` (ad boşsa girdi yoktur).
  ///
  /// İstemci kullanıcıya "bu e-posta <ad> kişisine ait; aktarılsın mı?" diye sorar ve onayda.
  /// AYNI uca aynı gövdeyi `transfer_account_id: <account_id girdisinin message'ı>` ile yeniden.
  /// gönderir (201; yeni hesap açılmaz, hesap hedef ekibe eklenir). Koordinatöre ve hesap hedef.
  /// ekipte zaten varken teklif girdileri gelmez (`fields` boş); `details` yapılandırılmış veri.
  /// taşımaz, teklif yalnız `fields[]`'tadır.
  @POST('/v1/admin/users')
  Future<UserResult> createUser({
    @Body() required CreateUserRequest body,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.createUserOpenapiExtras,
  });

  /// Tek kullanıcının yönetim görünümü.
  ///
  /// Yalnız şirket yöneticisi. Yetki kaynağa dokunmadan önce verilir:.
  /// yönetici olmayan çağıran var olan ve olmayan kimlik için aynı 403'ü.
  /// alır. Cevap liste satırının alanları ve bütün programlardaki ekip.
  /// satırları (`teams`). Bulunmayan ya da silinmiş hesap 404.
  /// `organization.account_not_found`.
  @GET('/v1/admin/users/{id}')
  Future<KnownUser> readUser({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.readUserOpenapiExtras,
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

  /// Hesabın girişini kapatır.
  ///
  /// Yalnız şirket yöneticisi. Durum `disabled` olur, hesabın bütün.
  /// oturumları (web ve mobil, erişim ve yenileme) aynı transaction'da.
  /// iptal edilir ve audit yazılır. Kendini kapatma 403; son aktif şirket.
  /// yöneticisini kapatma 409 `organization.last_admin` (kapatılmış.
  /// yönetici aktif sayılmaz). Kapatılmış hesap giriş ve yenileme.
  /// yapamaz; ekip satırları ve yöneticilik ataması değişmez.
  @POST('/v1/admin/accounts/{id}/disable')
  Future<AccountStatusResult> disableAccount({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.disableAccountOpenapiExtras,
  });

  /// Kapatılmış hesabı açar.
  ///
  /// Yalnız şirket yöneticisi; kendini açma 403 (kapatılmış hesap.
  /// yetkisizdir). Durum `active` olur ve audit yazılır;.
  /// kapatmada iptal edilen oturumlar geri gelmez (kullanıcı yeniden.
  /// giriş yapar). Silinmiş hesap canlanmaz (404; geri yükleme ayrı.
  /// uçtadır).
  @POST('/v1/admin/accounts/{id}/enable')
  Future<AccountStatusResult> enableAccount({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.enableAccountOpenapiExtras,
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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
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
