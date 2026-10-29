# Servis katmanı envanteri — `work` (WorkClient, 33 işlem)

Pin: `v0.2.0-api`. Kaynak istemci: `lib/core/api/generated/clients/work_client.dart`. Kapsam sınıfı
`operations.gen.dart`'tan. Kapsam başlıkları ara katmandan gelir; üretilmiş imzada başlık parametresi
yoktur, bu yüzden hiçbir repository metodu kapsam parametresi almaz. Dosya uçları
(`/v1/work-items/{id}/files`, `/v1/files/**`) records istemcisindedir, bu envanterde yer almaz.

Karşılanan: **33 / 33**.

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| createWorkItem | POST /v1/work-items | S3 | `WorkItemRepository.create` | `TaskDraft` → `TaskSummary` | Tek atanan (`assignee_account_id`); çoklu atama `addAssignees` ile. Gün alanı biçimi açık (aşağıda §Açık sorunlar 1). |
| listWorkItems | GET /v1/work-items | S3 | `WorkItemRepository.list` | `PageSlice<TaskSummary>` | İmleçli; sıralama/süzgeç parametresi yok. Liste tarih taşımaz → `TaskItem` yerine `TaskSummary`. |
| transitionWorkItem | POST /v1/work-items/{id}/transitions | S3 | `WorkItemRepository.transition` | `TaskTransition` | Geri almada `reason` zorunlu (sunucu 422). `unknown` hedef `ArgumentError` (istek atılmaz). |
| ownStatusWorkItem | PATCH /v1/work-items/{id}/own-status | S3 | `WorkItemRepository.setOwnStatus` | `TaskTransition` | Atanmış üyenin geçişi. |
| updateWorkItem | PATCH /v1/work-items/{id} | S3 | `WorkItemRepository.update` | `TaskPatch` → `TaskSummary` | `completed_on`/`submitted_on` korumalı, domain'de bilerek yok. Zincirleme kaydırma (WORK-K28). |
| deleteWorkItem | DELETE /v1/work-items/{id} | S3 | `WorkItemRepository.delete` | `void` | Yumuşak silme. |
| claimWorkItem | POST /v1/work-items/{id}/claim | S3 | `WorkItemRepository.claim` | `void` | |
| unclaimWorkItem | DELETE /v1/work-items/{id}/claim | S3 | `WorkItemRepository.unclaim` | `void` | |
| addAssignments | POST /v1/work-items/{id}/assignments | S3 | `WorkItemRepository.addAssignees` | `int` (eklenen) | Yalnız K (WORK-K10). |
| removeAssignment | DELETE /v1/work-items/{id}/assignments/{accountId} | S3 | `WorkItemRepository.removeAssignee` | `int` (kaldırılan) | |
| myTasks | GET /v1/work-items/my-tasks | S3 | `WorkItemRepository.myTasks` | `List<AssignedTask>` | `MyTask.status` serbest dize → `TaskStatus` (+unknown). |
| addWorkItemNote | POST /v1/work-items/{id}/notes | S3 | `WorkItemNoteRepository.add` | `TaskNote` | ŞY yazamaz (WORK-K32). |
| listWorkItemNotes | GET /v1/work-items/{id}/notes | S3 | `WorkItemNoteRepository.list` | `CountedList<TaskNote>` | Sayfasız, zorunlu `total` domain'e taşındı. |
| updateWorkItemNote | PATCH /v1/work-items/{id}/notes/{noteId} | S3 | `WorkItemNoteRepository.update` | `void` | |
| deleteWorkItemNote | DELETE /v1/work-items/{id}/notes/{noteId} | S3 | `WorkItemNoteRepository.delete` | `void` | |
| addDependency | POST /v1/work-items/{id}/dependencies | S3 | `WorkItemDependencyRepository.add` | `TaskDependency` | |
| listDependencies | GET /v1/work-items/{id}/dependencies | S3 | `WorkItemDependencyRepository.list` | `TaskDependencies` | `dependencies` (ön görevler) + `dependents`. |
| removeDependency | DELETE /v1/work-items/{id}/dependencies/{depId} | S3 | `WorkItemDependencyRepository.remove` | `void` | `depId` kenar kimliği (`TaskDependency.id`), görev kimliği değil. |
| coordinatorGantt | GET /v1/work-items/gantt | S3 | `GanttRepository.coordinator` (timeline) | `GanttSchedule` | Görevler `TaskItem`'a, bağlantılar `TaskDependency`'ye eşlenir. |
| memberGantt | GET /v1/work-items/gantt/mine | S3 | `GanttRepository.member` (timeline) | `GanttSchedule` | |
| extendWorkItem | POST /v1/work-items/{id}/extend | S3 | `WorkItemRepository.extend` | `TaskExtension` | Bağımlılara yayılır (`cascade_count`). |
| pullCompletion | POST /v1/work-items/{id}/pull-completion | S3 | `WorkItemRepository.pullCompletion` | `TaskDates` | Gün alanı biçimi açık (§1). |
| pullEndDate | POST /v1/work-items/{id}/pull-end-date | S3 | `WorkItemRepository.pullEndDate` | `TaskDates` | |
| setCompletionDate | PATCH /v1/work-items/{id}/completion-date | S3 | `WorkItemRepository.setCompletionDate` | `TaskDates` | Gün alanı biçimi açık (§1). |
| adminGantt | GET /v1/work-items/gantt/admin | S2 | `GanttRepository.admin({overdueOnly})` (timeline) | `GanttSchedule` | `overdue=true` yalnız `overdueOnly` iken gönderilir. |
| requestDateChange | POST /v1/date-change-requests | S3 | `DateChangeRequestRepository.request` | `DateChangeRequest` | Yalnız K (WORK-K38). Gün alanı biçimi açık (§1). |
| listDateChangeRequests | GET /v1/date-change-requests | S1 | `DateChangeRequestRepository.list({pendingOnly})` | `CountedList<DateChangeRequest>` | Yalnız ŞY. `status=pending` tek tanımlı süzgeç. Zorunlu `total` taşındı. |
| myDateChangeRequests | GET /v1/date-change-requests/mine | S3 | `DateChangeRequestRepository.mine` | `CountedList<DateChangeRequest>` | |
| reviewDateChangeRequest | POST /v1/date-change-requests/{id}/review | S1 | `DateChangeRequestRepository.review` | `DateRequestDecision` → `int` (etkilenen görev) | Yalnız ŞY (WORK-K39). |
| deleteDateChangeRequest | DELETE /v1/date-change-requests/{id} | S1 | `DateChangeRequestRepository.delete` | `void` | İncelenmiş talep. |
| listDeletedWorkItems | GET /v1/admin/deleted/work-items | S2 | `DeletedWorkItemRepository.list` | `PageSlice<DeletedTask>` | İmleçli. `status` serbest dize → `TaskStatus` (+unknown). |
| restoreWorkItem | PATCH /v1/admin/restore/work-items/{id} | S2 | `DeletedWorkItemRepository.restore` | `void` | Yalnız ŞY (WORK-K45). Yanıt `status` görmezden gelinir (tanımsız değer throw etmez). |
| permanentDeleteWorkItem | DELETE /v1/admin/permanent/work-items/{id} | S2 | `DeletedWorkItemRepository.purge` | `int` (silinen dosya) | |

Uygulama dosyaları: `lib/features/tasks/data/{work_item,work_item_dependency,work_item_note,date_change_request,deleted_work_item}_api_repository.dart`,
`lib/features/timeline/data/gantt_api_repository.dart`. Arayüzler: `lib/features/tasks/domain/work_item_repository.dart`,
`lib/features/timeline/domain/gantt_schedule.dart`. Testler: `test/features/tasks/data/*_api_repository_test.dart` (5 dosya),
`test/features/timeline/data/gantt_api_repository_test.dart` (toplam 61 test).

## Domain değişiklikleri

- `lib/features/tasks/domain/task_catalog.dart`
  - `TaskStatus`: `unknown` eklendi, `TaskStatus.known` (seçiciler için). Sunucu eşlemesi todo↔`baslanmadi`, inProgress↔`devam_ediyor`, review↔`onaya_sunuldu`, returned↔`iade_edildi`, done↔`tamamlandi`.
  - `TaskPriority`: `urgent` (`acil`) ve `unknown` eklendi; `TaskPriority.pickable` = low/medium/high (urgent'ın ARB metni yok, seçtirilmez).
  - `DateRequestState`: `unknown` eklendi. Yeni `DateRequestDecision {approve, reject}`.
  - `DateChangeRequest` spec ile birleşti: `id` (`request_id`), `workItemId`, `oldStart` (`old_start_on`) eklendi; `oldDue`←`old_end_on`, `start`←`new_start_on`, `due`←`new_end_on`, `state`←`status`. `by`/`at` isteğe bağlı oldu (sunucuda yok — entegrasyonda karar, B-08). `reason` varsayılanı `''` (sunucuda isteğe bağlı).
  - `TaskNote` spec ile birleşti: `id`, `workItemId`, `updatedAt` eklendi; `by`←`author_account_id`, `at`←`created_at`, `text`←`content`. `inMemory` sunucuda yok (B-17).
  - `TaskItem` spec `GanttTask` ile birleşti: `id` (verilmezse `code`), `departmentId`, `programId`, `plannedEnd`, `description`, `lateness` eklendi. Sunucudan eşlenen görevde `code = id`, `coordinatorship = department_id` (görev/koordinatörlük kodu sunucuda yok, B-03/B-04). `creator`/`createdAt` isteğe bağlı oldu (sunucu görev yüzlerinde yok, B-02). `subtasks`, `evidenceRequired`, `files`, `notes`, `fileEntries`, `noteEntries` dokunulmadı (sunucuda yok ya da başka uçtan, entegrasyonda karar).
  - Yeni `TaskLateness` (sunucu gecikme bayrakları), `TaskDependency` (`DependencyEdge` + `GanttLink` birleşik).
- `lib/features/tasks/domain/work_item.dart` (yeni): `TaskSummary` (tarihsiz `WorkItem`; `TaskItem`'ın UI'da zorunlu `start`/`due` alanları bu yüzde olmadığı için ayrı), `AssignedTask`, `TaskDraft`, `TaskPatch`, `TaskTransition` + `TransitionActor`, `TaskDates`, `TaskExtension`, `TaskDependencies`, `CountedList<T>`, `DeletedTask`.
- `lib/features/tasks/domain/work_item_repository.dart` (yeni): beş port.
- `lib/features/timeline/domain/gantt_schedule.dart` (yeni): `GanttSchedule` (`TaskItem` + `TaskDependency`), `GanttRepository`. Mevcut `TimelineTask`/yatay `GanttTask` görünüm sarmalayıcıları zaten `TaskItem` taşıdığı için Gantt verisi doğrudan onlara akabilir.

UI derlenmesi için yapılan zorunlu küçük uyarlamalar (davranış değişmez, örnek veride görünüm aynı):
`task_texts.dart`, `timeline_texts.dart` (urgent → "yüksek" metni, unknown → "başlanmadı"/"orta" metni; ARB anahtarı yok,
entegrasyonda karar), `timeline_painters.dart`, `gantt_painters.dart`, `timeline_selection_card.dart` (unknown → nötr renk),
seçicilerde `.values` → `TaskStatus.known`/`TaskPriority.pickable` (`detail_actions.dart`, `detail_forms.dart`,
`new_task_form.dart`, `tasks_filter_sheet.dart`, `gantt_controls.dart`), isteğe bağlı alanlar için `detail_tabs.dart`,
`task_detail_page.dart`, `detail_actions.dart` ve `task_query.dart` (`createdAt` `null` en sona).

## Ortaklaştırma adayları

1. **Gün (`format: date`) istek alanları** — core/üretim katmanı. Üretilmiş istek DTO'ları `DateTime`'ı
   `toIso8601String()` ile yazıyor (`2026-11-01T00:00:00.000`); backend `parseDay` yalnız `2006-01-02` kabul ediyor
   (422 `work.input_invalid`). features içinde `Map<String, …>` yasak (D2) olduğundan düzeltme burada yapılamadı.
   Öneri: üretimde `format: date` için `JsonConverter` (yalnız gün) ya da DTO'da `String`. Etkilenen: createWorkItem,
   updateWorkItem, requestDateChange, pullCompletion, setCompletionDate (ve başka modüllerdeki gün alanları).
2. **Görev durumu/öncelik sunucu değeri eşlemesi**: `tasks/data/work_item_mapping.dart` ve
   `timeline/data/gantt_api_repository.dart` içinde kopya (B3). Reporting (`ReportTask`, `WorkloadTask`) da aynı
   değerleri taşıyor; ortak saf-Dart eşleyici (`core/domain` ya da tasks açık yüzü) adayı.
3. **`CountedList<T>`** (sayfasız liste + sunucu `total`): reporting `ReportTaskList`, `WorkloadReport` için de
   gerekli; `core/domain/page_slice.dart` yanına taşınma adayı.
4. **`TaskLateness`**: reporting görev satırları da aynı bayrakları taşıyor.

## Açık sorunlar

1. Gün alanı biçimi (yukarıda 1) — tarih yazan 5 işlem gerçek sunucuda 422 dönecek; testler yalnız gün önekini doğrular.
2. `GanttTask.start_on/end_on/planned_end_on/completed_on` spec'te `format: date` değil → dize; repository ayrıştırır,
   geçersizse `client.invalid_response` (B-20).
3. `TaskPriority.urgent` ve `TaskStatus.unknown` için ARB metni yok; UI yaklaşık metin gösterir. `detail_forms.dart`
   öncelik seçicisinde `urgent` görevde seçili dilim yok (`indexOf` -1).
4. Önceden var olan iki test kırmızısı (temel `bd083c2`'de de kırmızı, bu değişiklikle ilgisiz):
   `task_catalog_controller_test.dart` (ALT koordinatörleri `['aa','av','ko']`) ve
   `quick_action_sheets_test.dart` "yeni görev: doğrulama, satırlar, oluşturma" (`üye` metni bulunamıyor).
