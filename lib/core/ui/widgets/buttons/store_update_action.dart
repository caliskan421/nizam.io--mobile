import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../config/update_store.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';
import 'buttons.dart';

/// No inferred marketplace target: absent configuration is an explicit state.
class StoreUpdateAction extends ConsumerStatefulWidget {
  const StoreUpdateAction({
    super.key,
    this.onRecheck,
    this.checking = false,
    this.unavailableMessage,
  });
  final String? unavailableMessage;
  final VoidCallback? onRecheck;
  final bool checking;
  @override
  ConsumerState<StoreUpdateAction> createState() => _StoreUpdateActionState();
}

class _StoreUpdateActionState extends ConsumerState<StoreUpdateAction> {
  bool _busy = false;
  bool _failed = false;

  Future<void> _open() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    final opened = await ref.read(updateStoreProvider).open();
    if (mounted) {
      setState(() {
        _busy = false;
        _failed = !opened;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (!ref.watch(updateStoreProvider).available) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.unavailableMessage ?? l.uiServerUpdateStoreUnavailable,
            textAlign: TextAlign.center,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
          if (widget.onRecheck != null) ...[
            const Gap(NizamioSpacing.space4),
            NzButton.primary(
              label: l.uiServerUpdateStore,
              size: NzSize.lg,
              radius: NizamioRadius.pill,
              expand: true,
              loading: widget.checking,
              onPressed: widget.onRecheck,
            ),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzButton.primary(
          label: l.uiServerUpdateStore,
          expand: true,
          size: NzSize.lg,
          radius: NizamioRadius.pill,
          loading: _busy,
          onPressed: _open,
        ),
        if (_failed) ...[
          const Gap(NizamioSpacing.space2),
          Text(l.uiServerUpdateStoreFailed, style: context.text.bodyMd),
        ],
      ],
    );
  }
}
