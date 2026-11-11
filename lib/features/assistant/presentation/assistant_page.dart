import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/nz_error_state.dart';
import '../application/assistant_controller.dart';
import '../domain/assistant.dart';

class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});
  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final _text = TextEditingController();
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionGenerationProvider, (_, _) => _text.clear());
    ref.listen(scopeStateProvider, (_, _) => _text.clear());
    final chat = ref.watch(assistantChatProvider);
    final controller = ref.read(assistantChatProvider.notifier);
    final conversations = ref.watch(assistantConversationsProvider);
    final disabled = chat.disabled || conversations.error is AssistantDisabled;
    return NzPage(
      title: 'Asistan',
      body: disabled
          ? const Center(child: Text('Asistan bu kurulumda kapalı.'))
          : Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: chat.busy ? null : () => controller.open(null),
                      child: const Text('Yeni sohbet'),
                    ),
                    if (chat.conversationId != null)
                      TextButton(
                        onPressed: chat.busy
                            ? null
                            : () async {
                                final session = ref.read(
                                  sessionGenerationProvider,
                                );
                                final scope = ref.read(scopeStateProvider);
                                final yes = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Sohbet silinsin mi?'),
                                    content: const Text(
                                      'Sohbet kalıcı olarak silinir.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Vazgeç'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Sil'),
                                      ),
                                    ],
                                  ),
                                );
                                if (yes == true &&
                                    mounted &&
                                    session ==
                                        ref.read(sessionGenerationProvider) &&
                                    scope == ref.read(scopeStateProvider)) {
                                  await controller.delete(chat.conversationId!);
                                }
                              },
                        child: const Text('Sohbeti sil'),
                      ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      if (chat.messages.isEmpty && !chat.busy)
                        NzAsyncView(
                          value: conversations,
                          skeletonOnReload: true,
                          onRetry: () =>
                              ref.invalidate(assistantConversationsProvider),
                          data: (page) => Column(
                            children: [
                              if (page.items.isEmpty)
                                const Text('Bir soru yazarak başlayın.'),
                              if (page.truncated)
                                const Text('En yeni sohbetler gösteriliyor.'),
                              for (final conversation in page.items)
                                ListTile(
                                  title: Text(conversation.title),
                                  onTap: () => controller.open(conversation.id),
                                ),
                            ],
                          ),
                        ),
                      for (final message in chat.messages)
                        ListTile(
                          title: Text(
                            message.role == AssistantMessageRole.user
                                ? 'Siz'
                                : 'Asistan',
                          ),
                          subtitle: SelectableText(message.content),
                        ),
                      if (chat.answer.isNotEmpty) SelectableText(chat.answer),
                      if (chat.sources.isNotEmpty)
                        Text('Kaynaklar: ${chat.sources.join(', ')}'),
                      if (chat.error != null) NzErrorState(error: chat.error!),
                      if (chat.busy) const LinearProgressIndicator(),
                    ],
                  ),
                ),
                const Gap(8),
                TextField(
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  controller: _text,
                  enabled: !chat.busy,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Sorunuz'),
                ),
                Row(
                  children: [
                    if (chat.busy)
                      TextButton(
                        onPressed: controller.stop,
                        child: const Text('Durdur'),
                      )
                    else
                      TextButton(
                        onPressed: () {
                          controller.send(_text.text);
                          _text.clear();
                        },
                        child: const Text('Gönder'),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}
