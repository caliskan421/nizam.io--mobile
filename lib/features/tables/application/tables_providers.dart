import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/tables_repository.dart';

part 'tables_providers.g.dart';

/// PORT: tablolar uçlarının kaynağı (`tables_module.dart`'ta sunucu gerçekleştirmesi
/// bağlanır).
@Riverpod(keepAlive: true)
TablesRepository tablesRepository(Ref ref) => throw UnimplementedError(
  'tablesRepositoryProvider bileşim kökünde (lib/app/di) bağlanır',
);
