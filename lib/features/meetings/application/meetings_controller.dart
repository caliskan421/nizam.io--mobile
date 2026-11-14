import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/cache_owner.dart';
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/stale_clock.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
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
/// Seçili program değişince yeniden yüklenir; yeniden ziyarette bayatsa arka planda tazelenir
/// ([refreshIfStale]). Liste okunduğu sahibe (oturum nesli + program) bağlıdır; ekran [visible]
/// durumunu gösterir (başka hesabın/programın listesi görünmez).
@Riverpod(keepAlive: true)
class MeetingsBoardController extends _$MeetingsBoardController {
  static const pageSize = 200;
  static const maxPages = 10;

  /// Son başarılı okumadan beri geçen süre (notifier yeniden kurulumlarda korunur).
  final _clock = StaleClock();

  /// Durumdaki listenin sahibi (notifier yeniden kurulumlarda korunur).
  final _owner = CacheOwnership();

  // Yerel özet nesli: [putSummary] satırı işaretler; okuma başladıktan SONRA yazılmış özet,
  // o okumanın (daha eski) satır özetiyle ezilmez.
  int _generation = 0;
  final _local = HashMap<String, (int, MeetingSummary)>();

  @override
  Future<MeetingsBoard> build() async {
    final owner = _owner.watch(ref);
    ref.watch(scopeStateProvider);
    final since = _generation;
    final repo = ref.read(meetingsRepositoryProvider);
    final catalog = await ref.read(taskCatalogControllerProvider.future);
    final admin = catalog.viewIn(ref.read(scopeStateProvider)).canAdminister;
    final (visible, truncated) = await _all(repo.listMeetings);
    final deleted = admin
        ? (await _all(repo.adminListDeletedMeetings)).$1
        : null;
    _owner.markLoaded(ref, owner);
    _clock.markFresh();
    _local.removeWhere((_, e) => e.$1 <= since);
    return MeetingsBoard(
      visible: [
        for (final m in visible)
          if (_local[m.id] case (_, final summary))
            m.withSummary(summary)
          else
            m,
      ],
      deleted: deleted,
      truncated: truncated,
    );
  }

  /// Ekranın gösterebileceği durum (bkz. [CacheOwnership.visible]); çağıran sağlayıcıyı izler.
  AsyncValue<MeetingsBoard> get visible => _owner.visible(ref, state);

  /// Durumdaki liste şimdiki oturum ve programa mı ait (takvim dizini de buna bakar).
  bool get ownsValue => _owner.owns(ref);

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

  /// Kullanıcı yenilemesi (aşağı çekerek): yeniden okur ve bitmesini bekler. Önceki liste
  /// ekrandaysa hata FIRLATILIR (ortak yenileme kabuğu bildirir, liste yerinde kalır); liste
  /// yoksa hata görünümü zaten ekrandadır, ikinci bildirim olmaz.
  Future<void> refresh() async {
    final shown = state.hasValue;
    ref.invalidateSelf();
    try {
      await future;
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.meetings);
      if (shown) rethrow;
    }
  }

  /// Yeniden ziyaret (sekmeye ya da ön plana dönüş): son başarılı okuma [maxAge]'den eskiyse
  /// liste arka planda yeniden okunur; eski liste görünür kalır, hata bildirilmez ve sonraki
  /// otomatik ziyarette yeniden denenmez ([StaleClock.refreshIfStale]). Kart sayaçları ve
  /// konferans durumu satır özetinde olduğundan liste ile birlikte tazelenir (ek istek yok).
  Future<void> refreshIfStale({Duration maxAge = StaleClock.staleAfter}) =>
      _clock.refreshIfStale(state, () {
        ref.invalidateSelf();
        return future;
      }, maxAge: maxAge);

  /// Açık ayrıntının güncel özetini liste satırına yazar (ağ isteği yok); liste yüklenmemişse ya
  /// da toplantı listede yoksa bir şey yapmaz. Liste okuması sürerken (ya da son okuma hatalıyken)
  /// durum değişmez — yükleniyor/hata bilgisi korunur; özet saklanır ve okuma bitince o satırda
  /// yanıtın (daha eski) özetinin yerine geçer.
  void putSummary(String id, MeetingSummary summary) {
    final board = state.value;
    if (board == null || !board.visible.any((m) => m.id == id)) return;
    _local[id] = (++_generation, summary);
    if (state.isLoading || state.hasError) return;
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
    } on Object catch (e, st) {
      return toReportedApiError(e, st, source: ReportSource.meetings);
    }
    if (ref.mounted) ref.invalidateSelf();
    return null;
  }

  /// Silinmiş toplantıyı kalıcı siler (yalnız yönetici).
  Future<ApiError?> purge(String id) async {
    try {
      await ref.read(meetingsRepositoryProvider).permanentDeleteMeeting(id);
    } on Object catch (e, st) {
      return toReportedApiError(e, st, source: ReportSource.meetings);
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
