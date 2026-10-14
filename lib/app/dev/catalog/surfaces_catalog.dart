import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import 'catalog_entry.dart';

// Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'surfaces';

CatalogEntry _entry(String name, WidgetBuilder builder) =>
    CatalogEntry(group: _group, name: name, builder: builder);

List<CatalogEntry> get surfacesCatalogEntries => [
  for (final size in NzSize.values) ...[
    _entry(
      'NzCard.filled (${size.name})',
      (_) => NzCard.filled(size: size, child: const Text('Sample content')),
    ),
    _entry(
      'NzCard.outlined (${size.name})',
      (_) => NzCard.outlined(size: size, child: const Text('Sample content')),
    ),
  ],
  _entry(
    'NzCard.outlined (onTap)',
    (_) => NzCard.outlined(onTap: () {}, child: const Text('Sample content')),
  ),
  for (final size in NzSize.values)
    _entry(
      'NzSection (${size.name})',
      (_) => NzSection(
        title: 'Sample title',
        size: size,
        trailing: const Icon(Icons.chevron_right),
        child: const Text('Sample content'),
      ),
    ),
  for (final size in NzSize.values)
    _entry(
      'NzDivider.horizontal (${size.name})',
      (_) => NzDivider.horizontal(size: size),
    ),
  _entry(
    'NzDivider.vertical',
    (_) => const SizedBox(
      height: NizamioSpacing.space8,
      child: Row(children: [Text('A'), NzDivider.vertical(), Text('B')]),
    ),
  ),
  for (final size in NzSize.values)
    _entry(
      'NzBadge (${size.name})',
      (_) => Wrap(
        spacing: NizamioSpacing.space2,
        runSpacing: NizamioSpacing.space2,
        children: [
          NzBadge.neutral(label: 'Neutral', size: size),
          NzBadge.info(label: 'Info', size: size, leading: Icons.info_outline),
          NzBadge.success(label: 'Success', size: size),
          NzBadge.warning(label: 'Warning', size: size),
          NzBadge.danger(label: 'Danger', size: size),
        ],
      ),
    ),
  for (final size in NzSize.values)
    _entry(
      'NzAvatar (${size.name})',
      (_) => Wrap(
        spacing: NizamioSpacing.space2,
        children: [
          NzAvatar.initials(name: 'Sample Name', size: size),
          NzAvatar.icon(size: size),
        ],
      ),
    ),
];
