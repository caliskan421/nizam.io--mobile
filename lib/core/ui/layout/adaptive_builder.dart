import 'package:flutter/widgets.dart';

import 'adaptive_value.dart';
import 'nz_layout.dart';

/// Pencere sınıfına göre farklı ağaç kurar. Üst kısıta ([LayoutBuilder]) bakar; ekran
/// genişliğine değil, bu widget'a verilen alana göre karar verir (bölünmüş ekran / çoklu
/// pencere doğru çalışır). Eksik sınıf bir küçüğüne düşer.
class AdaptiveBuilder extends StatelessWidget {
  const AdaptiveBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? expanded;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final layout = NzLayout.fromWidth(constraints.maxWidth);
      return AdaptiveValue<WidgetBuilder>(
        compact: compact,
        medium: medium,
        expanded: expanded,
      ).resolve(layout.resolvedClass)(context);
    },
  );
}
