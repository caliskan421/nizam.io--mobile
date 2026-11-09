// Tablet ölçeği (`NzTabletScale`) altında ölçü çerçevesi: tablette çizim çarpan kadar büyütülür,
// uygulama ağacı `pencere / çarpan` boyutunda bir pencere görür. Tablet sözleşmesi (ray 100,
// liste 390, modal genişliği …) uygulamanın mantıksal çerçevesindedir; ekran ölçüleri buraya
// çevrilerek karşılaştırılır. Telefonda çarpan 1'dir.
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/layout/nz_tablet_scale.dart';

/// Ekran penceresi (mantıksal pt, ölçeksiz).
Size _screen(WidgetTester t) => t.view.physicalSize / t.view.devicePixelRatio;

/// Pencerenin tablet çarpanı; telefonda 1.
double appScale(WidgetTester t) =>
    NzTabletScale.scaleFor(_screen(t).shortestSide);

/// Uygulama ağacının gördüğü pencere (ekran / çarpan).
Size appWindow(WidgetTester t) => _screen(t) / appScale(t);

/// Uygulama ağacının gördüğü üst güvenli alan (ekran güvenli alanı / çarpan).
double appSafeTop(WidgetTester t) =>
    t.view.padding.top / t.view.devicePixelRatio / appScale(t);

/// [f]'nin ekran dikdörtgeni uygulamanın mantıksal çerçevesinde.
Rect appRect(WidgetTester t, Finder f) {
  final r = t.getRect(f);
  final s = appScale(t);
  return Rect.fromLTRB(r.left / s, r.top / s, r.right / s, r.bottom / s);
}

/// [f]'nin yerel koordinatındaki [local] dikdörtgeni ekran koordinatında (ölçek dahil).
Rect localToScreen(WidgetTester t, Finder f, Rect local) =>
    MatrixUtils.transformRect(
      t.renderObject<RenderBox>(f).getTransformTo(null),
      local,
    );

/// Ekran noktası [p], [f]'nin yerel koordinatında (ölçek dahil).
Offset screenToLocal(WidgetTester t, Finder f, Offset p) =>
    t.renderObject<RenderBox>(f).globalToLocal(p);
