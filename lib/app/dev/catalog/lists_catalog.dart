import 'package:flutter/material.dart';

import '../../../core/domain/page_slice.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_size.dart';
import 'catalog_entry.dart';

// Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'lists';

Widget _avatar() => const Icon(Icons.person_outline);

List<CatalogEntry> get listsCatalogEntries => [
  for (final size in NzSize.values) ...[
    CatalogEntry(
      group: _group,
      name: 'NzListTile (${size.name})',
      builder: (_) => NzListTile(
        title: 'Sample title',
        subtitle: 'Sample subtitle',
        leading: _avatar(),
        size: size,
        onTap: () {},
      ),
    ),
    CatalogEntry(
      group: _group,
      name: 'NzListTile.navigation (${size.name})',
      builder: (_) => NzListTile.navigation(
        title: 'Sample title',
        subtitle: 'Sample subtitle',
        leading: _avatar(),
        size: size,
        onTap: () {},
      ),
    ),
    CatalogEntry(
      group: _group,
      name: 'NzListTile.danger (${size.name})',
      builder: (_) =>
          NzListTile.danger(title: 'Sample title', size: size, onTap: () {}),
    ),
  ],
  CatalogEntry(
    group: _group,
    name: 'NzListTile (selected · read-only)',
    builder: (_) => const Column(
      children: [
        NzListTile(title: 'Selected', selected: true),
        NzListTile(title: 'Read-only', subtitle: 'No tap'),
      ],
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzPagedList',
    builder: (_) => SizedBox(
      height: NizamioSpacing.space16 * 5,
      child: NzPagedList<int>(
        pageSize: 10,
        load: (request) async {
          final start = int.tryParse(request.cursor ?? '') ?? 0;
          final limit = request.limit ?? 10;
          final end = start + limit;
          return PageSlice<int>(
            items: [for (var i = start; i < end; i++) i],
            nextCursor: end < 30 ? '$end' : null,
          );
        },
        itemBuilder: (_, item) => NzListTile(title: 'Item $item'),
      ),
    ),
  ),
];
