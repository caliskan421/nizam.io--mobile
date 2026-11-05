import 'package:flutter/material.dart';

import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/inputs/nz_pill_tabs.dart';
import '../../../core/ui/widgets/nz_icons.dart';

/// Görevler ↔ Zaman çizelgesi anahtarı. Rotalar anında değiştiği için seçim hareketi kaynak
/// sayfada değil hedefte oynar: dokunuşta sayfa hemen değişir, hedefteki anahtar önceki
/// konumdan başlayıp kendi seçimine kayar (sayfa içerik girişiyle eşzamanlı; görev ayrıntısı
/// sekmeleri gibi). Geri dönüşte (alttaki sayfa yeniden görünür) aynı kayma oradan oynar.
class TasksModeToggle extends StatefulWidget {
  const TasksModeToggle({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  final int selected;
  final ValueChanged<int> onSelected;
  @override
  State<TasksModeToggle> createState() => _TasksModeToggleState();
}

class _TasksModeToggleState extends State<TasksModeToggle> {
  /// Geçişte kaynak anahtarın konumu; hedefte ilk karede okunur, kare sonunda silinir.
  static int? _handoff;

  late int _selected = widget.selected;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    final from = _handoff;
    if (from != null && from != widget.selected) {
      _handoff = null;
      _selected = from;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selected = widget.selected);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Üstteki sayfa kapanıp bu sayfa yeniden görünür olunca (örtülü rota TickerMode kapalı).
    final visible = TickerMode.valuesOf(context).enabled;
    if (visible && !_visible) _selected = widget.selected;
    _visible = visible;
  }

  @override
  void didUpdateWidget(TasksModeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) _selected = widget.selected;
  }

  void _select(int index) {
    if (index == widget.selected) return;
    _handoff = widget.selected;
    TasksHeaderSlide.capture(context);
    // Bu sayfa örtülür; geri dönüldüğünde seçimden kendi konumuna kayar.
    setState(() => _selected = index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handoff = null);
    widget.onSelected(index);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 84,
    child: NzPillTabs(
      iconsOnly: true,
      semanticLabel: 'Görünüm',
      selected: _selected,
      onSelected: _select,
      tabs: const [
        NzPillTab(label: 'Liste', icon: NzIcons.list),
        NzPillTab(label: 'Zaman çizelgesi', icon: NzIcons.timeline),
      ],
    ),
  );
}

/// Görevler başlığının eylem grubu (anahtar, ara, yeni görev): Liste ↔ Zaman çizelgesi
/// geçişinde grup kaynak sayfadaki yerinden (dokunma anındaki sağ kenarı) yeni yerine hızla
/// kayar; tablette liste bölmesi dar, çizelge tam genişlik olduğu için düğmeler birden sağda
/// belirmez. İlk karede ölçülür (o kare saydam), kayma sayfa girişinin süresi ve eğrisiyle
/// oynar. Konum farkı yoksa (telefon) hareket yoktur; hareketi azalt → anlık.
class TasksHeaderSlide extends StatefulWidget {
  const TasksHeaderSlide({super.key, required this.child});

  final Widget child;

  /// Kaynak grubun sağ kenarı (global x) ve alınma anı; hedef bir kez okur.
  static ({double right, DateTime at})? _handoff;

  /// Geçiş eskiyse (gezinme gerçekleşmediyse) okunmaz.
  static const _maxAge = Duration(seconds: 1);

  /// [context]'i saran grubun konumunu kaydeder (anahtar dokunuşunda).
  static void capture(BuildContext context) {
    final state = context.findAncestorStateOfType<_TasksHeaderSlideState>();
    final box = state?.context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    _handoff = (
      right: box.localToGlobal(Offset(box.size.width, 0)).dx,
      at: DateTime.now(),
    );
  }

  @override
  State<TasksHeaderSlide> createState() => _TasksHeaderSlideState();
}

class _TasksHeaderSlideState extends State<TasksHeaderSlide>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: RpMotion.enterDuration,
  );
  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: RpMotion.enterCurve,
  );
  double _dx = 0;
  bool _measuring = false;
  bool _visible = true;
  bool _reduced = false;

  @override
  void initState() {
    super.initState();
    _take();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = NzMotion.reduced(context);
    // Korunan sayfa yeniden görünür olunca (üstteki çizelge kapandı) aynı kayma.
    final visible = TickerMode.valuesOf(context).enabled;
    if (visible && !_visible) _take();
    _visible = visible;
  }

  void _take() {
    final h = TasksHeaderSlide._handoff;
    if (h == null ||
        DateTime.now().difference(h.at) > TasksHeaderSlide._maxAge) {
      return;
    }
    TasksHeaderSlide._handoff = null;
    _measuring = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      final right = box != null && box.hasSize
          ? box.localToGlobal(Offset(box.size.width, 0)).dx
          : h.right;
      final dx = h.right - right;
      final move = dx.abs() >= 1 && !_reduced;
      setState(() {
        _measuring = false;
        _dx = move ? dx : 0;
      });
      if (move) _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: _measuring ? 0 : 1,
    child: AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: Offset(_dx * (1 - _animation.value), 0),
        child: child,
      ),
    ),
  );
}
