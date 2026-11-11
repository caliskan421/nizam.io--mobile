// Toplantı listesi ve ayrıntısı: dar ekran × 2.0 metin taşma yok (bütün sekme ve bölümler),
// kart dokunuşu ayrıntıyı kimlikle açar, yönetici olmayana Silinenler sekmesi çıkmaz.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/meetings/meetings.dart';

import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';
import '../meetings_server.dart';

final _l = AppLocalizationsTr();

Future<void> _tap(WidgetTester tester, Finder finder) async {
  final f = finder.first;
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

void _screen(WidgetTester tester, double width, double scale) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
}

MeetingsServer _server() => MeetingsServer()
  ..pages = [
    [
      meetingWire(
        id: 'm1',
        title: 'Haftalık koordinasyon toplantısı ve saha keşfi bulguları',
        departments: const ['d1', 'd2', 'd3', 'd4', 'd5', 'd6'],
      ),
      meetingWire(id: 'm2', date: '2020-03-01T08:00:00Z'),
    ],
  ]
  ..deleted = [meetingWire(id: 'mx', deletedAt: '2026-10-18T09:00:00Z')]
  ..notes = [
    noteWire('n1', content: 'Saha teslim listesi cuma akşamına kadar.'),
    noteWire('n2', author: 'acc-2', role: 'member', task: 'w9'),
  ];

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('klavye açılınca gündem alanı ve ekleme eylemi görünür', (
    tester,
  ) async {
    _screen(tester, 390, 1);
    final server = _server()..agenda.add(agendaWire('g3', order: 3));
    final (h, _) = await real(tester, () => openMeetings(server));
    await pumpScreen(tester, h, const MeetingPage(id: 'm1'));
    await settle(tester);
    final field = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == _l.uiMeetingsAgendaAdd,
    );
    await _tap(tester, field);
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    tester.binding.handleMetricsChanged();
    await settle(tester);
    expect(tester.getBottomLeft(field).dy, lessThanOrEqualTo(524));
    expect(
      tester.getBottomLeft(find.text(_l.uiMeetingsAdd)).dy,
      lessThanOrEqualTo(524),
    );
    expect(tester.takeException(), isNull);
  });

  for (final width in [390.0, 800.0]) {
    testWidgets('not yazma ve düzenleme klavye üstünde kalır: $width', (
      tester,
    ) async {
      _screen(tester, width, 1);
      final (h, _) = await real(tester, () => openMeetings(_server()));
      await pumpScreen(tester, h, const MeetingPage(id: 'm1'));
      await settle(tester);
      await _tap(tester, find.textContaining(_l.uiMeetingsTabNotes));
      final field = find.byWidgetPredicate(
        (w) =>
            w is TextField && w.decoration?.hintText == _l.uiMeetingsNoteHint,
      );
      await _tap(tester, field);
      tester.view.viewInsets = const FakeViewPadding(bottom: 320);
      tester.binding.handleMetricsChanged();
      await settle(tester);
      expect(
        tester.getBottomLeft(find.text(_l.uiMeetingsAdd)).dy,
        lessThanOrEqualTo(524),
      );
      tester.view.viewInsets = FakeViewPadding.zero;
      tester.binding.handleMetricsChanged();
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester);
      await _tap(tester, find.bySemanticsLabel(_l.uiMeetingsNoteEdit).first);
      final edit = find.byType(TextFormField).last;
      await _tap(tester, edit);
      tester.view.viewInsets = const FakeViewPadding(bottom: 320);
      tester.binding.handleMetricsChanged();
      await settle(tester);
      expect(
        tester.getBottomLeft(find.text(_l.uiMeetingsSave)).dy,
        lessThanOrEqualTo(524),
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final (width, scale) in [(360.0, 2.0), (390.0, 1.0)]) {
    testWidgets('liste: taşma yok ${width.toInt()} × $scale; kart → ayrıntı', (
      tester,
    ) async {
      _screen(tester, width, scale);
      final (h, _) = await real(tester, () => openMeetings(_server()));
      final nav = RecordingAppNav();
      await pumpScreen(tester, h, const MeetingsPage(), nav: nav);
      await settle(tester);
      await _tap(tester, find.bySemanticsLabel(_l.uiMeetingsSearch));
      await _tap(tester, find.textContaining(_l.uiMeetingsTabPast));
      await _tap(tester, find.textContaining(_l.uiMeetingsTabDeleted));
      expect(find.text(_l.uiMeetingsRestore), findsOneWidget);
      await _tap(tester, find.textContaining(_l.uiMeetingsTabUpcoming));
      await _tap(tester, find.textContaining('Haftalık koordinasyon'));
      expect(nav.calls, ['meeting:m1']);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'ayrıntı: taşma yok ${width.toInt()} × $scale; bütün bölümler',
      (tester) async {
        _screen(tester, width, scale);
        final (h, _) = await real(tester, () => openMeetings(_server()));
        await pumpScreen(tester, h, const MeetingPage(id: 'm1'));
        await settle(tester);
        expect(find.text(_l.uiMeetingsConfStart), findsOneWidget);
        for (final s in [
          _l.uiMeetingsTabNotes,
          _l.uiMeetingsTabPeople,
          _l.uiMeetingsTabInfo,
          _l.uiMeetingsTabAgenda,
        ]) {
          await _tap(tester, find.textContaining(s));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('not: uçuşta yazılan yeni metin geç gelen başarıyla silinmez', (
    tester,
  ) async {
    _screen(tester, 390, 1);
    final s = _server();
    final (h, _) = await real(tester, () => openMeetings(s));
    await pumpScreen(tester, h, const MeetingPage(id: 'm1'));
    await settle(tester);
    await _tap(tester, find.textContaining(_l.uiMeetingsTabNotes));
    final field = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == _l.uiMeetingsNoteHint,
    );
    await tester.enterText(field, 'Birinci not');
    await tester.pump();
    s.hold = Completer();
    await _tap(tester, find.text(_l.uiMeetingsAdd));
    // Uçuşta alan kilitli değil: kullanıcı ikinci notu yazmaya başlar.
    await tester.enterText(field, 'İkinci not taslağı');
    await tester.pump();
    s.hold!.complete();
    await settle(tester);
    expect(
      tester.widget<TextField>(field).controller!.text,
      'İkinci not taslağı',
      reason: 'A başarısı B taslağını silmez',
    );
    expect(find.textContaining('Birinci not'), findsWidgets);
  });

  testWidgets('not: alan değişmediyse başarıda taslak temizlenir', (
    tester,
  ) async {
    _screen(tester, 390, 1);
    final (h, _) = await real(tester, () => openMeetings(_server()));
    await pumpScreen(tester, h, const MeetingPage(id: 'm1'));
    await settle(tester);
    await _tap(tester, find.textContaining(_l.uiMeetingsTabNotes));
    final field = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.hintText == _l.uiMeetingsNoteHint,
    );
    await tester.enterText(field, 'Tek not');
    await tester.pump();
    await _tap(tester, find.text(_l.uiMeetingsAdd));
    await settle(tester);
    expect(tester.widget<TextField>(field).controller!.text, isEmpty);
  });

  testWidgets('yönetici olmayana Silinenler sekmesi yok', (tester) async {
    _screen(tester, 390, 1);
    final (h, _) = await real(
      tester,
      () => openMeetings(MeetingsServer(admin: false, seat: 'koordinator')),
    );
    await pumpScreen(tester, h, const MeetingsPage());
    await settle(tester);
    expect(find.textContaining(_l.uiMeetingsTabUpcoming), findsOneWidget);
    expect(find.textContaining(_l.uiMeetingsTabDeleted), findsNothing);
  });
}
