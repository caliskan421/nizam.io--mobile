import 'package:flutter/widgets.dart';

/// Hareket süresinin tek uygulama yolu: süreler `NizamioMotion` token'larından gelir; sistemde
/// "hareketi azalt" açıksa (README: `prefers-reduced-motion` → 1 ms) süre sıfırlanır.
abstract final class NzMotion {
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [duration] ya da azaltılmış harekette [Duration.zero].
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}
