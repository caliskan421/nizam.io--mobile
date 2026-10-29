import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/scope/scope_controller.dart';
import '../../../core/server/server_binding.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/session_state.dart';
import '../data/program_repository.dart';
import '../domain/program.dart';

/// Kapsam (program) servisi. Kapsam kimliğini taşıyan tek yer core [ScopeController]'dır; bu
/// servis programları okur, seçimi ona yazar ve kapsamdaki programı S2 ucundan okur (kapsam
/// başlığının isteğe girdiğinin kanıtı). Seçim yalnız bellektedir (ADR-0003 karar 20).
class ScopeService {
  ScopeService({
    required this.binding,
    required this.session,
    required this.scope,
    required this.repository,
  });

  final ServerBindingController binding;
  final SessionController session;
  final ScopeController scope;
  final ProgramRepository? Function() repository;

  ProgramRepository _repo() {
    final r = repository();
    if (r == null) throw ApiError(ClientErrorCode.serverNotVerified);
    return r;
  }

  /// Oturumdaki hesabın programları (S1). Yanıt beklenirken oturum / bağ değiştiyse sonuç
  /// atılır (başka hesabın listesi gösterilmez; farklı sunucuya yeniden bağlanma da oturum
  /// nesli artırır).
  Future<PageSlice<Program>> programs() async {
    final generation = session.generation;
    final slice = await _repo().listPrograms();
    if (session.generation != generation) {
      throw ApiError(ClientErrorCode.sessionEnded);
    }
    return slice;
  }

  /// [programId] programını kapsam olarak seçer. Etkin (ve parola değişikliği beklemeyen)
  /// oturum yoksa seçim yapılmaz.
  void select(String programId) {
    final s = session.state.value;
    if (s is! SessionActive || s.forcePasswordChange || programId.isEmpty) {
      throw ApiError(ClientErrorCode.notSignedIn);
    }
    scope.selectProgram(programId);
  }

  /// Örnek kapsam (program yokken statik verilerle kabuk); faz `scoped` olur.
  void selectSample() => scope.selectSample();

  /// Seçimi kaldırır; faz `sessionOpen`'a döner.
  void clearSelection() => scope.clear();

  /// Kapsamdaki program (S2). Seçim yoksa istek GÖNDERİLMEZ: ara katman
  /// `client.scope_missing` ile reddeder. Yanıt beklenirken oturum / kapsam değiştiyse sonuç
  /// atılır.
  Future<Program> currentProgram() async {
    final generation = session.generation;
    final programId = scope.current.programId;
    final program = await _repo().readProgram();
    if (session.generation != generation ||
        scope.current.programId != programId) {
      throw ApiError(ClientErrorCode.sessionEnded);
    }
    return program;
  }
}
