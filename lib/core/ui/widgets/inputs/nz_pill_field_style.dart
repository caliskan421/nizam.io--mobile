import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Shared appearance for page search and compact form inputs.
TextStyle nzPillFieldText(BuildContext context, NzSize size) => size.pick(
  sm: context.text.bodyMd,
  md: context.text.bodyLg,
  lg: context.text.bodyLg,
);

InputDecoration nzPillFieldDecoration(
  BuildContext context, {
  required TextStyle text,
  bool multiline = false,
}) {
  final c = context.colors;
  OutlineInputBorder border(
    Color color, [
    double width = NizamioSize.borderWidth,
  ]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      multiline ? NizamioRadius.group : NizamioRadius.pill,
    ),
    borderSide: BorderSide(color: color, width: width),
  );
  final line = (text.fontSize ?? 16) * (text.height ?? 1);
  final vertical = multiline
      ? NizamioSpacing.space3
      : ((NizamioSize.controlMd - line) / 2).clamp(0.0, NizamioSize.controlMd);
  return InputDecoration(
    filled: true,
    fillColor: c.surface,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: NizamioSpacing.space4,
      vertical: vertical,
    ),
    constraints: const BoxConstraints(minHeight: NizamioSize.controlMd),
    border: border(c.borderControl),
    enabledBorder: border(c.borderControl),
    disabledBorder: border(c.border),
    focusedBorder: border(c.focusRing, NizamioSize.focusRingWidth),
    errorBorder: border(c.danger),
    focusedErrorBorder: border(c.danger, NizamioSize.focusRingWidth),
  );
}
