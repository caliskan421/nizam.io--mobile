import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../tasks/tasks.dart';
import '../domain/home_dashboard.dart';

part 'home_team_people.g.dart';

/// Ekip kutularının açtığı görev listesi süzgeci: EKİP rolü (koordinator/uye) başına kişi
/// kimlikleri. Koordinatör kümesi koordinatör rolündekiler ile herhangi bir koordinatörlüğün
/// koordinatörü olanların birleşimidir. Yönetici süzgeci yoktur (F57): şirket yöneticiliği
/// ekip rolü değildir; yönetici yalnız ekip satırı varsa o rolle görünür.
@immutable
final class HomeTeamPeople {
  const HomeTeamPeople({required this.coordinators, required this.members});

  factory HomeTeamPeople.fromCatalog(TaskCatalog catalog) {
    final leads = {for (final c in catalog.coordinatorships) ...c.leads};
    List<String> where(bool Function(Person p) test) => [
      for (final p in catalog.people)
        if (test(p)) p.id,
    ];
    return HomeTeamPeople(
      coordinators: where(
        (p) => p.role == PersonRole.coordinator || leads.contains(p.id),
      ),
      members: where((p) => p.role == PersonRole.member),
    );
  }

  final List<String> coordinators;
  final List<String> members;

  /// Rolün kişileri; yönetici için boş (süzgeç yok).
  List<String> of(TeamRole role) => switch (role) {
    TeamRole.admin => const [],
    TeamRole.coordinator => coordinators,
    TeamRole.member => members,
  };
}

/// Ortak görev kataloğundan türetilir (katalog yüklenmeden null; kutu o zaman süzgeçsiz açar).
@riverpod
HomeTeamPeople? homeTeamPeople(Ref ref) {
  final catalog = ref.watch(taskCatalogControllerProvider).value;
  return catalog == null ? null : HomeTeamPeople.fromCatalog(catalog);
}
