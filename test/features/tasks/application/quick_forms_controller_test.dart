// Hızlı işlem formları: yeni görev (satır kuralları, takvim aralığı, doğrulama, kataloğa
// ekleme), toplantı (geçmiş tarih, davetli kipleri, gündem), davet (e-posta, rol kuralları).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/features/tasks/application/quick_forms_controller.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../pilot_support.dart';

Future<ProviderContainer> _setup() async {
  final h = await pilotHarness(PilotBackend());
  h.container.listen(taskCatalogControllerProvider, (_, _) {});
  await h.container.read(taskCatalogControllerProvider.future);
  return h.container;
}

void main() {
  test('yeni görev: satırlar, takvim, doğrulama, oluşturma', () async {
    final c = await _setup();
    final ctl = c.read(newTaskFormControllerProvider.notifier);
    NewTaskForm f() => c.read(newTaskFormControllerProvider);
    ctl.prepare();
    expect(f().start, DateTime(2026, 10, 21));
    expect(f().days, 14);
    // Koordinatörlük yokken Atanan → koordinatörlük satırı açılır.
    ctl.togglePane(NewTaskPane.assignees);
    expect(f().pane, NewTaskPane.coordinatorship);
    expect(ctl.submit(), isNull);
    expect(f().error, NewTaskError.title);
    ctl.setTitle('Basınç testi raporu');
    expect(ctl.submit(), isNull);
    expect(f().error, NewTaskError.coordinatorship);
    ctl.pickCoordinatorship('ALT');
    expect(f().pane, NewTaskPane.assignees);
    expect(ctl.submit(), isNull);
    expect(f().error, NewTaskError.assignees);
    ctl.toggleAssignee('ko');

    // Takvim: ilk dokunuş başlangıç, önceki güne ikinci dokunuş yer değiştirir.
    ctl.togglePane(NewTaskPane.dates);
    ctl.pickDay(DateTime(2026, 10, 25));
    expect(f().picking, isTrue);
    ctl.pickDay(DateTime(2026, 10, 23));
    expect(
      (f().start, f().end),
      (DateTime(2026, 10, 23), DateTime(2026, 10, 25)),
    );
    // Yarıda kalan seçim satır kapanınca geri alınır.
    ctl.pickDay(DateTime(2026, 10, 27));
    ctl.togglePane(NewTaskPane.dates);
    expect(
      (f().start, f().end),
      (DateTime(2026, 10, 23), DateTime(2026, 10, 25)),
    );
    ctl.stepMonth(1);
    expect(f().month, DateTime(2026, 11));

    ctl
      ..setPriority(TaskPriority.high)
      ..setEvidenceRequired(value: true);
    final r = ctl.submit()!;
    expect(r.notified, 1);
    final task = c.read(taskCatalogControllerProvider).value!.task(r.code)!;
    expect(task.title, 'Basınç testi raporu');
    expect(task.evidenceRequired, isTrue);
    expect(
      c.read(taskCatalogControllerProvider).value!.tasks.first.code,
      r.code,
    );
    expect(f().title, ''); // taslak sıfırlandı

    ctl
      ..setTitle('taslak')
      ..prepare(coordinatorship: 'MEK');
    expect(f().title, 'taslak'); // taslak korunur
    expect(f().coordinatorship, 'MEK');
  });

  test('toplantı: doğrulama ve gönderim', () async {
    final c = await _setup();
    final ctl = c.read(meetingFormControllerProvider.notifier);
    MeetingForm f() => c.read(meetingFormControllerProvider);
    expect(f().agenda, hasLength(2));
    expect(f().date, DateTime(2026, 10, 22));
    expect(ctl.submit(), isNull);
    expect(f().error, MeetingError.title);
    ctl.setTitle('Saha toplantısı');
    ctl.pickDate(DateTime(2026, 10, 1));
    expect(ctl.submit(), isNull);
    expect(f().error, MeetingError.past);
    ctl.pickDate(DateTime(2026, 10, 23));
    expect(ctl.submit(), isNull);
    expect(f().error, MeetingError.coordinatorships);
    ctl.setMode(MeetingMode.people);
    expect(ctl.submit(), isNull);
    expect(f().error, MeetingError.people);
    ctl
      ..togglePerson('ko')
      ..setTime(14, 30)
      ..setAgendaDraft('Bütçe')
      ..addAgenda()
      ..setAgendaItem(0, ' ')
      ..finishAgendaItem(0)
      ..toggleGroup('ALT')
      ..togglePane(MeetingPane.time);
    expect(f().agenda, [
      'Güvenlik ve tahliye planının fuar alanına uyarlanması',
      'Bütçe',
    ]);
    expect(f().openGroups, isEmpty);
    final sent = ctl.submit()!;
    expect((sent.hour, sent.minute), (14, 30));
    expect(sent.people, ['ko']);
    expect(f().title, '');
    expect(f().agenda, isEmpty);
    ctl.prepare(coordinatorship: 'ALT');
    expect(f().coordinatorships, ['ALT']);
    ctl
      ..toggleAllMembers()
      ..stepMonth(-1);
    expect(f().allMembers, isTrue);
  });

  test(
    'davet: ad, e-posta, koordinatör için koordinatörlük, admin kilidi',
    () async {
      final c = await _setup();
      final ctl = c.read(inviteFormControllerProvider.notifier);
      InviteForm f() => c.read(inviteFormControllerProvider);
      expect(ctl.submit(), isNull);
      expect(f().error, InviteError.name);
      ctl
        ..setName('Ayşe Deneme')
        ..setEmail('ayse');
      expect(ctl.submit(), isNull);
      expect(f().error, InviteError.email);
      ctl
        ..setEmail('ayse.deneme@ornek.test')
        ..setRole(InviteRole.coordinator);
      expect(ctl.submit(), isNull);
      expect(f().error, InviteError.coordinatorships);
      ctl
        ..togglePane()
        ..toggleCoordinatorship('ALT');
      expect(f().paneOpen, isTrue);
      ctl.setRole(InviteRole.admin);
      expect(f().paneOpen, isFalse);
      ctl.togglePane();
      expect(f().paneOpen, isFalse);
      expect(ctl.submit()!.email, 'ayse.deneme@ornek.test');
      expect(f().name, '');
      ctl.prepare(coordinatorship: 'EĞİ');
      expect(f().role, InviteRole.member);
      expect(f().coordinatorships, ['EĞİ']);
    },
  );
}
