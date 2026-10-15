import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'scope_service.dart';

part 'scope_providers.g.dart';

/// PORT: kapsam servisi bileşim kökünde (`scope_module.dart`, get_it) kurulur ve burada
/// geçersiz kılınır; sunum katmanı servisi bu sağlayıcıdan okur.
@Riverpod(keepAlive: true)
ScopeService scopeService(Ref ref) => throw UnimplementedError(
  'scopeServiceProvider bileşim kökünde (lib/app/di) bağlanır',
);
