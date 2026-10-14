import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/page_slice.dart';
import '../../../errors/api_error.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../feedback/nz_empty_state.dart';
import '../feedback/nz_error_state.dart';
import '../feedback/nz_loader.dart';
import '../nz_size.dart';

/// İmleçli sayfalı liste + aşağı çek yenile.
///
/// Veri [load] geri çağrısıyla gelir (servis/repository/Riverpod bilinmez); ilk sayfa
/// `PageRequest(limit: pageSize)`, sonrakiler `PageRequest(limit: pageSize, cursor: …)` ile istenir.
///
/// - Sonraki sayfa isteği aynı anda en çok bir tanedir.
/// - Otomatik yeniden deneme YOKTUR: ilk sayfa hatası [NzErrorState], sonraki sayfa hatası alt
///   satırda [NzErrorState.inline]; yeniden deneme yalnız dokunuşla.
/// - Aşağı çek yenile ilk sayfayı yeniden yükler (imleç sıfırlanır). Yenileme hatası mevcut
///   satırların yerine ilk sayfa hata görünümünü getirir.
/// - [PageSlice.truncated] ise listenin sonunda bilgi satırı çıkar.
class NzPagedList<T> extends StatefulWidget {
  const NzPagedList({
    super.key,
    required this.load,
    required this.itemBuilder,
    this.pageSize = 20,
    this.empty,
  }) : assert(pageSize >= 1, 'pageSize en az 1 olmalı');

  /// Bir sayfayı yükler; hata fırlatırsa `toApiError` ile [ApiError]'a çevrilir.
  final Future<PageSlice<T>> Function(PageRequest request) load;
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// İstek başına en çok satır.
  final int pageSize;

  /// Boş liste görünümü; null → varsayılan [NzEmptyState] (`ui.lists.empty_title`).
  final Widget? empty;

  @override
  State<NzPagedList<T>> createState() => _NzPagedListState<T>();
}

class _NzPagedListState<T> extends State<NzPagedList<T>> {
  List<T> _items = const [];
  String? _cursor;
  bool _truncated = false;
  bool _loadingFirst = true;
  bool _loadingMore = false;
  ApiError? _firstError;
  ApiError? _moreError;

  // Yenileme/yeniden yükleme sonrası eski isteklerin sonucu yok sayılır.
  int _generation = 0;

  bool get _hasMore => _cursor != null;

  @override
  void initState() {
    super.initState();
    unawaited(_loadFirst(showLoader: true));
  }

  /// [showLoader] false (aşağı çek yenile): mevcut içerik yenileme göstergesi altında kalır.
  Future<void> _loadFirst({required bool showLoader}) async {
    final generation = ++_generation;
    setState(() {
      if (showLoader) _loadingFirst = true;
      _loadingMore = false;
      _firstError = null;
      _moreError = null;
    });
    try {
      final slice = await widget.load(PageRequest(limit: widget.pageSize));
      if (!mounted || generation != _generation) return;
      setState(() {
        _items = slice.items;
        _cursor = slice.nextCursor;
        _truncated = slice.truncated;
        _loadingFirst = false;
      });
    } on Object catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _items = const [];
        _cursor = null;
        _truncated = false;
        _firstError = toApiError(error);
        _loadingFirst = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore ||
        _loadingFirst ||
        _cursor == null ||
        _moreError != null) {
      return;
    }
    final generation = _generation;
    setState(() => _loadingMore = true);
    try {
      final slice = await widget.load(
        PageRequest(limit: widget.pageSize, cursor: _cursor),
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        _items = [..._items, ...slice.items];
        _cursor = slice.nextCursor;
        _truncated = slice.truncated;
        _loadingMore = false;
      });
    } on Object catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _moreError = toApiError(error);
        _loadingMore = false;
      });
    }
  }

  void _retryMore() {
    setState(() => _moreError = null);
    unawaited(_loadMore());
  }

  // Son satır çizildiğinde (liste kısa ya da sona gelindi) sonraki sayfa istenir; yineleme
  // koruması [_loadingMore] ve [_moreError] ile.
  void _maybeLoadMore() {
    if (!_hasMore || _loadingMore || _moreError != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_loadMore());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingFirst) return const NzLoader.page();

    return RefreshIndicator(
      onRefresh: () => _loadFirst(showLoader: false),
      child: _firstError != null
          ? _fillViewport(
              NzErrorState(
                error: _firstError!,
                onRetry: () => unawaited(_loadFirst(showLoader: true)),
              ),
            )
          : _items.isEmpty
          ? _fillViewport(
              widget.empty ??
                  NzEmptyState(title: context.l10n.uiListsEmptyTitle),
            )
          : _buildList(context),
    );
  }

  // Boş/hata görünümü de aşağı çekilebilsin diye kaydırılabilir bir alanda durur.
  Widget _fillViewport(Widget child) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: child,
      ),
    ),
  );

  Widget _buildList(BuildContext context) {
    final hasFooter = _hasMore || _truncated;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _items.length + (hasFooter ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _items.length) {
          if (index == _items.length - 1) _maybeLoadMore();
          return widget.itemBuilder(context, _items[index]);
        }
        return _buildFooter(context);
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final Widget child;
    if (_moreError != null) {
      child = NzErrorState.inline(error: _moreError!, onRetry: _retryMore);
    } else if (_hasMore) {
      child = const Center(child: NzLoader(size: NzSize.sm));
    } else {
      child = Text(
        context.l10n.uiListsTruncated,
        textAlign: TextAlign.center,
        style: context.text.bodySm.copyWith(color: context.colors.textMuted),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(NizamioSpacing.space4),
      child: child,
    );
  }
}
