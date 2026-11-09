import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/stale_clock.dart';
import '../features/meetings/meetings.dart';
import '../features/messages/messages.dart';
import '../features/notifications/notifications.dart';
import '../features/tasks/tasks.dart';

/// V10 güncellik (F60): uygulama ön plana dönünce (`resumed`) okunmuş görev kataloğu, son
/// okumadan beri [maxAge] geçtiyse arka planda yeniden okunur; eski veri görünür kalır, açık
/// ayrıntı katalogla birlikte yeniden okunur, açık düzenleme taslağı tabanını korur. Hiç
/// okunmamış katalog için okuma başlatılmaz; yoklama yoktur (arka planda iş yapılmaz).
/// Toplantı listesi (toplantılar ve takvim ekranı) yaşıyorsa aynı kuralla tazelenir
/// ([refreshStaleMeetings]).
/// Aynı geçişte zil rozeti (okunmamış bildirim sayısı) ekrandaysa yeniden okunur
/// ([refreshNotificationBadge]; v1 ön plan yoklaması, zamanlayıcı yok); Mesajlar rozeti de
/// akış açık değilse tek okumayla tazelenir ([refreshMessagesBadge]).
class ForegroundRefresh extends ConsumerStatefulWidget {
  const ForegroundRefresh({
    super.key,
    required this.child,
    this.maxAge = StaleClock.staleAfter,
  });

  final Widget child;
  final Duration maxAge;

  @override
  ConsumerState<ForegroundRefresh> createState() => _ForegroundRefreshState();
}

class _ForegroundRefreshState extends ConsumerState<ForegroundRefresh> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: _resumed);
  }

  void _resumed() {
    final container = ProviderScope.containerOf(context, listen: false);
    unawaited(refreshStaleTasks(container, maxAge: widget.maxAge));
    unawaited(refreshStaleMeetings(container, maxAge: widget.maxAge));
    unawaited(refreshNotificationBadge(container));
    unawaited(refreshMessagesBadge(container));
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Ön plana dönüş tazelemesi: katalog hiç okunmadıysa bir şey yapmaz; okunduysa
/// [TaskCatalogController.refreshIfStale] (hata durumda kalır, veri görünür).
Future<void> refreshStaleTasks(
  ProviderContainer container, {
  Duration maxAge = StaleClock.staleAfter,
}) async {
  if (!container.exists(taskCatalogControllerProvider)) return;
  await container
      .read(taskCatalogControllerProvider.notifier)
      .refreshIfStale(maxAge: maxAge);
}

/// Ön plana dönüş: toplantı listesi yaşamıyorsa (toplantılar/takvim açılmadı) istek yok;
/// yaşıyorsa [refreshStaleTasks] kuralıyla bayatsa arka planda yeniden okunur.
Future<void> refreshStaleMeetings(
  ProviderContainer container, {
  Duration maxAge = StaleClock.staleAfter,
}) async {
  if (!container.exists(meetingsBoardControllerProvider)) return;
  await container
      .read(meetingsBoardControllerProvider.notifier)
      .refreshIfStale(maxAge: maxAge);
}

/// Ön plana dönüşte zil rozeti: rozet ekranda değilse (sağlayıcı yaşamıyorsa) istek yok;
/// yaşıyorsa okunmamış sayısı yeniden okunur (hata durumda kalır, önceki sayı görünür).
Future<void> refreshNotificationBadge(ProviderContainer container) async {
  if (!container.exists(notificationUnreadControllerProvider)) return;
  await container.read(notificationUnreadControllerProvider.notifier).refresh();
}
