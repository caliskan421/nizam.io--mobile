import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'identity_service.dart';

part 'identity_providers.g.dart';

/// PORT: kimlik servisi bileşim kökünde (`identity_module.dart`, get_it) kurulur ve burada
/// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.
@Riverpod(keepAlive: true)
IdentityService identityService(Ref ref) => throw UnimplementedError(
  'identityServiceProvider bileşim kökünde (lib/app/di) bağlanır',
);
