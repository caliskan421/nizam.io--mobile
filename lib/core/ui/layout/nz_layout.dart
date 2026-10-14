import 'package:flutter/widgets.dart';

import '../../theme/generated/tokens.gen.dart';
import 'adaptive_value.dart';
import 'window_class.dart';

/// İçerik türüne göre en geniş içerik genişliği (dp).
// TOKEN-BEKLİYOR: genişlik token'ı yok (tokens.gen.dart yalnız boşluk/yarıçap taşır);
// token eklendiğinde buradan okunur.
enum NzContentWidth {
  form(480),
  reading(720),
  list(960);

  const NzContentWidth(this.maxWidth);

  final double maxWidth;
}

/// Genişliğe bağlı yerleşim değerleri (değer nesnesi).
@immutable
class NzLayout {
  const NzLayout(this.width) : windowClass = null;

  /// [windowClass] verilmişse eşikler yerine bu sınıf kullanılır (testler/önizleme).
  const NzLayout.withClass(this.width, WindowClass this.windowClass);

  /// Yalnız `MediaQuery.sizeOf` dinler: klavye/inset değişimi yeniden çizim tetiklemez.
  factory NzLayout.of(BuildContext context) =>
      NzLayout.fromWidth(MediaQuery.sizeOf(context).width);

  factory NzLayout.fromWidth(double width) => NzLayout(width);

  final double width;
  final WindowClass? windowClass;

  WindowClass get resolvedClass => windowClass ?? WindowClass.fromWidth(width);

  bool get isCompact => resolvedClass.isCompact;
  bool get isMedium => resolvedClass.isMedium;
  bool get isExpanded => resolvedClass.isExpanded;

  /// Sayfa yan boşluğu: compact 16 · medium 24 · expanded 32.
  double get pagePadding => pick(
    compact: NizamioSpacing.space4,
    medium: NizamioSpacing.space6,
    expanded: NizamioSpacing.space8,
  );

  /// Izgara sütunu: compact 4 · medium 8 · expanded 12.
  int get columns => pick(compact: 4, medium: 8, expanded: 12);

  double contentMaxWidth(NzContentWidth kind) => kind.maxWidth;

  /// Eksik sınıf bir küçüğüne düşer: `pick(compact: 1, expanded: 3)` medium'da 1.
  T pick<T>({required T compact, T? medium, T? expanded}) => AdaptiveValue<T>(
    compact: compact,
    medium: medium,
    expanded: expanded,
  ).resolve(resolvedClass);

  @override
  bool operator ==(Object other) =>
      other is NzLayout &&
      other.width == width &&
      other.resolvedClass == resolvedClass;

  @override
  int get hashCode => Object.hash(width, resolvedClass);
}
