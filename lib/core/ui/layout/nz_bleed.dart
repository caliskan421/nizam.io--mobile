import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Çocuğu iki yanda [bleed] kadar taşırır (CSS negatif yatay `margin`, ör. kaynak gelen kutusu
/// `margin: 0 -8px`, sohbet ayırıcısı `margin: 10px -12px 6px`). Kendi genişliği üst kısıttır;
/// çocuk `genişlik + 2 × bleed` ile yerleşir ve `-bleed` kaydırılır. `LayoutBuilder` kullanmaz
/// (tembel listelerde ek derleme kapsamı açmaz).
class NzHorizontalBleed extends SingleChildRenderObjectWidget {
  const NzHorizontalBleed({super.key, required this.bleed, super.child});

  final double bleed;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderNzHorizontalBleed(bleed);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderNzHorizontalBleed renderObject,
  ) => renderObject.bleed = bleed;
}

/// [NzHorizontalBleed] yerleşimi.
class RenderNzHorizontalBleed extends RenderShiftedBox {
  RenderNzHorizontalBleed(this._bleed) : super(null);

  double _bleed;

  set bleed(double v) {
    if (v == _bleed) return;
    _bleed = v;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final c = constraints;
    final child = this.child;
    if (child == null) {
      size = c.smallest;
      return;
    }
    final extra = 2 * _bleed;
    child.layout(
      c.copyWith(minWidth: c.minWidth + extra, maxWidth: c.maxWidth + extra),
      parentUsesSize: true,
    );
    size = c.constrain(Size(child.size.width - extra, child.size.height));
    (child.parentData! as BoxParentData).offset = Offset(-_bleed, 0);
  }
}
