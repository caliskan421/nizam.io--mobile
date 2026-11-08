import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/meeting_status.dart';
import '../domain/meetings_repository.dart';

part 'meetings_providers.g.dart';

/// PORT: toplantı uçlarının kaynağı (`meetings_module.dart`'ta sunucu gerçekleştirmesi bağlanır).
@Riverpod(keepAlive: true)
MeetingsRepository meetingsRepository(Ref ref) => throw UnimplementedError(
  'meetingsRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);

/// Backend'in taşımadığı toplantı olguları (geçici; bkz. [MeetingExtras]). Bağlanmamışsa boş:
/// üretimde hiçbir olgu yok. Bileşim kökü dev'de örnek kaynağı bağlar.
@Riverpod(keepAlive: true)
MeetingExtrasRepository meetingExtrasRepository(Ref ref) =>
    const NoMeetingExtras();
