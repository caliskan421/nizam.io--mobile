import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';

/// YER TUTUCU (iskelet): prototip ekranı bu dosyada uygulanır.
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) => NzPage(
    title: context.l10n.uiActivityTitle,
    body: Center(
      child: Text(
        [context.l10n.uiRouterPlaceholder].join('\n'),
        textAlign: TextAlign.center,
        style: context.text.bodyMd,
      ),
    ),
  );
}
