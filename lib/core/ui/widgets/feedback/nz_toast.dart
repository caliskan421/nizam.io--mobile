import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../errors/api_error.dart';
import '../../../errors/error_text.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';

enum NzToastTone { info, success, danger }

/// Snackbar servisi (durumsuz). `ScaffoldMessenger` üzerinden gösterilir; `MaterialApp.builder`
/// içindeki PrivacyMask altında kalır, ayrı Overlay/pencere açılmaz. Yeni toast öncekinin yerini
/// alır (kuyruk birikmez).
abstract final class NzToast {
  static void show(
    BuildContext context,
    String message, {
    NzToastTone tone = NzToastTone.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    assert(
      (actionLabel == null) == (onAction == null),
      'actionLabel ve onAction birlikte verilir',
    );
    final colors = context.colors;
    final (background, icon) = switch (tone) {
      NzToastTone.info => (colors.text, Icons.info_outline),
      NzToastTone.success => (colors.success, Icons.check_circle_outline),
      NzToastTone.danger => (colors.danger, Icons.error_outline),
    };
    final foreground = colors.background;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          content: Semantics(
            liveRegion: true,
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Icon(
                    icon,
                    color: foreground,
                    size: NizamioSpacing.space6,
                  ),
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Text(
                    message,
                    style: context.text.bodyMd.copyWith(color: foreground),
                  ),
                ),
              ],
            ),
          ),
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  label: actionLabel,
                  textColor: foreground,
                  onPressed: onAction!,
                ),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, tone: NzToastTone.success);

  /// Metin `errorText`; oturum bitti sınıfı hataları ayıklamak ÇAĞIRANIN işidir (listenErrors).
  static void error(BuildContext context, ApiError error) =>
      show(context, errorText(context.l10n, error), tone: NzToastTone.danger);
}
