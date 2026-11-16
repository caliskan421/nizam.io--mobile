import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/context_ext.dart';

/// Kart dışını yakalar: görev üstüne dokunma seçimi değiştirir, boş alan kapatır.
/// Sürükleme arka plana geçmez; kart kendi içeriğini kaydırmaya devam eder.
class TimelineSelectionBackdrop extends StatelessWidget {
  const TimelineSelectionBackdrop({
    super.key,
    required this.selected,
    required this.taskAt,
    required this.onSelect,
    required this.onClose,
  });

  final String selected;
  final String? Function(Offset globalPosition) taskAt;
  final ValueChanged<String> onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: context.l10n.uiCommonClose,
    onTap: onClose,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTapUp: (details) {
        final code = taskAt(details.globalPosition);
        if (code == null) {
          onClose();
        } else if (code != selected) {
          onSelect(code);
        }
      },
      onPanUpdate: (_) {},
      child: const SizedBox.expand(),
    ),
  );
}
