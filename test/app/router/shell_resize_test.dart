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
import 'package:nizamio/core/ui/widgets/inputs/nz_search_field.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_floating_nav.dart';
import 'package:nizamio/core/ui/widgets/navigation/nz_tablet_rail.dart';
import 'package:nizamio/features/archive/application/archive_controller.dart';
import 'package:nizamio/features/archive/archive.dart';
import 'package:nizamio/features/archive/data/sample/sample_archive_repository.dart';
import 'package:nizamio/features/archive/domain/archive.dart';

import '../../core/ui/widgets/feedback/feedback_test_support.dart';
import '../../support/harness.dart';
import 'router_test_support.dart';

final _l = AppLocalizationsTr();

/// Başlangıç kaydırma konumu (arama ve etiket alanları her boyutta kurulu kalır).
const _offset = 100.0;

/// Gerçek örnek depoyu sayan sarmalayıcı (yalnız test; üretim modülü değişmez).
final class _CountingArchiveRepository implements ArchiveRepository {
  var loads = 0;

  @override
  Future<List<ArchiveFolder>> loadFolders() {
    loads++;
    return const SampleArchiveRepository().loadFolders();
  }
}

void main() {
  setUpFonts();

  testWidgets(
    'arşiv sekmesi yeniden boyutlanmada State, süzgeç, metin, kaydırma ve tek yüklemeyi korur',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(599, 700);
      addTearDown(tester.view.reset);
      final repo = _CountingArchiveRepository();
      final harness = Harness();
      addTearDown(harness.dispose);
      // Port, get_it kaydından tembel okunur (archiveOverrides): ilk okumadan önce değiştirilir.
      harness.composition.locator
        ..unregister<ArchiveRepository>()
        ..registerSingleton<ArchiveRepository>(repo);
      final phase = ValueNotifier(AppPhase.scoped);
      addTearDown(phase.dispose);
      final router = createRouter(phase);
      addTearDown(router.dispose);
      await pumpRouterWidget(tester, router, harness: harness);
      await settle(tester);
      router.go('/archive');
      await settle(tester);
      expect(locationOf(router), '/archive');
      expect(repo.loads, 1);

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
      await tester.enterText(searchField, 'i');
      await settle(tester);
      await tap(inPage(find.text(_l.uiArchiveSortRecent)));
      await tap(inPage(find.text('${_l.uiArchiveTags} · 3')));
      await tap(
        inPage(find.bySemanticsLabel(RegExp('^${_l.uiArchiveTagField} '))),
      );
      final draftField = inPage(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == _l.uiArchiveNewTag,
        ),
      );
      await tester.enterText(draftField, 'Taslak etiket');
      await settle(tester);
      final view = harness.read(archiveControllerProvider);
      expect(view.query, 'i');
      expect(view.sort, ArchiveSort.name);
      expect(view.tag, ArchiveTag.field);
      expect(view.tagsOpen, isTrue);
      final caption = inPage(
        find.textContaining(_l.uiArchiveCoordinatorshipsLc),
      );
      final captionText = tester.widget<Text>(caption).data;

      final state = tester.state(page);
      final shell = tester.state(find.byType(NzAdaptiveShell));
      final search = tester.widget<TextField>(searchField).controller!;
      final draft = tester.widget<TextField>(draftField).controller!;
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
        // ≥ 840: arşiv listesi sol bölmede, sağda modül varsayılanı (klasör).
        expect(
          find.byType(ArchiveFolderPage),
          size.width >= 840 ? findsOneWidget : findsNothing,
          reason: why,
        );
        expect(locationOf(router), '/archive', reason: why);
        expect(tester.state(find.byType(NzAdaptiveShell)), same(shell));
        expect(tester.state(page), same(state), reason: why);
        expect(
          tester.widget<TextField>(searchField).controller,
          same(search),
          reason: why,
        );
        expect(search.text, 'i', reason: why);
        expect(
          tester.widget<TextField>(draftField).controller,
          same(draft),
          reason: why,
        );
        expect(draft.text, 'Taslak etiket', reason: why);
        expect(harness.read(archiveControllerProvider), same(view));
        expect(tester.widget<Text>(caption).data, captionText, reason: why);
        // Konum korunur; yeni içerik daha kısaysa yeni sınıra sıkıştırılır.
        final p = position();
        final expected = offset.clamp(p.minScrollExtent, p.maxScrollExtent);
        expect(p.pixels, closeTo(expected, 0.01), reason: why);
        if (expected > 0 && expected == offset) kept++;
        if (expected < offset) clamped++;
        offset = p.pixels;
        expect(repo.loads, 1, reason: why);
      }
      // Kanıtın boş olmadığı: sıfırdan farklı konum birebir korundu ve kısalan içerikte sıkıştı.
      expect(kept, greaterThanOrEqualTo(4));
      expect(clamped, greaterThanOrEqualTo(2));
    },
  );
}
