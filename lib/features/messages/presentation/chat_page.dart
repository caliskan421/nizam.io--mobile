import 'package:flutter/material.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_page.dart';

/// YER TUTUCU (iskelet): prototip ekranı bu dosyada uygulanır.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) => NzPage(
    title: context.l10n.uiMessagesChatTitle,
    body: Center(
      child: Text(
        [context.l10n.uiRouterPlaceholder, id].join('\n'),
        textAlign: TextAlign.center,
        style: context.text.bodyMd,
      ),
    ),
  );
}
