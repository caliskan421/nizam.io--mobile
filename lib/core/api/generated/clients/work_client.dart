// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/added_count.dart';
import '../models/assignments_request.dart';
import '../models/completion_request.dart';
import '../models/create_subtask_request.dart';
import '../models/create_work_item_request.dart';
import '../models/date_change_request.dart';
import '../models/date_change_request_create.dart';
import '../models/date_change_request_list.dart';
import '../models/deleted_work_item_list.dart';
import '../models/dependency_edge.dart';
import '../models/dependency_list.dart';
import '../models/dependency_request.dart';
import '../models/extend_request.dart';
import '../models/extend_result.dart';
import '../models/gantt.dart';
import '../models/my_task_list.dart';
import '../models/removed_count.dart';
import '../models/review_request.dart';
import '../models/review_result.dart';
import '../models/status_result.dart';
import '../models/transition_request.dart';
import '../models/transition_result.dart';
import '../models/update_subtask_request.dart';
import '../models/update_work_item_request.dart';
import '../models/work_item.dart';
import '../models/work_item_dates.dart';
import '../models/work_item_detail.dart';
import '../models/work_item_lifecycle_result.dart';
import '../models/work_item_list.dart';
import '../models/work_item_note.dart';
import '../models/work_item_note_list.dart';
import '../models/work_item_purge_result.dart';
import '../models/work_item_subtask.dart';
import '../models/work_item_subtask_list.dart';
import '../models/work_note_request.dart';

part 'work_client.g.dart';

@RestApi()
abstract class WorkClient {
  factory WorkClient(Dio dio, {String? baseUrl}) = _WorkClient;

  static const Map<String, dynamic> listProgramWorkItemsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "listProgramWorkItems",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> createWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "createWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listWorkItemsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "listWorkItems",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> transitionWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "transitionWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> ownStatusWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "ownStatusWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> getWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "getWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "updateWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "deleteWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> claimWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "claimWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> unclaimWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "unclaimWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> addAssignmentsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "addAssignments",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> removeAssignmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "removeAssignment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> myTasksOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["work"],
      'operationId': "myTasks",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> addWorkItemNoteOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "addWorkItemNote",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listWorkItemNotesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "listWorkItemNotes",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateWorkItemNoteOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "updateWorkItemNote",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteWorkItemNoteOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "deleteWorkItemNote",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listWorkItemSubtasksOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "listWorkItemSubtasks",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> createWorkItemSubtaskOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "createWorkItemSubtask",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateWorkItemSubtaskOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "updateWorkItemSubtask",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteWorkItemSubtaskOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "deleteWorkItemSubtask",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> addDependencyOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "addDependency",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listDependenciesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "listDependencies",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> removeDependencyOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "removeDependency",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> coordinatorGanttOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "coordinatorGantt",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> memberGanttOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "memberGantt",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> extendWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "extendWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> pullCompletionOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "pullCompletion",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> pullEndDateOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "pullEndDate",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> setCompletionDateOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "setCompletionDate",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> adminGanttOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["work"],
      'operationId': "adminGantt",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> requestDateChangeOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "requestDateChange",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listDateChangeRequestsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "listDateChangeRequests",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> myDateChangeRequestsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "myDateChangeRequests",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reviewDateChangeRequestOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "reviewDateChangeRequest",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteDateChangeRequestOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "deleteDateChangeRequest",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listDeletedWorkItemsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "listDeletedWorkItems",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> restoreWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "restoreWorkItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> permanentDeleteWorkItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "permanentDeleteWorkItem",
          'externalDocsUrl': null,
        },
      };

  /// Seçili programın görünür görevleri (imleçli; departman başlığı yok).
  ///
  /// Görev listesinin program bağlamındaki ucudur (WORK-K81). Satır biçimi.
  /// `listWorkItems` ile aynıdır (`WorkItemList`: tarihler, adlı atananlar, gecikme.
  /// etiketleri, `subtask_counts`); toplam ya da sayaç eklenmez.
  ///
  /// Görünürlük çağıranın **bu programdaki** ekip satırlarından sunucuda, tek sorguda.
  /// hesaplanır: şirket yöneticisi programın bütün görevlerini, koordinatör koordinatörü.
  /// olduğu departmanların bütün görevlerini, üye üyesi olduğu departmanlarda yalnız.
  /// kendisine atanan görevleri görür; birden çok rolü olan hesap birleşimi görür (aynı.
  /// görev bir kez döner). Silinmiş görev ve silinmiş departmanın satırı yetki vermez.
  ///
  /// `department_id` verilirse görünürlükle **kesişir**, yetkiyi genişletmez: koordinatör.
  /// olunmayan departman süzülürse yalnız o departmanda kendisine atanan görevler döner.
  /// (ekip satırı yoksa boş liste). Programa bağlı olmayan ya da yumuşak silinmiş.
  /// (bağı duran) departman `404 work.program_scope_invalid`. Boş ya da yalnız.
  /// boşluktan oluşan `department_id` süzgeç verilmemiş sayılır (`limit` ve `cursor`.
  /// boş değerleriyle aynı gelenek).
  ///
  /// Hiçbir programda ekip satırı olmayan ve yönetici olmayan hesap `403.
  /// organization.membership_required`; bu programda ekip satırı olmayan ve yönetici.
  /// olmayan hesap, var olmayan programla aynı `404 work.program_scope_invalid` alır.
  /// (programın varlığı sızmaz). Sıra `(created_at, id)`; imleç opak; `limit`.
  /// varsayılanı 50, 200 üstü 200'e çekilir. Tek görev istekleri yine görevin kendi.
  /// `program_id` ve `department_id` başlıklarıyla gider.
  ///
  /// [departmentId] - İsteğe bağlı departman süzgeci; görünürlükle kesişir. Boş ya da yalnız boşluk değer süzgeç yok sayılır.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/program/work-items')
  Future<WorkItemList> listProgramWorkItems({
    @Query('department_id') String? departmentId,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.listProgramWorkItemsOpenapiExtras,
  });

  /// Görev açar (tarihler `YYYY-MM-DD`).
  @POST('/v1/work-items')
  Future<WorkItem> createWorkItem({
    @Body() required CreateWorkItemRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.createWorkItemOpenapiExtras,
  });

  /// Kapsamdaki görevler (imleçli).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/work-items')
  Future<WorkItemList> listWorkItems({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.listWorkItemsOpenapiExtras,
  });

  /// Durum geçişi (geçiş tablosu; ön koşullar use-case sınırında).
  @POST('/v1/work-items/{id}/transitions')
  Future<TransitionResult> transitionWorkItem({
    @Path('id') required String id,
    @Body() required TransitionRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.transitionWorkItemOpenapiExtras,
  });

  /// Atanmış üyenin kendi durum geçişi (geçiş günü bugündür).
  @PATCH('/v1/work-items/{id}/own-status')
  Future<TransitionResult> ownStatusWorkItem({
    @Path('id') required String id,
    @Body() required TransitionRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.ownStatusWorkItemOpenapiExtras,
  });

  /// Tek görevi açıklamasıyla okur (liste ile aynı rol kümesi, seçili programdaki rol).
  ///
  /// Şirket yöneticisi ve görevin departmanının koordinatörü kapsamdaki her görevi,.
  /// atanmış üye yalnız kendi görevini okur. Rol, görevin kendi `(program, departman)`.
  /// kapsamından okunur. Kapsam başlığı görevin kapsamıyla uyuşmuyorsa ya da görev.
  /// yok/silinmişse 404 `work.item_not_found`. Atanmamış üye 403 `work.not_assigned`.
  /// alır: bu uç (notlar ve alt görev uçları gibi) görevin varlığını kapsam içindeki.
  /// ekip üyesinden gizlemez.
  @GET('/v1/work-items/{id}')
  Future<WorkItemDetail> getWorkItem({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.getWorkItemOpenapiExtras,
  });

  /// Görevi günceller; tamamlanma/teslim alanları korumalıdır.
  @PATCH('/v1/work-items/{id}')
  Future<WorkItem> updateWorkItem({
    @Path('id') required String id,
    @Body() required UpdateWorkItemRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.updateWorkItemOpenapiExtras,
  });

  /// Görevi yumuşak siler.
  @DELETE('/v1/work-items/{id}')
  Future<StatusResult> deleteWorkItem({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.deleteWorkItemOpenapiExtras,
  });

  /// Görevi üstlenir.
  @POST('/v1/work-items/{id}/claim')
  Future<StatusResult> claimWorkItem({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.claimWorkItemOpenapiExtras,
  });

  /// Üstlenmeyi bırakır.
  @DELETE('/v1/work-items/{id}/claim')
  Future<StatusResult> unclaimWorkItem({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.unclaimWorkItemOpenapiExtras,
  });

  /// Göreve atama ekler.
  @POST('/v1/work-items/{id}/assignments')
  Future<AddedCount> addAssignments({
    @Path('id') required String id,
    @Body() required AssignmentsRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.addAssignmentsOpenapiExtras,
  });

  /// Atamayı kaldırır.
  @DELETE('/v1/work-items/{id}/assignments/{accountId}')
  Future<RemovedCount> removeAssignment({
    @Path('id') required String id,
    @Path('accountId') required String accountId,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.removeAssignmentOpenapiExtras,
  });

  /// Çağıranın atandığı görevler.
  @GET('/v1/work-items/my-tasks')
  Future<MyTaskList> myTasks({
    @Extras() Map<String, dynamic>? extras = WorkClient.myTasksOpenapiExtras,
  });

  /// Göreve not ekler (hesap başına hız sınırı).
  @POST('/v1/work-items/{id}/notes')
  Future<WorkItemNote> addWorkItemNote({
    @Path('id') required String id,
    @Body() required WorkNoteRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.addWorkItemNoteOpenapiExtras,
  });

  /// Görevin notları.
  @GET('/v1/work-items/{id}/notes')
  Future<WorkItemNoteList> listWorkItemNotes({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.listWorkItemNotesOpenapiExtras,
  });

  /// Kendi notunu günceller.
  @PATCH('/v1/work-items/{id}/notes/{noteId}')
  Future<StatusResult> updateWorkItemNote({
    @Path('id') required String id,
    @Path('noteId') required String noteId,
    @Body() required WorkNoteRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.updateWorkItemNoteOpenapiExtras,
  });

  /// Kendi notunu siler.
  @DELETE('/v1/work-items/{id}/notes/{noteId}')
  Future<StatusResult> deleteWorkItemNote({
    @Path('id') required String id,
    @Path('noteId') required String noteId,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.deleteWorkItemNoteOpenapiExtras,
  });

  /// Görevin alt görevleri (ADR-0024).
  @GET('/v1/work-items/{id}/subtasks')
  Future<WorkItemSubtaskList> listWorkItemSubtasks({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.listWorkItemSubtasksOpenapiExtras,
  });

  /// Göreve alt görev ekler (koordinatör, şirket yöneticisi; görev başına en çok 50).
  @POST('/v1/work-items/{id}/subtasks')
  Future<WorkItemSubtask> createWorkItemSubtask({
    @Path('id') required String id,
    @Body() required CreateSubtaskRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.createWorkItemSubtaskOpenapiExtras,
  });

  /// Alt görevi değiştirir: başlık/atama/tarih (koordinatör, şirket yöneticisi), `done` (atanan ya da koordinatör).
  @PATCH('/v1/work-items/{id}/subtasks/{subtaskId}')
  Future<WorkItemSubtask> updateWorkItemSubtask({
    @Path('id') required String id,
    @Path('subtaskId') required String subtaskId,
    @Body() required UpdateSubtaskRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.updateWorkItemSubtaskOpenapiExtras,
  });

  /// Alt görevi siler (koordinatör, şirket yöneticisi); dosyaları ana görevde kalır, `subtask_id` referansları boşaltılır.
  @DELETE('/v1/work-items/{id}/subtasks/{subtaskId}')
  Future<StatusResult> deleteWorkItemSubtask({
    @Path('id') required String id,
    @Path('subtaskId') required String subtaskId,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.deleteWorkItemSubtaskOpenapiExtras,
  });

  /// Ön görev bağımlılığı ekler (döngü reddedilir).
  @POST('/v1/work-items/{id}/dependencies')
  Future<DependencyEdge> addDependency({
    @Path('id') required String id,
    @Body() required DependencyRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.addDependencyOpenapiExtras,
  });

  /// Görevin ön görevleri ve bağımlıları.
  @GET('/v1/work-items/{id}/dependencies')
  Future<DependencyList> listDependencies({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.listDependenciesOpenapiExtras,
  });

  /// Bağımlılığı kaldırır.
  ///
  /// [depId] - Bağımlılık kenarının kimliği (`dependency_id`); bağımlı olunan görevin kimliği değildir.
  @DELETE('/v1/work-items/{id}/dependencies/{depId}')
  Future<StatusResult> removeDependency({
    @Path('id') required String id,
    @Path('depId') required String depId,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.removeDependencyOpenapiExtras,
  });

  /// Departman Gantt görünümü.
  @GET('/v1/work-items/gantt')
  Future<Gantt> coordinatorGantt({
    @Extras()
    Map<String, dynamic>? extras = WorkClient.coordinatorGanttOpenapiExtras,
  });

  /// Çağıranın atandığı görevlerin Gantt görünümü.
  @GET('/v1/work-items/gantt/mine')
  Future<Gantt> memberGantt({
    @Extras()
    Map<String, dynamic>? extras = WorkClient.memberGanttOpenapiExtras,
  });

  /// Bitişi gün sayısı kadar uzatır (bağımlılara yayılır).
  @POST('/v1/work-items/{id}/extend')
  Future<ExtendResult> extendWorkItem({
    @Path('id') required String id,
    @Body() required ExtendRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.extendWorkItemOpenapiExtras,
  });

  /// Tamamlanma tarihini geri çeker (koordinatör ya da görevin `(program, departman)` ekibinde satırı olan atanmış üye; aksi 403 `work.not_authorized`).
  @POST('/v1/work-items/{id}/pull-completion')
  Future<WorkItemDates> pullCompletion({
    @Path('id') required String id,
    @Body() required CompletionRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.pullCompletionOpenapiExtras,
  });

  /// Bitişi tamamlanma gününe çeker.
  @POST('/v1/work-items/{id}/pull-end-date')
  Future<WorkItemDates> pullEndDate({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.pullEndDateOpenapiExtras,
  });

  /// Tamamlanma tarihini yönetici olarak düzeltir.
  @PATCH('/v1/work-items/{id}/completion-date')
  Future<WorkItemDates> setCompletionDate({
    @Path('id') required String id,
    @Body() required CompletionRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.setCompletionDateOpenapiExtras,
  });

  /// Programın bütün departmanları için Gantt görünümü.
  ///
  /// [overdue] - `true` ise yalnız gecikenler.
  @GET('/v1/work-items/gantt/admin')
  Future<Gantt> adminGantt({
    @Query('overdue') String? overdue,
    @Extras() Map<String, dynamic>? extras = WorkClient.adminGanttOpenapiExtras,
  });

  /// Tarih değişikliği talebi açar (görev başına tek bekleyen).
  @POST('/v1/date-change-requests')
  Future<DateChangeRequest> requestDateChange({
    @Body() required DateChangeRequestCreate body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.requestDateChangeOpenapiExtras,
  });

  /// Tarih talepleri (yönetici inceleme yüzü).
  ///
  /// [status] - `pending` ise yalnız bekleyenler; diğer değerler hepsi.
  @GET('/v1/date-change-requests')
  Future<DateChangeRequestList> listDateChangeRequests({
    @Query('status') String? status,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.listDateChangeRequestsOpenapiExtras,
  });

  /// Çağıranın açtığı tarih talepleri.
  @GET('/v1/date-change-requests/mine')
  Future<DateChangeRequestList> myDateChangeRequests({
    @Extras()
    Map<String, dynamic>? extras = WorkClient.myDateChangeRequestsOpenapiExtras,
  });

  /// Tarih talebini onaylar ya da reddeder.
  @POST('/v1/date-change-requests/{id}/review')
  Future<ReviewResult> reviewDateChangeRequest({
    @Path('id') required String id,
    @Body() required ReviewRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.reviewDateChangeRequestOpenapiExtras,
  });

  /// İncelenmiş tarih talebini siler.
  @DELETE('/v1/date-change-requests/{id}')
  Future<StatusResult> deleteDateChangeRequest({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.deleteDateChangeRequestOpenapiExtras,
  });

  /// Silinmiş görevler (imleçli; korunan ek sayısıyla).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/admin/deleted/work-items')
  Future<DeletedWorkItemList> listDeletedWorkItems({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.listDeletedWorkItemsOpenapiExtras,
  });

  /// Silinmiş görevi geri yükler.
  @PATCH('/v1/admin/restore/work-items/{id}')
  Future<WorkItemLifecycleResult> restoreWorkItem({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.restoreWorkItemOpenapiExtras,
  });

  /// Silinmiş görevi ve eklerini kalıcı siler.
  @DELETE('/v1/admin/permanent/work-items/{id}')
  Future<WorkItemPurgeResult> permanentDeleteWorkItem({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.permanentDeleteWorkItemOpenapiExtras,
  });
}
