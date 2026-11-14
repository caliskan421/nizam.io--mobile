import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FutureProvider, Provider;
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_overview.dart';
import '../domain/department.dart';
import 'coordinatorships_providers.dart';

part 'coordinatorship_detail_controller.g.dart';

/// Ayrıntı bölümleri (prototip `cdetail` sekmeleri): Genel, Görevler, Üyeler, Arşiv, Takvim.
enum CoordinatorshipTab { general, tasks, members, archive, calendar }

/// Görünümün sekme kümesi. Üyeler bölümü ekibi okuyabilen görünümde vardır (yönetici ya da
/// koordinatör; `GET /v1/departments/{id}/members` üyeye kapalı) — [readsTeam] `false` ise
/// bölüm yoktur (boş liste yerine).
List<CoordinatorshipTab> coordinatorshipTabs({required bool readsTeam}) => [
  for (final t in CoordinatorshipTab.values)
    if (t != CoordinatorshipTab.members || readsTeam) t,
];

/// Ayrıntı ekranının görünüm durumu: bölüm, görev süzgeci (durum + kişi), açılır alanlar.
@immutable
final class CoordinatorshipDetailView {
  const CoordinatorshipDetailView({
    this.tab = CoordinatorshipTab.general,
    this.filter = CoordTaskFilter.open,
    this.extra = const TaskFilter(),
    this.pastOpen = false,
  });

  final CoordinatorshipTab tab;
  final CoordTaskFilter filter;

  /// Görev süzgecindeki kişi kimliği (null → herkes).
  final TaskFilter extra;
  String? get person => extra.people.firstOrNull;
  final bool pastOpen;

  /// Varsayılandan farklı süzgeç (süz düğmesinin noktası).
  bool get filtered => filter != CoordTaskFilter.open || extra.hasExtra;

  CoordinatorshipDetailView copyWith({
    CoordinatorshipTab? tab,
    CoordTaskFilter? filter,
    TaskFilter? extra,
    bool? pastOpen,
  }) => CoordinatorshipDetailView(
    tab: tab ?? this.tab,
    filter: filter ?? this.filter,
    extra: extra ?? this.extra,
    pastOpen: pastOpen ?? this.pastOpen,
  );

  @override
  bool operator ==(Object other) =>
      other is CoordinatorshipDetailView &&
      other.tab == tab &&
      other.filter == filter &&
      other.extra == extra &&
      other.pastOpen == pastOpen;

  @override
  int get hashCode => Object.hash(tab, filter, extra, pastOpen);
}

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel bölümünden başlar).
@riverpod
class CoordinatorshipDetailController
    extends _$CoordinatorshipDetailController {
  @override
  CoordinatorshipDetailView build(String code) =>
      const CoordinatorshipDetailView();

  void selectTab(CoordinatorshipTab tab) => state = state.copyWith(tab: tab);

  /// Görevler bölümünü [filter] süzgeciyle açar (kişi sayfası).
  void showTasks(CoordTaskFilter filter, {String? person}) =>
      state = state.copyWith(
        tab: CoordinatorshipTab.tasks,
        filter: filter,
        extra: TaskFilter(people: {?person}),
      );

  void setFilter(CoordTaskFilter filter) =>
      state = state.copyWith(filter: filter);

  void togglePerson(String id) =>
      _update(people: _toggle(state.extra.people, id));
  void togglePriority(TaskPriority p) =>
      _update(priorities: _toggle(state.extra.priorities, p));
  void toggleCoordinatorship(String code) =>
      _update(coordinatorships: _toggle(state.extra.coordinatorships, code));
  void _update({
    Set<String>? people,
    Set<String>? coordinatorships,
    Set<TaskPriority>? priorities,
  }) {
    final f = state.extra;
    state = state.copyWith(
      extra: TaskFilter(
        people: people ?? f.people,
        coordinatorships: coordinatorships ?? f.coordinatorships,
        priorities: priorities ?? f.priorities,
      ),
    );
  }

  Set<T> _toggle<T>(Set<T> set, T item) =>
      set.contains(item) ? ({...set}..remove(item)) : {...set, item};
  void clearGroup(TaskFilterGroup group) {
    switch (group) {
      case TaskFilterGroup.people:
        _update(people: {});
      case TaskFilterGroup.coordinatorship:
        _update(coordinatorships: {});
      case TaskFilterGroup.priority:
        _update(priorities: {});
    }
  }

  void clearExtra() => state = state.copyWith(extra: const TaskFilter());
  void clearFilter() => state = state.copyWith(
    filter: CoordTaskFilter.open,
    extra: const TaskFilter(),
  );

  void togglePast() => state = state.copyWith(pastOpen: !state.pastOpen);
}

/// Etkin görünüm [code] koordinatörlüğünün ekibini yönetir mi: yönetici görünümü her
/// koordinatörlükte; koordinatör görünümü yalnız koordinatörü olduğu koordinatörlükte (derin
/// bağlantıyla başka birime gelse de); üye görünümü (yönetici dahil) hayır. Üyeler bölümü,
/// "Üye ekle", "Görev ata" ve "Toplantı planla" bununla açılır; sunucu yine denetler.
final coordManagesTeamProvider = Provider.autoDispose.family<bool, String>((
  ref,
  code,
) {
  final view = ref.watch(effectiveAccessProvider);
  final program = view.programId;
  return view.isAdminView ||
      (view.isCoordinatorView &&
          program != null &&
          (view.access?.coordinatesIn(program, code) ?? false));
});

typedef ProgramDepartmentResult = ({
  int session,
  String program,
  Department department,
});

final programDepartmentProvider = FutureProvider.autoDispose
    .family<ProgramDepartmentResult, String>((Ref ref, String code) async {
      ref.watch(sessionGenerationProvider);
      ref.watch(scopeStateProvider);
      final sessionController = ref.read(sessionControllerProvider);
      final scopeController = ref.read(scopeControllerProvider);
      final session = sessionController.generation;
      final program = scopeController.current.programId;
      if (program == null) throw StateError('Program seçilmedi');
      final department = await ref
          .watch(departmentRepositoryProvider)
          .readProgramDepartment(program, code);
      if (sessionController.generation != session ||
          scopeController.current.programId != program) {
        throw ApiError(ClientErrorCode.scopeMissing);
      }
      return (session: session, program: program, department: department);
    });

/// [code] koordinatörlüğünün ayrıntısı; tekil okuma sunucunun rol denetiminden geçer.
@riverpod
AsyncValue<CoordinatorshipDetail?> coordinatorshipDetail(Ref ref, String code) {
  final catalog = ref.watch(taskCatalogControllerProvider);
  if (catalog.hasError) {
    return AsyncError(catalog.error!, catalog.stackTrace!);
  }
  if (catalog.isLoading) {
    // Açık ayrıntının tekil okumasını katalog geçişinde dinlemeyi sürdür. İlk açılışta
    // henüz doğrulanmamış kimlik için istek başlatılmaz.
    if (ref.read(scopeControllerProvider).current.programId != null &&
        ref.exists(programDepartmentProvider(code))) {
      ref.watch(programDepartmentProvider(code));
    }
    return const AsyncLoading();
  }
  final c = catalog.value;
  if (c == null) return const AsyncLoading();
  if (c.coordinatorship(code) == null) return const AsyncData(null);
  final departments = ref.watch(programDepartmentProvider(code));
  if (departments.hasError) {
    return AsyncError(departments.error!, departments.stackTrace!);
  }
  if (departments.isLoading) return const AsyncLoading();
  final d = departments.value;
  if (d == null) return const AsyncLoading();
  if (d.session != ref.read(sessionControllerProvider).generation ||
      d.program != ref.read(scopeControllerProvider).current.programId) {
    return const AsyncLoading();
  }
  return AsyncData(CoordinatorshipDetail.from(c, [d.department], code));
}

/// Koordinatörlüğün ([code] = `department_id`) toplantıları, tarihe göre.
@riverpod
Future<List<CoordMeeting>> coordinatorshipMeetings(Ref ref, String code) async {
  final list = await ref
      .watch(coordinatorshipActivityRepositoryProvider)
      .meetings(code);
  return [...list]..sort((a, b) => a.at.compareTo(b.at));
}

/// Koordinatörlüğün arşiv dosyaları (görevleri katalogdan; yeni önce).
@riverpod
Future<List<CoordFile>> coordinatorshipFiles(Ref ref, String code) async {
  final catalog = await ref.watch(taskCatalogControllerProvider.future);
  final ids = {for (final t in catalog.tasksOf(code)) t.id};
  if (ids.isEmpty) return const [];
  return ref.watch(coordinatorshipActivityRepositoryProvider).files(code, ids);
}
