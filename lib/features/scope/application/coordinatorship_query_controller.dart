import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/turkish_collation.dart';
import '../domain/home_dashboard.dart';

part 'coordinatorship_query_controller.g.dart';

/// Sıralama ölçütü (döngü sırası: gecikme → ilerleme → ad).
enum CoordinatorshipSort { late, progress, name }

/// Ana sayfadaki koordinatörlük listesinin sorgusu: ölçüt, yön ve "tümünü göster" (görünüm
/// durumu; süzgeç yok, bütün koordinatörlükler sıralanır).
@immutable
final class CoordinatorshipQuery {
  const CoordinatorshipQuery({
    this.sort = CoordinatorshipSort.late,
    this.descending = true,
    this.expanded = false,
  });

  /// Daraltılmış listede görünen kart sayısı.
  static const collapsedCount = 4;

  final CoordinatorshipSort sort;
  final bool descending;
  final bool expanded;

  /// Sıralanmış tam liste (prototip `CS`): gecikmede eşitlik adla, yönle
  /// birlikte döner (büyükten küçüğe → A→Z, tersinde Z→A); ilerlemede eşitler sunucu sırasını
  /// korur (kararlı); ad ölçütü Türkçe sıradır.
  List<CoordinatorshipSummary> sorted(List<CoordinatorshipSummary> all) {
    final indexed = [...all.indexed];
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

  /// Ekranda görünen kartlar (daraltılmışken ilk [collapsed]; geniş ana sayfada iki satır).
  List<CoordinatorshipSummary> visible(
    List<CoordinatorshipSummary> all, {
    int collapsed = collapsedCount,
  }) {
    final list = sorted(all);
    return expanded ? list : list.take(collapsed).toList();
  }

  CoordinatorshipQuery copyWith({
    CoordinatorshipSort? sort,
    bool? descending,
    bool? expanded,
  }) => CoordinatorshipQuery(
    sort: sort ?? this.sort,
    descending: descending ?? this.descending,
    expanded: expanded ?? this.expanded,
  );

  @override
  bool operator ==(Object other) =>
      other is CoordinatorshipQuery &&
      other.sort == sort &&
      other.descending == descending &&
      other.expanded == expanded;

  @override
  int get hashCode => Object.hash(sort, descending, expanded);
}

/// Koordinatörlük listesinin ekran durumu ve komutları (widget'lar yalnız bunları çağırır).
@riverpod
class CoordinatorshipQueryController extends _$CoordinatorshipQueryController {
  @override
  CoordinatorshipQuery build() => const CoordinatorshipQuery();

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
