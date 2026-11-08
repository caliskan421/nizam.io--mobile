import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../tasks/tasks.dart';
import 'application/chat_task_planner.dart';
import 'application/messages_providers.dart';
import 'data/chat_api_repository.dart';
import 'domain/chat.dart';

/// messages modülünün kayıt fonksiyonu (ADR-0001). YALNIZ bileşim kökünden çağrılır (G2).
///
/// [apiDio]: doğrulanmış bağın güncel API istemcisi (Riverpod `apiDioProvider`); bağ yoksa null.
void registerMessagesModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerLazySingleton<ChatRepository>(
    () => ApiChatRepository(apiDio),
  );
}

/// messages'in Riverpod portlarını get_it örnekleriyle bağlar; tasks'ın mesajdan görev portu
/// ([ChatTaskPlanner]) da buradan gerçekleştirilir.
List<Override> messagesOverrides(GetIt locator) => [
  chatRepositoryProvider.overrideWith((ref) => locator<ChatRepository>()),
  chatTaskPlannerProvider.overrideWith(MessagesTaskPlanner.new),
];
