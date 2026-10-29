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

  /// Filtreye uyan, sıralanmış tam liste (prototip `CS`): gecikmede eşitlik adla, yönle
  /// birlikte döner (büyükten küçüğe → A→Z, tersinde Z→A); ilerlemede eşitler sunucu sırasını
  /// korur (kararlı); ad ölçütü Türkçe sıradır.
  List<CoordinatorshipSummary> filtered(List<CoordinatorshipSummary> all) {
    final indexed = [
      for (final (i, c) in all.indexed)
        if (matches(filter, c)) (i, c),
    ];
    int compare(CoordinatorshipSummary a, CoordinatorshipSummary b) =>
        switch (sort) {
          CoordinatorshipSort.late =>
            a.late != b.late
                ? a.late.compareTo(b.late)
                : compareTurkish(b.name, a.name),
          CoordinatorshipSort.progress => a.donePercent.compareTo(
            b.donePercent,
          ),
          CoordinatorshipSort.name => compareTurkish(a.name, b.name),
        };
    indexed.sort((x, y) {
      final d = descending ? compare(y.$2, x.$2) : compare(x.$2, y.$2);
      return d != 0 ? d : x.$1.compareTo(y.$1);
    });
    return [for (final (_, c) in indexed) c];
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
