// Kesik katalogda uçuştaki görev araması sahibe (oturum/program) bağlıdır: sahip değişince yeni
// sahip eski aramaya bağlanmaz, kendi aramasını yapar; eski aramanın tamamlanması yeni sahibin
// uçuştaki kaydını silmez (aynı görev için ikinci istek atılmaz).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/application/task_catalog_controller.dart';
import 'package:nizamio/features/tasks/application/task_details_controller.dart';
import 'package:nizamio/features/tasks/application/tasks_providers.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';

TaskItem _item(String code) => TaskItem(
  code: code,
  departmentId: 'd1',
  title: 'Görev $code',
  coordinatorship: 'd1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 11),
  due: DateTime(2026, 12),
  assignees: const [],
);

class _Catalog implements TaskCatalogRepository {
  @override
  Future<TaskCatalog> load() async => TaskCatalog(
    today: DateTime(2026, 11),
    me: 'me',
    tasks: [_item('w1')],
    people: const [],
    coordinatorships: const [],
    access: TaskAccess(
      accountId: 'me',
      companyAdmin: false,
      seats: [
        for (final p in ['p1', 'p2'])
          TeamSeat(
            programId: p,
            departmentId: 'd1',
            departmentName: 'D1',
            role: SeatRole.member,
          ),
      ],
    ),
    truncated: true,
  );
}

/// Her tekil okuma bekleyen bir [Completer]'dır; test sırayla tamamlar.
class _Gated implements TaskDetailsRepository {
  final calls = <Completer<TaskItem>>[];

  @override
  Future<TaskDetails> load(TaskItem task, {TaskAccess? access}) async =>
      TaskDetails(subtasks: const [], notes: const [], files: const []);

  @override
  Future<TaskItem> loadItem(TaskItem task) {
    final c = Completer<TaskItem>();
    calls.add(c);
    return c.future;
  }
}

Future<void> _settle() async {
  for (var i = 0; i < 20; i++) {
    await pumpEventQueue();
  }
}

void main() {
  test('sahip değişince yeni arama yapılır ve bulunur; eski tamamlanma yeni kaydı silmez', () async {
    var program = 'p1';
    final details = _Gated();
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        sessionGenerationProvider.overrideWith((ref) => 1),
        taskCatalogRepositoryProvider.overrideWithValue(_Catalog()),
        taskDetailsRepositoryProvider.overrideWithValue(details),
        scopeStateProvider.overrideWith(
          (ref) => ScopeSelection(programId: program),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(taskCatalogControllerProvider.future);
    c.listen(taskDetailsProvider('w9'), (_, _) {});
    await _settle();
    expect(details.calls, hasLength(1), reason: 'eski sahibin araması');

    // Sahip değişir (program); ayrıntı ekranı kapsamı izler ve aynı görevi yeniden açar.
    program = 'p2';
    c.invalidate(scopeStateProvider);
    await _settle();
    expect(details.calls, hasLength(2), reason: 'yeni sahip kendi araması');

    // Eski arama biter (sahip değişti: sessiz); yeni sahibin uçuştaki kaydı kalmalı.
    details.calls[0].complete(_item('w9'));
    await _settle();
    c.invalidate(taskDetailsProvider('w9'));
    await _settle();
    expect(details.calls, hasLength(2), reason: 'uçuştaki aramaya bağlanır');

    details.calls[1].complete(_item('w9'));
    await _settle();
    expect(c.read(taskDetailsProvider('w9')).error, isNull);
    expect(c.read(taskCatalogControllerProvider).value!.task('w9'), isNotNull);
  });
}
