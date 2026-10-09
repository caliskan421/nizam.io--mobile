import 'scope/scope_controller.dart';
import 'server/server_binding.dart';
import 'session/session_state.dart';

/// Uygulama durum makinesi (platform §6, K-11): bağ yok → sunucu doğrulandı → oturum → kapsam.
/// Router bu değerden türetilir (app/router.dart).
enum AppPhase {
  unbound,
  verifying,
  bindingFailed,
  updateRequired,
  serverVerified,
  reauthRequired,
  passwordChangeRequired,
  sessionOpen,
  scoped,
}

AppPhase deriveAppPhase(
  BindingState binding,
  SessionState session,
  ScopeSelection scope,
) {
  switch (binding) {
    case BindingUnbound():
      return AppPhase.unbound;
    case BindingVerifying():
      return AppPhase.verifying;
    case BindingFailed():
      return AppPhase.bindingFailed;
    case BindingUpdateRequired():
      return AppPhase.updateRequired;
    case BindingVerified():
      break;
  }
  switch (session) {
    case SessionNone():
      return AppPhase.serverVerified;
    case SessionReauthRequired():
      return AppPhase.reauthRequired;
    case SessionActive(forcePasswordChange: true):
      return AppPhase.passwordChangeRequired;
    case SessionActive():
      return scope.hasProgram ? AppPhase.scoped : AppPhase.sessionOpen;
  }
}
