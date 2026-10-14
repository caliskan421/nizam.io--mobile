import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/generated/tokens.gen.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/theme/app_theme.dart';
import 'catalog/catalog_entry.dart';
import 'catalog/catalog_registry.dart';

/// Pencere sınıfı önizleme genişlikleri (compact · medium · expanded).
const _previewWidths = <double>[360, 700, 1024];

/// Bileşen kataloğu (yalnız dev flavor, `/dev/catalog`): bütün giriş × açık/koyu × genişlik ×
/// metin ölçeği. Geliştirici aracıdır; etiketler ARB'ye girmez.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, this.entries});

  /// null → [allCatalogEntries] (testler kendi girişini verir).
  final List<CatalogEntry>? entries;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ThemeData _light = AppTheme.light();
  final ThemeData _dark = AppTheme.dark();
  bool _isDark = false;
  double _width = _previewWidths.first;
  double _textScale = 1;

  Map<String, List<CatalogEntry>> get _groups {
    final groups = <String, List<CatalogEntry>>{};
    for (final e in widget.entries ?? allCatalogEntries) {
      (groups[e.group] ??= []).add(e);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final preview = _isDark ? _dark : _light;
    final viewData = MediaQueryData.fromView(View.of(context));
    final previewData = viewData.copyWith(
      size: Size(_width, viewData.size.height),
      textScaler: TextScaler.linear(_textScale),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: Column(
        children: [
          _Controls(
            isDark: _isDark,
            width: _width,
            textScale: _textScale,
            onDark: (v) => setState(() => _isDark = v),
            onWidth: (v) => setState(() => _width = v),
            onTextScale: (v) => setState(() => _textScale = v),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _width,
                child: MediaQuery(
                  data: previewData,
                  child: Theme(
                    data: preview,
                    child: _Groups(groups: _groups),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.isDark,
    required this.width,
    required this.textScale,
    required this.onDark,
    required this.onWidth,
    required this.onTextScale,
  });

  final bool isDark;
  final double width;
  final double textScale;
  final ValueChanged<bool> onDark;
  final ValueChanged<double> onWidth;
  final ValueChanged<double> onTextScale;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(NizamioSpacing.space3),
    child: Wrap(
      spacing: NizamioSpacing.space2,
      runSpacing: NizamioSpacing.space2,
      children: [
        for (final dark in const [false, true])
          ChoiceChip(
            label: Text(dark ? 'dark' : 'light'),
            selected: isDark == dark,
            onSelected: (_) => onDark(dark),
          ),
        for (final w in _previewWidths)
          ChoiceChip(
            label: Text('${w.toInt()}'),
            selected: width == w,
            onSelected: (_) => onWidth(w),
          ),
        for (final s in const [1.0, 2.0])
          ChoiceChip(
            label: Text('${s}x'),
            selected: textScale == s,
            onSelected: (_) => onTextScale(s),
          ),
      ],
    ),
  );
}

class _Groups extends StatelessWidget {
  const _Groups({required this.groups});

  final Map<String, List<CatalogEntry>> groups;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.background,
      child: ListView(
        padding: EdgeInsets.all(context.layout.pagePadding),
        children: [
          for (final MapEntry(:key, :value) in groups.entries) ...[
            Text(key, style: context.text.titleMd),
            const Gap(NizamioSpacing.space3),
            for (final entry in value) ...[
              Text(
                entry.name,
                style: context.text.labelMd.copyWith(color: colors.textMuted),
              ),
              const Gap(NizamioSpacing.space2),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(NizamioRadius.radiusLg),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(NizamioSpacing.space3),
                  child: Builder(builder: entry.builder),
                ),
              ),
              const Gap(NizamioSpacing.space6),
            ],
          ],
        ],
      ),
    );
  }
}
