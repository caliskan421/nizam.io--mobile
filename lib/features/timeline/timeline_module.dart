import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

/// timeline modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerTimelineModule(GetIt locator) {}

/// timeline'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> timelineOverrides(GetIt locator) => const [];
