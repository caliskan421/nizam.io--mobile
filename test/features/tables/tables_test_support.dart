// Tablolar controller testlerinin kapsayıcısı: sahte depo, etkin oturum ('me'), seçili
// program + departman.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/core/session/session_state.dart';
import 'package:nizamio/features/tables/application/tables_providers.dart';

import 'fake_tables_repository.dart';

ProviderContainer tablesContainer(
  FakeTablesRepository repo, {
  String? programId = 'p1',
  String? departmentId = 'd1',
}) {
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      tablesRepositoryProvider.overrideWithValue(repo),
      sessionGenerationProvider.overrideWithValue(1),
      sessionStateProvider.overrideWithValue(
        const SessionActive(accountId: 'me', forcePasswordChange: false),
      ),
      scopeStateProvider.overrideWithValue(
        ScopeSelection(programId: programId, departmentId: departmentId),
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}
