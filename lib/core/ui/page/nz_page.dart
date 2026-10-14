import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/connectivity_monitor.dart';
import '../../providers.dart';
import '../extensions/context_ext.dart';
import '../layout/layout.dart';
import '../widgets/feedback/nz_banner.dart';
import '../widgets/feedback/nz_loader.dart';

/// Her ekranın kabuğu (U6: features presentation'da Scaffold yasağının tek karşılığı).
///
/// Scaffold + SafeArea + [NzTextScaleLimit] + yatay `pagePadding` + [NzContentWidth] azami
/// genişliği (ortalanır) + bağlantı çevrimdışıyken gövdenin üstünde [NzBanner.offline] +
/// [loading] iken dokunmayı kesen [NzLoader] örtüsü. Kendi Overlay'i yoktur: şerit ve örtü
/// sayfa ağacının parçasıdır, `MaterialApp.builder`'daki PrivacyMask'ın altında kalır.
///
/// [onRetry] yalnız kullanıcı dokunuşuyla çalışır (çevrimiçine dönüşte otomatik deneme yok).
class NzPage extends ConsumerWidget {
  const NzPage({
    super.key,
    required this.title,
    required this.body,
    this.width = NzContentWidth.list,
    this.actions = const [],
    this.floatingAction,
    this.loading = false,
    this.onRetry,
  });

  /// AppBar başlığı (ARB'den).
  final String title;
  final Widget body;
  final NzContentWidth width;

  /// AppBar eylemleri.
  final List<Widget> actions;
  final Widget? floatingAction;
  final bool loading;

  /// Çevrimdışı şeridindeki "yeniden dene".
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline =
        ref.watch(connectivityStateProvider) == ConnectivityState.offline;
    final layout = context.layout;
    return NzTextScaleLimit(
      child: Scaffold(
        appBar: AppBar(title: Text(title), actions: actions),
        floatingActionButton: floatingAction,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (offline) NzBanner.offline(onAction: onRetry),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: layout.pagePadding,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: layout.contentMaxWidth(width),
                          ),
                          child: body,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (loading) const Positioned.fill(child: _LoadingScrim()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dokunmayı keser; gövdeyi yarı saydam örter, ortada [NzLoader.page].
class _LoadingScrim extends StatelessWidget {
  const _LoadingScrim();

  @override
  Widget build(BuildContext context) => AbsorbPointer(
    child: ColoredBox(
      color: context.colors.background.withValues(alpha: 0.6),
      child: const NzLoader.page(),
    ),
  );
}
