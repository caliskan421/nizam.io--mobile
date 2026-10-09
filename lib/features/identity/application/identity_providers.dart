import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/generated/clients/identity_client.dart';
import '../../../core/providers.dart';
import '../data/identity_repository.dart';
import 'identity_service.dart';

part 'identity_providers.g.dart';

@Riverpod(keepAlive: true)
IdentityService identityService(Ref ref) => IdentityService(
  binding: ref.watch(serverBindingProvider),
  session: ref.watch(sessionControllerProvider),
  repository: () {
    final dio = ref.read(apiDioProvider);
    return dio == null ? null : IdentityRepository(IdentityClient(dio));
  },
);
