import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';

/// YER TUTUCU (iskelet): prototipin hızlı işlem alt sayfaları (yeni görev, toplantı, kullanıcı
/// davet) bu dosyada uygulanır. Ana sayfa, kısayol menüleri ve koordinatörlük ayrıntısı çağırır.
Future<void> showNewTaskSheet(
  BuildContext context, {
  String? coordinatorship,
}) => _placeholder(context, context.l10n.uiHomeQaTaskLong);

Future<void> showMeetingSheet(
  BuildContext context, {
  String? coordinatorship,
}) => _placeholder(context, context.l10n.uiHomeQaMeetingLong);

Future<void> showInviteSheet(BuildContext context) =>
    _placeholder(context, context.l10n.uiHomeQaInviteLong);

Future<void> _placeholder(BuildContext context, String title) =>
    NzBottomSheet.show<void>(
      context,
      title: title,
      builder: (sheet) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            sheet.l10n.uiHomeFormSoon,
            style: sheet.text.bodyMd.copyWith(color: sheet.colors.textMuted),
          ),
          const Gap(NizamioSpacing.space6),
          NzButton.secondary(
            label: sheet.l10n.uiCommonClose,
            expand: true,
            onPressed: () => Navigator.of(sheet).pop(),
          ),
        ],
      ),
    );
