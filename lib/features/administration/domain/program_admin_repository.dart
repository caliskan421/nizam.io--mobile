import '../../../core/domain/page_slice.dart';
import '../../scope/scope.dart' show Program;
import 'program_admin.dart';

/// Program yönetimi: oluşturma/güncelleme/silme, dönem sıfırlama ve programlar arası görev
/// aktarımı (program modülü). Yetki sunucudadır; istemci yetki türetmez. Gerçekleştirme
/// `data/`; bütün hatalar `ApiError` olarak fırlar. Parolalar yalnız istek gövdesine girer.
abstract interface class ProgramAdminRepository {
  /// `POST /v1/programs`: aynı ad varsa mevcut program döner (`created == false`).
  Future<ProgramCreation> createProgram({
    required String name,
    int? year,
    String? description,
  });

  /// `PATCH /v1/programs/{id}`: `null` alan değişmez.
  Future<Program> updateProgram(
    String programId, {
    String? name,
    int? year,
    String? description,
  });

  /// `DELETE /v1/programs/{id}`: [password] yeniden doğrulanır.
  Future<void> deleteProgram(String programId, {required String password});

  /// `POST /v1/programs/{id}/reset`: program ve katılım bağları kalır, dönem içeriği silinir.
  Future<ProgramReset> resetProgram(
    String programId, {
    required String password,
  });

  /// `POST /v1/program-transfers/preview` (salt okunur; hız sınırlı).
  Future<TransferPreview> previewTransfer({
    required String sourceProgramId,
    required String targetProgramId,
    required String departmentId,
    required List<String> workItemIds,
  });

  /// `POST /v1/program-transfers` (ileri aktarım; hep ya da hiç). [idempotencyKey] istemcinin
  /// ürettiği tekrar anahtarıdır: aynı anahtar + aynı gövde ilk sonucu döndürür
  /// ([TransferOutcome.replayed]); farklı gövde 409 `program.idempotency_key_reused`.
  Future<TransferOutcome> transfer({
    required String idempotencyKey,
    required String sourceProgramId,
    required String targetProgramId,
    required String departmentId,
    required List<String> workItemIds,
    required String previewFingerprint,
    bool? addMissingAccess,
  });

  /// `POST /v1/program-transfers` (ters aktarım: `reverses_transfer_id`).
  Future<TransferOutcome> reverseTransfer({
    required String idempotencyKey,
    required String transferId,
  });

  /// `GET /v1/program-transfers` (imleçli).
  Future<PageSlice<TransferRecord>> listTransfers({
    PageRequest page = const PageRequest(),
  });

  /// `GET /v1/program-transfers/{id}`.
  Future<TransferRecord> readTransfer(String transferId);
}
