import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/coordinatorship_profile.dart';

part 'coordinatorships_providers.g.dart';

/// PORT: koordinatörlük ek bilgilerinin kaynağı (`coordinatorships_module.dart`'ta bağlanır;
/// bugün geliştirme örneği).
@Riverpod(keepAlive: true)
CoordinatorshipProfileRepository coordinatorshipProfileRepository(Ref ref) =>
    throw UnimplementedError(
      'coordinatorshipProfileRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );
