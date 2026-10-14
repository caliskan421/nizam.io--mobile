import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../buttons/nz_button.dart';

/// Onay diyaloğunun tonu: [destructive] birincil eylemi `NzButton.danger` yapar.
enum NzDialogTone { normal, destructive }

/// Diyalog servisi (durumsuz). Uygulamanın Navigator'ında açılır (`showDialog` varsayılanı);
/// `MaterialApp.builder` içindeki PrivacyMask altında kalır, ayrı pencere/Overlay yoktur.
abstract final class NzDialog {
  /// Onay diyaloğu. Yalnız birincil eyleme dokunuş `true` döner; iptal düğmesi, geri tuşu ve
  /// dışarı dokunma `false` döner (onay DEĞİL). Düğme etiketleri çağıran tarafından (ARB'den)
  /// verilir; [cancelLabel] verilmezse `ui.common.cancel`.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String confirmLabel,
    String? message,
    String? cancelLabel,
    NzDialogTone tone = NzDialogTone.normal,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => NzConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        tone: tone,
      ),
    );
    return result ?? false;
  }
}

/// [NzDialog.confirm] içeriği. Doğrudan değil, servis üzerinden açılır (golden/katalog çizimi
/// için dışa açıktır). Düğmeler `Navigator.pop(context, bool)` ile kapanır.
class NzConfirmDialog extends StatelessWidget {
  const NzConfirmDialog({
    super.key,
    required this.title,
    required this.confirmLabel,
    this.message,
    this.cancelLabel,
    this.tone = NzDialogTone.normal,
  });

  final String title;
  final String confirmLabel;
  final String? message;
  final String? cancelLabel;
  final NzDialogTone tone;

  @override
  Widget build(BuildContext context) {
    final cancel = NzButton.secondary(
      label: cancelLabel ?? context.l10n.uiCommonCancel,
      onPressed: () => Navigator.of(context).pop(false),
    );
    void confirm() => Navigator.of(context).pop(true);
    final accept = switch (tone) {
      NzDialogTone.normal => NzButton.primary(
        label: confirmLabel,
        onPressed: confirm,
      ),
      NzDialogTone.destructive => NzButton.danger(
        label: confirmLabel,
        onPressed: confirm,
      ),
    };
    return AlertDialog(
      scrollable: true,
      title: Text(title, style: context.text.titleMd),
      content: message == null
          ? null
          : Text(message!, style: context.text.bodyMd),
      // OverflowBar: dar genişlik/büyük metinde düğmeler alt alta dizilir (taşma yok).
      actionsOverflowAlignment: OverflowBarAlignment.end,
      actionsOverflowDirection: VerticalDirection.down,
      actionsOverflowButtonSpacing: NizamioSpacing.space2,
      actions: [cancel, accept],
    );
  }
}
