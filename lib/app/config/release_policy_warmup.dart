import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/release_policy_provider.dart';

/// İlk kareden sonra çağrılır; politika okuması giriş/açılış akışını bekletmez.
/// Ham SDK hatası uygulama günlüğüne veya başka bir Firebase servisine taşınmaz.
Future<void> warmReleasePolicy(ProviderContainer container) async {
  try {
    await container.read(mobileReleasePolicyProvider.future);
  } on Object {
    // Sağlayıcı AsyncError durumunu korur; yeniden deneme açık kullanıcı/akış kararıdır.
  }
}
