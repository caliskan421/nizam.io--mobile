import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/coordinatorship_overview.dart';
import 'coordinatorship_profiles_controller.dart';

part 'coordinatorship_detail_controller.g.dart';

/// Ayrıntı sekmeleri (prototip hap sekmeler).
enum CoordinatorshipTab { general, units, team, about }

/// Ayrıntı ekranının görünüm durumu: seçili sekme ve "N üye daha" açık mı.
@immutable
final class CoordinatorshipDetailView {
  const CoordinatorshipDetailView({
    this.tab = CoordinatorshipTab.general,
    this.membersOpen = false,
  });

  final CoordinatorshipTab tab;
  final bool membersOpen;

  @override
  bool operator ==(Object other) =>
      other is CoordinatorshipDetailView &&
      other.tab == tab &&
      other.membersOpen == membersOpen;

  @override
  int get hashCode => Object.hash(tab, membersOpen);
}

/// Koordinatörlük ayrıntısının görünüm durumu ([code] başına; başka koordinatörlüğe geçince
/// Genel sekmesinden başlar).
@riverpod
class CoordinatorshipDetailController
    extends _$CoordinatorshipDetailController {
  @override
  CoordinatorshipDetailView build(String code) =>
      const CoordinatorshipDetailView();

  void selectTab(CoordinatorshipTab tab) => state = CoordinatorshipDetailView(
    tab: tab,
    membersOpen: state.membersOpen,
  );

  void toggleMembers() => state = CoordinatorshipDetailView(
    tab: state.tab,
    membersOpen: !state.membersOpen,
  );
}

/// [code] koordinatörlüğünün ayrıntısı (katalog + ek bilgiler); bilinmeyen kod → null.
@riverpod
Future<CoordinatorshipDetail?> coordinatorshipDetail(
  Ref ref,
  String code,
) async {
  final catalog = ref.watch(taskCatalogControllerProvider.future);
  final profiles = ref.watch(coordinatorshipProfilesControllerProvider.future);
  return CoordinatorshipDetail.from(await catalog, await profiles, code);
}
