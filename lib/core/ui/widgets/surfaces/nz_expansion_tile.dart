import 'package:flutter/material.dart';

import '../nz_glyph.dart';

/// Flutter açılır satırının okunu uygulamanın özel çizimiyle gösterir.
class NzExpansionTile extends StatefulWidget {
  const NzExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;

  @override
  State<NzExpansionTile> createState() => _NzExpansionTileState();
}

class _NzExpansionTileState extends State<NzExpansionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: widget.title,
    subtitle: widget.subtitle,
    onExpansionChanged: (value) => setState(() => _expanded = value),
    trailing: RotatedBox(
      quarterTurns: _expanded ? 2 : 0,
      child: const NzGlyphIcon(NzDesignGlyphs.chevronDown),
    ),
    children: widget.children,
  );
}
