import 'package:flutter/material.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../domain/program.dart';

class ProgramBadge extends StatelessWidget {
  const ProgramBadge({
    super.key,
    required this.name,
    this.shortName,
    this.color,
  });
  final String name;
  final String? shortName;
  final ProgramColor? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, ink) = switch (color) {
      ProgramColor.gold => (c.warning, c.onWarning),
      ProgramColor.blue => (c.programBlue, c.onProgramColor),
      ProgramColor.teal => (c.programTeal, c.onProgramColor),
      ProgramColor.green => (c.programGreen, c.onProgramColor),
      ProgramColor.orange => (c.programOrange, c.onProgramColor),
      ProgramColor.red => (c.programRed, c.onProgramColor),
      ProgramColor.slate => (c.programSlate, c.onProgramColor),
      _ => (c.inProgress, c.onInProgress),
    };
    final trimmed = name.trim();
    final label = shortName?.trim();
    final text = label != null && label.isNotEmpty
        ? label
        : (trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase());
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
      ),
      child: SizedBox(
        width: NizamioSize.controlSm - NizamioSpacing.space1,
        height: NizamioSize.controlSm - NizamioSpacing.space1,
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.caption.copyWith(
              color: ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
