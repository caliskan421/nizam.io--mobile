import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/domain/request_key.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/providers.dart';
import '../../../core/session/session_state.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/table_models.dart';
import 'tables_providers.dart';

part 'tables_list_controller.g.dart';

/// Liste sekmesi: koordinatörlük tabloları, sahibi olduğum kişisel tablolar, bana paylaşılan
/// kişisel tablolar (sahibi başkası).
enum TablesArea { coordinatorship, personal, shared }

/// Bir alanın yüklenen tabloları.
@immutable
final class TableListSection {
  TableListSection({
    required List<TableMeta> items,
    this.nextCursor,
    this.loadingMore = false,
    this.moreError,
  }) : items = List.unmodifiable(items);

  final List<TableMeta> items;
  final String? nextCursor;
  final bool loadingMore;
  final ApiError? moreError;
  bool get hasMore => nextCursor != null;

  TableListSection copyWith({
    List<TableMeta>? items,
    String? Function()? nextCursor,
    bool? loadingMore,
    ApiError? Function()? moreError,
  }) => TableListSection(
    items: items ?? this.items,
    nextCursor: nextCursor == null ? this.nextCursor : nextCursor(),
    loadingMore: loadingMore ?? this.loadingMore,
    moreError: moreError == null ? this.moreError : moreError(),
  );
}

/// Liste ekranının durumu. Bölüm null → kapsam o alanı okumaya yetmiyor (koordinatörlük
/// için seçili departman yok).
@immutable
final class TablesListView {
  const TablesListView({
    required this.accountId,
    this.coordinatorship,
    this.personal,
  });

  final String? accountId;
  final TableListSection? coordinatorship;
  final TableListSection? personal;

  /// [area] sekmesinin tabloları; [query] adda büyük/küçük harf duyarsız arar.
  List<TableMeta> visible(TablesArea area, [String query = '']) {
    final q = query.trim().toLowerCase();
    final source = switch (area) {
      TablesArea.coordinatorship => coordinatorship?.items ?? const [],
      TablesArea.personal => [
        for (final t in personal?.items ?? const <TableMeta>[])
          if (t.ownedBy(accountId)) t,
      ],
      TablesArea.shared => [
        for (final t in personal?.items ?? const <TableMeta>[])
          if (!t.ownedBy(accountId)) t,
      ],
    };
    return [
      for (final t in source)
        if (q.isEmpty || t.name.toLowerCase().contains(q)) t,
    ];
  }

  TableListSection? section(TableSpace space) =>
      space == TableSpace.personal ? personal : coordinatorship;

  TableMeta? find(String id) {
    for (final t in [...?coordinatorship?.items, ...?personal?.items]) {
      if (t.id == id) return t;
    }
    return null;
  }

  TablesListView withSection(TableSpace space, TableListSection? s) =>
      TablesListView(
        accountId: accountId,
        coordinatorship: space == TableSpace.personal ? coordinatorship : s,
        personal: space == TableSpace.personal ? s : personal,
      );
}

/// Liste filtresi (sekme + arama); ekran durumudur, sunucuya gitmez.
@immutable
final class TablesFilter {
  const TablesFilter({this.area = TablesArea.coordinatorship, this.query = ''});
  final TablesArea area;
  final String query;
}

@riverpod
class TablesFilterController extends _$TablesFilterController {
  @override
  TablesFilter build() => const TablesFilter();

  void setArea(TablesArea area) =>
      state = TablesFilter(area: area, query: state.query);
  void setQuery(String query) =>
      state = TablesFilter(area: state.area, query: query);
}

/// Seçili kapsamın tablo listeleri (`listTables` S3 + `listPersonalTables` S2). Oturum nesli
/// ya da kapsam değişince yeniden kurulur (önceki hesabın/programın verisi görünmez).
@riverpod
class TablesListController extends _$TablesListController {
  static const pageSize = 100;

  int _generation = 0;
  RequestKeys _keys = const RequestKeys();

  /// Seçili kapsamdan liste kapsamları (program yoksa ikisi de null).
  static (TableScope?, TableScope?) scopesOf(
    String? programId,
    String? departmentId,
  ) {
    if (programId == null || programId.isEmpty) return (null, null);
    return (
      departmentId == null || departmentId.isEmpty
          ? null
          : TableScope.coordinatorship(
              programId: programId,
              departmentId: departmentId,
            ),
      TableScope.personal(programId: programId),
    );
  }

  @override
  Future<TablesListView> build() async {
    ref.watch(sessionGenerationProvider);
    final scope = ref.watch(scopeStateProvider);
    final session = ref.read(sessionStateProvider);
    ++_generation;
    _keys = const RequestKeys();
    final (coord, personal) = scopesOf(scope.programId, scope.departmentId);
    final repo = ref.read(tablesRepositoryProvider);
    const first = PageRequest(limit: pageSize);
    final results = await Future.wait([
      if (coord != null) repo.list(coord, page: first),
      if (personal != null) repo.list(personal, page: first),
    ]);
    TableListSection section(PageSlice<TableMeta> s) =>
        TableListSection(items: s.items, nextCursor: s.nextCursor);
    return TablesListView(
      accountId: session is SessionActive ? session.accountId : null,
      coordinatorship: coord == null ? null : section(results.first),
      personal: personal == null ? null : section(results.last),
    );
  }

  TableScope? _scopeFor(TableSpace space) {
    final s = ref.read(scopeStateProvider);
    final (coord, personal) = scopesOf(s.programId, s.departmentId);
    return space == TableSpace.personal ? personal : coord;
  }

  /// İlk sayfaları yeniden okur; hata durumda görünür.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.tables);
    }
  }

  /// [space] alanının sonraki sayfası; son sayfadaysa ya da istek sürüyorsa bir şey yapmaz.
  Future<void> loadMore(TableSpace space) async {
    final view = state.value;
    final section = view?.section(space);
    final scope = _scopeFor(space);
    if (view == null ||
        section == null ||
        scope == null ||
        !section.hasMore ||
        section.loadingMore) {
      return;
    }
    final generation = _generation;
    state = AsyncData(
      view.withSection(
        space,
        section.copyWith(loadingMore: true, moreError: () => null),
      ),
    );
    try {
      final page = await ref
          .read(tablesRepositoryProvider)
          .list(
            scope,
            page: PageRequest(limit: pageSize, cursor: section.nextCursor),
          );
      if (!ref.mounted || generation != _generation) return;
      final now = state.value!;
      final current = now.section(space)!;
      final seen = {for (final t in current.items) t.id};
      state = AsyncData(
        now.withSection(
          space,
          current.copyWith(
            items: [
              ...current.items,
              for (final t in page.items)
                if (!seen.contains(t.id)) t,
            ],
            nextCursor: () => page.nextCursor,
            loadingMore: false,
          ),
        ),
      );
    } on ApiError catch (e) {
      if (!ref.mounted || generation != _generation) return;
      final now = state.value!;
      state = AsyncData(
        now.withSection(
          space,
          now.section(space)!.copyWith(loadingMore: false, moreError: () => e),
        ),
      );
    }
  }

  /// Yeni boş tablo oluşturur ve kimliğini döner. Sonucu bilinmeyen hata (zaman aşımı/5xx)
  /// fırlar; aynı adla yeniden deneme AYNI işlem anahtarını kullanır (çift tablo olmaz).
  Future<String> create(TableSpace space, String name) async {
    final scope = _scopeFor(space);
    if (scope == null) throw ApiError(ClientErrorCode.scopeMissing);
    final trimmed = name.trim();
    final action = 'create:${space.name}';
    final (keys, key) = _keys.keyFor(action, trimmed);
    _keys = keys;
    final generation = _generation;
    try {
      final r = await ref
          .read(tablesRepositoryProvider)
          .create(scope, trimmed, requestKey: key);
      _keys = _keys.clear(action);
      if (ref.mounted && generation == _generation) {
        // Tam üst bilgi (sıra/şema) liste yenilemesiyle gelir.
        await refresh();
      }
      return r.id ?? r.tableId;
    } on ApiError catch (e) {
      if (!isOutcomeUnknown(e)) _keys = _keys.clear(action);
      rethrow;
    }
  }

  /// Tablo ekranından gelen yeniden adlandırma (liste yeniden okunmadan).
  void renamed(String id, String name) =>
      _patch(id, (t) => t.copyWith(name: name));

  /// Tablo silindi ya da erişim bitti: listeden düşer.
  void removed(String id) {
    final view = state.value;
    if (view == null) return;
    var next = view;
    for (final space in [TableSpace.coordinatorship, TableSpace.personal]) {
      final s = next.section(space);
      if (s == null) continue;
      next = next.withSection(
        space,
        s.copyWith(
          items: [
            for (final t in s.items)
              if (t.id != id) t,
          ],
        ),
      );
    }
    state = AsyncData(next);
  }

  void _patch(String id, TableMeta Function(TableMeta) change) {
    final view = state.value;
    if (view == null) return;
    var next = view;
    for (final space in [TableSpace.coordinatorship, TableSpace.personal]) {
      final s = next.section(space);
      if (s == null) continue;
      next = next.withSection(
        space,
        s.copyWith(
          items: [for (final t in s.items) t.id == id ? change(t) : t],
        ),
      );
    }
    state = AsyncData(next);
  }
}
