import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_profile.dart';

part 'coordinatorships_providers.g.dart';

/// PORT: koordinatörlük departman kaydının (tür, açıklama) kaynağı
/// (`coordinatorships_module.dart`'ta bağlanır; sunucu).
@Riverpod(keepAlive: true)
CoordinatorshipProfileRepository coordinatorshipProfileRepository(Ref ref) =>
    throw UnimplementedError(
      'coordinatorshipProfileRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );

/// PORT: koordinatörlük toplantı ve arşiv kaynağı (`coordinatorships_module.dart`'ta bağlanır).
@Riverpod(keepAlive: true)
CoordinatorshipActivityRepository coordinatorshipActivityRepository(Ref ref) =>
    throw UnimplementedError(
      'coordinatorshipActivityRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );
