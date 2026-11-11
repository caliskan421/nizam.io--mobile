import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Eşit hücreli ızgara: [columns] eşit sütun, bütün hücreler en uzun öğenin yüksekliğinde
/// (yalnız satır içinde değil, satırlar arasında da). Öğe yükseklikleri içsel ölçüden
/// (`getMaxIntrinsicHeight`) gelir; esnek (`Spacer`) içerik hücreyi doldurur.
class UniformGrid extends MultiChildRenderObjectWidget {
  const UniformGrid({
    super.key,
    required this.columns,
    required this.gap,
    required super.children,
  }) : assert(columns > 0);

  final int columns;
  final double gap;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderUniformGrid(columnCount: columns, spacing: gap);

  @override
  void updateRenderObject(
    BuildContext context,
    // ignore: library_private_types_in_public_api
    _RenderUniformGrid renderObject,
  ) {
    renderObject
      ..columns = columns
      ..gap = gap;
  }
}

class _GridParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderUniformGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _GridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _GridParentData> {
  _RenderUniformGrid({required int columnCount, required double spacing})
    : _columns = columnCount,
      _gap = spacing;

  int _columns;
  set columns(int value) {
    if (value == _columns) return;
    _columns = value;
    markNeedsLayout();
  }

  double _gap;
  set gap(double value) {
    if (value == _gap) return;
    _gap = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _GridParentData) {
      child.parentData = _GridParentData();
    }
  }

  int get _rows => (childCount + _columns - 1) ~/ _columns;

  double _columnWidth(double width) =>
      math.max(0, (width - _gap * (_columns - 1)) / _columns);

  /// En uzun öğenin [column] genişliğindeki yüksekliği.
  double _cellHeight(double column) {
    var height = 0.0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      height = math.max(height, child.getMaxIntrinsicHeight(column));
    }
    return height;
  }

  double _height(double cell) =>
      _rows == 0 ? 0 : _rows * cell + (_rows - 1) * _gap;

  double _heightFor(double width) => _height(_cellHeight(_columnWidth(width)));

  @override
  double computeMinIntrinsicHeight(double width) => _heightFor(width);

  @override
  double computeMaxIntrinsicHeight(double width) => _heightFor(width);

  double _widthFor(double Function(RenderBox) measure) {
    var widest = 0.0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      widest = math.max(widest, measure(child));
    }
    final columns = math.min(_columns, childCount);
    return columns == 0 ? 0 : columns * widest + (columns - 1) * _gap;
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _widthFor((c) => c.getMinIntrinsicWidth(double.infinity));

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _widthFor((c) => c.getMaxIntrinsicWidth(double.infinity));

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) => constraints
      .constrain(Size(constraints.maxWidth, _heightFor(constraints.maxWidth)));

  @override
  void performLayout() {
    assert(constraints.hasBoundedWidth, 'UniformGrid sınırlı genişlik ister');
    final width = constraints.maxWidth;
    final column = _columnWidth(width);
    final cell = _cellHeight(column);
    var i = 0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      child.layout(BoxConstraints.tight(Size(column, cell)));
      (child.parentData! as _GridParentData).offset = Offset(
        (i % _columns) * (column + _gap),
        (i ~/ _columns) * (cell + _gap),
      );
      i++;
    }
    size = constraints.constrain(Size(width, _height(cell)));
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
