import 'package:flutter/material.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/nz_size.dart';
import 'catalog_entry.dart';

// Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'feedback';

final _error = ApiError(ClientErrorCode.networkError);
final _rateLimited = ApiError(
  'platform.rate_limited',
  retryAfter: const Duration(seconds: 30),
);

List<CatalogEntry> get feedbackCatalogEntries => [
  CatalogEntry(
    group: _group,
    name: 'NzLoader (sm · md · lg)',
    builder: (_) => const Wrap(
      spacing: NizamioSpacing.space4,
      children: [
        NzLoader(size: NzSize.sm),
        NzLoader(),
        NzLoader(size: NzSize.lg),
      ],
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzLoader.page',
    builder: (_) => const SizedBox(
      height: NizamioSpacing.space16 * 2,
      child: NzLoader.page(),
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzSkeleton.text',
    builder: (_) => const NzSkeleton.text(lines: 3),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzSkeleton.block',
    builder: (_) => const NzSkeleton.block(
      height: NizamioSpacing.space16 + NizamioSpacing.space8,
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzSkeleton.list',
    builder: (_) => const NzSkeleton.list(),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzEmptyState',
    builder: (_) => NzEmptyState(
      title: 'Sample title',
      message: 'Sample message',
      actionLabel: 'Action',
      onAction: () {},
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzErrorState',
    builder: (_) => NzErrorState(error: _error, onRetry: () {}),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzErrorState (retryAfter)',
    builder: (_) => NzErrorState(error: _rateLimited, onRetry: () {}),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzErrorState.inline',
    builder: (_) => NzErrorState.inline(error: _error, onRetry: () {}),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzBanner.info',
    builder: (_) => const NzBanner.info(message: 'Sample message'),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzBanner.warning',
    builder: (_) => NzBanner.warning(
      message: 'Sample message',
      actionLabel: 'Action',
      onAction: () {},
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzBanner.danger',
    builder: (_) => const NzBanner.danger(message: 'Sample message'),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzBanner.offline',
    builder: (_) => NzBanner.offline(onAction: () {}),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzToast (info · success · danger)',
    builder: (context) => Wrap(
      spacing: NizamioSpacing.space2,
      children: [
        for (final tone in NzToastTone.values)
          OutlinedButton(
            onPressed: () =>
                NzToast.show(context, 'Sample message', tone: tone),
            child: Text(tone.name),
          ),
      ],
    ),
  ),
];
