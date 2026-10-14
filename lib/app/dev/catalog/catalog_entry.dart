import 'package:flutter/widgets.dart';

/// Katalogtaki tek bileşen/varyant örneği (yalnız dev flavor).
class CatalogEntry {
  const CatalogEntry({
    required this.group,
    required this.name,
    required this.builder,
  });

  /// 'feedback', 'buttons', ...
  final String group;

  /// 'NzBanner.offline'
  final String name;
  final WidgetBuilder builder;
}
