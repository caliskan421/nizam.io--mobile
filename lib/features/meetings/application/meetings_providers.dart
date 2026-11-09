import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/meetings_repository.dart';

part 'meetings_providers.g.dart';

/// PORT: toplantı uçlarının kaynağı (`meetings_module.dart`'ta sunucu gerçekleştirmesi bağlanır).
@Riverpod(keepAlive: true)
MeetingsRepository meetingsRepository(Ref ref) => throw UnimplementedError(
  'meetingsRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);
