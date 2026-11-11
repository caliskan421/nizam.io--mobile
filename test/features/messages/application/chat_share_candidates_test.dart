import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/scope/scope_controller.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/archive/domain/records.dart' show RecordTag;
import 'package:nizamio/features/messages/application/chat_group_sources.dart';
import 'package:nizamio/features/messages/application/chat_share_candidates.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../fake_chat_repository.dart';

void main() {
  test(
    'geç arşiv scope yanıtı yeni programla eski departman isteği başlatmaz',
    () async {
      final gate = Completer<ArchiveScope>();
      final scope = ScopeController()..selectProgram('old');
      final archive = _Archive();
      final c = ProviderContainer(
        overrides: [
          sessionGenerationProvider.overrideWithValue(1),
          scopeControllerProvider.overrideWithValue(scope),
          archiveScopeProvider.overrideWith((ref) {
            final program = ref.watch(scopeStateProvider).programId;
            return program == 'old'
                ? gate.future
                : Future.value(
                    const ArchiveScope(
                      department: 'new-department',
                      admin: false,
                    ),
                  );
          }),
          archiveRepositoryProvider.overrideWithValue(archive),
        ],
      );
      addTearDown(c.dispose);
      final provider = chatShareCandidatesProvider((
        kind: ChatRefKind.file,
        query: '',
        cursor: 'old-cursor',
        session: 1,
        program: 'old',
      ));
      c.listen(provider, (_, _) {});
      await pumpEventQueue();
      scope.selectProgram('new');
      await pumpEventQueue();
      await c.read(provider.future);
      gate.complete(
        const ArchiveScope(department: 'old-department', admin: false),
      );
      await pumpEventQueue();
      expect(archive.departments, isEmpty);
      final current = chatShareCandidatesProvider((
        kind: ChatRefKind.file,
        query: '',
        cursor: null,
        session: 1,
        program: 'new',
      ));
      c.listen(current, (_, _) {});
      await c.read(current.future);
      expect(archive.departments, ['new-department']);
    },
  );
  test('paylaşım seçenekleri yetkili kaynaklardan; tür, kimlik, imleç ve kesilme korunur', () async {
    final archive = _Archive();
    final c = chatContainer(
      FakeChatRepository(),
      extra: [
        archiveScopeProvider.overrideWith(
          (_) async =>
              const ArchiveScope(department: 'my-department', admin: false),
        ),
        archiveRepositoryProvider.overrideWithValue(archive),
        taskCatalogControllerProvider.overrideWith(_Catalog.new),
        chatGroupSourcesProvider.overrideWith(
          (_) async => const ChatGroupSources(
            departments: [
              ChatDepartmentOption(id: 'other-department', name: 'İletişim'),
            ],
            canCreateSource: false,
            truncated: true,
          ),
        ),
      ],
    );
    final task = chatShareCandidatesProvider((
      kind: ChatRefKind.task,
      query: 'İŞ',
      cursor: null,
      session: 1,
      program: 'prog-1',
    ));
    final department = chatShareCandidatesProvider((
      kind: ChatRefKind.department,
      query: 'İLET',
      cursor: null,
      session: 1,
      program: 'prog-1',
    ));
    final file = chatShareCandidatesProvider((
      kind: ChatRefKind.file,
      query: ' rapor ',
      cursor: 'next-1',
      session: 1,
      program: 'prog-1',
    ));
    for (final provider in [task, department, file]) {
      c.listen(provider, (_, _) {});
    }
    final tasks = await c.read(task.future);
    expect(tasks.items.single.ref.targetId, 'work-item');
    expect(tasks.items.single.ref.kind, ChatRefKind.task);
    expect(tasks.truncated, isTrue);
    final departments = await c.read(department.future);
    expect(departments.items.single.ref.targetId, 'other-department');
    expect(departments.truncated, isTrue);
    final files = await c.read(file.future);
    expect(files.items.single.ref.targetId, 'file-1');
    expect(files.nextCursor, 'next-2');
    expect(archive.department, 'my-department');
    expect(archive.filter!.search, 'rapor');
    expect(archive.page!.cursor, 'next-1');
  });
}

final class _Catalog extends TaskCatalogController {
  @override
  Future<TaskCatalog> build() async => TaskCatalog(
    today: DateTime(2026, 11, 11),
    me: 'me',
    people: const [],
    coordinatorships: const [],
    truncated: true,
    tasks: [
      TaskItem(
        code: 'work-item',
        title: 'İş planı',
        coordinatorship: 'own-department',
        status: TaskStatus.todo,
        priority: TaskPriority.low,
        start: DateTime(2026, 11, 11),
        due: DateTime(2026, 11, 12),
        assignees: const [],
      ),
    ],
  );
}

final class _Archive implements ArchiveRepository {
  final departments = <String>[];
  String? department;
  ArchiveAttachmentFilter? filter;
  PageRequest? page;

  @override
  Future<PageSlice<RecordFile>> archiveAttachments({
    required String department,
    ArchiveAttachmentFilter filter = const ArchiveAttachmentFilter(),
    PageRequest page = const PageRequest(),
  }) async {
    departments.add(department);
    this.department = department;
    this.filter = filter;
    this.page = page;
    return PageSlice(
      items: const [
        RecordFile(
          id: 'file-1',
          workItemId: 'work-item',
          displayName: 'rapor.pdf',
          contentType: 'application/pdf',
          sizeBytes: 9,
          tag: RecordTag.plan,
        ),
      ],
      nextCursor: 'next-2',
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
