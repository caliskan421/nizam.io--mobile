import 'package:flutter/painting.dart';

import '../../theme/generated/tokens.gen.dart';

/// Prototipin satır içi SABİT renkleri: temadan bağımsızdır (açık temada da aynı), bu yüzden
/// tema rolü değil koyu token değerinin kendisidir. Ham renk yazılmaz; değer token
/// kaynağındadır (`NizamioColors.dark`).
abstract final class NzFixedColors {
  static const _dark = NizamioColors.dark;

  /// Tablet rayı etkin kapsül: `rgba(255,255,255,.13)` (iki temada).
  static Color get railHighlight => _dark.navHighlight;

  /// Ray menü ve asistan cam dairesi: `rgba(18,18,18,.74)`, kenar `rgba(255,255,255,.08)`,
  /// mürekkep `#f5f5f5`; asistan ikonu `#c8f53c`.
  static Color get glassFill => _dark.glassFloat;
  static Color get glassEdge => _dark.glassEdge;
  static Color get glassInk => _dark.glassInk;
  static Color get assistantInk => _dark.primary;

  /// Marka logosu (assets SVG): karo `#d8f866 → #c8f53c`, çizgi `#0b0b0b`.
  static Color get logoTop => _dark.primaryTop;
  static Color get logoBottom => _dark.primary;
  static Color get logoInk => _dark.onPrimary;
}
