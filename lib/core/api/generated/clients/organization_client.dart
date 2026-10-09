// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/assign_membership_request.dart';
import '../models/assignable_list.dart';
import '../models/change_role_request.dart';
import '../models/confirm.dart';
import '../models/coordinator_request.dart';
import '../models/coordinator_result.dart';
import '../models/create_department_request.dart';
import '../models/create_user_request.dart';
import '../models/delete_department_result.dart';
import '../models/department.dart';
import '../models/department_list.dart';
import '../models/membership.dart';
import '../models/membership_change.dart';
import '../models/my_department_list.dart';
import '../models/roster_list.dart';
import '../models/task_summary.dart';
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

  /// Hesabın departmanları ve rolleri.
  @GET('/v1/me/departments')
  Future<MyDepartmentList> myDepartments({
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.myDepartmentsOpenapiExtras,
  });

  /// Departman listesi.
  @GET('/v1/departments')
  Future<DepartmentList> listDepartments({
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
  @GET('/v1/departments/{id}/members')
  Future<RosterList> listMembers({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.listMembersOpenapiExtras,
  });

  /// Hesabı departmana rolle bağlar.
  @POST('/v1/departments/{id}/memberships')
  Future<Membership> assignMembership({
    @Path('id') required String id,
    @Body() required AssignMembershipRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.assignMembershipOpenapiExtras,
  });

  /// Üyelik rolünü değiştirir; görev etkisi varsa onay ister.
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
  @GET('/v1/departments/{id}/assignable')
  Future<AssignableList> listAssignable({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        OrganizationClient.listAssignableOpenapiExtras,
  });

  /// Departman koordinatörünü atar.
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

  /// Departmanın görev özeti.
  @GET('/v1/departments/{id}/task-summary')
  Future<TaskSummary> taskSummary({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.taskSummaryOpenapiExtras,
  });

  /// Bilinen kullanıcı listesi (imleçli).
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/admin/users')
  Future<UserList> listUsers({
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
  @POST('/v1/admin/users')
  Future<UserResult> createUser({
    @Body() required CreateUserRequest body,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.createUserOpenapiExtras,
  });

  /// Kullanıcı günceller.
  @PATCH('/v1/admin/users/{id}')
  Future<UserResult> updateUser({
    @Path('id') required String id,
    @Body() required UpdateUserRequest body,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.updateUserOpenapiExtras,
  });

  /// Kullanıcıyı siler (geri alınabilir silme).
  @DELETE('/v1/admin/users/{id}')
  Future<UserResult> deleteUser({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = OrganizationClient.deleteUserOpenapiExtras,
  });
}
