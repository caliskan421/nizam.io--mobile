import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';

/// YER TUTUCU (iskelet): prototip ekranı bu dosyada uygulanır.
class TasksPage extends StatelessWidget {
  const TasksPage({super.key, this.view, this.people = const []});

  final NzTaskView? view;
  final List<String> people;

  @override
  Widget build(BuildContext context) => NzPage(
    title: context.l10n.uiTasksTitle,
    body: Center(
      child: Text(
        [context.l10n.uiRouterPlaceholder].join('\n'),
        textAlign: TextAlign.center,
        style: context.text.bodyMd,
      ),
    ),
  );
}
