// Gerçek yönlendirici + StatefulNavigationShell açıkken pencere yeniden boyutlanır (pencere
// sınıfı sınırları, tablet dönüşü, dar bölünmüş görünüm): aynı uygulama, aynı sağlayıcı
// kapsayıcısı. Kabuk sekme gövdesini alt menüden raya taşırken sekme sayfasının State'i,
// denetleyici durumu, metin denetleyicileri ve kaydırma konumu korunur; veri yeniden çekilmez.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/router/router.dart';
import 'package:nizamio/app/router/shell.dart';
import 'package:nizamio/core/app_phase.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_pick_record.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_search_field.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_tablet_rail.dart';
import 'package:nizamio/features/archive/application/archive_controller.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/archive/domain/archive.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../features/archive/archive_fixture.dart';
import '../../features/pilot_support.dart' show pilotHarness, real;
import 'router_test_support.dart';

final _l = AppLocalizationsTr();

/// Başlangıç kaydırma konumu (arama alanı her boyutta kurulu kalır).
const _offset = 100.0;

void main() {
  setUpFonts();

  testWidgets(
    'arşiv sekmesi yeniden boyutlanmada State, arama, kaydırma ve tek yüklemeyi korur',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(599, 700);
      addTearDown(tester.view.reset);
      // Taşan içerik için çok sayıda klasör (sunucu yanıtı sahte depodan).
      final repo = FakeArchiveRepository()
        ..folders = [
          for (var i = 0; i < 12; i++)
            ArchiveFolder(code: 'd$i', name: 'Klasör $i', files: i),
        ];
      // Klasör ızgarası yönetici görünümünde (koordinatör düz görev klasörü listesini görür).
      final harness = await real(
        tester,
        () => pilotHarness(archiveBackend(admin: true), signedIn: true),
      );
      // Port, get_it kaydından tembel okunur (archiveOverrides): ilk okumadan önce değiştirilir.
      useArchiveFakes(harness, repo);
      harness.read(scopeControllerProvider).selectProgram('prog-1');
      int loads() => repo.calls.where((c) => c.$1 == 'folders').length;
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      final router = createRouter(phase);
      addTearDown(router.dispose);
      await pumpRouterWidget(tester, router, harness: harness);
      await settle(tester);
      router.go('/archive');
      await settle(tester);
      expect(locationOf(router), '/archive');
      expect(loads(), 1);

      final page = find.byType(ArchivePage);
      Finder inPage(Finder f) => find.descendant(of: page, matching: f);
      Future<void> tap(Finder f) async {
        await tester.ensureVisible(f);
        await tester.pump();
        await tester.tap(f);
        await settle(tester);
      }

      // Anlamlı süzgeç: arama sorgusu, hazır etiket, sıralama, açık etiket paneli, etiket taslağı.
      await tap(inPage(find.byIcon(Icons.search_rounded)).first);
      final searchField = inPage(
        find.descendant(
          of: find.byType(NzSearchField),
          matching: find.byType(TextField),
        ),
      );
      await tester.enterText(searchField, 'k');
      await settle(tester);
      final view = harness.read(archiveControllerProvider);
      expect(view.query, 'k');
      final caption = inPage(find.textContaining(_l.uiArchiveFoldersTitle));
      final captionText = tester.widget<Text>(caption).data;

      final state = tester.state(page);
      final shell = tester.state(find.byType(NzAdaptiveShell));
      final search = tester.widget<TextField>(searchField).controller!;
      ScrollPosition position() => tester
          .state<ScrollableState>(inPage(find.byType(Scrollable)).first)
          .position;
      // Kaydırma önkoşulu: içerik taşar ve konum sıfırdan farklıdır. Konum, alanlar tembel
      // listede kurulu kalacak kadar küçüktür (kimlikleri her boyutta okunur). Tablet sol
      // bölmesinde kök üst çubuk gizli olduğundan içerik ~70 px yukarıdadır.
      expect(position().maxScrollExtent, greaterThan(200));
      position().jumpTo(_offset);
      await tester.pump();
      var offset = position().pixels;
      expect(offset, greaterThan(0));

      // Pencere sınıfı sınırları, tablet yatay → dikey, dar bölünmüş görünüm ve geri.
      var kept = 0;
      var clamped = 0;
      for (final size in const [
        Size(600, 700),
        Size(839, 700),
        Size(840, 700),
        Size(599, 700),
        Size(1180, 820),
        Size(820, 1180),
        Size(1180, 820),
        Size(375, 820),
        Size(1180, 820),
        Size(820, 1180),
      ]) {
        // Dikey tablette içerik sığar (konum 0); taşan ilk boyutta konum yeniden kurulur.
        if (offset == 0 && position().maxScrollExtent > 0) {
          position().jumpTo(position().maxScrollExtent.clamp(0, _offset));
          await tester.pump();
          offset = position().pixels;
        }
        tester.view.physicalSize = size;
        await settle(tester);
        final why = 'boyut $size';
        expect(tester.takeException(), isNull, reason: why);
        expect(
          find.byType(NzFloatingNav),
          size.width < 600 ? findsOneWidget : findsNothing,
          reason: why,
        );
        expect(
          find.byType(NzTabletRail),
          size.width < 600 ? findsNothing : findsOneWidget,
          reason: why,
        );
        // Klasör açılmadığında arşiv listesi tam genişliktedir.
        expect(find.byType(NzPickRecord), findsNothing, reason: why);
        expect(find.byType(ArchiveFolderPage), findsNothing, reason: why);
        expect(locationOf(router), '/archive', reason: why);
        expect(tester.state(find.byType(NzAdaptiveShell)), same(shell));
        expect(tester.state(page), same(state), reason: why);
        expect(
          tester.widget<TextField>(searchField).controller,
          same(search),
          reason: why,
        );
        expect(search.text, 'k', reason: why);
        expect(harness.read(archiveControllerProvider), same(view));
        expect(tester.widget<Text>(caption).data, captionText, reason: why);
        // Konum korunur; yeni içerik daha kısaysa yeni sınıra sıkıştırılır.
        final p = position();
        final expected = offset.clamp(p.minScrollExtent, p.maxScrollExtent);
        expect(p.pixels, closeTo(expected, 0.01), reason: why);
        if (expected > 0 && expected == offset) kept++;
        if (expected < offset) clamped++;
        offset = p.pixels;
        expect(loads(), 1, reason: why);
      }
      // Kanıtın boş olmadığı: sıfırdan farklı konum birebir korundu ve kısalan içerikte sıkıştı.
      expect(kept, greaterThan(0));
      expect(clamped, greaterThan(0));
    },
  );
}
