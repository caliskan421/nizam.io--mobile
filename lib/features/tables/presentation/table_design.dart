import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_pressable.dart';
import '../../../core/ui/widgets/inputs/nz_search_field.dart';
import '../../../core/ui/widgets/inputs/nz_text_field.dart';
import '../../../core/ui/widgets/nz_glyph.dart';
import '../../../core/ui/widgets/nz_icon.dart';

enum TableButtonKind { primary, share, outline, secondary, plain, row, danger }

class TableDesignButton extends StatelessWidget {
  const TableDesignButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.glyph,
    this.kind = TableButtonKind.secondary,
    this.alignStart = false,
    this.fadeWhenDisabled = true,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NzGlyph? glyph;
  final TableButtonKind kind;
  final bool alignStart;
  final bool fadeWhenDisabled;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fill = switch (kind) {
      TableButtonKind.primary => c.primary,
      TableButtonKind.share => c.text,
      TableButtonKind.secondary => c.surfaceRaised,
      TableButtonKind.danger => c.surface,
      _ => context.colors.surface.withValues(alpha: 0),
    };
    final ink = switch (kind) {
      TableButtonKind.primary => c.onPrimary,
      TableButtonKind.share => c.background,
      TableButtonKind.plain => c.accentText,
      TableButtonKind.danger => c.danger,
      _ => c.text,
    };
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: FocusableActionDetector(
        enabled: onPressed != null,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onPressed?.call();
              return null;
            },
          ),
        },
        child: NzPressable(
          enabled: onPressed != null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: Opacity(
              opacity: onPressed == null && fadeWhenDisabled ? .4 : 1,
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: fill,
                  border:
                      kind == TableButtonKind.outline ||
                          kind == TableButtonKind.danger
                      ? Border.all(
                          color: kind == TableButtonKind.danger
                              ? c.border
                              : c.borderControl,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(
                    (kind == TableButtonKind.secondary ||
                            kind == TableButtonKind.danger)
                        ? 16
                        : 999,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: alignStart
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    if (icon != null || glyph != null) ...[
                      glyph != null
                          ? NzGlyphIcon(glyph!, size: 18, color: ink)
                          : NzIcon(icon, size: 18, color: ink),
                      const Gap(8),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelMd.copyWith(color: ink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TableDesignCard extends StatelessWidget {
  const TableDesignCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: context.colors.surfaceRaised,
      border: Border.all(color: context.colors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
}

/// Uses the same title field as the task creation form.
class TableTitleInput extends StatefulWidget {
  const TableTitleInput({
    super.key,
    required this.value,
    required this.hint,
    required this.onChanged,
    this.label = 'Ad',
    this.large = true,
  });
  final String value, hint, label;
  final ValueChanged<String> onChanged;
  final bool large;
  @override
  State<TableTitleInput> createState() => _TableTitleInputState();
}

class _TableTitleInputState extends State<TableTitleInput> {
  late final _controller = TextEditingController(text: widget.value);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NzTextField(
    pill: true,
    labelAbove: false,
    controller: _controller,
    label: widget.label,
    hint: widget.hint,
    onChanged: widget.onChanged,
    textInputAction: TextInputAction.done,
  );
}

class TableSearchInput extends StatelessWidget {
  const TableSearchInput({
    super.key,
    required this.label,
    required this.onChanged,
  });
  final String label;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) =>
      NzSearchField(label: label, onChanged: onChanged);
}

class TableDragHandle extends StatelessWidget {
  const TableDragHandle({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 16,
    height: 24,
    child: CustomPaint(painter: _TableDragDots(context.colors.textMuted)),
  );
}

class _TableDragDots extends CustomPainter {
  _TableDragDots(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (final x in [5.0, 10.0]) {
      for (final y in [6.0, 11.0, 16.0]) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_TableDragDots oldDelegate) => oldDelegate.color != color;
}
