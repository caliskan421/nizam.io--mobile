import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/conference.dart';
import '../domain/meetings_repository.dart';

part 'meetings_providers.g.dart';

/// PORT: toplantı uçlarının kaynağı (`meetings_module.dart`'ta sunucu gerçekleştirmesi bağlanır).
@Riverpod(keepAlive: true)
MeetingsRepository meetingsRepository(Ref ref) => throw UnimplementedError(
  'meetingsRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// PORT: görüntülü görüşme oda bağı üreticisi (`meetings_module.dart`'ta LiveKit bağlanır;
/// testte sahte). Her katılım yeni bağ alır.
@Riverpod(keepAlive: true)
ConferenceLinkFactory conferenceLinkFactory(Ref ref) =>
    throw UnimplementedError(
      'conferenceLinkFactoryProvider bileşim kökünde (lib/app/di) bağlanır',
    );
