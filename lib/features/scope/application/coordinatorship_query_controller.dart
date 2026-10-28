import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/turkish_collation.dart';
import '../domain/home_dashboard.dart';

part 'coordinatorship_query_controller.g.dart';

/// Ana sayfadaki koordinatörlük listesinin görünüm filtresi.
enum CoordinatorshipFilter { all, late, onTrack, unassigned }

/// Sıralama ölçütü (döngü sırası: gecikme → ilerleme → ad).
enum CoordinatorshipSort { late, progress, name }

/// Liste sorgusu: filtre, ölçüt, yön ve "tümünü göster". Görünüm durumudur; süzme yalnız
/// sunucunun verdiği sayılara bakar (gecikme > 0, koordinatör yok).
@immutable
final class CoordinatorshipQuery {
  const CoordinatorshipQuery({
    this.filter = CoordinatorshipFilter.all,
    this.sort = CoordinatorshipSort.late,
    this.descending = true,
    this.expanded = false,
  });

  /// Daraltılmış listede görünen kart sayısı.
  static const collapsedCount = 4;

  final CoordinatorshipFilter filter;
  final CoordinatorshipSort sort;
  final bool descending;
  final bool expanded;

  static bool matches(CoordinatorshipFilter f, CoordinatorshipSummary c) =>
      switch (f) {
        CoordinatorshipFilter.all => true,
        CoordinatorshipFilter.late => c.late > 0,
        CoordinatorshipFilter.onTrack => c.late == 0,
        CoordinatorshipFilter.unassigned => !c.hasLead,
      };

  /// Filtreye uyan, sıralanmış tam liste.
  List<CoordinatorshipSummary> filtered(List<CoordinatorshipSummary> all) {
    int byName(CoordinatorshipSummary a, CoordinatorshipSummary b) =>
        compareTurkish(a.name, b.name);
    int compare(CoordinatorshipSummary a, CoordinatorshipSummary b) =>
        switch (sort) {
          CoordinatorshipSort.late => a.late.compareTo(b.late),
          CoordinatorshipSort.progress => a.donePercent.compareTo(
            b.donePercent,
          ),
          CoordinatorshipSort.name => byName(a, b),
        };
    // Eşitlikte ad sırası (A→Z) yönden bağımsız kalır.
    return [
      for (final c in all)
        if (matches(filter, c)) c,
    ]..sort((a, b) {
      final d = descending ? compare(b, a) : compare(a, b);
      return d != 0 ? d : byName(a, b);
    });
  }

  /// Ekranda görünen kartlar (daraltılmışken ilk [collapsedCount]).
  List<CoordinatorshipSummary> visible(List<CoordinatorshipSummary> all) {
    final list = filtered(all);
    return expanded ? list : list.take(collapsedCount).toList();
  }

  CoordinatorshipQuery copyWith({
    CoordinatorshipFilter? filter,
    CoordinatorshipSort? sort,
    bool? descending,
    bool? expanded,
  }) => CoordinatorshipQuery(
    filter: filter ?? this.filter,
    sort: sort ?? this.sort,
    descending: descending ?? this.descending,
    expanded: expanded ?? this.expanded,
  );

  @override
  bool operator ==(Object other) =>
      other is CoordinatorshipQuery &&
      other.filter == filter &&
      other.sort == sort &&
      other.descending == descending &&
      other.expanded == expanded;

  @override
  int get hashCode => Object.hash(filter, sort, descending, expanded);
}

/// Koordinatörlük listesinin ekran durumu ve komutları (widget'lar yalnız bunları çağırır).
@riverpod
class CoordinatorshipQueryController extends _$CoordinatorshipQueryController {
  @override
  CoordinatorshipQuery build() => const CoordinatorshipQuery();

  /// Filtre değişince liste daralır.
  void selectFilter(CoordinatorshipFilter filter) =>
      state = state.copyWith(filter: filter, expanded: false);

  /// Sonraki ölçüt; ad ölçütü A→Z, diğerleri büyükten küçüğe başlar.
  void cycleSort() {
    const order = CoordinatorshipSort.values;
    final next = order[(order.indexOf(state.sort) + 1) % order.length];
    state = state.copyWith(
      sort: next,
      descending: next != CoordinatorshipSort.name,
    );
  }

  void flipDirection() => state = state.copyWith(descending: !state.descending);

  void toggleExpanded() => state = state.copyWith(expanded: !state.expanded);
}
