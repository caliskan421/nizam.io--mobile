import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../domain/app_notification.dart';
import 'notifications_providers.dart';

part 'notifications_controller.g.dart';

/// Zil rozeti: okunmamış bildirim sayısı (`countUnreadNotifications`). Kabuğun üst çubuğu ve
/// tablet rayı izledikçe yaşar. Zamanlayıcıyla yoklama YOK (v1: push yok, arka planda iş yok):
/// uygulama ön plana dönünce (`ForegroundRefresh`) ve bildirim listesi kapanınca [refresh];
/// liste ve yazma uçları sayıyı [NotificationsController] üzerinden günceller.
@riverpod
class NotificationUnreadController extends _$NotificationUnreadController {
  @override
  Future<int> build() => ref.read(notificationRepositoryProvider).unreadCount();

  /// Yeniden okur; hata durumda kalır, önceki sayı `value` olarak korunur.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.notifications);
      // Hata durumda (AsyncError) kalır; rozet önceki sayıyı gösterir.
    }
  }

  /// Sunucunun bildirdiği toplam (liste yanıtı `unread_count`, tümü okundu → 0).
  void sync(int count) {
    if (ref.mounted) state = AsyncData(count);
  }

  /// Bir kayıt okundu işaretlendi (sayı sıfırın altına inmez).
  void markedOne() {
    if (!ref.mounted) return;
    final v = state.value;
    if (v != null) state = AsyncData(math.max(0, v - 1));
  }
}

/// Bildirim listesinin görünüm durumu: yüklenen satırlar, sonraki sayfa imleci ve sonraki
/// sayfa isteğinin durumu (ilk sayfa hatası `AsyncError`'dır).
@immutable
final class NotificationsView {
  const NotificationsView({
    required this.items,
    this.nextCursor,
    this.loadingMore = false,
    this.moreError,
  });

  final List<AppNotification> items;
  final String? nextCursor;
  final bool loadingMore;

  /// Son "daha fazla" isteğinin hatası (yeniden deneme yalnız dokunuşla).
  final ApiError? moreError;

  bool get hasMore => nextCursor != null;
  bool get hasUnread => items.any((n) => !n.isRead);
}

/// Bildirim listesi (`listNotifications`, en yeni önce, imleçli). Çan açıkken yaşar; her
/// açılışta ilk sayfa yeniden okunur. Her liste yanıtının `unread_count`'u ve başarılı yazma
/// (tek okundu, tümü okundu) zil rozetine ([NotificationUnreadController]) yansır: sayaç ve
/// satırlar aynı anda tutarlıdır. Otomatik yeniden deneme YOK (A3).
@riverpod
class NotificationsController extends _$NotificationsController {
  static const pageSize = 30;

  // Yenileme sonrası uçuştaki "daha fazla" sonucu atılır.
  int _generation = 0;

  // Aynı satır için aynı anda tek okundu isteği (çift dokunuş sayacı iki kez düşürmesin).
  final _marking = <String>{};

  @override
  Future<NotificationsView> build() async {
    final generation = ++_generation;
    final feed = await ref
        .read(notificationRepositoryProvider)
        .list(page: const PageRequest(limit: pageSize));
    if (ref.mounted && generation == _generation) {
      _unread()?.sync(feed.unreadCount);
    }
    return NotificationsView(
      items: feed.page.items,
      nextCursor: feed.page.nextCursor,
    );
  }

  /// Rozet denetleyicisi yalnız yaşıyorsa (zil ekrandaysa) güncellenir; okuma onu kurmasın.
  NotificationUnreadController? _unread() =>
      ref.exists(notificationUnreadControllerProvider)
      ? ref.read(notificationUnreadControllerProvider.notifier)
      : null;

  /// İlk sayfayı yeniden okur; hata durumda görünür.
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.notifications);
      // Hata durumda (AsyncError) gösterilir.
    }
  }

  /// Sonraki sayfa; son sayfadaysa, istek sürüyorsa ya da ilk sayfa yüklenirken bir şey yapmaz.
  Future<void> loadMore() async {
    final view = state.value;
    if (view == null || !view.hasMore || view.loadingMore || state.isLoading) {
      return;
    }
    final generation = _generation;
    state = AsyncData(
      NotificationsView(
        items: view.items,
        nextCursor: view.nextCursor,
        loadingMore: true,
      ),
    );
    try {
      final feed = await ref
          .read(notificationRepositoryProvider)
          .list(
            page: PageRequest(limit: pageSize, cursor: view.nextCursor),
          );
      if (!ref.mounted || generation != _generation) return;
      // Okundu yazmaları bu arada satırları değiştirmiş olabilir: güncel satırlar esas alınır;
      // sayfa sınırında kayan kayıt iki kez gösterilmez.
      final current = state.requireValue.items;
      final known = {for (final n in current) n.id};
      state = AsyncData(
        NotificationsView(
          items: [
            ...current,
            for (final n in feed.page.items)
              if (!known.contains(n.id)) n,
          ],
          nextCursor: feed.page.nextCursor,
        ),
      );
      _unread()?.sync(feed.unreadCount);
    } on Object catch (e, st) {
      // Rapor/çeviri bayat-durum korumasından ÖNCE; yalnız durum yazımı koruma altında.
      final api = toReportedApiError(e, st, source: ReportSource.notifications);
      if (!ref.mounted || generation != _generation) return;
      final current = state.requireValue;
      state = AsyncData(
        NotificationsView(
          items: current.items,
          nextCursor: current.nextCursor,
          moreError: api,
        ),
      );
    }
  }

  /// Tek bildirimi okundu işaretler (`markNotificationRead`). Satır yoksa ya da zaten
  /// okunmuşsa istek gönderilmez. Başarıda satır okundu olur ve rozet bir azalır; hata döner,
  /// durum değişmez.
  Future<ApiError?> markRead(String id) async {
    final row = state.value?.items.where((n) => n.id == id).firstOrNull;
    if (row == null || row.isRead || !_marking.add(id)) return null;
    final unread = _unread();
    try {
      await ref.read(notificationRepositoryProvider).markRead(id);
    } on Object catch (e, st) {
      return toReportedApiError(e, st, source: ReportSource.notifications);
    } finally {
      _marking.remove(id);
    }
    if (!ref.mounted) {
      unread?.markedOne();
      return null;
    }
    final view = state.value;
    final stillUnread =
        view?.items.any((n) => n.id == id && !n.isRead) ?? false;
    if (view != null && stillUnread) {
      unread?.markedOne();
      state = AsyncData(
        NotificationsView(
          items: [for (final n in view.items) n.id == id ? n.asRead() : n],
          nextCursor: view.nextCursor,
          loadingMore: view.loadingMore,
          moreError: view.moreError,
        ),
      );
    }
    return null;
  }

  /// Bütün bildirimleri okundu işaretler (`markAllNotificationsRead`). Başarıda bütün
  /// satırlar okundu olur, rozet 0'a iner; hata döner, durum değişmez.
  Future<ApiError?> markAllRead() async {
    final unread = _unread();
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
    } on Object catch (e, st) {
      return toReportedApiError(e, st, source: ReportSource.notifications);
    }
    unread?.sync(0);
    final view = ref.mounted ? state.value : null;
    if (view != null) {
      state = AsyncData(
        NotificationsView(
          items: [for (final n in view.items) n.isRead ? n : n.asRead()],
          nextCursor: view.nextCursor,
          loadingMore: view.loadingMore,
          moreError: view.moreError,
        ),
      );
    }
    return null;
  }
}
