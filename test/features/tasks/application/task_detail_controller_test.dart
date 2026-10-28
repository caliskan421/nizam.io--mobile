// TaskDetailController: durum kuralları (alt görev/kanıt), talep onay/ret, düzenle doğrulama,
// kanıt yükleme, sil/geri al, kopyala, alt görev ve not komutları; değişiklik katalogda kalır.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/application/task_detail_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

Future<ProviderContainer> _setup() async {
  final h = await pilotHarness(PilotBackend());
  h.container.listen(taskCatalogControllerProvider, (_, _) {});
  await h.container.read(taskCatalogControllerProvider.future);
  return h.container;
}

void main() {
  test('durum: alt görev ve kanıt kuralı; öncelik', () async {
    final c = await _setup();
    final p = taskDetailControllerProvider('ALT-7');
    c.listen(p, (_, _) {});
    final ctl = c.read(p.notifier);
    TaskItem task() =>
        c.read(taskCatalogControllerProvider).value!.task('ALT-7')!;
    expect(ctl.setStatus(TaskStatus.inProgress), StatusChange.unchanged);
    expect(ctl.setStatus(TaskStatus.done), StatusChange.blockedBySubtasks);
    expect(ctl.setStatus(TaskStatus.review), StatusChange.changed);
    expect(task().status, TaskStatus.review);
    expect(ctl.setPriority(TaskPriority.low), isTrue);
    expect(ctl.setPriority(TaskPriority.low), isFalse);

    // Kanıtı zorunlu alt görev kanıtsız bitirilemez; kanıt yükleyince bitirilir.
    expect(ctl.toggleSubtask('s3'), isFalse);
    ctl.openUpload();
    expect(c.read(p).upload!.subtask, 's3');
    expect(ctl.submitUpload(), isTrue);
    expect(c.read(p).tab, TaskDetailTab.files);
    expect(task().fileEntries, hasLength(2));
    expect(task().files, 2);
    expect(ctl.toggleSubtask('s3'), isTrue);
    expect(ctl.toggleSubtask('s2'), isTrue);
    expect(ctl.setStatus(TaskStatus.done), StatusChange.changed);
    expect(task().overdueDays, 0);
    expect(
      c
          .read(taskCatalogControllerProvider)
          .value!
          .tasks
          .where((t) => t.code == 'ALT-7')
          .single
          .isDone,
      isTrue,
    );
  });

  test('talep onay/ret, yeni talep, düzenle doğrulaması', () async {
    final c = await _setup();
    final p = taskDetailControllerProvider('ALT-7');
    c.listen(p, (_, _) {});
    final ctl = c.read(p.notifier);
    TaskItem task() =>
        c.read(taskCatalogControllerProvider).value!.task('ALT-7')!;
    expect(ctl.openDateRequest(), isFalse); // bekleyen talep var
    ctl.approveRequest();
    expect(task().due, DateTime(2026, 10, 31));
    expect(task().hasPendingRequest, isFalse);
    expect(task().overdueDays, 0);
    expect(ctl.openDateRequest(), isTrue);
    expect(c.read(p).dateDraft!.due, DateTime(2026, 11, 14));
    expect(ctl.submitDateRequest(), isTrue);
    expect(task().hasPendingRequest, isTrue);
    ctl.rejectRequest();
    expect(task().dateRequest!.state, DateRequestState.rejected);

    ctl.openEdit();
    ctl.updateEdit(c.read(p).edit!.copyWith(title: '  '));
    expect(ctl.submitEdit(), isFalse);
    expect(c.read(p).showErrors, isTrue);
    ctl
      ..updateEdit(c.read(p).edit!.copyWith(title: 'Yeni başlık'))
      ..editCoordinatorship('MEK');
    expect(c.read(p).edit!.assignees, isEmpty);
    ctl.editToggleAssignee('my');
    expect(ctl.submitEdit(), isTrue);
    expect(task().title, 'Yeni başlık');
    expect(task().coordinatorship, 'MEK');
  });

  test('sil / geri al, kopyala, alt görev ve not', () async {
    final c = await _setup();
    final p = taskDetailControllerProvider('ALT-7');
    c.listen(p, (_, _) {});
    final ctl = c.read(p.notifier);
    TaskCatalog cat() => c.read(taskCatalogControllerProvider).value!;
    final index = cat().tasks.indexWhere((t) => t.code == 'ALT-7');
    ctl.delete();
    expect(cat().task('ALT-7'), isNull);
    expect(c.read(p).deleted, isNotNull);
    ctl.undoDelete();
    expect(cat().tasks.indexWhere((t) => t.code == 'ALT-7'), index);

    final copy = ctl.copy('(kopya)');
    expect(copy, startsWith('ALT-'));
    expect(cat().task(copy!)!.title, endsWith('(kopya)'));
    expect(cat().tasks, hasLength(77));

    ctl.addSubtask();
    final id = c.read(p).editingSubtask!;
    expect(cat().task('ALT-7')!.subtasks, hasLength(4));
    ctl.finishSubtaskEdit(); // boş ad → atılır
    expect(cat().task('ALT-7')!.subtasks, hasLength(3));
    expect(cat().task('ALT-7')!.subtasks.any((s) => s.id == id), isFalse);
    ctl
      ..setSubtaskAssignee('s2', 'ko')
      ..setSubtaskStart('s2', DateTime(2026, 10, 25))
      ..setSubtaskEnd('s2', DateTime(2026, 10, 20))
      ..setSubtaskStart('s2', DateTime(2026, 10, 26));
    final s2 = cat().task('ALT-7')!.subtasks.firstWhere((s) => s.id == 's2');
    expect(s2.assignee, 'ko');
    expect(s2.end, DateTime(2026, 10, 26));
    expect(ctl.removeSubtask('s1')?.title, 'Pompa tedarikçisinden teyit al');

    ctl
      ..setNoteDraft('  Saha kontrol edildi ')
      ..sendNote();
    final notes = cat().task('ALT-7')!.noteEntries;
    expect(notes.last.text, 'Saha kontrol edildi');
    expect(c.read(p).noteDraft, '');
    expect(ctl.addNoteToMemory(0), isFalse); // örnek not zaten hafızada
    expect(ctl.addNoteToMemory(1), isTrue);
    ctl.selectTab(TaskDetailTab.notes);
    expect(c.read(p).tab, TaskDetailTab.notes);
  });
}
