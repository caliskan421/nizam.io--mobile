import 'buttons_catalog.dart';
import 'catalog_entry.dart';
import 'feedback_catalog.dart';
import 'foundation_catalog.dart';
import 'inputs_catalog.dart';
import 'lists_catalog.dart';
import 'overlays_catalog.dart';
import 'surfaces_catalog.dart';

/// Katalogtaki bütün girişler; her kit grubu kendi satırını ekler.
List<CatalogEntry> get allCatalogEntries => [
  ...foundationCatalogEntries,
  ...feedbackCatalogEntries,
  ...buttonsCatalogEntries,
  ...inputsCatalogEntries,
  ...surfacesCatalogEntries,
  ...overlaysCatalogEntries,
  ...listsCatalogEntries,
];
