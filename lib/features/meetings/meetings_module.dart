import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/config/flavor.dart';
import '../tasks/tasks.dart';
import 'application/meetings_planner.dart';
import 'application/meetings_providers.dart';
import 'data/meetings_api_repository.dart';
import 'data/sample/sample_meeting_extras.dart';
import 'domain/meeting_status.dart';
import 'domain/meetings_repository.dart';

/// meetings modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
/// [flavor] dev ise backend'in henüz taşımadığı olgular örnek kaynaktan gelir (geçici).
void registerMeetingsModule(
  GetIt locator, {
  required Dio? Function() apiDio,
  required Flavor flavor,
}) {
  locator
    ..registerLazySingleton<MeetingsRepository>(
      () => ApiMeetingsRepository(apiDio),
    )
    // GEÇİCİ: konferans geçmişi, bağlı kişi, silen, sohbet backend'de yok (yalnız dev örneği).
    ..registerLazySingleton<MeetingExtrasRepository>(
      () => flavor == Flavor.dev
          ? const SampleMeetingExtras()
          : const NoMeetingExtras(),
    );
}

/// meetings'in Riverpod portlarını bağlar; tasks'ın toplantı yazma portu ([MeetingPlanner])
/// da buradan gerçekleştirilir.
List<Override> meetingsOverrides(GetIt locator) => [
  meetingsRepositoryProvider.overrideWith(
    (ref) => locator<MeetingsRepository>(),
  ),
  meetingExtrasRepositoryProvider.overrideWith(
    (ref) => locator<MeetingExtrasRepository>(),
  ),
  meetingPlannerProvider.overrideWith(MeetingsPlanner.new),
];
