import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/scope/scope_controller.dart';
import '../../../core/scope/scope_store.dart';
import '../../../core/server/server_binding.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/session/session_state.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../data/program_repository.dart';
import '../domain/program.dart';

/// Kapsam (program) servisi. Kapsam kimliğini taşıyan tek yer core [ScopeController]'dır; bu
/// servis programları okur, seçimi ona yazar ve kapsamdaki programı S2 ucundan okur (kapsam
/// başlığının isteğe girdiğinin kanıtı). Son seçim güvenli depoda kalır ve girişte geri yüklenir ([restoreLast], ADR-0003 karar 20).
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

  /// Girişten sonra aynı hesap + kurulumun SON görünümünü (program, rol, koordinatörlük) geri
  /// yükler. Etkin oturum, doğrulanmış bağ ve seçimsizlik gerekir. Kayıtlı program artık
  /// kullanıcının programları arasında değilse kayıt silinir; liste okunamazsa seçim bırakılır
  /// (kayıt kalır). Hata fırlatmaz.
  Future<void> restoreLast() async {
    final s = session.state.value;
    final b = binding.current;
    if (s is! SessionActive ||
        s.forcePasswordChange ||
        b is! BindingVerified ||
        scope.current.hasProgram) {
      return;
    }
    final generation = session.generation;
    final owner = ScopeOwner(
      accountId: s.accountId,
      instanceId: b.info.instanceId,
    );
    if (!await scope.restore(owner) || session.generation != generation) return;
    final id = scope.current.programId;
    try {
      final slice = await programs();
      if (!slice.items.any((p) => p.id == id)) scope.clear();
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.scope);
      if (session.generation == generation) scope.suspend();
    }
  }

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
