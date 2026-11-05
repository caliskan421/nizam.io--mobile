import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/inputs/nz_pill_tabs.dart';
import '../../../core/ui/widgets/nz_icons.dart';

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
  late int _selected = widget.selected;
  bool _changing = false;
  @override
  void didUpdateWidget(TasksModeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) _selected = widget.selected;
  }

  Future<void> _select(int index) async {
    if (_changing || index == _selected) return;
    final duration = NzMotion.of(context, NizamioMotion.durSheet);
    setState(() {
      _selected = index;
      _changing = true;
    });
    await Future<void>.delayed(duration);
    if (!mounted) return;
    widget.onSelected(index);
    if (mounted) {
      setState(() {
        _selected = widget.selected;
        _changing = false;
      });
    }
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
