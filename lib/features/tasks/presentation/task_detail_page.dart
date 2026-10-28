import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';

/// YER TUTUCU (iskelet): prototip ekranı bu dosyada uygulanır.
class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => NzPage(
    title: context.l10n.uiTasksDetailTitle,
    body: Center(
      child: Text(
        [context.l10n.uiRouterPlaceholder, code].join('\n'),
        textAlign: TextAlign.center,
        style: context.text.bodyMd,
      ),
    ),
  );
}
