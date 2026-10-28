import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/archive.dart';

part 'archive_providers.g.dart';

/// PORT: arşiv klasörlerinin kaynağı (`archive_module.dart`'ta bağlanır; bugün geliştirme
/// örneği).
@Riverpod(keepAlive: true)
ArchiveRepository archiveRepository(Ref ref) => throw UnimplementedError(
  'archiveRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);
