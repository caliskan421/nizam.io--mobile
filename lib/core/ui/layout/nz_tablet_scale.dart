import 'package:flutter/widgets.dart';

/// Tablette arayüzü (yazı, bileşen, ikon, boşluk) tek yerden büyütür. Dp değerleri telefonla
/// aynı kaldığı için büyük ekranda her şey küçük kalıyordu; burada çizim [factor] kadar
/// büyütülür, alttaki ağaç ise `boyut / factor` boyutunda bir pencere görür (yerleşim sınıfı
/// ve kenar boşlukları buna göre hesaplanır). Telefonda (kısa kenar < [minShortestSide])
/// çarpan 1'dir. Ağaç yapısı çarpandan bağımsız sabittir; yön değişince alt durum kaybolmaz.
class NzTabletScale extends StatelessWidget {
  const NzTabletScale({super.key, required this.child});

  static const double factor = 1.15;
  static const double minShortestSide = 600;

  /// [shortestSide] dp cinsinden pencerenin kısa kenarı.
  static double scaleFor(double shortestSide) =>
      shortestSide >= minShortestSide ? factor : 1;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = scaleFor(mq.size.shortestSide);
    final inner = Size(mq.size.width / s, mq.size.height / s);
    EdgeInsets down(EdgeInsets e) => e / s;
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.topLeft,
        minWidth: inner.width,
        maxWidth: inner.width,
        minHeight: inner.height,
        maxHeight: inner.height,
        child: Transform.scale(
          scale: s,
          alignment: Alignment.topLeft,
          child: MediaQuery(
            data: mq.copyWith(
              size: inner,
              padding: down(mq.padding),
              viewPadding: down(mq.viewPadding),
              viewInsets: down(mq.viewInsets),
              systemGestureInsets: down(mq.systemGestureInsets),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
