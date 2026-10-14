import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/dev/catalog/catalog_registry.dart';
import 'package:nizamio/app/dev/catalog/feedback_catalog.dart';

void main() {
  test('feedback girişleri kayıt defterindedir ve adları tekildir', () {
    final all = allCatalogEntries;
    expect(all.length, greaterThanOrEqualTo(feedbackCatalogEntries.length));
    expect(
      all.where((e) => e.group == 'feedback').length,
      feedbackCatalogEntries.length,
    );
    final names = [for (final e in all) '${e.group}/${e.name}'];
    expect(names.toSet().length, names.length);
  });

  test('feedback kitinin her bileşeni kataloğta', () {
    final names = feedbackCatalogEntries.map((e) => e.name).join('\n');
    for (final n in [
      'NzLoader',
      'NzLoader.page',
      'NzSkeleton.text',
      'NzSkeleton.block',
      'NzSkeleton.list',
      'NzEmptyState',
      'NzErrorState',
      'NzErrorState.inline',
      'NzBanner.info',
      'NzBanner.warning',
      'NzBanner.danger',
      'NzBanner.offline',
      'NzToast',
    ]) {
      expect(names, contains(n));
    }
  });
}
