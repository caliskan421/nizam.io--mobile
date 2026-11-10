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
import '../models/program_work_item_counts.dart';
import '../models/removed_count.dart';
import '../models/review_request.dart';
import '../models/review_result.dart';
import '../models/status_result.dart';
import '../models/transition_request.dart';
import '../models/transition_result.dart';
import '../models/update_subtask_request.dart';
import '../models/update_work_item_request.dart';
import '../models/update_work_note_request.dart';
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
import '../models/work_note_updated.dart';

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
  static const Map<String, dynamic> countProgramWorkItemsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["work"],
          'operationId': "countProgramWorkItems",
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
  /// etiketleri, `subtask_counts`, `pending_date_request`); toplam ya da sayaç eklenmez.
  /// (sayaçlar aynı süzgeçlerle `countProgramWorkItems` ucundadır).
  /// Bekleyen tarih talebi satır başına yetkiyle dolar (yönetici her satırda,.
  /// koordinatör kendi departmanının satırında; üye satırında `null`; kural tekil.
  /// görev uçlarıyla aynıdır) ve listeyle aynı sorguda okunur; departman başına ek.
  /// istek gerekmez.
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
  /// `assignee_account_id` (tekrarlanabilir) verilirse görev verilen hesaplardan en az.
  /// birine atanmışsa kalır (VEYA); süzgeç görünürlükle ve `department_id` ile.
  /// **kesişir**, yetkiyi genişletmez (üye başkasının kimliğiyle süzerse yalnız zaten.
  /// görebildiği görevler döner). En çok 50 değer; tekrar eden değer tek sayılır, boş.
  /// değer yok sayılır. 50'den çok değer ya da biçimsiz kimlik `422 work.input_invalid`.
  /// (`fields[].field` = `assignee_account_id`). Sonraki sayfa isteği aynı süzgeçleri.
  /// tekrar gönderir.
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
  /// [assigneeAccountId] - İsteğe bağlı, tekrarlanabilir atanan süzgeci (WORK-K81): görev verilen hesaplardan en.
  /// az birine atanmışsa kalır. Görünürlükle ve `department_id` ile kesişir, yetkiyi.
  /// genişletmez. En çok 50 değer; tekrar eden değer tek sayılır, boş değer yok sayılır;.
  /// kimlik harf, rakam, `-` ve `_` dışında karakter taşıyamaz ve en çok 64 bayttır.
  ///
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/program/work-items')
  Future<WorkItemList> listProgramWorkItems({
    @Query('department_id') String? departmentId,
    @Query('assignee_account_id') List<String>? assigneeAccountId,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.listProgramWorkItemsOpenapiExtras,
  });

  /// Seçili programın görünür görevlerinin sayaçları (listeyle aynı görünürlük ve süzgeçler).
  ///
  /// Program görev listesinin (`listProgramWorkItems`) sayaç ucudur (WORK-K87). Görünürlük,.
  /// `department_id` ve `assignee_account_id` süzgeçleri, redler (403/404/422) ve.
  /// sıraları listeyle **aynıdır**; aynı süzgeçlerle `total`, listenin sayfalanarak.
  /// okunan satır sayısına eşittir (iki ayrı istek aynı anı görmeyebilir). Liste.
  /// cevabına sayaç eklenmez; sayaç bu uçtan alınır. `limit` ve `cursor` yok sayılır.
  ///
  /// - `by_status`: beş durumun her biri (sıfır dahil); toplamı `total`'dir.
  /// - `overdue`: durumu `tamamlandi` olmayan ve `end_on` günü bugünden önce olan görev.
  ///   sayısı. Bugün kurulumun saat dilimindeki takvim günüdür; bitiş günü bugün olan.
  ///   görev gecikmiş değildir, tamamlanmış görev (geç tamamlansa da) sayılmaz. Satırdaki.
  ///   `is_overdue` ile aynı kuraldır.
  /// - `pending_date_requests`: bekleyen (`pending`) tarih talebi olan görünür görev.
  ///   sayısı; satırdaki `pending_date_request` kuralıyla (WORK-K82): şirket yöneticisine.
  ///   her görevde, koordinatöre yalnız **bu programda** koordinatörü olduğu departmanın.
  ///   görevinde sayılır, üyeye 0.
  ///
  /// Silinmiş görev sayılmaz. Şirket yöneticisinin süzgeçsiz sayacı, listede olduğu gibi.
  /// silinmiş departmandaki canlı görevleri de kapsar; `reportDashboard` sayaçları ise.
  /// yalnız canlı katılan departmanları sayar (fark için `reportDashboard` açıklaması).
  ///
  /// [departmentId] - İsteğe bağlı departman süzgeci; listeyle aynı kural.
  ///
  /// [assigneeAccountId] - İsteğe bağlı, tekrarlanabilir atanan süzgeci (WORK-K81): görev verilen hesaplardan en.
  /// az birine atanmışsa kalır. Görünürlükle ve `department_id` ile kesişir, yetkiyi.
  /// genişletmez. En çok 50 değer; tekrar eden değer tek sayılır, boş değer yok sayılır;.
  /// kimlik harf, rakam, `-` ve `_` dışında karakter taşıyamaz ve en çok 64 bayttır.
  @GET('/v1/program/work-items/counts')
  Future<ProgramWorkItemCounts> countProgramWorkItems({
    @Query('department_id') String? departmentId,
    @Query('assignee_account_id') List<String>? assigneeAccountId,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.countProgramWorkItemsOpenapiExtras,
  });

  /// Görev açar (tarihler `YYYY-MM-DD`).
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/work-items')
  Future<WorkItem> createWorkItem({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required CreateWorkItemRequest body,
    @Extras()
    Map<String, dynamic>? extras = WorkClient.createWorkItemOpenapiExtras,
  });

  /// Kapsamdaki görevler (imleçli).
  ///
  /// Satırdaki `pending_date_request` yöneticiye ve bu departmanın koordinatörüne.
  /// dolar; üyede her satırda `null` (WORK-K82; tekil görev uçlarıyla aynı kural).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/work-items/{id}/notes')
  Future<WorkItemNote> addWorkItemNote({
    @Path('id') required String id,
    @Header('Idempotency-Key') required String idempotencyKey,
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
  Future<WorkNoteUpdated> updateWorkItemNote({
    @Path('id') required String id,
    @Path('noteId') required String noteId,
    @Body() required UpdateWorkNoteRequest body,
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
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/work-items/{id}/subtasks')
  Future<WorkItemSubtask> createWorkItemSubtask({
    @Path('id') required String id,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required CreateSubtaskRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        WorkClient.createWorkItemSubtaskOpenapiExtras,
  });

  /// Alt görevi değiştirir: başlık/atama/tarih (koordinatör, şirket yöneticisi), `done` (atanan, koordinatör ya da şirket yöneticisi).
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
  ///
  /// En çok 200 görev döner; imleç yoktur. Yüzün kapsamında 200'den fazla görev varsa.
  /// ilk 200 döner ve cevap `X-Result-Truncated: true` taşır (tam 200 görevde başlık yoktur). Tarih, atama, alt.
  /// görev sayacı ya da bağ okuması başarısızsa kısmi Gantt dönmez, cevap 500.
  /// `platform.internal`'dır. Liste ile tarih okuması arasında silinen ya da aktarılan.
  /// görev satırı düşer (hata değildir). Bağ yalnız iki ucu da listelenen görevler.
  /// arasında döner (WORK-K36); satır alanları WORK-K88.
  /// ([GAP-053](../known-gaps.md#gap-053)).
  @GET('/v1/work-items/gantt')
  Future<HttpResponse<Gantt>> coordinatorGantt({
    @Extras()
    Map<String, dynamic>? extras = WorkClient.coordinatorGanttOpenapiExtras,
  });

  /// Çağıranın atandığı görevlerin Gantt görünümü.
  ///
  /// En çok 200 görev döner; imleç yoktur. Yüzün kapsamında 200'den fazla görev varsa.
  /// ilk 200 döner ve cevap `X-Result-Truncated: true` taşır (tam 200 görevde başlık yoktur). Tarih, atama, alt.
  /// görev sayacı ya da bağ okuması başarısızsa kısmi Gantt dönmez, cevap 500.
  /// `platform.internal`'dır. Liste ile tarih okuması arasında silinen ya da aktarılan.
  /// görev satırı düşer (hata değildir). Bağ yalnız iki ucu da listelenen görevler.
  /// arasında döner (WORK-K36); satır alanları WORK-K88.
  /// ([GAP-053](../known-gaps.md#gap-053)).
  @GET('/v1/work-items/gantt/mine')
  Future<HttpResponse<Gantt>> memberGantt({
    @Extras()
    Map<String, dynamic>? extras = WorkClient.memberGanttOpenapiExtras,
  });

  /// Bitişi gün sayısı kadar uzatır (bağımlılara yayılır).
  ///
  /// WORK-K40. İsteğe bağlı `Idempotency-Key` (WORK-K89): başlıksız istek mevcut davranıştır.
  /// Verilmiş ama boş ya da sınır dışı anahtar 422 `work.input_invalid` (alan `idempotency_key`,.
  /// kod `work.request_key_invalid`). Anahtar aktör kapsamlıdır; makbuzda ilk uzatmanın sonucu.
  /// saklanır ve görev kalıcı silinene kadar yaşar. Aynı anahtar + aynı istek (kapsam, görev,.
  /// `days`, `expected_dates_revision`) uzatmayı ikinci kez UYGULAMAZ: 200 + ilk sonuç +.
  /// `replayed: true` (audit ve olay yazılmaz; başarı zaten 200 olduğundan tekrar durum koduyla.
  /// değil bu alanla ayırt edilir). Anahtar kararı her doğrulamadan (sürümün biçimi dahil) ve her business reddinden önce.
  /// verilir, görev kilidinden sonra yeniden verilir: kendi uzatmasıyla artmış sürüm, arada.
  /// tamamlanan görev ya da farklı gövdedeki geçersiz sürüm (409 `work.idempotency_key_reused`).
  /// tekrarı ya da çakışmayı gölgelemez.
  /// Tekrar uzatma yetkisini yeniden sormaz, görevin güncel görme yetkisini ister (yetkisi düşen.
  /// 403, kapsamı değişen 404). Farklı istek 409 `work.idempotency_key_reused`; görev soft.
  /// silinmişse 409 `work.item_deleted`. Aynı anahtarlı eşzamanlı iki istek görev kilidinde.
  /// serileşir: tek uzatma, ikincisi tekrar. "Sonuç bilinmiyor" (zaman aşımı, bağlantı kopması).
  /// durumunda istemci AYNI anahtar ve gövdeyle yeniden dener.
  ///
  /// [idempotencyKey] - İsteğe bağlı işlem anahtarı (ADR-0027 kalıbı). Verilmezse uç anahtarsız davranır (mevcut davranış). Verilirse (boş ya da yalnız boşluk dahil) kırpılmış uzunluk 22–200 bayttır, aksi 422 `<mod>.input_invalid` (alan `idempotency_key`, kod `<mod>.invalid_request_key`). Anahtar aktör + uç tablosu kapsamındadır ve kaynak satırında yaşar. Aynı anahtar + aynı normalize istek ilk kaynağın bugünkü temsilini 200 ile döndürür; farklı istek 409 `<mod>.idempotency_key_reused`; aynı anahtarlı eşzamanlı istek ilk isteğin bitişini bekler ve tekrar olarak döner.
  @POST('/v1/work-items/{id}/extend')
  Future<ExtendResult> extendWorkItem({
    @Path('id') required String id,
    @Body() required ExtendRequest body,
    @Header('Idempotency-Key') String? idempotencyKey,
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
  /// En çok 200 görev döner; imleç yoktur. Yüzün kapsamında 200'den fazla görev varsa.
  /// ilk 200 döner ve cevap `X-Result-Truncated: true` taşır (tam 200 görevde başlık yoktur). Tarih, atama, alt.
  /// görev sayacı ya da bağ okuması başarısızsa kısmi Gantt dönmez, cevap 500.
  /// `platform.internal`'dır. Liste ile tarih okuması arasında silinen ya da aktarılan.
  /// görev satırı düşer (hata değildir). Bağ yalnız iki ucu da listelenen görevler.
  /// arasında döner (WORK-K36); satır alanları WORK-K88.
  /// ([GAP-053](../known-gaps.md#gap-053)).
  ///
  /// `overdue=true` süzgeci taranan ilk 200 görevin üzerinde bellekte uygulanır: başlık.
  /// taranan kümenin kesildiğini söyler; süzme sonrası 200'den az satırla da gelebilir.
  ///
  /// [overdue] - `true` ise yalnız bitiş günü bugünden (kurulum saat dilimi) önce olan görevler. Süzgeç görev durumuna bakmaz: bitişi geçmiş TAMAMLANMIŞ görev de listelenir; satırdaki `is_overdue` ise tamamlanmış görevde `false`'tur ([GAP-053](../known-gaps.md#gap-053)).
  @GET('/v1/work-items/gantt/admin')
  Future<HttpResponse<Gantt>> adminGantt({
    @Query('overdue') String? overdue,
    @Extras() Map<String, dynamic>? extras = WorkClient.adminGanttOpenapiExtras,
  });

  /// Tarih değişikliği talebi açar (görev başına tek bekleyen).
  ///
  /// WORK-K38. İsteğe bağlı `Idempotency-Key` (WORK-K89): başlıksız istek mevcut davranıştır.
  /// Verilmiş ama boş ya da sınır dışı anahtar 422 `work.input_invalid` (alan `idempotency_key`,.
  /// kod `work.request_key_invalid`). Anahtar aktör kapsamlıdır ve talep satırında yaşar. Yeni.
  /// talep 201; aynı anahtar + aynı istek (kapsam, görev, günler, kırpılmış gerekçe,.
  /// `expected_dates_revision`) 200 + talebin BUGÜNKÜ hâli (arada onaylanmış ya da reddedilmişse.
  /// o durumla); farklı istek 409 `work.idempotency_key_reused`. Anahtar kararı her doğrulamadan.
  /// (sürümün biçimi dahil) ve her business reddinden önce verilir; bekleyen talep, bağımlılık.
  /// ve sürüm denetimleri görev kilidinden ve anahtarın yeniden sınıflanmasından sonradır. Tekrar okumadır: talep çağıranın.
  /// kendi talebidir (`/mine` ile de görünür), oluşturma yetkisi yeniden sorulmaz; koordinatörlüğü.
  /// sonradan kaldırılmış talepçi de 200 alır. Yönetici incelenmiş talebi silerse anahtar da gider:.
  /// aynı anahtar yeni talep açar (201). Aynı anahtarlı eşzamanlı iki istek görev kilidinde.
  /// serileşir: tek talep, ikincisi 200 (409 `work.date_request_pending_exists` değil); farklı.
  /// anahtarlı iki istekten biri 409 `work.date_request_pending_exists` alır. "Sonuç bilinmiyor".
  /// durumunda istemci AYNI anahtar ve gövdeyle yeniden dener.
  ///
  /// [idempotencyKey] - İsteğe bağlı işlem anahtarı (ADR-0027 kalıbı). Verilmezse uç anahtarsız davranır (mevcut davranış). Verilirse (boş ya da yalnız boşluk dahil) kırpılmış uzunluk 22–200 bayttır, aksi 422 `<mod>.input_invalid` (alan `idempotency_key`, kod `<mod>.invalid_request_key`). Anahtar aktör + uç tablosu kapsamındadır ve kaynak satırında yaşar. Aynı anahtar + aynı normalize istek ilk kaynağın bugünkü temsilini 200 ile döndürür; farklı istek 409 `<mod>.idempotency_key_reused`; aynı anahtarlı eşzamanlı istek ilk isteğin bitişini bekler ve tekrar olarak döner.
  @POST('/v1/date-change-requests')
  Future<DateChangeRequest> requestDateChange({
    @Body() required DateChangeRequestCreate body,
    @Header('Idempotency-Key') String? idempotencyKey,
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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
