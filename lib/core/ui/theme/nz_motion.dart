import 'package:flutter/widgets.dart';

/// Süreler genel bileşenlerde `NizamioMotion`, sayfalarda [RpMotion] üzerinden gelir.
/// Sistemde "hareketi azalt" açıksa süre sıfırlanır.
abstract final class NzMotion {
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [duration] ya da azaltılmış harekette [Duration.zero].
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}

/// Sayfa, içerik ve sekme hareketlerinin tek değer kaynağı.
abstract final class RpMotion {
  static const enterOffset = 10.0;
  static const enterDuration = Duration(milliseconds: 320);
  static const enterCurve = Cubic(0.2, 0.8, 0.2, 1.0);
  static const pushOffset = 36.0;
  static const pushDuration = Duration(milliseconds: 380);
  static const tabFadeDuration = Duration(milliseconds: 300);
}
