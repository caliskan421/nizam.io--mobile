// Durum makinesi: bağ yok → sunucu doğrulandı → oturum → kapsam; router türetimi.
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/server/server_address.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/session/session_state.dart';

void main() {
  final address = ServerAddress.parse('https://n.example.test', Flavor.prod);
  final verified = BindingVerified(
    ServerInfo(
      address: address,
      instanceId: 'i',
      displayName: 'd',
      brandColor: '#000000',
      apiVersion: 'v1',
      minimumMobileVersion: '0.0.0',
      serverVersion: 's',
    ),
  );
  const none = ScopeSelection();
  const active = SessionActive(accountId: 'a', forcePasswordChange: false);

  test('geçişler', () {
    expect(
      deriveAppPhase(const BindingUnbound(), active, none),
      AppPhase.unbound,
    );
    expect(
      deriveAppPhase(BindingFailed(ApiError('client.tls_error')), active, none),
      AppPhase.bindingFailed,
    );
    expect(
      deriveAppPhase(
        BindingUpdateRequired(
          address: address,
          minimumVersion: '9.0.0',
          appVersion: '0.1.0',
        ),
        active,
        none,
      ),
      AppPhase.updateRequired,
      reason: 'güncelleme gerekliyken oturum olsa da giriş/kabuk açılmaz',
    );
    expect(
      deriveAppPhase(verified, const SessionNone(), none),
      AppPhase.serverVerified,
    );
    expect(
      deriveAppPhase(
        verified,
        const SessionReauthRequired(ReauthReason.refreshAmbiguous),
        none,
      ),
      AppPhase.reauthRequired,
    );
    expect(
      deriveAppPhase(
        verified,
        const SessionActive(accountId: 'a', forcePasswordChange: true),
        none,
      ),
      AppPhase.passwordChangeRequired,
    );
    expect(deriveAppPhase(verified, active, none), AppPhase.sessionOpen);
    expect(
      deriveAppPhase(verified, active, const ScopeSelection(programId: 'p')),
      AppPhase.scoped,
    );
  });

  test('her faz bir rotaya gider', () {
    for (final p in AppPhase.values) {
      expect(routeForPhase(p), startsWith('/'));
    }
    expect(routeForPhase(AppPhase.updateRequired), '/update-required');
  });
}
