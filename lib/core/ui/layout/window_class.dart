/// Pencere sınıfı (Material 3 eşikleri). Yönden değil, **genişlikten** türetilir:
/// telefon dikey = compact, telefon yatay / küçük tablet = medium, tablet = expanded.
enum WindowClass {
  compact,
  medium,
  expanded;

  /// medium alt sınırı (dp); altı compact.
  static const double mediumMinWidth = 600;

  /// expanded alt sınırı (dp); 600–839 medium.
  static const double expandedMinWidth = 840;

  static WindowClass fromWidth(double width) {
    if (width >= expandedMinWidth) return WindowClass.expanded;
    if (width >= mediumMinWidth) return WindowClass.medium;
    return WindowClass.compact;
  }

  bool get isCompact => this == WindowClass.compact;
  bool get isMedium => this == WindowClass.medium;
  bool get isExpanded => this == WindowClass.expanded;
}
