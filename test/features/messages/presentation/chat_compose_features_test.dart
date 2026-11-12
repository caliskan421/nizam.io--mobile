import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/features/messages/application/chat_controller.dart';
import 'package:nizamio/features/messages/application/chat_group_sources.dart';
import 'package:nizamio/features/messages/application/chat_share_candidates.dart';
import 'package:nizamio/features/messages/domain/chat.dart';
import 'package:nizamio/features/messages/domain/chat_share_option.dart';
import 'package:nizamio/features/messages/presentation/chat_page.dart';
import 'package:nizamio/features/tasks/domain/task_writes.dart'
    show UploadPicker;
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../pilot_support.dart';
import '../fake_chat_repository.dart';

final _l = AppLocalizationsTr();

Future<(ProviderContainer, FakeChatRepository)> _open(
  WidgetTester tester, {
  double width = 390,
  double scale = 1,
  bool manyShares = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final repo = FakeChatRepository()
    ..getChatResult = ((id) => chat(id, group: true))
    ..server['c1'] = [msg(1, text: 'Yanıtlanacak mesaj')];
  final container = chatContainer(
    repo,
    extra: [
      connectivityStateProvider.overrideWithValue(ConnectivityState.online),
      uploadPickerProvider.overrideWithValue(_Picker()),
      chatGroupSourcesProvider.overrideWith(
        (_) async => const ChatGroupSources(
          departments: [ChatDepartmentOption(id: 'dep-ele', name: 'Elektrik')],
          canCreateSource: true,
        ),
      ),
      chatShareCandidatesProvider.overrideWith(
        (_, query) async => PageSlice(
          items: [
            for (var i = 0; i < (manyShares ? 11 : 1); i++)
              ChatShareOption(
                ref: ChatRefDraft(
                  kind: query.kind,
                  targetId: '${query.kind.name}-id${manyShares ? '-$i' : ''}',
                ),
                label:
                    'Seçilebilir ${query.kind.name}${manyShares ? '-$i' : ''}',
              ),
          ],
        ),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: theme(false),
        locale: const Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: testLocalizationDelegates,
        home: const ChatPage(id: 'c1'),
      ),
    ),
  );
  await settle(tester);
  return (container, repo);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await settle(tester);
}

Finder _field(String label) => find.descendant(
  of: find.widgetWithText(NzTextField, label),
  matching: find.byType(TextField),
);

Future<void> _draft(WidgetTester tester, String text) async {
  await tester.enterText(
    find.descendant(
      of: find.byType(NzComposer),
      matching: find.byType(TextField),
    ),
    text,
  );
  await settle(tester);
}

Future<void> _reference(WidgetTester tester, String label) async {
  await _tap(tester, find.byTooltip(_l.uiMessagesReference));
  await _tap(tester, find.text(label));
}

Future<void> _attach(WidgetTester tester, String label) async {
  await _tap(tester, find.bySemanticsLabel(_l.uiMessagesAttach).last);
  await _tap(tester, find.text(label));
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('ataç ve atıf menüleri ayrı seçenekler açar', (tester) async {
    await _open(tester);
    await _tap(tester, find.bySemanticsLabel(_l.uiMessagesAttach).last);
    expect(find.text(_l.uiMessagesAttachPhotos), findsOneWidget);
    expect(find.text(_l.uiMessagesAttachFile), findsOneWidget);
    expect(find.text(_l.uiMessagesAttachPoll), findsOneWidget);
    expect(find.text(_l.uiMessagesComposeShareTask), findsNothing);
    expect(find.text(_l.uiMessagesComposeShareDepartment), findsNothing);
    expect(find.text(_l.uiMessagesComposeShareFile), findsNothing);
    Navigator.of(tester.element(find.text(_l.uiMessagesAttachFile))).pop();
    await settle(tester);
    await _tap(tester, find.byTooltip(_l.uiMessagesReference));
    expect(find.text(_l.uiMessagesComposeShareTask), findsOneWidget);
    expect(find.text(_l.uiMessagesComposeShareDepartment), findsOneWidget);
    expect(find.text(_l.uiMessagesComposeShareFile), findsOneWidget);
    expect(find.text(_l.uiMessagesAttachPhotos), findsNothing);
    expect(find.text(_l.uiMessagesAttachFile), findsNothing);
    expect(find.text(_l.uiMessagesAttachPoll), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('seçici açıkken düzenlemeye geçilirse atıf taslağa eklenmez', (
    tester,
  ) async {
    final (container, repo) = await _open(tester);
    await _reference(tester, _l.uiMessagesComposeShareTask);
    final view = container.read(chatControllerProvider('c1').notifier);
    view.edit('m1', revision: 0);
    await settle(tester);
    await _tap(tester, find.text('Seçilebilir task'));
    expect(find.byTooltip(_l.uiMessagesReference), findsNothing);
    view.clearContext();
    await _draft(tester, 'Yeni mesaj');
    await _tap(tester, find.bySemanticsLabel(_l.uiMessagesSend).last);
    expect(repo.sent.single.refs, isEmpty);
    expect(repo.sent.single.text, 'Yeni mesaj');
  });

  testWidgets(
    'yalnız paylaşım gönderiminde boş gövde yerine doğal başlık gider',
    (tester) async {
      final (_, repo) = await _open(tester);
      await _reference(tester, _l.uiMessagesComposeShareTask);
      await _tap(tester, find.text('Seçilebilir task'));
      await _tap(tester, find.bySemanticsLabel(_l.uiMessagesSend).last);
      expect(repo.sent.single.text, 'Seçilebilir task');
      expect(repo.sent.single.refs.single.targetId, 'task-id');
    },
  );

  testWidgets(
    'on referanstan sonra paylaşım seçimi kapanır; gönderim sınırı aşmaz',
    (tester) async {
      final (_, repo) = await _open(tester, manyShares: true);
      for (var i = 0; i < chatComposeMaxRefs; i++) {
        await _reference(tester, _l.uiMessagesComposeShareTask);
        await _tap(tester, find.text('Seçilebilir task-$i'));
      }
      await _tap(tester, find.byTooltip(_l.uiMessagesReference));
      final disabled = find.ancestor(
        of: find.text(_l.uiMessagesComposeShareTask),
        matching: find.byType(IgnorePointer),
      );
      expect(tester.widget<IgnorePointer>(disabled.first).ignoring, isTrue);
      Navigator.of(tester.element(find.text(_l.uiMessagesComposeShareTask)))
          .pop();
      await settle(tester);
      await _tap(tester, find.bySemanticsLabel(_l.uiMessagesSend).last);
      expect(repo.sent.single.refs, hasLength(chatComposeMaxRefs));
      expect(
        repo.sent.single.refs.map((r) => r.targetId).toSet(),
        hasLength(chatComposeMaxRefs),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'paylaşım taslağı kaldırılır; yalnız kalan ref ve department mention gönderilir',
    (tester) async {
      final (_, repo) = await _open(tester);
      for (final entry in [
        (ChatRefKind.task, _l.uiMessagesComposeShareTask),
        (ChatRefKind.department, _l.uiMessagesComposeShareDepartment),
        (ChatRefKind.file, _l.uiMessagesComposeShareFile),
      ]) {
        await _reference(tester, entry.$2);
        await _tap(tester, find.text('Seçilebilir ${entry.$1.name}'));
      }
      await _tap(tester, find.byTooltip(_l.uiMessagesComposeRemove).first);
      await _draft(tester, '@Ele');
      await _tap(tester, find.text('@Elektrik'));
      await _tap(tester, find.bySemanticsLabel(_l.uiMessagesSend).last);
      expect(repo.sent, hasLength(1));
      expect(repo.sent.single.refs.map((r) => r.kind), [
        ChatRefKind.department,
        ChatRefKind.file,
      ]);
      expect(repo.sent.single.refs.map((r) => r.targetId), [
        'department-id',
        'file-id',
      ]);
      expect(repo.sent.single.mentions, [
        const ChatMention.department('dep-ele'),
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  for (final width in [390.0, 1024.0]) {
    testWidgets('ek iptal yazmaz; açıklama/yanıt gönderilir ($width, 2x)', (
      tester,
    ) async {
      final (container, repo) = await _open(tester, width: width, scale: 2);
      final view = container.read(chatControllerProvider('c1').notifier);
      view.reply('m1');
      await _draft(tester, 'Taslak açıklama');
      await _attach(tester, _l.uiMessagesAttachFile);
      expect(find.text('Yanıtlanacak mesaj'), findsWidgets);
      await _tap(tester, find.text(_l.uiMessagesCancel));
      expect(repo.uploads, isEmpty);
      expect(container.read(chatControllerProvider('c1')).reply, 'm1');
      await _attach(tester, _l.uiMessagesAttachFile);
      await tester.enterText(
        _field(_l.uiMessagesComposeCaption),
        'Son açıklama',
      );
      await _tap(tester, find.text(_l.uiMessagesSend).last);
      expect(repo.uploads, hasLength(1));
      expect(repo.uploadCaptions, ['Son açıklama']);
      expect(repo.uploadReplies, ['m1']);
      expect(container.read(chatControllerProvider('c1')).reply, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('anket son tarihi UTC; iptal mesaj yazmaz ($width, 2x)', (
      tester,
    ) async {
      final (_, repo) = await _open(tester, width: width, scale: 2);
      await _attach(tester, _l.uiMessagesAttachPoll);
      await _tap(tester, find.text(_l.uiMessagesCancel));
      expect(repo.sent, isEmpty);
      await _attach(tester, _l.uiMessagesAttachPoll);
      await tester.enterText(_field(_l.uiMessagesPollQuestion), 'Ne zaman?');
      await tester.enterText(_field('${_l.uiMessagesPollOption} 1'), 'Bugün');
      await tester.enterText(_field('${_l.uiMessagesPollOption} 2'), 'Yarın');
      await _tap(tester, find.text(_l.uiMessagesComposeClosesAt));
      await _tap(tester, find.text(_l.uiMessagesSend).last);
      expect(repo.sent, hasLength(1));
      expect(repo.sent.single.poll!.closesAt!.isUtc, isTrue);
      expect(repo.sent.single.poll!.closesAt!.isAfter(DateTime.now()), isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}

final class _Picker implements UploadPicker {
  @override
  bool get available => true;

  @override
  Future<UploadSource?> pick(UploadOrigin origin) async => const UploadSource(
    path: '/test/rapor.pdf',
    name: 'rapor.pdf',
    sizeBytes: 10,
  );
}
