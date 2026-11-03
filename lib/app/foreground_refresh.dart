import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/tasks/tasks.dart';

/// V10 güncellik (F60): uygulama ön plana dönünce (`resumed`) okunmuş görev kataloğu, son
/// okumadan beri [maxAge] geçtiyse arka planda yeniden okunur; eski veri görünür kalır, açık
/// ayrıntı katalogla birlikte yeniden okunur, açık düzenleme taslağı tabanını korur. Hiç
/// okunmamış katalog için okuma başlatılmaz; yoklama yoktur (arka planda iş yapılmaz).
class ForegroundRefresh extends ConsumerStatefulWidget {
  const ForegroundRefresh({
    super.key,
    required this.child,
    this.maxAge = TaskCatalogController.staleAfter,
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

  void _resumed() => unawaited(
    refreshStaleTasks(
      ProviderScope.containerOf(context, listen: false),
      maxAge: widget.maxAge,
    ),
  );

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
  Duration maxAge = TaskCatalogController.staleAfter,
}) async {
  if (!container.exists(taskCatalogControllerProvider)) return;
  await container
      .read(taskCatalogControllerProvider.notifier)
      .refreshIfStale(maxAge: maxAge);
}
