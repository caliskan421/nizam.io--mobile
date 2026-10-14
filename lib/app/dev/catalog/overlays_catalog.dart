import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import 'catalog_entry.dart';

// Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'overlays';

Widget _trigger(String label, VoidCallback onPressed) =>
    OutlinedButton(onPressed: onPressed, child: Text(label));

List<CatalogEntry> get overlaysCatalogEntries => [
  CatalogEntry(
    group: _group,
    name: 'NzDialog.confirm (normal)',
    builder: (context) => _trigger(
      'Open',
      () => NzDialog.confirm(
        context,
        title: 'Sample title',
        message: 'Sample message',
        confirmLabel: 'Confirm',
      ),
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzDialog.confirm (destructive)',
    builder: (context) => _trigger(
      'Open',
      () => NzDialog.confirm(
        context,
        title: 'Sample title',
        message: 'Sample message',
        confirmLabel: 'Delete',
        tone: NzDialogTone.destructive,
      ),
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzBottomSheet',
    builder: (context) => _trigger(
      'Open',
      () => NzBottomSheet.show<void>(
        context,
        title: 'Sample title',
        builder: (_) => const Padding(
          padding: EdgeInsets.symmetric(vertical: NizamioSpacing.space4),
          child: Text('Sample content'),
        ),
      ),
    ),
  ),
  CatalogEntry(
    group: _group,
    name: 'NzBottomSheet (not dismissible)',
    builder: (context) => _trigger(
      'Open',
      () => NzBottomSheet.show<void>(
        context,
        title: 'Sample title',
        dismissible: false,
        builder: (sheetContext) => Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: const Text('Done'),
          ),
        ),
      ),
    ),
  ),
];
