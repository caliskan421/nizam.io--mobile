import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../domain/meeting_planner.dart';
import '../domain/task_catalog.dart';
import '../domain/task_writes.dart';
import 'task_catalog_controller.dart';
import 'tasks_providers.dart';

part 'quick_forms_controller.g.dart';

// Hızlı işlem formları (prototip `S_home.state.tk/mt/iv`). Taslaklar sayfa kapanınca korunur
// (keepAlive); yalnız başarılı gönderimde sıfırlanır. Açılışta `prepare` bağlamı uygular.

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

// ===================================================================================== görev

/// Yeni görev formunda yerinde açık satır.
enum NewTaskPane { coordinatorship, assignees, dates }

enum NewTaskError { title, coordinatorship, dates }

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
    this.failure,
    this.busy = false,
    this.note,
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

  /// Sunucu (ya da yerel ön denetim) hatası; metin koddan.
  final ApiError? failure;

  /// Oluşturma isteği uçuşta (ikinci dokunuş istek göndermez).
  final bool busy;

  /// Kaynak toplantı notu: verilmişse görev `convertNoteToTask` ile açılır ve not göreve
  /// bağlanır (kanıt bayrağı yoktur); null → bağımsız yeni görev.
  final String? note;

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
    ApiError? Function()? failure,
    bool? busy,
    String? Function()? note,
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
    failure: failure == null ? this.failure : failure(),
    busy: busy ?? this.busy,
    note: note == null ? this.note : note(),
  );
}

/// Yeni görev formunun koordinatörlük seçenekleri: yalnız görev açılabilen departmanlar ([TaskAccess.canCreateIn]: yönetici programın bütün
/// departmanları, karma rolde yalnız koordinatörlükler; üyelik departmanı listelenmez).
@riverpod
List<CoordinatorshipRef> newTaskCoordinatorships(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  if (catalog == null) return const [];
  final access = catalog.access;
  final program = ref.watch(scopeStateProvider).programId;
  if (access == null || program == null) return const [];
  return [
    for (final c in catalog.coordinatorships)
      if (access.canCreateIn(program, c.code)) c,
  ];
}

/// Oluşturulan görevin özeti (sonuç bildirimi).
typedef CreatedTask = ({String code, int notified});

@Riverpod(keepAlive: true)
class NewTaskFormController extends _$NewTaskFormController {
  @override
  NewTaskForm build() => _initial();

  /// Boş taslak; açılabilir ilk koordinatörlük seçili açılır.
  NewTaskForm _initial() {
    final today = _today();
    return NewTaskForm(
      start: today,
      end: today.add(const Duration(days: 14)),
      month: DateTime(today.year, today.month),
      // Sunucu varsayılanı açık (WORK-K75).
      evidenceRequired: true,
      coordinatorship: _defaultCoordinatorship(),
    );
  }

  /// Varsayılan koordinatörlük: formun seçeneklerinin ilki ([newTaskCoordinatorships]; sunucu
  /// kataloğunda yalnız görev açılabilen departmanlar — üyelik departmanı varsayılan olmaz).
  String? _defaultCoordinatorship() =>
      ref.read(newTaskCoordinatorshipsProvider).firstOrNull?.code;

  DateTime _today() => _day(
    ref.read(taskCatalogControllerProvider).value?.today ?? DateTime.now(),
  );

  /// Açılış bağlamı (prototip `openSheet(kind, key, patch)`): [reset] ile hedef
  /// koordinatörlük [coordinatorship] olur (null → seçilmemiş) ve atananlar silinir (görev
  /// listesi, koordinatörlük ayrıntısı, sohbet); [reset] olmadan taslak olduğu gibi kalır
  /// (ana sayfa hızlı işlemi). Her iki durumda satırlar kapalı, hata yok, yarım takvim
  /// seçimi geri alınır. [title] verilirse başlık onunla doldurulur (mesajı göreve
  /// dönüştür: metnin ilk 120 karakteri). [note] toplantı notundan görev açar (bkz.
  /// [NewTaskForm.note]); nottan açılmış taslağa nottan olmayan açılış boş taslakla başlar.
  void prepare({
    String? coordinatorship,
    bool reset = true,
    String? title,
    String? note,
  }) {
    var f = _cancelPick(state);
    if (note != null || f.note != null) {
      f = _initial().copyWith(note: () => note);
    }
    if (title != null) f = f.copyWith(title: title);
    // Hedefsiz sıfırlama (görev listesi) hesaplanan açılabilir varsayılana düşer.
    final target = coordinatorship ?? _defaultCoordinatorship();
    state = reset
        ? f.copyWith(
            coordinatorship: () => target,
            assignees: const [],
            pane: () => null,
            error: () => null,
          )
        : f.copyWith(pane: () => null, error: () => null);
  }

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

  /// Atanan seçimi; TEK atanan (`assignee_account_id`): seçim yer değiştirir.
  void toggleAssignee(String id) => state = state.copyWith(
    assignees: state.assignees.contains(id)
        ? [
            for (final a in state.assignees)
              if (a != id) a,
          ]
        : [id],
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

  /// Doğrular ve görevi oluşturur; hata varsa [NewTaskForm.error] / [NewTaskForm.failure]
  /// ile null döner.
  ///
  /// `createWorkItem`: koordinatörlük = departman (isteğin açık departmanı), tek
  /// atanan (boş → atamasız görev), tarihler, öncelik, kanıt bayrağı. Kod yerelde üretilmez;
  /// sunucunun verdiği kimlik kullanılır ve katalog yeniden okunur (iyimser ekleme yok).
  /// Yetki: kapsamda yönetici ya da koordinatör ([TaskAccess.canCreateIn]); değilse istek
  /// gönderilmez (`work.not_authorized`). Uçuştaki istekte ikinci çağrı null döner.
  Future<CreatedTask?> submit() async {
    if (state.busy) return null;
    final f = _cancelPick(state);
    final err = _validate(f);
    if (err != null) {
      state = state.copyWith(error: () => err, failure: () => null);
      return null;
    }
    final catalog = ref.read(taskCatalogControllerProvider).value;
    final access = catalog?.access;
    final program = ref.read(scopeStateProvider).programId;
    final dept = f.coordinatorship!;
    if (access == null ||
        program == null ||
        !access.canCreateIn(program, dept)) {
      state = state.copyWith(failure: () => ApiError('work.not_authorized'));
      return null;
    }
    state = state.copyWith(busy: true, failure: () => null, error: () => null);
    final store = ref.read(taskCatalogControllerProvider.notifier);
    final note = f.note;
    try {
      final id = note != null
          ? await ref
                .read(meetingPlannerProvider)
                .convertNote(
                  note,
                  NoteTaskPlan(
                    title: f.title.trim(),
                    start: f.start,
                    end: f.end,
                    priority: f.priority,
                    departmentId: dept,
                    assigneeIds: f.assignees,
                  ),
                )
          : await ref
                .read(taskWriteRepositoryProvider)
                .createWorkItem(
                  WorkItemDraft(
                    programId: program,
                    departmentId: dept,
                    title: f.title.trim(),
                    start: f.start,
                    end: f.end,
                    priority: f.priority,
                    assignee: f.assignees.firstOrNull,
                    evidenceRequired: f.evidenceRequired,
                  ),
                );
      await store.reload();
      if (!ref.mounted) return null;
      final key =
          ref
              .read(taskCatalogControllerProvider)
              .value
              ?.task(id)
              ?.displayCode ??
          id;
      state = _initial();
      return (code: key, notified: f.assignees.length);
    } on Object catch (e) {
      final err = toApiError(e);
      // 409 (kapsam/çakışma) ya da 403 (yetki değişmiş): kapsam kataloğu ve rol olguları
      // (`/v1/me`, `/v1/me/departments`, departmanlar, liste) yeniden okunur; otomatik
      // gönderim YOK — karar kullanıcıda (taslak korunur).
      if (_rereadAfterCreate(err)) await store.reload();
      if (ref.mounted) {
        state = state.copyWith(busy: false, failure: () => err);
      }
      return null;
    }
  }

  NewTaskError? _validate(NewTaskForm f) => f.title.trim().isEmpty
      ? NewTaskError.title
      : f.coordinatorship == null
      ? NewTaskError.coordinatorship
      : f.end.isBefore(f.start)
      ? NewTaskError.dates
      : null;

  static bool _rereadAfterCreate(ApiError e) =>
      e.status == 409 ||
      e.status == 403 ||
      const {'work.not_authorized', 'platform.conflict_retry'}.contains(e.code);
}

/// [list]'te [x] varsa çıkarılmış, yoksa eklenmiş kopya (çoklu seçim satırları).
List<T> toggled<T>(List<T> list, T x) => list.contains(x)
    ? [
        for (final y in list)
          if (y != x) y,
      ]
    : [...list, x];

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
    state.copyWith(coordinatorships: toggled(state.coordinatorships, code)),
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
