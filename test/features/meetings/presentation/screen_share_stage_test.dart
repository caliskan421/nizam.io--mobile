// Ekran paylaşımı sahnesi (sahte oda bağı, gerçek bileşim kökü, sahte toplantı sunucusu): uzak
// kişi paylaşırken paylaşım sahnesi ızgaranın yerini alır; kendi paylaşımında "bitir" düğmesi
// bağa paylaşımı kapatma isteği gönderir ve yerleşim normale döner. Bütün ekran boyutlarında
// taşma yok. Görsel/piksel denetimi yapılmaz.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/features/meetings/application/meeting_room_controller.dart';
import 'package:nizamio/features/meetings/domain/conference.dart';
import 'package:nizamio/features/meetings/presentation/conference_page.dart';
import 'package:nizamio/features/meetings/presentation/conference_tiles.dart';
import 'package:nizamio/features/meetings/presentation/screen_share_stage.dart';

import '../../../support/recording_app_nav.dart';
import '../../../support/screen_matrix.dart';
import '../../pilot_support.dart';
import '../meetings_server.dart';

class _Link implements ConferenceLink {
  _Link({required this.remoteSharing});

  final bool remoteSharing;
  final calls = <String>[];
  bool localSharing = false;

  @override
  Stream<ConferenceSignal> get signals => const Stream.empty();

  @override
  List<ConferencePeer> get peers => [
    ConferencePeer(
      id: 'acc-1',
      name: '',
      isLocal: true,
      micOn: true,
      screenSharing: localSharing,
    ),
    ConferencePeer(
      id: 'acc-2',
      name: 'Abdullah Ateş',
      isLocal: false,
      micOn: true,
      screenSharing: remoteSharing,
    ),
    const ConferencePeer(id: 'acc-3', name: 'Bahar Kılıç', isLocal: false),
  ];

  @override
  Future<void> connect(String url, String token) async => calls.add('connect');

  @override
  Future<MediaIssue?> setMicrophone(bool on) async => null;

  @override
  Future<MediaIssue?> setCamera(bool on) async => null;

  @override
  Future<bool> screenShareAvailable() async => true;

  @override
  Future<MediaIssue?> setScreenShare(bool on) async {
    calls.add('share:$on');
    localSharing = on;
    return null;
  }

  @override
  Future<void> flipCamera() async {}

  @override
  Future<void> leave() async => calls.add('leave');
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<_Link> open(WidgetTester tester, {required bool remote}) async {
    final s = MeetingsServer()..conference = conferenceWire();
    final (h, c) = await real(tester, () => openMeetings(s));
    final link = _Link(remoteSharing: remote);
    h.composition.locator
      ..unregister<ConferenceLink>()
      ..registerFactory<ConferenceLink>(() => link);
    await real(tester, () {
      c.listen(meetingRoomControllerProvider('m1'), (_, _) {});
      return c.read(meetingRoomControllerProvider('m1').future);
    });
    await pumpScreen(
      tester,
      h,
      const ConferencePage(id: 'm1'),
      nav: RecordingAppNav(),
    );
    await settle(tester);
    return link;
  }

  for (final screen in screenMatrix) {
    testWidgets('uzak paylaşım sahnesi · ${screen.name}', (tester) async {
      useScreen(tester, screen);
      await open(tester, remote: true);
      expect(find.byType(ScreenShareStage), findsOneWidget);
      expect(find.byType(ConferenceGrid), findsNothing);
      expect(find.textContaining('ekranını paylaşıyor'), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('kendi paylaşımı: bitir → normal · ${screen.name}', (
      tester,
    ) async {
      useScreen(tester, screen);
      final link = await open(tester, remote: false);
      expect(find.byType(ScreenShareStage), findsNothing);

      await tester.tap(find.bySemanticsLabel('Ekranını paylaş').last);
      await settle(tester);
      expect(link.calls, contains('share:true'));
      expect(find.byType(ScreenShareStage), findsOneWidget);
      expect(find.text('Ekranını paylaşıyorsun'), findsWidgets);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Paylaşımı bitir').first);
      await settle(tester);
      expect(link.calls, contains('share:false'));
      expect(find.byType(ScreenShareStage), findsNothing);
      expect(find.byType(ConferenceGrid), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
