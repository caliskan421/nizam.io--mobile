import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/coordinatorship_board.dart';
import '../domain/coordinatorship_overview.dart';
import 'coordinatorship_profiles_controller.dart';
import 'coordinatorships_providers.dart';

part 'coordinatorship_detail_controller.g.dart';

/// Ayrıntı bölümleri (prototip segmentli sekmeler).
enum CoordinatorshipTab { general, tasks, members, archive, meetings }

/// Ayrıntı ekranının görünüm durumu: bölüm, görev süzgeci (durum + kişi), açılır alanlar.
@immutable
final class CoordinatorshipDetailView {
  const CoordinatorshipDetailView({
    this.tab = CoordinatorshipTab.general,
    this.filter = CoordTaskFilter.open,
    this.person,
    this.pastOpen = false,
  });

  final CoordinatorshipTab tab;
  final CoordTaskFilter filter;

  /// Görev süzgecindeki kişi kimliği (null → herkes).
  final String? person;
  final bool pastOpen;

  /// Varsayılandan farklı süzgeç (süz düğmesinin noktası).
  bool get filtered => filter != CoordTaskFilter.open || person != null;

  CoordinatorshipDetailView copyWith({
    CoordinatorshipTab? tab,
    CoordTaskFilter? filter,
    String? Function()? person,
    bool? pastOpen,
  }) => CoordinatorshipDetailView(
    tab: tab ?? this.tab,
    filter: filter ?? this.filter,
    person: person == null ? this.person : person(),
    pastOpen: pastOpen ?? this.pastOpen,
  );

  @override
  bool operator ==(Object other) =>
      other is CoordinatorshipDetailView &&
      other.tab == tab &&
      other.filter == filter &&
      other.person == person &&
      other.pastOpen == pastOpen;

  @override
  int get hashCode => Object.hash(tab, filter, person, pastOpen);
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
        person: () => person,
      );

  void setFilter(CoordTaskFilter filter) =>
      state = state.copyWith(filter: filter);

  void setPerson(String? person) =>
      state = state.copyWith(person: () => person);

  void clearFilter() =>
      state = state.copyWith(filter: CoordTaskFilter.open, person: () => null);

  void togglePast() => state = state.copyWith(pastOpen: !state.pastOpen);
}

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
/// Eşzamanlı türetilir: iki kaynak (keepAlive) hazırsa ilk kare doludur; biri hatalıysa hata,
/// biri yükleniyorsa yükleniyor.
@riverpod
AsyncValue<CoordinatorshipDetail?> coordinatorshipDetail(Ref ref, String code) {
  final catalog = ref.watch(taskCatalogControllerProvider);
  final profiles = ref.watch(coordinatorshipProfilesControllerProvider);
  for (final v in [catalog, profiles]) {
    if (v case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  final (c, p) = (catalog.value, profiles.value);
  if (c == null || p == null) return const AsyncLoading();
  return AsyncData(CoordinatorshipDetail.from(c, p, code));
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
