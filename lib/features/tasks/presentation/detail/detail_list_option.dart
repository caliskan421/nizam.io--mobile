part of 'detail_actions.dart';

/// Liste tipi alt sayfa satırı (prototip `.rp-menuitem`).
class _ListOption extends StatelessWidget {
  const _ListOption({
    required this.label,
    required this.leading,
    required this.onTap,
    this.hint,
    this.selected = false,
    this.color,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;
  final String? hint;
  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final hint = this.hint;
    return Semantics(
      button: true,
      selected: selected,
      label: [label, ?hint].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.row),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space2,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: NizamioSize.iconSize,
                  child: Center(child: leading),
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Text(
                    label,
                    style: t.list.copyWith(
                      color: color ?? c.text,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (hint != null) ...[
                  const Gap(NizamioSpacing.space2),
                  Text(hint, style: t.caption.copyWith(color: c.textMuted)),
                ],
                if (selected) ...[
                  const Gap(NizamioSpacing.space2),
                  NzIcon(
                    NzIcons.check,
                    size: NizamioSize.iconSizeSm,
                    color: c.accentText,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
