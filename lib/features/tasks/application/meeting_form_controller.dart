import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/meeting_planner.dart';
import '../domain/task_catalog.dart';
import 'quick_forms_controller.dart' show toggled;
import 'task_catalog_controller.dart';
import 'tasks_providers.dart';

part 'meeting_form_controller.g.dart';

// Hızlı toplantı formu (prototip `S_home.state.mt`): yeni toplantı ve toplantı düzenleme.
// Taslak sayfa kapanınca korunur (keepAlive); yalnız başarılı gönderimde sıfırlanır. Yazma
// [MeetingPlanner] portuyladır (gerçekleştirme meetings feature'ında).

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// [owner] yalnız kişi kipinde görünür (sahip koordinatörlük; sunucu en az bir departman ister).
enum MeetingPane { date, time, invitees, agenda, owner }

enum MeetingMode { coordinatorships, people }

enum MeetingError { title, past, place, coordinatorships, people, owner }

/// Yerin en çok uzunluğu (COLLABORATION-K76).
const meetingPlaceMax = 200;

/// Kişi kipinde seçilebilen sahip koordinatörlükler (K73): yönetici her birini, koordinatör
/// yalnız kendi koordinatörlüklerini seçer.
List<CoordinatorshipRef> meetingOwnerChoices(TaskCatalog catalog) =>
    catalog.access?.companyAdmin ?? false
    ? catalog.coordinatorships
    : [
        for (final c in catalog.coordinatorships)
          if (c.leads.contains(catalog.me)) c,
      ];

@immutable
final class MeetingForm {
  const MeetingForm({
    required this.date,
    required this.month,
    this.title = '',
    this.place = '',
    this.hour = 10,
    this.minute = 0,
    this.mode = MeetingMode.coordinatorships,
    this.coordinatorships = const [],
    this.people = const [],
    this.owner,
    this.allMembers = false,
    this.pane,
    this.agenda = const [],
    this.agendaDraft = '',
    this.openGroups = const {},
    this.editing,
    this.error,
    this.failure,
    this.busy = false,
    this.created,
  });

  final String title;

  /// Yer (isteğe bağlı).
  final String place;
  final DateTime date;
  final DateTime month;
  final int hour;
  final int minute;
  final MeetingMode mode;

  /// Davetli koordinatörlükler (`department_id`); ilki sahip departmandır.
  final List<String> coordinatorships;
  final List<String> people;

  /// Kişi kipinde sahip koordinatörlük.
  final String? owner;
  final bool allMembers;
  final MeetingPane? pane;
  final List<String> agenda;
  final String agendaDraft;

  /// Kişiler kipinde açık koordinatörlük grupları.
  final Set<String> openGroups;

  /// Düzenlenen toplantının kimliği; null → yeni toplantı. Düzenlemede kip seçimi ve gündem
  /// yoktur (katılımcı ve gündem toplantı ayrıntısında yönetilir); kişi kipindeki toplantının
  /// departman seti de değişmez (K73).
  final String? editing;
  final MeetingError? error;

  /// Sunucu hatası (taslak korunur).
  final ApiError? failure;
  final bool busy;

  /// Yalnız [MeetingFormController.submit]'in döndürdüğü gönderilmiş formda: açılan toplantı
  /// (eklenemeyen katılımcılarıyla); düzenlemede ve taslakta null.
  final MeetingPlanned? created;

  /// Davet edilen ve eklenemeyen kişi kimlikleri (kişi kipinde; [created]'tan).
  List<String> get notInvited => created?.failedParticipantIds ?? const [];

  MeetingForm copyWith({
    String? title,
    String? place,
    DateTime? date,
    DateTime? month,
    int? hour,
    int? minute,
    MeetingMode? mode,
    List<String>? coordinatorships,
    List<String>? people,
    String? Function()? owner,
    bool? allMembers,
    MeetingPane? Function()? pane,
    List<String>? agenda,
    String? agendaDraft,
    Set<String>? openGroups,
    MeetingError? Function()? error,
    ApiError? Function()? failure,
    bool? busy,
    MeetingPlanned? created,
  }) => MeetingForm(
    title: title ?? this.title,
    place: place ?? this.place,
    date: date ?? this.date,
    month: month ?? this.month,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    mode: mode ?? this.mode,
    coordinatorships: coordinatorships ?? this.coordinatorships,
    people: people ?? this.people,
    owner: owner == null ? this.owner : owner(),
    allMembers: allMembers ?? this.allMembers,
    pane: pane == null ? this.pane : pane(),
    agenda: agenda ?? this.agenda,
    agendaDraft: agendaDraft ?? this.agendaDraft,
    openGroups: openGroups ?? this.openGroups,
    editing: editing,
    error: error == null ? this.error : error(),
    failure: failure == null ? this.failure : failure(),
    busy: busy ?? this.busy,
    created: created ?? this.created,
  );

  /// Gönderilecek departman seti (ilki sahip).
  List<String> get departmentIds =>
      mode == MeetingMode.people ? [?owner] : coordinatorships;

  /// Toplantı anı (yerel duvar saati).
  DateTime get at => DateTime(date.year, date.month, date.day, hour, minute);
}

/// Düzenlenecek toplantının formdaki değerleri.
@immutable
final class MeetingSeed {
  const MeetingSeed({
    required this.id,
    required this.title,
    required this.at,
    required this.departmentIds,
    required this.membersIncluded,
    this.place,
    this.byPerson = false,
  });

  final String id;
  final String title;

  /// Yerel an.
  final DateTime at;
  final List<String> departmentIds;
  final bool membersIncluded;
  final String? place;

  /// Davet kipi `person` (değişmez; formda kip `people`, sahip departman setinin ilki).
  final bool byPerson;
}

@Riverpod(keepAlive: true)
class MeetingFormController extends _$MeetingFormController {
  @override
  MeetingForm build() => _initial();

  MeetingForm _initial() {
    final t = today;
    final d = t.add(const Duration(days: 1));
    return MeetingForm(date: d, month: DateTime(t.year, t.month));
  }

  /// Verinin bugünü (geçmiş günler seçilemez).
  DateTime get today => _day(
    ref.read(taskCatalogControllerProvider).value?.today ?? DateTime.now(),
  );

  /// Yeni toplantı. [date] verilirse (takvimden "seçili güne toplantı planla") tarih ve ay o
  /// güne gelir. Düzenleme taslağından dönülüyorsa boş form açılır.
  void prepare({String? coordinatorship, DateTime? date}) {
    var f = state.editing != null
        ? _initial()
        : state.copyWith(
            pane: () => null,
            error: () => null,
            failure: () => null,
          );
    if (coordinatorship != null) {
      f = f.copyWith(
        mode: MeetingMode.coordinatorships,
        coordinatorships: [coordinatorship],
      );
    }
    if (date != null) {
      f = f.copyWith(date: _day(date), month: DateTime(date.year, date.month));
    }
    state = f;
  }

  /// Var olan toplantıyı düzenlemek için doldurur. Geçmiş tarihli toplantının günü bugüne
  /// çekilir (sunucu geçmiş tarihi reddeder, COLLABORATION-K17).
  void prepareEdit(MeetingSeed seed) {
    final t = today;
    final day = _day(seed.at).isBefore(t) ? t : _day(seed.at);
    state = MeetingForm(
      title: seed.title,
      place: seed.place ?? '',
      date: day,
      month: DateTime(day.year, day.month),
      hour: seed.at.hour,
      minute: seed.at.minute,
      mode: seed.byPerson ? MeetingMode.people : MeetingMode.coordinatorships,
      coordinatorships: seed.byPerson ? const [] : seed.departmentIds,
      owner: seed.byPerson ? seed.departmentIds.firstOrNull : null,
      allMembers: !seed.byPerson && seed.membersIncluded,
      editing: seed.id,
    );
  }

  void _set(MeetingForm f) =>
      state = f.copyWith(error: () => null, failure: () => null);

  void setTitle(String v) => _set(state.copyWith(title: v));

  void setPlace(String v) => _set(state.copyWith(place: v));

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
    state.copyWith(coordinatorships: toggled(state.coordinatorships, code)),
  );

  void togglePerson(String id) =>
      _set(state.copyWith(people: toggled(state.people, id)));

  /// Kişi kipinde sahip koordinatörlük (aynısına dokunmak seçimi kaldırır).
  void pickOwner(String code) =>
      _set(state.copyWith(owner: () => state.owner == code ? null : code));

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

  /// Kişi kipinde katılımcı yalnız açılışta istenir (düzenlemede ayrıntıda yönetilir).
  MeetingError? _validate(MeetingForm f) => f.title.trim().isEmpty
      ? MeetingError.title
      : f.date.isBefore(today)
      ? MeetingError.past
      : f.place.trim().length > meetingPlaceMax
      ? MeetingError.place
      : f.mode == MeetingMode.coordinatorships && f.coordinatorships.isEmpty
      ? MeetingError.coordinatorships
      : f.mode == MeetingMode.people && f.editing == null && f.people.isEmpty
      ? MeetingError.people
      : f.mode == MeetingMode.people && f.owner == null
      ? MeetingError.owner
      : null;

  /// Doğrular ve sunucuya yazar (yeni ya da düzenleme). Başarıda gönderilen formu döner (yeni
  /// toplantıda [MeetingForm.created] dolu: eklenemeyen katılımcılar bildirimde ayrı yazılır) ve
  /// taslağı sıfırlar; doğrulama ya da sunucu hatasında null (hata formda görünür, taslak kalır).
  Future<MeetingForm?> submit() async {
    final f = state;
    if (f.busy) return null;
    final err = _validate(f);
    if (err != null) {
      state = f.copyWith(error: () => err, failure: () => null);
      return null;
    }
    state = f.copyWith(busy: true, error: () => null, failure: () => null);
    final people = f.mode == MeetingMode.people;
    final plan = MeetingPlan(
      title: f.title.trim(),
      place: f.place.trim(),
      byPerson: people,
      at: f.at,
      departmentIds: f.departmentIds,
      participantIds: people ? f.people : const [],
      membersIncluded: !people && f.allMembers,
      agenda: [
        for (final a in f.agenda)
          if (a.trim().isNotEmpty) a.trim(),
      ],
    );
    try {
      final planner = ref.read(meetingPlannerProvider);
      final id = f.editing;
      MeetingPlanned? created;
      if (id == null) {
        created = await planner.create(plan);
      } else {
        await planner.update(id, plan);
      }
      if (!ref.mounted) return null;
      state = _initial();
      return f.copyWith(created: created);
    } on Object catch (e, st) {
      // Rapor/çeviri dispose korumasından ÖNCE; yalnız durum yazımı koruma altında.
      final failure = toReportedApiError(e, st, source: ReportSource.tasks);
      if (ref.mounted) {
        state = state.copyWith(busy: false, failure: () => failure);
      }
      return null;
    }
  }
}
