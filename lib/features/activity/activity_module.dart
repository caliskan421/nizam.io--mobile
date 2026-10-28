import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

/// activity modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerActivityModule(GetIt locator) {}

/// activity'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> activityOverrides(GetIt locator) => const [];
