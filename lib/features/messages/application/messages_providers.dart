import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/chat.dart';

part 'messages_providers.g.dart';

/// PORT: mesajlar kutusunun kaynağı (`messages_module.dart`'ta bağlanır; bugün geliştirme
/// örneği).
@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) => throw UnimplementedError(
  'chatRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);
