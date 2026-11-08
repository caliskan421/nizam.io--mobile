// Sunucu uyum kapısı (CX-P0K-04): sürümlü yazma yalnız doğrulanmış bağda ve keşif
// `server_version` ≥ 0.11.0 iken; ön sürüm/derleme eki çekirdeği değiştirmez; okunamayan sürüm
// yazmayı kapatır (fail-closed).
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/config/flavor.dart';
import 'package:nizamio/core/server/server_address.dart';
import 'package:nizamio/core/server/server_binding.dart';
import 'package:nizamio/core/server/write_compat.dart';

BindingState _verified(String version) => BindingVerified(
  ServerInfo(
    address: ServerAddress.parse('https://nizam.example.test', Flavor.prod),
    instanceId: 'i',
    displayName: 'd',
    brandColor: '#000000',
    apiVersion: 'v1',
    minimumMobileVersion: '0.0.0',
    serverVersion: version,
  ),
);

void main() {
  test('sürüm çekirdeği: ek yok sayılır; biçim dışı null', () {
    expect(serverVersionCore('0.11.0').toString(), '0.11.0');
    expect(serverVersionCore('v0.11.0-rc.1').toString(), '0.11.0');
    expect(serverVersionCore('1.2.3+abc').toString(), '1.2.3');
    expect(serverVersionCore('x'), isNull);
    expect(serverVersionCore('0.11'), isNull);
    expect(serverVersionCore(''), isNull);
  });

  test('asgari sürüm ve üstü destekli; altı ve okunamayan desteksiz', () {
    expect(serverSupportsVersionedWrites(_verified('0.11.0')), isTrue);
    expect(serverSupportsVersionedWrites(_verified('0.11.0-test')), isTrue);
    expect(serverSupportsVersionedWrites(_verified('1.0.0')), isTrue);
    expect(serverSupportsVersionedWrites(_verified('0.10.9')), isFalse);
    expect(serverSupportsVersionedWrites(_verified('0.0.0-test')), isFalse);
    expect(serverSupportsVersionedWrites(_verified('x')), isFalse);
  });

  test('doğrulanmamış bağ yazmayı kapatır', () {
    expect(serverSupportsVersionedWrites(const BindingUnbound()), isFalse);
  });
}
