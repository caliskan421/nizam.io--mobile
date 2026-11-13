import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';

/// Silinmiş kayıt satırı: ad, alt bilgi ve iki eylem (geri yükle, kalıcı sil). Eylem sürerken
/// iki düğme de kilitlenir (çift dokunuş tek istek).
class DeletedRecordRow extends StatefulWidget {
  const DeletedRecordRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.onRestore,
    required this.onPurge,
  });

  final String title;
  final String? subtitle;
  final Future<void> Function() onRestore;
  final Future<void> Function() onPurge;

  @override
  State<DeletedRecordRow> createState() => _DeletedRecordRowState();
}

class _DeletedRecordRowState extends State<DeletedRecordRow> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() op) async {
    setState(() => _busy = true);
    try {
      await op();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final sub = widget.subtitle;
    return Padding(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space2),
      child: NzCard.outlined(
        padding: const EdgeInsets.all(NizamioSpacing.rowPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: t.labelLg),
            if (sub != null && sub.isNotEmpty) ...[
              const Gap(NizamioSpacing.space1),
              Text(sub, style: t.caption.copyWith(color: c.textMuted)),
            ],
            const Gap(NizamioSpacing.space3),
            Wrap(
              spacing: NizamioSpacing.space2,
              runSpacing: NizamioSpacing.space2,
              children: [
                NzButton.secondary(
                  label: 'Geri yükle',
                  icon: NzIcons.history,
                  loading: _busy,
                  onPressed: _busy ? null : () => _run(widget.onRestore),
                ),
                NzButton.ghost(
                  label: 'Kalıcı sil',
                  icon: NzIcons.delete,
                  onPressed: _busy ? null : () => _run(widget.onPurge),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
