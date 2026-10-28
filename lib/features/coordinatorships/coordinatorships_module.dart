import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

/// coordinatorships modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerCoordinatorshipsModule(GetIt locator) {}

/// coordinatorships'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> coordinatorshipsOverrides(GetIt locator) => const [];
