// Görüşme ekranı (sahte oda bağı, gerçek bileşim kökü ve sahte toplantı sunucusu): kamerasız
// cihazda (simülatör) çökmeden avatar karolarıyla açılır ve açıklama gösterir; panel "görüşmede"
// kişileri listeler; yetkili ayrılırken "yalnız ayrıl" seçilince oda bırakılır, istek gitmez.
// Telefon ve tablette taşma yok. Görsel/piksel denetimi yapılmaz.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/features/meetings/application/active_conference.dart';
import 'package:nizamio/features/meetings/application/conference_controller.dart';
import 'package:nizamio/features/meetings/application/meeting_room_controller.dart';
import 'package:nizamio/features/meetings/domain/conference.dart';
import 'package:nizamio/features/meetings/presentation/conference_page.dart';
import 'package:nizamio/features/meetings/presentation/conference_tiles.dart';

import '../../../support/recording_app_nav.dart';
import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';
import '../meetings_server.dart';

class _Link implements ConferenceLink {
  final calls = <String>[];
  @override
  Stream<ConferenceSignal> get signals => const Stream.empty();

  @override
  List<ConferencePeer> get peers => const [
    ConferencePeer(id: 'acc-1', name: '', isLocal: true, micOn: true),
    ConferencePeer(
      id: 'acc-2',
      name: 'Abdullah Ateş',
      isLocal: false,
      micOn: true,
      speaking: true,
    ),
  ];

  @override
  Future<void> connect(String url, String token) async => calls.add('connect');

  @override
  Future<MediaIssue?> setMicrophone(bool on) async => null;

  // Simülatör: kamera yok.
  @override
  Future<MediaIssue?> setCamera(bool on) async =>
      on ? MediaIssue.unavailable : null;

  @override
  Future<void> flipCamera() async {}

  @override
  Future<void> leave() async => calls.add('leave');
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final screen in [screenMatrix.first, screenMatrix.last]) {
    testWidgets('kamerasız görüşme ekranı · ${screen.name}', (tester) async {
      useScreen(tester, screen);
      final s = MeetingsServer()..conference = conferenceWire();
      final (h, c) = await real(tester, () => openMeetings(s));
      final link = _Link();
      h.composition.locator
        ..unregister<ConferenceLink>()
        ..registerFactory<ConferenceLink>(() => link);
      await real(tester, () {
        c.listen(meetingRoomControllerProvider('m1'), (_, _) {});
        return c.read(meetingRoomControllerProvider('m1').future);
      });
      final nav = RecordingAppNav();
      await pumpScreen(tester, h, const ConferencePage(id: 'm1'), nav: nav);
      await settle(tester);

      expect(
        c.read(conferenceControllerProvider('m1')).phase,
        ConferencePhase.connected,
      );
      expect(c.read(activeConferenceControllerProvider).docked, isNull);
      expect(find.byType(ConferenceTile), findsNWidgets(2));
      expect(find.textContaining('kullanılabilir kamera yok'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.bySemanticsLabel('Gündem, notlar ve kişiler').last);
      await settle(tester);
      expect(find.text('görüşmede'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Telefonda panel alt sayfadır, çubuğu örter: kapatılır.
      await tester.tap(find.bySemanticsLabel('Paneli kapat').last);
      await settle(tester);
      expect(find.text('görüşmede'), findsNothing);

      // Yetkili (host): ayrıl → seçim sayfası → yalnız ayrıl.
      await tester.tap(find.bySemanticsLabel('Herkes için bitir').first);
      await settle(tester);
      await tester.tap(find.text('Ayrıl').last);
      await settle(tester);
      expect(link.calls, ['connect', 'leave']);
      expect(calls(h), isNot(contains('DELETE /v1/meetings/m1/conference')));
      expect(c.read(activeConferenceControllerProvider).inCall, isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
