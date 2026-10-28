import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

/// messages modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerMessagesModule(GetIt locator) {}

/// messages'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> messagesOverrides(GetIt locator) => const [];
