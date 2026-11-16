import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_tap.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';

/// Table forms use the same custom round selection indicator as task lists.
class TableChoiceRow extends StatelessWidget {
  const TableChoiceRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.trailing,
  });
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Semantics(
    checked: value,
    enabled: onChanged != null,
    label: label,
    onTap: onChanged == null ? null : () => onChanged!(!value),
    child: NzTap(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: Row(
        children: [
          ExcludeSemantics(
            child: IgnorePointer(
              child: NzCheckCircle(
                value: value,
                label: label,
                onChanged: onChanged == null ? null : () => onChanged!(!value),
              ),
            ),
          ),
          const Gap(NizamioSpacing.space2),
          Expanded(
            child: ExcludeSemantics(
              child: Text(label, style: context.text.bodyMd),
            ),
          ),
          ?trailing,
        ],
      ),
    ),
  );
}
