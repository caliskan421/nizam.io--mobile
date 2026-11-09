import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../tasks/tasks.dart';
import '../domain/meeting.dart';
import '../domain/meeting_board.dart';
import 'meeting_summary_controller.dart';
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
/// silme de bu yoldadır): `/v1/meetings/deleted` istemci kapısında `/v1/meetings/{id}` ile
/// belirsiz eşleşir ve fail-closed reddedilir. İkisi de imleçli; en çok [maxPages] × [pageSize]
/// satır okunur. Seçili program değişince yeniden yüklenir; yeniden ziyarette bayatsa arka
/// planda tazelenir ([refreshIfStale]).
@Riverpod(keepAlive: true)
class MeetingsBoardController extends _$MeetingsBoardController {
  static const pageSize = 200;
  static const maxPages = 10;

  /// Son başarılı okumadan beri geçen süre (notifier yeniden kurulumlarda korunur).
  final _clock = StaleClock();

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
    _clock.markFresh();
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
    ref
      ..invalidate(meetingSummaryControllerProvider)
      ..invalidateSelf();
    try {
      await future;
    } on Object {
      // Hata durumda (AsyncError) gösterilir; yenileme göstergesi kapanır.
    }
  }

  /// Yeniden ziyaret (sekmeye ya da ön plana dönüş): son başarılı okuma [maxAge]'den eskiyse
  /// liste arka planda yeniden okunur; eski liste görünür kalır, hata yutulur. Kart ayrıntıları
  /// (sayaç, konferans) geçersizlenmez: kart başına istek yalnız aşağı çekerek yenilemede.
  Future<void> refreshIfStale({Duration maxAge = StaleClock.staleAfter}) =>
      _clock.refreshIfStale(state, () {
        ref.invalidateSelf();
        return future;
      }, maxAge: maxAge);

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
