import 'package:flutter/material.dart';

/// Klavye açıldığında alanı ve ona ait eylemleri birlikte görünür tutar.
class MeetingInputVisibility extends StatefulWidget {
  const MeetingInputVisibility({super.key, required this.child});

  final Widget child;

  @override
  State<MeetingInputVisibility> createState() => _MeetingInputVisibilityState();
}

class _MeetingInputVisibilityState extends State<MeetingInputVisibility>
    with WidgetsBindingObserver {
  final _content = GlobalKey();
  var _focused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() => _reveal();

  void _reveal() {
    if (!_focused) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _show());
  }

  void _show() {
    final target = _content.currentContext;
    if (!mounted || !_focused || target == null) return;
    final scroll = Scrollable.maybeOf(target);
    final box = target.findRenderObject();
    final viewport = scroll?.context.findRenderObject();
    if (scroll == null || box is! RenderBox || viewport is! RenderBox) return;
    final bottom = box.localToGlobal(Offset(0, box.size.height)).dy;
    final viewportBottom =
        viewport.localToGlobal(Offset.zero).dy +
        scroll.position.viewportDimension;
    final delta = bottom - viewportBottom;
    if (delta <= 0) return;
    final position = scroll.position;
    position.animateTo(
      (position.pixels + delta + 8).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) => Focus(
    onFocusChange: (focused) {
      _focused = focused;
      if (focused) _reveal();
    },
    child: KeyedSubtree(key: _content, child: widget.child),
  );
}
