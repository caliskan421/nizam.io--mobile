import 'package:flutter/widgets.dart';

import '../../theme/generated/tokens.gen.dart';

/// Süreler genel bileşenlerde `NizamioMotion`, sayfalarda [RpMotion] üzerinden gelir.
/// Sistemde "hareketi azalt" açıksa süre sıfırlanır.
abstract final class NzMotion {
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [duration] ya da azaltılmış harekette [Duration.zero].
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;

  /// Kapanış eğrisi (`easeExit`) için `reverseCurve`. Tasarımda kapanış ileri yönde oynayan
  /// ayrı bir animasyondur (`m-sheet-down .24s ease-exit`: yavaş başlar, hızlanarak çıkar).
  /// Flutter `reverseCurve`'ü ise geri yönde (t: 1 → 0) okur; eğri çevrilmezse hareket en
  /// hızlı noktasından başlar ve katman ekrandan birden fırlar.
  static const Curve exitReverse = FlippedCurve(NizamioMotion.easeExit);
}

/// Sayfa, içerik ve sekme hareketlerinin tek değer kaynağı.
abstract final class RpMotion {
  static const enterOffset = 10.0;
  static const enterDuration = Duration(milliseconds: 320);
  static const enterCurve = Cubic(0.2, 0.8, 0.2, 1.0);
  static const pushOffset = 36.0;
  static const pushDuration = Duration(milliseconds: 380);

  /// Kademeli girişte öğeler arası adım ve gecikmenin üst sınırı (ince; uzun listede birikmez).
  static const staggerStep = Duration(milliseconds: 40);
  static const staggerMaxSteps = 5;

  /// [index]. öğenin giriş gecikmesi (`index * staggerStep`, en çok [staggerMaxSteps] adım).
  static Duration stagger(int index) =>
      staggerStep * index.clamp(0, staggerMaxSteps);
}
