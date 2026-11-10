import '../../../core/domain/page_slice.dart';
import 'task_catalog.dart';
import 'work_item.dart';

// work modülünün görev servis yüzleri (domain portları; gerçekleştirmeler `data/`). Kapsam
// başlıkları (`X-Nizamio-Program`/`Department`) ara katmandan, seçili kapsamdan gelir: S3
// uçları tek departman içindir. Bütün hatalar `ApiError` olarak fırlar; yetki kararı
// (ŞY/K/Ü matrisi) sunucudadır, istemci türetmez.

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

  /// `POST /v1/work-items/{id}/notes`; [requestKey] işlem anahtarı (ADR-0027).
  Future<TaskNote> add(
    String workItemId,
    String text, {
    required String requestKey,
  });

  /// `PATCH /v1/work-items/{id}/notes/{noteId}`; [expectedRevision] notun okunan
  /// `edit_revision`'ı (ADR-0027).
  Future<void> update(
    String workItemId,
    String noteId,
    String text, {
    required int expectedRevision,
  });

  /// `DELETE /v1/work-items/{id}/notes/{noteId}`.
  Future<void> delete(String workItemId, String noteId);
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
