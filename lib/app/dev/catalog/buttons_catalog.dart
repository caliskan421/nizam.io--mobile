import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import 'catalog_entry.dart';

// Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'buttons';

void _noop() {}

Widget _sizes(Widget Function(NzSize size) build) => Wrap(
  spacing: NizamioSpacing.space2,
  runSpacing: NizamioSpacing.space2,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [for (final size in NzSize.values) build(size)],
);

CatalogEntry _entry(String name, WidgetBuilder builder) =>
    CatalogEntry(group: _group, name: name, builder: builder);

List<CatalogEntry> _variant(
  String name,
  Widget Function({
    required NzSize size,
    required bool loading,
    required IconData? icon,
    required VoidCallback? onPressed,
    required bool expand,
  })
  make,
) => [
  _entry(
    '$name (sm · md · lg)',
    (_) => _sizes(
      (size) => make(
        size: size,
        loading: false,
        icon: null,
        onPressed: _noop,
        expand: false,
      ),
    ),
  ),
  _entry(
    '$name · icon',
    (_) => _sizes(
      (size) => make(
        size: size,
        loading: false,
        icon: Icons.add,
        onPressed: _noop,
        expand: false,
      ),
    ),
  ),
  _entry(
    '$name · loading',
    (_) => _sizes(
      (size) => make(
        size: size,
        loading: true,
        icon: null,
        onPressed: _noop,
        expand: false,
      ),
    ),
  ),
  _entry(
    '$name · disabled',
    (_) => _sizes(
      (size) => make(
        size: size,
        loading: false,
        icon: null,
        onPressed: null,
        expand: false,
      ),
    ),
  ),
  _entry(
    '$name · expand',
    (_) => make(
      size: NzSize.md,
      loading: false,
      icon: null,
      onPressed: _noop,
      expand: true,
    ),
  ),
];

List<CatalogEntry> get buttonsCatalogEntries => [
  ..._variant(
    'NzButton.primary',
    ({
      required size,
      required loading,
      required icon,
      required onPressed,
      required expand,
    }) => NzButton.primary(
      label: 'Sample',
      size: size,
      loading: loading,
      icon: icon,
      onPressed: onPressed,
      expand: expand,
    ),
  ),
  ..._variant(
    'NzButton.secondary',
    ({
      required size,
      required loading,
      required icon,
      required onPressed,
      required expand,
    }) => NzButton.secondary(
      label: 'Sample',
      size: size,
      loading: loading,
      icon: icon,
      onPressed: onPressed,
      expand: expand,
    ),
  ),
  ..._variant(
    'NzButton.ghost',
    ({
      required size,
      required loading,
      required icon,
      required onPressed,
      required expand,
    }) => NzButton.ghost(
      label: 'Sample',
      size: size,
      loading: loading,
      icon: icon,
      onPressed: onPressed,
      expand: expand,
    ),
  ),
  ..._variant(
    'NzButton.danger',
    ({
      required size,
      required loading,
      required icon,
      required onPressed,
      required expand,
    }) => NzButton.danger(
      label: 'Sample',
      size: size,
      loading: loading,
      icon: icon,
      onPressed: onPressed,
      expand: expand,
    ),
  ),
  _entry(
    'NzIconButton (sm · md · lg)',
    (_) => _sizes(
      (size) => NzIconButton(
        icon: Icons.add,
        semanticLabel: 'Sample',
        onPressed: _noop,
        size: size,
      ),
    ),
  ),
  _entry(
    'NzIconButton · disabled',
    (_) => _sizes(
      (size) => NzIconButton(
        icon: Icons.add,
        semanticLabel: 'Sample',
        onPressed: null,
        size: size,
      ),
    ),
  ),
];
