part of 'chat_page.dart';

/// Mesaj eylem menüsü ve mesajdan görev akışı ([ChatPage] parçası).
extension _ChatPageActions on _ChatPageState {
  Future<void> _actions(ChatRoom room, ChatMessage m) async {
    final l = context.l10n;
    if (m.state == ChatSendState.sending) return;
    final me = ref.read(chatMeProvider);
    final mine = m.senderId == me;
    _flash.value = m.id;
    final a = await showMessageActions(
      context,
      message: m,
      canEdit: mine && m.poll == null && m.attachments.isEmpty,
      canDelete: mine || room.chat.canModerate,
      canPin: room.chat.canPin,
      // Mesajdan görev program rolüyle görünür (şirket yöneticisi ya da koordinatör; §10.9).
      canToTask: m.poll == null && ref.read(canCreateTaskProvider),
      canClosePoll: mine && m.poll != null && !m.poll!.isClosed(DateTime.now()),
    );
    if (!mounted) return;
    if (_flash.value == m.id) _flash.value = null;
    switch (a) {
      case null:
        return;
      case ChatActReact(:final reaction):
        unawaited(_try(() => _acts.react(m.id, reaction)));
      case ChatActSimple(:final action):
        switch (action) {
          case ChatSimpleAction.reply:
            _view.reply(m.id);
            _focus.requestFocus();
          case ChatSimpleAction.copy:
            unawaited(Clipboard.setData(ClipboardData(text: m.text)));
            _toast(l.uiMessagesCopied);
          case ChatSimpleAction.edit:
            _view.edit(m.id, revision: m.revision);
            _draft.text = m.text;
            _focus.requestFocus();
          case ChatSimpleAction.pin:
            await _try(() => _acts.togglePin(m.id));
          case ChatSimpleAction.pollResults:
            await showPollResults(context, m);
          case ChatSimpleAction.closePoll:
            await _try(() => _acts.closePoll(m.id));
          case ChatSimpleAction.toTask:
            await _toTask(m);
          case ChatSimpleAction.delete:
            try {
              await _room.delete(m.id);
              if (mounted) _toast(l.uiMessagesDeleted);
            } on ApiError catch (e, st) {
              reportUnexpected(e, st, source: ReportSource.messages);
              if (mounted) _toast(errorText(l, e));
            }
          case ChatSimpleAction.retry:
            await _room.retry(m.clientId);
          case ChatSimpleAction.discard:
            _room.discard(m.clientId);
        }
    }
  }

  /// Mesajdan görev (§10.9): mesajdan daha önce görev açıldıysa önce uyarılır; form başlığı
  /// mesaj metniyle dolar (sunucu boş başlıkta ilk 100 karakteri alır).
  Future<void> _toTask(ChatMessage m) async {
    final l = context.l10n;
    if (m.taskIds.isNotEmpty &&
        !await NzDialog.confirm(
          context,
          title: l.uiMessagesTaskAgainTitle,
          message: l.uiMessagesTaskAgain,
          confirmLabel: l.uiMessagesContinue,
        )) {
      return;
    }
    if (!mounted) return;
    await showNewTaskSheet(
      context,
      resetTarget: true,
      title: String.fromCharCodes(m.text.trim().runes.take(100)),
      chatMessage: ChatTaskSource(chatId: widget.id, messageId: m.id),
    );
  }
}
