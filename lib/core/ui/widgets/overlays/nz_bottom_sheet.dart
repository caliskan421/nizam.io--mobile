import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../layout/nz_layout.dart';

/// Alt sayfa servisi (durumsuz). Uygulamanın Navigator'ında açılır (`showModalBottomSheet`
/// varsayılanı); `MaterialApp.builder` içindeki PrivacyMask altında kalır, ayrı Overlay yoktur.
abstract final class NzBottomSheet {
  /// [title] başlıktır ve ekran okuyucuya başlık olarak bildirilir. Kapanınca [T] sonucu
  /// (sayfa içinden `Navigator.pop(context, değer)`); kapatma/sürükleme/geri `null` döner.
  /// [dismissible] false ise dışarı dokunma, sürükleme, geri tuşu ve kapat düğmesi kapalıdır
  /// (sayfa içeriği kendi eylemiyle kapatır).
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
    bool dismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
      constraints: BoxConstraints(
        maxWidth: context.layout.contentMaxWidth(NzContentWidth.form),
      ),
      builder: (sheetContext) => PopScope(
        canPop: dismissible,
        child: NzBottomSheetContent(
          title: title,
          dismissible: dismissible,
          child: Builder(builder: builder),
        ),
      ),
    );
  }
}

/// [NzBottomSheet.show] içeriği: başlık satırı + kaydırılabilir gövde (golden/katalog çizimi
/// için dışa açıktır).
class NzBottomSheetContent extends StatelessWidget {
  const NzBottomSheetContent({
    super.key,
    required this.title,
    required this.child,
    this.dismissible = true,
  });

  final String title;
  final Widget child;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NizamioSpacing.space4,
        0,
        NizamioSpacing.space4,
        NizamioSpacing.space4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title, style: context.text.titleMd),
                ),
              ),
              if (dismissible)
                IconButton(
                  tooltip: l.uiCommonClose,
                  constraints: const BoxConstraints(
                    minWidth: NizamioSpacing.space12,
                    minHeight: NizamioSpacing.space12,
                  ),
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
            ],
          ),
          const Gap(NizamioSpacing.space2),
          Flexible(child: SingleChildScrollView(child: child)),
        ],
      ),
    );
  }
}
