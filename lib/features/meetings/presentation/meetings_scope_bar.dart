import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';

/// Koordinatör/Üye görünümünün kapsam satırı ve birim süzgeci (prototip `meetings` koordinatör
/// dalı): "ALT · 3 yaklaşan, 5 geçmiş · koordinatör olarak birimlerinin dahil olduğu
/// toplantıları görüyorsun" ve "Tümü / ALT". Yönetici görünümünde kullanılmaz.
class MeetingsScopeBar extends StatelessWidget {
  const MeetingsScopeBar({
    super.key,
    required this.unit,
    required this.upcoming,
    required this.past,
    required this.coordinator,
    required this.unitOnly,
    required this.onUnitOnly,
  });

  /// Etkin koordinatörlüğün ekrandaki etiketi (kod, yoksa ad).
  final String unit;
  final int upcoming;
  final int past;

  /// Koordinatör görünümü (değilse üye notu).
  final bool coordinator;
  final bool unitOnly;
  final ValueChanged<bool> onUnitOnly;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$unit · $upcoming ${l.uiMeetingsScopeUpcoming}, '
          '$past ${l.uiMeetingsScopePast} · '
          '${coordinator ? l.uiMeetingsScopeCoordNote : l.uiMeetingsScopeMemberNote}',
          style: context.text.caption.copyWith(color: c.textMuted),
        ),
        const Gap(NizamioSpacing.space3),
        NzPillTabs(
          semanticLabel: l.uiMeetingsUnitLabel,
          selected: unitOnly ? 1 : 0,
          onSelected: (i) => onUnitOnly(i == 1),
          tabs: [
            NzPillTab(label: l.uiMeetingsUnitAll),
            NzPillTab(label: unit),
          ],
        ),
      ],
    );
  }
}
