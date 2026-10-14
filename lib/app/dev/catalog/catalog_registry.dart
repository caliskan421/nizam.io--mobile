import 'catalog_entry.dart';
import 'feedback_catalog.dart';

/// Katalogtaki bütün girişler; her kit grubu kendi satırını ekler.
List<CatalogEntry> get allCatalogEntries => [...feedbackCatalogEntries];
