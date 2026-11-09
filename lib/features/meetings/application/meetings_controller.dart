import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../tasks/tasks.dart';
import '../domain/meeting.dart';
import '../domain/meeting_board.dart';
import 'meetings_providers.dart';

part 'meetings_controller.g.dart';

/// Liste ekranının görünüm durumu (sekme, arama). Sayfalar arası korunur.
@immutable
final class MeetingsView {
  const MeetingsView({
    this.tab = MeetingsTab.upcoming,
    this.query = '',
    this.searchOpen = false,
  });

  final MeetingsTab tab;
  final String query;
  final bool searchOpen;

  MeetingsView copyWith({MeetingsTab? tab, String? query, bool? searchOpen}) =>
      MeetingsView(
        tab: tab ?? this.tab,
        query: query ?? this.query,
        searchOpen: searchOpen ?? this.searchOpen,
      );

  @override
  bool operator ==(Object other) =>
      other is MeetingsView &&
      other.tab == tab &&
      other.query == query &&
      other.searchOpen == searchOpen;

  @override
  int get hashCode => Object.hash(tab, query, searchOpen);
}

@Riverpod(keepAlive: true)
class MeetingsViewController extends _$MeetingsViewController {
  @override
  MeetingsView build() => const MeetingsView();

  void selectTab(MeetingsTab tab) => state = state.copyWith(tab: tab);

  void setQuery(String q) => state = state.copyWith(query: q);

  /// Arama kapanınca sorgu da temizlenir (prototip `toggleSearch`).
  void toggleSearch() => state = state.searchOpen
      ? state.copyWith(searchOpen: false, query: '')
      : state.copyWith(searchOpen: true);
}

/// Toplantı listesi: görünür toplantılar (`listMeetings`) ve yöneticiye silinenler. Silinenler
/// yönetici yaşam döngüsü yolundan okunur (`adminListDeletedMeetings`; geri yükleme ve kalıcı
/// silme de bu yoldadır). İkisi de imleçli; en çok [maxPages] × [pageSize] satır okunur. Kart
/// sayaçları ve konferans durumu satır özetindedir (COLLABORATION-K70; kart başına istek yok).
/// Seçili program değişince yeniden yüklenir.
@riverpod
class MeetingsBoardController extends _$MeetingsBoardController {
  static const pageSize = 200;
  static const maxPages = 10;

  @override
  Future<MeetingsBoard> build() async {
    ref.watch(scopeStateProvider);
    final repo = ref.read(meetingsRepositoryProvider);
    final catalog = await ref.read(taskCatalogControllerProvider.future);
    final admin = catalog.access?.companyAdmin ?? false;
    final (visible, truncated) = await _all(repo.listMeetings);
    final deleted = admin
        ? (await _all(repo.adminListDeletedMeetings)).$1
        : null;
    return MeetingsBoard(
      visible: visible,
      deleted: deleted,
      truncated: truncated,
    );
  }

  static Future<(List<Meeting>, bool)> _all(
    Future<PageSlice<Meeting>> Function(PageRequest) load,
  ) async {
    final out = <Meeting>[];
    String? cursor;
    for (var page = 0; page < maxPages; page++) {
      final r = await load(PageRequest(limit: pageSize, cursor: cursor));
      out.addAll(r.items);
      cursor = r.nextCursor;
      if (cursor == null) return (out, false);
    }
    return (out, true);
  }

  /// Aşağı çekerek yenileme: yeniden okur ve bitmesini bekler (hata ekranda görünür).
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object {
      // Hata durumda (AsyncError) gösterilir; yenileme göstergesi kapanır.
    }
  }

  /// Açık ayrıntının güncel özetini liste satırına yazar (ağ isteği yok); liste yüklenmemişse ya
  /// da toplantı listede yoksa bir şey yapmaz.
  void putSummary(String id, MeetingSummary summary) {
    final board = state.value;
    if (board == null || !board.visible.any((m) => m.id == id)) return;
    state = AsyncData(
      board.copyWith(
        visible: [
          for (final m in board.visible)
            m.id == id ? m.withSummary(summary) : m,
        ],
      ),
    );
  }

  /// Silinmiş toplantıyı geri yükler (yalnız yönetici); liste yeniden okunur.
  Future<ApiError?> restore(String id) async {
    try {
      await ref.read(meetingsRepositoryProvider).restoreMeeting(id);
    } on Object catch (e) {
      return toApiError(e);
    }
    if (ref.mounted) ref.invalidateSelf();
    return null;
  }

  /// Silinmiş toplantıyı kalıcı siler (yalnız yönetici).
  Future<ApiError?> purge(String id) async {
    try {
      await ref.read(meetingsRepositoryProvider).permanentDeleteMeeting(id);
    } on Object catch (e) {
      return toApiError(e);
    }
    final board = state.value;
    if (ref.mounted && board != null) {
      state = AsyncData(
        board.copyWith(
          deleted: [
            for (final m in board.deleted ?? const <Meeting>[])
              if (m.id != id) m,
          ],
        ),
      );
    }
    return null;
  }
}
