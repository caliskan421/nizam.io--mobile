import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import 'application/messages_providers.dart';
import 'data/sample/sample_chat_repository.dart';
import 'domain/chat.dart';

/// messages modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
void registerMessagesModule(GetIt locator) {
  // GEÇİCİ: mesajlaşma backend'de hazır olana kadar geliştirme örneği; gerçek kaynak
  // geldiğinde yalnız bu kayıt değişir.
  locator.registerLazySingleton<ChatRepository>(SampleChatRepository.new);
}

/// messages'in Riverpod portlarını get_it örnekleriyle bağlar.
List<Override> messagesOverrides(GetIt locator) => [
  chatRepositoryProvider.overrideWith((ref) => locator<ChatRepository>()),
];
