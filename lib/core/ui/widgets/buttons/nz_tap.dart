import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';
import 'nz_pressable.dart';

/// Keyboard-accessible tap surface with the standard shrink feedback only.
class NzTap extends StatelessWidget {
  const NzTap({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
  });
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) => NzPressable(
    enabled: onTap != null,
    child: InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStatePropertyAll(
        context.colors.text.withValues(alpha: 0),
      ),
      child: child,
    ),
  );
}
