part of 'timeline_chart.dart';

/// Çubuk ve sütunların okuyucu düğümleri (çizimle aynı dikdörtgenler), yalnız görünür alan
/// ve yarım ekran payı için: tek [CustomPaint]'in `semanticsBuilder`'ı (çubuk başına widget
/// yok). Pencere yarım görünür alan adımlarıyla kayar; kaydırmada yalnız adım değişince
/// yeniden kurulur.
class _BarSemantics extends StatefulWidget {
  const _BarSemantics({
    required this.layout,
    required this.vertical,
    required this.horizontal,
    required this.viewport,
    required this.onSelect,
    required this.onOverview,
  });

  final TimelineLayout layout;
  final ScrollController vertical;
  final ScrollController horizontal;
  final Size viewport;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onOverview;

  @override
  State<_BarSemantics> createState() => _BarSemanticsState();
}

class _BarSemanticsState extends State<_BarSemantics> {
  Rect _window = Rect.zero;

  @override
  void initState() {
    super.initState();
    widget.vertical.addListener(_sync);
    widget.horizontal.addListener(_sync);
  }

  @override
  void didUpdateWidget(_BarSemantics old) {
    super.didUpdateWidget(old);
    if (old.vertical != widget.vertical) {
      old.vertical.removeListener(_sync);
      widget.vertical.addListener(_sync);
    }
    if (old.horizontal != widget.horizontal) {
      old.horizontal.removeListener(_sync);
      widget.horizontal.addListener(_sync);
    }
    // Yeni yerleşim kaydırma konumunu bildirimsiz düzeltebilir (içerik/genişlik daralması);
    // pencere kare sonunda yeniden hesaplanır.
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    widget.vertical.removeListener(_sync);
    widget.horizontal.removeListener(_sync);
    super.dispose();
  }

  /// Görünür alanı yarım ekran adımına yuvarlar ve yarım adım pay ekler: görünür alan her
  /// zaman pencerenin içindedir.
  static (double, double) _band(double offset, double extent) {
    if (extent <= 0) return (0, 0);
    final step = extent / 2;
    final top = (offset / step).floorToDouble() * step;
    return (top - step / 2, top + step + extent + step / 2);
  }

  Rect _compute() {
    final v = widget.vertical;
    final h = widget.horizontal;
    final (y0, y1) = _band(
      v.hasClients ? v.offset : v.initialScrollOffset,
      widget.viewport.height,
    );
    final (x0, x1) = _band(
      h.hasClients ? h.offset : h.initialScrollOffset,
      widget.viewport.width,
    );
    return Rect.fromLTRB(x0, y0, x1, y1);
  }

  void _sync() {
    if (!mounted) return;
    final w = _compute();
    if (w != _window) setState(() => _window = w);
  }

  @override
  Widget build(BuildContext context) {
    _window = _compute();
    return CustomPaint(
      painter: _BarSemanticsPainter(
        layout: widget.layout,
        window: _window,
        l10n: context.l10n,
        textDirection: Directionality.of(context),
        onSelect: widget.onSelect,
        onOverview: widget.onOverview,
      ),
    );
  }
}

class _BarSemanticsPainter extends CustomPainter {
  _BarSemanticsPainter({
    required this.layout,
    required this.window,
    required this.l10n,
    required this.textDirection,
    required this.onSelect,
    required this.onOverview,
  });

  final TimelineLayout layout;

  /// İçerik koordinatında düğüm kurulan alan.
  final Rect window;
  final AppLocalizations l10n;
  final TextDirection textDirection;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onOverview;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(_BarSemanticsPainter old) => false;

  @override
  SemanticsBuilderCallback get semanticsBuilder => (size) {
    final year = layout.view.year;
    final sel = layout.view.state.selected;
    return [
      for (final o in layout.overview)
        if (o.column.overlaps(window))
          CustomPainterSemantics(
            key: ValueKey('overview-${o.group.code}'),
            rect: o.column,
            properties: SemanticsProperties(
              button: true,
              label: l10n.overviewLabel(o.group),
              textDirection: textDirection,
              onTap: () => onOverview(o.group.code),
            ),
          ),
      for (final b in layout.bars)
        if (b.rect.overlaps(window))
          CustomPainterSemantics(
            key: ValueKey('bar-${b.task.code}'),
            rect: b.rect,
            properties: SemanticsProperties(
              button: true,
              selected: sel == b.task.code,
              label: l10n.barLabel(b.task, year),
              textDirection: textDirection,
              onTap: () => onSelect(b.task.code),
            ),
          ),
    ];
  };

  @override
  bool shouldRebuildSemantics(_BarSemanticsPainter old) =>
      old.layout != layout ||
      old.window != window ||
      old.l10n != l10n ||
      old.textDirection != textDirection ||
      old.onSelect != onSelect ||
      old.onOverview != onOverview;
}
