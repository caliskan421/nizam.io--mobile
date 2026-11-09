// Konferans kartı: açık ekranda taze bağlı kişi görüntüsü eşik anında (3 dk) kendiliğinden
// eski duruma geçer (avatarlar kalkar, "X dk önce" yazılır); tek seferlik zamanlayıcı kart
// kapanınca iptal edilir (bekleyen zamanlayıcı kalırsa test çerçevesi düşer).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/ui/widgets/surfaces/nz_avatar_stack.dart';
import 'package:nizamio/features/meetings/application/meeting_room_controller.dart';
import 'package:nizamio/features/meetings/presentation/meeting_hero.dart';
import 'package:nizamio/features/meetings/presentation/meeting_page.dart';

import '../../pilot_support.dart';
import '../meetings_server.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('bağlı kişi görüntüsü eşikte kendiliğinden eskir', (
    tester,
  ) async {
    final s = MeetingsServer()
      ..conference = conferenceWire(connected: ['acc-1']);
    final (h, c) = await real(tester, () => openMeetings(s));
    final room = meetingRoomControllerProvider('m1');
    // Sağlayıcı gerçek zaman bölgesinde kurulur (istekleri orada tamamlanır).
    final r = await real(tester, () {
      c.listen(room, (_, _) {});
      return c.read(room.future);
    });
    // Gözlem 07:00Z; kart 07:01'de açılır (taze).
    var now = DateTime.utc(2026, 11, 3, 7, 1);
    Widget card() => Consumer(
      builder: (context, ref, _) => MeetingConferenceCard(
        room: r,
        actions: MeetingActions(context, ref, 'm1'),
        clock: () => now,
      ),
    );
    await pumpScreen(tester, h, card());
    expect(find.byType(NzAvatarStack), findsOneWidget);
    expect(find.textContaining('dk önce'), findsNothing);

    // Eşik geçer: yeniden okuma ya da yoklama olmadan kart eskir.
    now = DateTime.utc(2026, 11, 3, 7, 4);
    await tester.pump(const Duration(minutes: 2, seconds: 1));
    await tester.pump();
    expect(find.byType(NzAvatarStack), findsNothing);
    expect(find.textContaining('4 dk önce'), findsOneWidget);

    // Taze kart kapanır: zamanlayıcı iptal edilir.
    now = DateTime.utc(2026, 11, 3, 7, 1);
    await pumpScreen(tester, h, card());
    await tester.pumpWidget(const SizedBox());
  });
}
