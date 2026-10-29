import '../../../core/domain/page_slice.dart';
import 'task_catalog.dart';
import 'work_item.dart';

// work modülünün görev servis yüzleri (domain portları; gerçekleştirmeler `data/`). Kapsam
// başlıkları (`X-Nizamio-Program`/`Department`) ara katmandan, seçili kapsamdan gelir: S3
// uçları tek departman içindir. Bütün hatalar `ApiError` olarak fırlar; yetki kararı
// (ŞY/K/Ü matrisi) sunucudadır, istemci türetmez.

/// Görev yaşam döngüsü: liste, oluşturma, güncelleme, silme, durum geçişleri, üstlenme,
/// atamalar, "görevlerim" ve tarih düzeltmeleri (S3).
abstract interface class WorkItemRepository {
  /// `GET /v1/work-items` (imleçli; Ü yalnız atandığını görür — WORK-K24).
  Future<PageSlice<TaskSummary>> list([PageRequest page = const PageRequest()]);

  /// `POST /v1/work-items`.
  Future<TaskSummary> create(TaskDraft draft);

  /// `PATCH /v1/work-items/{id}`.
  Future<TaskSummary> update(String id, TaskPatch patch);

  /// `DELETE /v1/work-items/{id}` (yumuşak silme).
  Future<void> delete(String id);

  /// `POST /v1/work-items/{id}/transitions` (koordinatör/ŞY geçiş tablosu). Geri almada
  /// [reason] zorunludur (422 `work.revert_reason_required`). [to] [TaskStatus.unknown]
  /// olamaz.
  Future<TaskTransition> transition(
    String id,
    TaskStatus to, {
    String? reason,
    bool? pullEndDate,
  });

  /// `PATCH /v1/work-items/{id}/own-status`: atanmış üyenin kendi geçişi (geçiş günü bugün).
  Future<TaskTransition> setOwnStatus(
    String id,
    TaskStatus to, {
    String? reason,
    bool? pullEndDate,
  });

  /// `POST /v1/work-items/{id}/claim`.
  Future<void> claim(String id);

  /// `DELETE /v1/work-items/{id}/claim`.
  Future<void> unclaim(String id);

  /// `POST /v1/work-items/{id}/assignments` (yalnız K — WORK-K10); eklenen kişi sayısı.
  Future<int> addAssignees(String id, List<String> accountIds);

  /// `DELETE /v1/work-items/{id}/assignments/{accountId}`; kaldırılan kişi sayısı.
  Future<int> removeAssignee(String id, String accountId);

  /// `GET /v1/work-items/my-tasks`: çağıranın atandığı görevler.
  Future<List<AssignedTask>> myTasks();

  /// `POST /v1/work-items/{id}/extend`: bitişi [days] gün uzatır (bağımlılara yayılır).
  Future<TaskExtension> extend(String id, int days);

  /// `POST /v1/work-items/{id}/pull-completion`: tamamlanma gününü [completedOn]'a çeker.
  Future<TaskDates> pullCompletion(String id, DateTime completedOn);

  /// `POST /v1/work-items/{id}/pull-end-date`: bitişi tamamlanma gününe çeker.
  Future<TaskDates> pullEndDate(String id);

  /// `PATCH /v1/work-items/{id}/completion-date`: tamamlanma gününü yönetici olarak düzeltir.
  Future<TaskDates> setCompletionDate(String id, DateTime completedOn);
}

/// Görevler arası bağımlılıklar (S3).
abstract interface class WorkItemDependencyRepository {
  /// `POST /v1/work-items/{id}/dependencies`: [id], [dependsOnId]'yi bekler.
  Future<TaskDependency> add(String id, String dependsOnId);

  /// `GET /v1/work-items/{id}/dependencies`.
  Future<TaskDependencies> list(String id);

  /// `DELETE /v1/work-items/{id}/dependencies/{depId}` ([dependencyId] kenar kimliğidir).
  Future<void> remove(String id, String dependencyId);
}

/// Görev notları (S3). ŞY not yazamaz; yalnız yazar düzenler/siler (WORK-K32).
abstract interface class WorkItemNoteRepository {
  /// `GET /v1/work-items/{id}/notes` (sayfasız; sunucu `total` bildirir).
  Future<CountedList<TaskNote>> list(String workItemId);

  /// `POST /v1/work-items/{id}/notes`.
  Future<TaskNote> add(String workItemId, String text);

  /// `PATCH /v1/work-items/{id}/notes/{noteId}`.
  Future<void> update(String workItemId, String noteId, String text);

  /// `DELETE /v1/work-items/{id}/notes/{noteId}`.
  Future<void> delete(String workItemId, String noteId);
}

/// Tarih değişikliği talepleri. Açma yalnız departman K'si (S3, WORK-K38); liste/inceleme/
/// silme yalnız ŞY (S1, WORK-K39).
abstract interface class DateChangeRequestRepository {
  /// `POST /v1/date-change-requests`.
  Future<DateChangeRequest> request({
    required String workItemId,
    required DateTime start,
    required DateTime due,
    String? reason,
  });

  /// `GET /v1/date-change-requests` (ŞY inceleme yüzü); [pendingOnly] → `status=pending`.
  Future<CountedList<DateChangeRequest>> list({bool pendingOnly = false});

  /// `GET /v1/date-change-requests/mine` (çağıranın açtıkları).
  Future<CountedList<DateChangeRequest>> mine();

  /// `POST /v1/date-change-requests/{id}/review`; etkilenen görev sayısı.
  Future<int> review(String requestId, DateRequestDecision decision);

  /// `DELETE /v1/date-change-requests/{id}` (incelenmiş talep).
  Future<void> delete(String requestId);
}

/// Silinmiş görevler (ŞY çöp kutusu, S2; WORK-K45).
abstract interface class DeletedWorkItemRepository {
  /// `GET /v1/admin/deleted/work-items` (imleçli).
  Future<PageSlice<DeletedTask>> list([PageRequest page = const PageRequest()]);

  /// `PATCH /v1/admin/restore/work-items/{id}`.
  Future<void> restore(String id);

  /// `DELETE /v1/admin/permanent/work-items/{id}`; silinen dosya sayısı.
  Future<int> purge(String id);
}
