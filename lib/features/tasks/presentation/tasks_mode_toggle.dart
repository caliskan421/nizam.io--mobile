import 'package:flutter/material.dart';

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
