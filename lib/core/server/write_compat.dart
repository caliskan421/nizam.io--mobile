import 'semver.dart';
import 'server_binding.dart';

/// Düzenleme sürümü ve işlem anahtarı sözleşmesinin (ADR-0027) geldiği asgari sunucu sürümü.
/// Keşif `server_version` bundan düşükse ya da okunamıyorsa yazma gönderilmez: eski sunucu
/// `expected_revision`'ı ve `Idempotency-Key`'i sessizce yok sayar (yeni istemci × eski
/// sunucu desteklenmez; ADR-0027 uyum matrisi).
const minimumWriteServerVersion = SemVer(0, 11, 0);

/// Sunucu sürümünün `MAJOR.MINOR.PATCH` çekirdeği; ön sürüm/derleme eki (`-rc.1`, `+abc`)
/// karşılaştırmaya girmez. Biçim dışı → null.
SemVer? serverVersionCore(String raw) {
  final m = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)(?:[-+].*)?$')
      .firstMatch(raw.trim());
  if (m == null) return null;
  return SemVer(
    int.parse(m.group(1)!),
    int.parse(m.group(2)!),
    int.parse(m.group(3)!),
  );
}

/// Bağlı sunucu sürümlü yazmayı destekliyor mu (yalnız doğrulanmış bağda).
bool serverSupportsVersionedWrites(BindingState binding) {
  if (binding is! BindingVerified) return false;
  final v = serverVersionCore(binding.info.serverVersion);
  return v != null && !(v < minimumWriteServerVersion);
}
