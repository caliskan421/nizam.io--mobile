import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';
import '../nz_icons.dart';

enum _BannerTone { info, warning, danger, offline }

/// Sayfa üstü şerit. Tonlar isimli yapıcıdır.
class NzBanner extends StatelessWidget {
  const NzBanner.info({
    super.key,
    required String this.message,
    this.actionLabel,
    this.onAction,
  }) : _tone = _BannerTone.info,
       assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel ve onAction birlikte verilir',
       );

  const NzBanner.warning({
    super.key,
    required String this.message,
    this.actionLabel,
    this.onAction,
  }) : _tone = _BannerTone.warning,
       assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel ve onAction birlikte verilir',
       );

  const NzBanner.danger({
    super.key,
    required String this.message,
    this.actionLabel,
    this.onAction,
  }) : _tone = _BannerTone.danger,
       assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel ve onAction birlikte verilir',
       );

  /// Çevrimdışı şeridi: metin `ui.feedback.offline`; [onAction] varsa `ui.common.retry` düğmesi.
  /// Yeniden deneme yalnız kullanıcı dokunuşuyla (A3b).
  const NzBanner.offline({super.key, this.onAction})
    : message = null,
      actionLabel = null,
      _tone = _BannerTone.offline;

  /// Offline'da null (ARB'den).
  final String? message;

  /// Offline'da null (`ui.common.retry`).
  final String? actionLabel;
  final VoidCallback? onAction;
  final _BannerTone _tone;

  static const _tintAlpha = 0.12;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l = context.l10n;
    final (tone, icon) = switch (_tone) {
      _BannerTone.info => (colors.info, NzIcons.info),
      _BannerTone.warning => (colors.warning, NzIcons.warning),
      _BannerTone.danger => (colors.danger, NzIcons.error),
      _BannerTone.offline => (colors.warning, NzIcons.offline),
    };
    final shownMessage = message ?? l.uiFeedbackOffline;
    final shownAction =
        actionLabel ?? (onAction == null ? null : l.uiCommonRetry);

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: NizamioSpacing.space4,
          vertical: NizamioSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: tone.withValues(alpha: _tintAlpha),
          border: Border.all(color: tone),
          borderRadius: BorderRadius.circular(NizamioRadius.tile),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          spacing: NizamioSpacing.space3,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: NzIcon(icon, color: tone, size: NizamioSpacing.space6),
                ),
                const Gap(NizamioSpacing.space3),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: NizamioSpacing.space2,
                    ),
                    child: Text(shownMessage, style: context.text.bodyMd),
                  ),
                ),
              ],
            ),
            if (shownAction != null)
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, NizamioSpacing.space12),
                  foregroundColor: tone,
                ),
                onPressed: onAction,
                child: Text(shownAction),
              ),
          ],
        ),
      ),
    );
  }
}
