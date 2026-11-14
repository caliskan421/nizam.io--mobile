// Kesik katalogda görev kimlik araması (departman denemesi): geçici hata ayrıntıda hata
// durumudur ve yenileme aramayı tekrarlar; 429 Retry-After dolmadan istek atılmaz; bütün
// adaylarda 404 kesin "bulunamadı"dır, tekrar aranmaz; aday sınırı ayrı sonuçtur.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/tasks/application/task_catalog_controller.dart';
import 'package:nizamio/features/tasks/application/task_details_controller.dart';
import 'package:nizamio/features/tasks/application/tasks_providers.dart';
import 'package:nizamio/features/tasks/domain/task_access.dart';
import 'package:nizamio/features/tasks/domain/task_catalog.dart';
import 'package:nizamio/features/tasks/domain/task_details.dart';

TaskItem _item(String code, {String? department}) => TaskItem(
  code: code,
  departmentId: department,
  title: 'Görev $code',
  coordinatorship: department ?? 'd1',
  status: TaskStatus.inProgress,
  priority: TaskPriority.medium,
  start: DateTime(2026, 11),
  due: DateTime(2026, 12),
  assignees: const [],
);

class _Catalog implements TaskCatalogRepository {
  _Catalog(this.departments);
  final int departments;
  var loads = 0;

  @override
  Future<TaskCatalog> load() async {
    loads++;
    return TaskCatalog(
      today: DateTime(2026, 11),
      me: 'me',
      tasks: [_item('w1')],
      people: const [],
      coordinatorships: const [],
      access: TaskAccess(
        accountId: 'me',
        companyAdmin: false,
        seats: [
          for (var i = 1; i <= departments; i++)
            TeamSeat(
              programId: 'p1',
              departmentId: 'd$i',
              departmentName: 'D$i',
              role: SeatRole.member,
            ),
        ],
      ),
      truncated: true,
    );
  }
}

/// Departman → sonuç: ApiError fırlatılır, 'ok' bulunur; listede yoksa 404.
class _Details implements TaskDetailsRepository {
  final probed = <String>[];
  final asked = <String>[];
  final outcomes = <(String, Object)>[];

  @override
  Future<TaskDetails> load(TaskItem task, {TaskAccess? access}) async {
    asked.add(task.code);
    return TaskDetails(subtasks: const [], notes: const [], files: const []);
  }

  @override
  Future<TaskItem> loadItem(TaskItem task) async {
    probed.add(task.departmentId!);
    for (final (i, (dept, out)) in outcomes.indexed) {
      if (dept != task.departmentId) continue;
      outcomes.removeAt(i);
      if (out is ApiError) throw out;
      return _item(task.code, department: dept);
    }
    throw ApiError('work.item_not_found', status: 404);
  }
}

(ProviderContainer, _Details) _open(int departments) {
  final details = _Details();
  final c = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      sessionGenerationProvider.overrideWith((ref) => 1),
      taskCatalogRepositoryProvider.overrideWithValue(_Catalog(departments)),
      taskDetailsRepositoryProvider.overrideWithValue(details),
      scopeStateProvider.overrideWith(
        (ref) => const ScopeSelection(programId: 'p1'),
      ),
    ],
  );
  addTearDown(c.dispose);
  return (c, details);
}

Future<Object?> _detailsError(ProviderContainer c, String code) async {
  c.listen(taskDetailsProvider(code), (_, _) {});
  try {
    await c.read(taskDetailsProvider(code).future);
    for (var i = 0; i < 5; i++) {
      await pumpEventQueue();
    }
    return c.read(taskDetailsProvider(code)).error;
  } on Object catch (e) {
    return e;
  }
}

void main() {
  test(
    'geçici hata ayrıntıda hata durumudur; yenileme aramayı tekrarlar ve bulur',
    () async {
      final (c, details) = _open(2);
      await c.read(taskCatalogControllerProvider.future);
      details.outcomes.add(('d1', ApiError(ClientErrorCode.networkError)));
      final first = await _detailsError(c, 'w9');
      expect((first as ApiError?)?.code, ClientErrorCode.networkError);
      expect(details.probed, ['d1']);
      details.outcomes.add(('d2', 'ok'));
      c.invalidate(taskDetailsProvider('w9'));
      final second = await _detailsError(c, 'w9');
      expect(second, isNull);
      expect(details.probed, ['d1', 'd1', 'd2']);
      expect(
        c.read(taskCatalogControllerProvider).value!.task('w9'),
        isNotNull,
      );
    },
  );

  test('429 Retry-After dolmadan yeniden istek yok', () async {
    final (c, details) = _open(2);
    await c.read(taskCatalogControllerProvider.future);
    details.outcomes.add((
      'd1',
      ApiError(
        'platform.rate_limited',
        status: 429,
        retryAfter: const Duration(hours: 1),
      ),
    ));
    final first = await _detailsError(c, 'w9');
    expect((first as ApiError?)?.status, 429);
    c.invalidate(taskDetailsProvider('w9'));
    final second = await _detailsError(c, 'w9');
    expect((second as ApiError?)?.status, 429);
    expect(details.probed, ['d1']);
  });

  test(
    'bütün adaylarda 404: bulunamadı (hata değil) ve tekrar aranmaz',
    () async {
      final (c, details) = _open(2);
      await c.read(taskCatalogControllerProvider.future);
      expect(await _detailsError(c, 'w9'), isNull);
      expect(details.probed, ['d1', 'd2']);
      c.invalidate(taskDetailsProvider('w9'));
      expect(await _detailsError(c, 'w9'), isNull);
      expect(details.probed, ['d1', 'd2']);
    },
  );

  test('aday sınırı dolunca ayrı sonuç (client.task_lookup_limit)', () async {
    final (c, details) = _open(25);
    await c.read(taskCatalogControllerProvider.future);
    final e = await _detailsError(c, 'w9');
    expect((e as ApiError?)?.code, 'client.task_lookup_limit');
    expect(
      details.probed,
      hasLength(TaskCatalogController.maxDepartmentProbes),
    );
  });

  test(
    '403 work.not_assigned kesin sonuçtur; diğer 403 hata durumudur',
    () async {
      final (c, details) = _open(2);
      await c.read(taskCatalogControllerProvider.future);
      details.outcomes.add(('d1', ApiError('work.not_assigned', status: 403)));
      expect(await _detailsError(c, 'w9'), isNull);
      c.invalidate(taskDetailsProvider('w9'));
      expect(await _detailsError(c, 'w9'), isNull);
      expect(details.probed, ['d1']);

      details.outcomes.add((
        'd1',
        ApiError('work.not_authorized', status: 403),
      ));
      final e = await _detailsError(c, 'w8');
      expect((e as ApiError?)?.code, 'work.not_authorized');
      expect(details.probed, ['d1', 'd1']);
    },
  );
}
