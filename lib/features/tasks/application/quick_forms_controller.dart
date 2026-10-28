import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/task_catalog.dart';
import 'task_catalog_controller.dart';

part 'quick_forms_controller.g.dart';

// Hızlı işlem formları (prototip `S_home.state.tk/mt/iv`). Taslaklar sayfa kapanınca korunur
// (keepAlive); yalnız başarılı gönderimde sıfırlanır. Açılışta `prepare` bağlamı uygular.

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

// ===================================================================================== görev

/// Yeni görev formunda yerinde açık satır.
enum NewTaskPane { coordinatorship, assignees, dates }

enum NewTaskError { title, coordinatorship, assignees, dates }

@immutable
final class NewTaskForm {
  const NewTaskForm({
    required this.start,
    required this.end,
    required this.month,
    this.title = '',
    this.coordinatorship,
    this.assignees = const [],
    this.priority = TaskPriority.medium,
    this.evidenceRequired = false,
    this.pane,
    this.picking = false,
    this.previous,
    this.error,
  });

  final String title;
  final String? coordinatorship;
  final List<String> assignees;
  final TaskPriority priority;
  final DateTime start;
  final DateTime end;

  /// Takvimde gösterilen ay (ayın 1'i).
  final DateTime month;
  final bool evidenceRequired;
  final NewTaskPane? pane;

  /// Başlangıç seçildi, bitiş bekleniyor.
  final bool picking;

  /// Seçim yarıda kalırsa dönülecek aralık.
  final (DateTime, DateTime)? previous;
  final NewTaskError? error;

  int get days => end.difference(start).inDays;

  NewTaskForm copyWith({
    String? title,
    String? Function()? coordinatorship,
    List<String>? assignees,
    TaskPriority? priority,
    DateTime? start,
    DateTime? end,
    DateTime? month,
    bool? evidenceRequired,
    NewTaskPane? Function()? pane,
    bool? picking,
    (DateTime, DateTime)? Function()? previous,
    NewTaskError? Function()? error,
  }) => NewTaskForm(
    title: title ?? this.title,
    coordinatorship: coordinatorship == null
        ? this.coordinatorship
        : coordinatorship(),
    assignees: assignees ?? this.assignees,
    priority: priority ?? this.priority,
    start: start ?? this.start,
    end: end ?? this.end,
    month: month ?? this.month,
    evidenceRequired: evidenceRequired ?? this.evidenceRequired,
    pane: pane == null ? this.pane : pane(),
    picking: picking ?? this.picking,
    previous: previous == null ? this.previous : previous(),
    error: error == null ? this.error : error(),
  );
}

/// Oluşturulan görevin özeti (sonuç bildirimi).
typedef CreatedTask = ({String code, int notified});

@Riverpod(keepAlive: true)
class NewTaskFormController extends _$NewTaskFormController {
  @override
  NewTaskForm build() => _initial();

  NewTaskForm _initial() {
    final today = _today();
    return NewTaskForm(
      start: today,
      end: today.add(const Duration(days: 14)),
      month: DateTime(today.year, today.month),
    );
  }

  DateTime _today() => _day(
    ref.read(taskCatalogControllerProvider).value?.today ?? DateTime.now(),
  );

  /// Açılış bağlamı: koordinatörlük (null → seçilmemiş), atanan yok, satırlar kapalı.
  void prepare({String? coordinatorship}) =>
      state = _cancelPick(state).copyWith(
        coordinatorship: () => coordinatorship,
        assignees: const [],
        pane: () => null,
        error: () => null,
      );

  void setTitle(String v) =>
      state = state.copyWith(title: v, error: () => null);

  NewTaskForm _cancelPick(NewTaskForm f) {
    final p = f.previous;
    if (!f.picking || p == null) return f;
    return f.copyWith(
      start: p.$1,
      end: p.$2,
      picking: false,
      previous: () => null,
    );
  }

  /// Satırı açar/kapatır (aynı anda tek satır). Koordinatörlük seçilmeden Atanan açılmaz:
  /// koordinatörlük satırı açılır.
  void togglePane(NewTaskPane p) {
    if (p == NewTaskPane.assignees && state.coordinatorship == null) {
      state = state.copyWith(pane: () => NewTaskPane.coordinatorship);
      return;
    }
    state = _cancelPick(state)
        .copyWith(pane: () => state.pane == p ? null : p, error: () => null);
  }

  /// Koordinatörlük seçer ve Atanan satırına geçer (başka koordinatörlükte atananlar silinir).
  void pickCoordinatorship(String code) => state = state.copyWith(
    coordinatorship: () => code,
    assignees: code == state.coordinatorship ? state.assignees : const [],
    pane: () => NewTaskPane.assignees,
    error: () => null,
  );

  void toggleAssignee(String id) => state = state.copyWith(
    assignees: state.assignees.contains(id)
        ? [
            for (final a in state.assignees)
              if (a != id) a,
          ]
        : [...state.assignees, id],
    error: () => null,
  );

  void setPriority(TaskPriority p) =>
      state = state.copyWith(priority: p, error: () => null);

  void setEvidenceRequired({required bool value}) =>
      state = state.copyWith(evidenceRequired: value);

  void stepMonth(int delta) => state = state.copyWith(
    month: DateTime(state.month.year, state.month.month + delta),
  );

  /// Takvim dokunuşu: ilk dokunuş başlangıç (bitiş bekler), ikinci bitiş (önceyse yer
  /// değiştirir); bekleyen başlangıca yeniden dokunmak seçimi geri alır.
  void pickDay(DateTime d) {
    final f = state;
    d = _day(d);
    if (f.picking && d == f.start) {
      state = _cancelPick(f);
    } else if (!f.picking) {
      state = f.copyWith(
        start: d,
        end: d,
        picking: true,
        previous: () => (f.start, f.end),
        error: () => null,
      );
    } else if (d.isBefore(f.start)) {
      state = f.copyWith(
        start: d,
        end: f.start,
        picking: false,
        previous: () => null,
      );
    } else {
      state = f.copyWith(end: d, picking: false, previous: () => null);
    }
  }

  /// Doğrular ve görevi kataloğa ekler; hata varsa [NewTaskForm.error] ile null döner.
  CreatedTask? submit() {
    final f = _cancelPick(state);
    final err = f.title.trim().isEmpty
        ? NewTaskError.title
        : f.coordinatorship == null
        ? NewTaskError.coordinatorship
        : f.assignees.isEmpty
        ? NewTaskError.assignees
        : f.end.isBefore(f.start)
        ? NewTaskError.dates
        : null;
    if (err != null) {
      state = state.copyWith(error: () => err);
      return null;
    }
    final c = ref.read(taskCatalogControllerProvider).value;
    final coord = f.coordinatorship!;
    final code = c?.nextCode(coord) ?? '$coord-1';
    ref
        .read(taskCatalogControllerProvider.notifier)
        .add(
          TaskItem(
            code: code,
            title: f.title.trim(),
            coordinatorship: coord,
            status: TaskStatus.todo,
            priority: f.priority,
            start: f.start,
            due: f.end,
            assignees: f.assignees,
            creator: c?.me ?? '',
            createdAt: _today(),
            overdueDays: c?.overdueDaysFor(f.end, done: false) ?? 0,
            evidenceRequired: f.evidenceRequired,
          ),
        );
    state = _initial();
    return (code: code, notified: f.assignees.length);
  }
}

// ================================================================================= toplantı

enum MeetingPane { date, time, invitees, agenda }

enum MeetingMode { coordinatorships, people }

enum MeetingError { title, past, coordinatorships, people }

@immutable
final class MeetingForm {
  const MeetingForm({
    required this.date,
    required this.month,
    this.title = '',
    this.hour = 10,
    this.minute = 0,
    this.mode = MeetingMode.coordinatorships,
    this.coordinatorships = const [],
    this.people = const [],
    this.allMembers = false,
    this.pane,
    this.agenda = const [],
    this.agendaDraft = '',
    this.openGroups = const {'ALT'},
    this.error,
  });

  final String title;
  final DateTime date;
  final DateTime month;
  final int hour;
  final int minute;
  final MeetingMode mode;
  final List<String> coordinatorships;
  final List<String> people;
  final bool allMembers;
  final MeetingPane? pane;
  final List<String> agenda;
  final String agendaDraft;

  /// Kişiler kipinde açık koordinatörlük grupları.
  final Set<String> openGroups;
  final MeetingError? error;

  MeetingForm copyWith({
    String? title,
    DateTime? date,
    DateTime? month,
    int? hour,
    int? minute,
    MeetingMode? mode,
    List<String>? coordinatorships,
    List<String>? people,
    bool? allMembers,
    MeetingPane? Function()? pane,
    List<String>? agenda,
    String? agendaDraft,
    Set<String>? openGroups,
    MeetingError? Function()? error,
  }) => MeetingForm(
    title: title ?? this.title,
    date: date ?? this.date,
    month: month ?? this.month,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    mode: mode ?? this.mode,
    coordinatorships: coordinatorships ?? this.coordinatorships,
    people: people ?? this.people,
    allMembers: allMembers ?? this.allMembers,
    pane: pane == null ? this.pane : pane(),
    agenda: agenda ?? this.agenda,
    agendaDraft: agendaDraft ?? this.agendaDraft,
    openGroups: openGroups ?? this.openGroups,
    error: error == null ? this.error : error(),
  );
}

List<T> _toggled<T>(List<T> list, T x) => list.contains(x)
    ? [
        for (final y in list)
          if (y != x) y,
      ]
    : [...list, x];

@Riverpod(keepAlive: true)
class MeetingFormController extends _$MeetingFormController {
  @override
  MeetingForm build() => _initial(
    agenda: const [
      'Saha kurulum takvimi',
      'Güvenlik ve tahliye planının fuar alanına uyarlanması',
    ],
  );

  MeetingForm _initial({List<String> agenda = const []}) {
    final t = today;
    final d = t.add(const Duration(days: 1));
    return MeetingForm(
      date: d,
      month: DateTime(t.year, t.month),
      agenda: agenda,
    );
  }

  /// Verinin bugünü (geçmiş günler seçilemez).
  DateTime get today => _day(
    ref.read(taskCatalogControllerProvider).value?.today ?? DateTime.now(),
  );

  void prepare({String? coordinatorship}) {
    var f = state.copyWith(pane: () => null, error: () => null);
    if (coordinatorship != null) {
      f = f.copyWith(
        mode: MeetingMode.coordinatorships,
        coordinatorships: [coordinatorship],
      );
    }
    state = f;
  }

  void _set(MeetingForm f) => state = f.copyWith(error: () => null);

  void setTitle(String v) => _set(state.copyWith(title: v));

  void togglePane(MeetingPane p) =>
      _set(state.copyWith(pane: () => state.pane == p ? null : p));

  void pickDate(DateTime d) => _set(state.copyWith(date: _day(d)));

  void stepMonth(int delta) => _set(
    state.copyWith(
      month: DateTime(state.month.year, state.month.month + delta),
    ),
  );

  void setTime(int hour, int minute) =>
      _set(state.copyWith(hour: hour, minute: minute));

  void setMode(MeetingMode m) => _set(state.copyWith(mode: m));

  void toggleCoordinatorship(String code) => _set(
    state.copyWith(coordinatorships: _toggled(state.coordinatorships, code)),
  );

  void togglePerson(String id) =>
      _set(state.copyWith(people: _toggled(state.people, id)));

  void toggleAllMembers() =>
      _set(state.copyWith(allMembers: !state.allMembers));

  void toggleGroup(String code) {
    final g = {...state.openGroups};
    if (!g.remove(code)) g.add(code);
    _set(state.copyWith(openGroups: g));
  }

  void setAgendaDraft(String v) => _set(state.copyWith(agendaDraft: v));

  void addAgenda() {
    final d = state.agendaDraft.trim();
    if (d.isEmpty) return;
    _set(state.copyWith(agenda: [...state.agenda, d], agendaDraft: ''));
  }

  void setAgendaItem(int i, String v) => _set(
    state.copyWith(
      agenda: [
        for (var j = 0; j < state.agenda.length; j++)
          j == i ? v : state.agenda[j],
      ],
    ),
  );

  /// Düzenleme bitince boş kalan madde atılır.
  void finishAgendaItem(int i) {
    if (i < state.agenda.length && state.agenda[i].trim().isEmpty) {
      removeAgenda(i);
    }
  }

  void removeAgenda(int i) =>
      _set(state.copyWith(agenda: [...state.agenda]..removeAt(i)));

  /// Doğrular; geçerliyse gönderilen formu döner ve taslağı sıfırlar.
  MeetingForm? submit() {
    final f = state;
    final err = f.title.trim().isEmpty
        ? MeetingError.title
        : f.date.isBefore(today)
        ? MeetingError.past
        : f.mode == MeetingMode.coordinatorships && f.coordinatorships.isEmpty
        ? MeetingError.coordinatorships
        : f.mode == MeetingMode.people && f.people.isEmpty
        ? MeetingError.people
        : null;
    if (err != null) {
      state = f.copyWith(error: () => err);
      return null;
    }
    state = _initial();
    return f;
  }
}

// ==================================================================================== davet

enum InviteRole { member, coordinator, admin }

enum InviteError { name, email, coordinatorships }

@immutable
final class InviteForm {
  const InviteForm({
    this.name = '',
    this.email = '',
    this.role = InviteRole.member,
    this.coordinatorships = const [],
    this.paneOpen = false,
    this.error,
  });

  final String name;
  final String email;
  final InviteRole role;
  final List<String> coordinatorships;
  final bool paneOpen;
  final InviteError? error;

  static final _email = RegExp(r'.+@.+\..+');

  bool get emailValid => _email.hasMatch(email);

  InviteForm copyWith({
    String? name,
    String? email,
    InviteRole? role,
    List<String>? coordinatorships,
    bool? paneOpen,
    InviteError? Function()? error,
  }) => InviteForm(
    name: name ?? this.name,
    email: email ?? this.email,
    role: role ?? this.role,
    coordinatorships: coordinatorships ?? this.coordinatorships,
    paneOpen: paneOpen ?? this.paneOpen,
    error: error == null ? this.error : error(),
  );
}

@Riverpod(keepAlive: true)
class InviteFormController extends _$InviteFormController {
  @override
  InviteForm build() => const InviteForm();

  void prepare({String? coordinatorship}) {
    var f = state.copyWith(paneOpen: false, error: () => null);
    if (coordinatorship != null) {
      f = f.copyWith(
        coordinatorships: [coordinatorship],
        role: InviteRole.member,
      );
    }
    state = f;
  }

  void _set(InviteForm f) => state = f.copyWith(error: () => null);

  void setName(String v) => _set(state.copyWith(name: v));
  void setEmail(String v) => _set(state.copyWith(email: v));

  /// Admin tüm koordinatörlükleri yönetir: seçim satırı kapanır ve kilitlenir.
  void setRole(InviteRole r) => _set(
    state.copyWith(
      role: r,
      paneOpen: r == InviteRole.admin ? false : state.paneOpen,
    ),
  );

  void togglePane() {
    if (state.role == InviteRole.admin) return;
    _set(state.copyWith(paneOpen: !state.paneOpen));
  }

  void toggleCoordinatorship(String code) => _set(
    state.copyWith(coordinatorships: _toggled(state.coordinatorships, code)),
  );

  /// Doğrular; geçerliyse gönderilen formu döner ve taslağı sıfırlar.
  InviteForm? submit() {
    final f = state;
    final err = f.name.trim().isEmpty
        ? InviteError.name
        : !f.emailValid
        ? InviteError.email
        : f.role == InviteRole.coordinator && f.coordinatorships.isEmpty
        ? InviteError.coordinatorships
        : null;
    if (err != null) {
      state = f.copyWith(error: () => err);
      return null;
    }
    state = const InviteForm();
    return f;
  }
}
