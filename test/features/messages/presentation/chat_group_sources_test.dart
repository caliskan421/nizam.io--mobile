import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_page.dart';
import 'package:nizamio/features/messages/messages.dart';
import 'package:nizamio/features/messages/presentation/chat/new_chat_sheet.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../pilot_support.dart';
import '../chat_backend.dart';

final _l = AppLocalizationsTr();

class _Backend extends ChatBackend {
  final creates = <Seen>[];
  final updates = <Seen>[];
  var failCreate = false;
  var source = 'department';
  String? sourceDepartment = 'd1';

  Map<String, Object?> detail() => {
    ...chats.chats.first,
    'role': chats.role,
    'source': source,
    'source_department_id': sourceDepartment,
  };

  @override
  ResponseBody handle(Seen r) {
    if (r.path == '/v1/program/departments') {
      return jsonResponse(200, {
        'departments': [
          {
            'department_id': r.header('X-Nizamio-Program') == 'prog-2'
                ? 'd2'
                : 'd1',
            'display_name': 'Elektrik',
          },
        ],
      });
    }
    if (r.path.endsWith('/members') && !r.path.startsWith('/v1/chats/')) {
      return jsonResponse(200, {'members': <Object>[]});
    }
    if (r.method == 'POST' && r.path == '/v1/chats/groups') {
      creates.add(r);
      if (failCreate) return errorBody(503, 'platform.unavailable');
      return jsonResponse(201, detail());
    }
    if (r.path == '/v1/chats/koord' && r.method == 'GET') {
      return jsonResponse(200, detail());
    }
    if (r.path == '/v1/chats/koord' && r.method == 'PATCH') {
      updates.add(r);
      final body = r.body! as Map<String, Object?>;
      source = body['source']! as String;
      sourceDepartment = body['source_department_id'] as String?;
      return jsonResponse(200, detail());
    }
    return super.handle(r);
  }
}

Future<Harness> _open(
  WidgetTester tester,
  _Backend server, {
  bool info = false,
  double width = 390,
  double scale = 1,
}) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final h = await real(tester, () => pilotHarness(server, signedIn: true));
  h.read(scopeControllerProvider).selectProgram('prog-1');
  await pumpScreen(
    tester,
    h,
    info
        ? const ChatPage(id: 'koord')
        : NzPage(
            title: 'test',
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showNewChatSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
  );
  await settle(tester);
  if (info) {
    await _tap(tester, find.bySemanticsLabel(RegExp(_l.uiMessagesGroupInfo)));
  } else {
    await _tap(tester, find.text('open'));
    await _tap(tester, find.text(_l.uiMessagesNewGroup));
  }
  return h;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder.last);
  await tester.pump();
  await tester.pump();
  await tester.tap(finder.last);
  await settle(tester);
}

Map<String, Object?> _body(Seen r) => r.body! as Map<String, Object?>;

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final width in [390.0, 1024.0]) {
    testWidgets('kaynak formu 2x kullanılır ve iptalde yazmaz: $width', (
      tester,
    ) async {
      final server = _Backend()..chats.role = 'admin';
      await _open(tester, server, width: width, scale: 2);
      await tester.enterText(
        find.widgetWithText(TextField, _l.uiMessagesGroupName),
        'Saha ekibi',
      );
      await _tap(tester, find.text(_l.uiMessagesGroupsSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsDepartment));
      await _tap(tester, find.text(_l.uiMessagesGroupsPickDepartment));
      await _tap(tester, find.text('Elektrik'));
      await _tap(tester, find.text(_l.uiMessagesCancel));
      expect(server.creates, isEmpty);
      expect(tester.takeException(), isNull);

      await _open(tester, server, info: true, width: width, scale: 2);
      await _tap(tester, find.text(_l.uiMessagesGroupsChangeSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsProgram));
      await _tap(tester, find.text(_l.uiMessagesCancel));
      expect(server.updates, isEmpty);
      expect(tester.takeException(), isNull);
      await _tap(tester, find.text(_l.uiMessagesGroupsChangeSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsProgram));
      await _tap(tester, find.text(_l.uiMessagesSave));
      expect(_body(server.updates.single)['source'], 'program');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'kaynak seçimi draft gövdesine gider; belirsiz hatada aynı anahtarla tekrar',
    (tester) async {
      final server = _Backend()..failCreate = true;
      await _open(tester, server);
      await tester.enterText(
        find.widgetWithText(TextField, _l.uiMessagesGroupName),
        'Saha',
      );
      await _tap(tester, find.text(_l.uiMessagesGroupsSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsProgram));
      await _tap(tester, find.text(_l.uiMessagesCreateGroup));
      expect(_body(server.creates.single)['source'], 'program');
      expect(_body(server.creates.single)['source_department_id'], isNull);
      server.failCreate = false;
      await tester.pump(const Duration(seconds: 4));
      await _tap(tester, find.text(_l.uiMessagesCreateGroup));
      expect(
        server.creates.last.header('Idempotency-Key'),
        server.creates.first.header('Idempotency-Key'),
      );
      expect(_body(server.creates.last), _body(server.creates.first));
    },
  );

  testWidgets(
    'koordinatör kaynağı bağlı koordinatörlük ister; program değişimi eski seçimi temizler',
    (tester) async {
      final server = _Backend()
        ..companyAdmin = false
        ..seats = [
          {
            'program_id': 'prog-1',
            'program_name': 'Bir',
            'department_id': 'd1',
            'display_name': 'Elektrik',
            'role': 'koordinator',
          },
          {
            'program_id': 'prog-2',
            'program_name': 'İki',
            'department_id': 'd2',
            'display_name': 'Elektrik',
            'role': 'koordinator',
          },
        ];
      final h = await _open(tester, server);
      await tester.enterText(
        find.widgetWithText(TextField, _l.uiMessagesGroupName),
        'Saha',
      );
      await _tap(tester, find.text(_l.uiMessagesGroupsSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsDepartment));
      await _tap(tester, find.text(_l.uiMessagesCreateGroup));
      expect(server.creates, isEmpty);
      await _tap(tester, find.text(_l.uiMessagesGroupsPickDepartment));
      await _tap(tester, find.text('Elektrik'));
      server.failCreate = true;
      await _tap(tester, find.text(_l.uiMessagesCreateGroup));
      expect(_body(server.creates.single)['source'], 'department');
      expect(_body(server.creates.single)['source_department_id'], 'd1');
      await tester.pump(const Duration(seconds: 4));
      h.read(scopeControllerProvider).selectProgram('prog-2');
      await settle(tester);
      expect(find.text(_l.uiMessagesGroupsManual), findsOneWidget);
      server.failCreate = false;
      await tester.enterText(
        find.widgetWithText(TextField, _l.uiMessagesGroupName),
        'Yeni saha',
      );
      await _tap(tester, find.text(_l.uiMessagesCreateGroup));
      // Create isteğinde kaynak yokluğu sözleşmenin elle üyelik varsayılanıdır.
      expect(_body(server.creates.last)['source'], isNull);
      expect(_body(server.creates.last)['source_department_id'], isNull);
      expect(server.creates.last.header('X-Nizamio-Program'), 'prog-2');
    },
  );

  testWidgets(
    'üye kaynak kuramaz; kurucu kaynak yönetemez; yönetici kapatmayı iptal veya onaylar',
    (tester) async {
      final member = _Backend()
        ..companyAdmin = false
        ..seats = [
          {
            'program_id': 'prog-1',
            'program_name': 'Bir',
            'department_id': 'd1',
            'display_name': 'Elektrik',
            'role': 'uye',
          },
          {
            'program_id': 'prog-2',
            'program_name': 'İki',
            'department_id': 'd2',
            'display_name': 'Mekanik',
            'role': 'koordinator',
          },
        ];
      await _open(tester, member);
      expect(find.text(_l.uiMessagesGroupsSource), findsNothing);
      // Yeni group formundan çıkmak hiçbir yazma yapmaz.
      await tester.binding.handlePopRoute();
      await settle(tester);
      expect(member.creates, isEmpty);

      final founder = _Backend()..chats.role = 'founder';
      await _open(tester, founder, info: true);
      expect(find.text(_l.uiMessagesGroupsChangeSource), findsNothing);
      expect(find.text(_l.uiMessagesGroupsCloseSource), findsNothing);
      expect(find.text(_l.uiMessagesRename), findsOneWidget);

      final admin = _Backend()..chats.role = 'admin';
      await _open(tester, admin, info: true);
      expect(find.textContaining('Elektrik'), findsOneWidget);
      await _tap(tester, find.text(_l.uiMessagesGroupsCloseSource));
      expect(find.text(_l.uiMessagesGroupsCloseConfirm), findsOneWidget);
      await _tap(tester, find.text(_l.uiMessagesCancel));
      expect(admin.updates, isEmpty);
      await _tap(tester, find.text(_l.uiMessagesGroupsCloseSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsCloseSource));
      expect(_body(admin.updates.single)['source'], 'none');
      expect(_body(admin.updates.single)['source_department_id'], isNull);
      await _tap(tester, find.text(_l.uiMessagesGroupsChangeSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsSource));
      await _tap(tester, find.text(_l.uiMessagesGroupsProgram));
      await _tap(tester, find.text(_l.uiMessagesSave));
      expect(_body(admin.updates.last)['source'], 'program');
      expect(_body(admin.updates.last)['source_department_id'], isNull);
    },
  );
}
