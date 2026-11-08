// Tablet değişmez (invariant) sahneleri: ekran görüntüsü almaz; kaynak gezinme/durum kurallarını
// (seçim, taslak, sağ yığın, liste arama metni) uygulamanın gerçek UI'sinden sınar. Görev ve
// koordinatörlük verisi [TabletBackend]'in sunucu biçimli fikstüründen gelir (örnek mod yok);
// mesajlar ve arşiv klasörleri modüllerin bugünkü kayıtlı deposundan (GEÇİCİ geliştirme
// örneği, `messages_module.dart`, `archive_module.dart`). Piksel/yerleşim ölçüsü ve veri sayısı
// iddiası içermez (CLAUDE.md test kapsamı); bölme geometrisi `tablet_measurements_test.dart`
// "ölçüye göre bölme" grubundadır.
//
// Modül kökü kuralı (`split.dart` `restoresLastRecord`): Görevler ve Koordinatörlükler son açılan
// kaydı geri getirmez (liste tam genişlik, sağ bölme yok); Arşiv ve Mesajlar son kaydı geri
// getirir, hiç açılmamışsa sağ bölme "Bir kayıt seç".
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/ui/layout/nz_pane.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_pick_record.dart';
import 'package:nizamio/core/ui/widgets/inputs/nz_composer.dart';
import 'package:nizamio/features/timeline/presentation/gantt/gantt_chart.dart'
    show GanttChart;

import '../features/coordinatorships/coord_backend.dart' show tAltLate30;
import 'tablet_harness.dart';

final _l = AppLocalizationsTr();

/// Fikstür görevleri ([TabletBackend] → `CoordBackend.workItems`).
const _hidrofor = 'Hidrofor montajı';
const _iletim = 'İletim hattı yapımı';
const _aritma = 'Arıtma devreye alma';

/// Mesajlar modülünde varsayılan olarak açılan sohbet (k1/k2 mesajlarını taşır).
const tabletChat = 'Koordinatörler';

/// Modül kökünün sağ bölme varsayılanı (kayıt açılmamış ya da modül son kaydı getirmez).
void expectModuleRoot(TabletSession s, TabletModule m) {
  expect(
    s.pane(NzPaneRole.master),
    findsOneWidget,
    reason: '${m.name} listesi',
  );
  switch (m) {
    case TabletModule.tasks || TabletModule.coordinatorships:
      expect(
        s.pane(NzPaneRole.detail),
        findsNothing,
        reason: '${m.name}: açık kayıt yok → liste tam genişlik, sağ bölme yok',
      );
    case TabletModule.home ||
        TabletModule.calendar ||
        TabletModule.archive ||
        TabletModule.messages:
      expect(
        s.inPane(NzPaneRole.detail, find.byType(NzPickRecord)),
        findsOneWidget,
        reason: '${m.name}: sağ bölme "${_l.uiRouterPickTitle}"',
      );
  }
}

/// Mesajlar → [tabletChat] sohbetini listeden açar.
Future<void> openTabletChat(TabletSession s) async {
  await s.tapRail(TabletModule.messages);
  expectModuleRoot(s, TabletModule.messages);
  await s.tapText(s.inPane(NzPaneRole.master, find.text(tabletChat)));
  expect(inChat(find.textContaining('trafo onayı')), findsWidgets);
}

Finder _composerField() => find.descendant(
  of: find.byType(NzComposer),
  matching: find.byType(TextField),
);

String _draft(TabletSession s) =>
    s.tester.widget<TextField>(_composerField().last).controller!.text;

Finder get _gantt => find.byType(GanttChart);

/// Gantt üst çubuğundaki "Liste" anahtarı: çizelgeyi kapatıp Görevler listesine döner.
Future<void> _closeTimeline(TabletSession s) =>
    s.tapText(find.bySemanticsLabel(_l.uiTasksModeList));

void _expectTimelineOpen(TabletSession s) {
  expect(_gantt, findsOneWidget, reason: 'Gantt açık');
  expect(s.pane(NzPaneRole.master), findsNothing, reason: 'Gantt tam genişlik');
  expect(s.railRect, isNotNull, reason: 'ray görünür');
}

final tabletInvariantScenes = <TabletScene>[
  // --- Modül değişimi: Arşiv/Mesajlar son yüklenen kaydı geri getirir, Koordinatörlükler getirmez
  TabletScene('nav-module-roundtrip-keeps-last-loaded-record', (s) async {
    await s.tapRail(TabletModule.archive);
    expectModuleRoot(s, TabletModule.archive);
    await s.tapText(s.inPane(NzPaneRole.master, find.text('Operasyon')));
    expect(
      s.inPane(NzPaneRole.detail, find.text('Operasyon')),
      findsWidgets,
      reason: 'seçilen klasör sağda',
    );
    await s.tapRail(TabletModule.messages);
    expectModuleRoot(s, TabletModule.messages);
    await s.tapRail(TabletModule.archive);
    expect(
      s.inPane(NzPaneRole.detail, find.text('Operasyon')),
      findsWidgets,
      reason: 'arşiv dönüşünde son yüklenen klasör (varsayılana sıfırlanmaz)',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.byType(NzPickRecord)),
      findsNothing,
    );
    expect(paneBack(s), findsNothing, reason: 'sağ yığın tek giriş');
    // Koordinatörlük kaydı modül dönüşünde geri gelmez: liste tam genişlik açılır.
    await s.tapRail(TabletModule.coordinatorships);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Elektrik ve enerji')),
    );
    expect(
      s.inPane(NzPaneRole.detail, find.text('Elektrik ve enerji')),
      findsWidgets,
    );
    await s.tapRail(TabletModule.archive);
    await s.tapRail(TabletModule.coordinatorships);
    expectModuleRoot(s, TabletModule.coordinatorships);
  }),
  // --- Liste (master) alt durumu modül gidiş-dönüşünde kalır: arama metni ve süzgeç
  TabletScene('master-search-survives-module-roundtrip', (s) async {
    await s.tapRail(TabletModule.tasks);
    expectModuleRoot(s, TabletModule.tasks);
    for (final t in [_hidrofor, _aritma]) {
      expect(s.inPane(NzPaneRole.master, find.text(t)), findsWidgets);
    }
    await s.tapText(find.bySemanticsLabel(_l.uiTasksSearch));
    final field = s.inPane(NzPaneRole.master, find.byType(TextField));
    await s.tester.enterText(field.first, 'Arıtma');
    await s.settle();
    expect(s.inPane(NzPaneRole.master, find.text(_aritma)), findsWidgets);
    expect(s.inPane(NzPaneRole.master, find.text(_hidrofor)), findsNothing);
    await s.tapRail(TabletModule.archive);
    await s.tapRail(TabletModule.tasks);
    final texts = s
        .inPane(NzPaneRole.master, find.byType(EditableText))
        .evaluate()
        .map((e) => (e.widget as EditableText).controller.text)
        .toList();
    expect(
      texts,
      contains('Arıtma'),
      reason: 'arama metni modül dönüşünde kalır',
    );
    expect(
      s.inPane(NzPaneRole.master, find.text(_aritma)),
      findsWidgets,
      reason: 'liste hâlâ süzülü',
    );
    expect(
      s.inPane(NzPaneRole.master, find.text(_hidrofor)),
      findsNothing,
      reason: 'süzgeç uygulanır',
    );
  }),
  // --- Sohbet DEĞİŞİMİ sıfırlar (S_chat.load): A→B→A taslak yok
  TabletScene('chat-switch-resets-draft', (s) async {
    await openTabletChat(s);
    await s.tester.enterText(_composerField().last, 'Sohbete özel taslak');
    await s.settle();
    expect(_draft(s), 'Sohbete özel taslak');
    await s.tapText(s.inPane(NzPaneRole.master, find.text('Genel')));
    expect(_draft(s), isEmpty, reason: 'sohbet değişince taslak temizlenir');
    await s.tapText(s.inPane(NzPaneRole.master, find.text(tabletChat)));
    expect(
      _draft(s),
      isEmpty,
      reason: 'ilk sohbete dönünce de boş (sohbet başına taslak yok)',
    );
    expectReplyChip(present: false);
  }),
  // --- AYNI sohbet yeniden seçimi: `load` koşulsuz sıfırlar (taslak, yanıt, okunmamış
  // işaretçisi); mesajlar kalır, yığın büyümez. (Yeniden BOYUT ayrı kuraldır: taslak korunur.)
  TabletScene('chat-same-reselect-follows-source', (s) async {
    await openTabletChat(s);
    expectUnreadDivider(s, present: true);
    await startReplyToK2(s);
    await s.tester.enterText(_composerField().last, 'Aynı sohbet taslağı');
    await s.settle();
    expectReplyChip(present: true);
    await s.tapText(s.inPane(NzPaneRole.master, find.text(tabletChat)));
    // Sıra: önce işaretçi ve taslak, en sonda yanıt çipi (tek kırmızıda hangisi kaldı görünsün).
    expectUnreadDivider(s, present: false);
    expect(
      _draft(s),
      isEmpty,
      reason: 'aynı sohbet seçimi de load ile taslağı sıfırlar',
    );
    expectReplyChip(present: false);
    expect(
      inChat(find.textContaining('trafo onayı')),
      findsWidgets,
      reason: 'sohbet içeriği (mesajlar) kalır',
    );
    expect(paneBack(s), findsNothing, reason: 'yığın büyümez');
  }),
  // --- Etiket sütunundan seçim (etiket tıklaması da `pick`): BAR seçiminden ayrı sözleşme
  TabletScene('gantt-label-selects-task', (s) async {
    await s.tapRail(TabletModule.tasks);
    await openTimelineFromTasks(s);
    await s.tapText(
      find.descendant(
        of: find.byKey(GanttChart.labelsKey),
        matching: find.textContaining(_hidrofor),
      ),
      reason: 'Gantt etiket sütunu satırı',
    );
    expect(find.bySemanticsLabel(_l.uiTimelineSelectedTask), findsWidgets);
    expect(find.text(_l.uiTimelineGanttOpenTask), findsWidgets);
  }),
  // --- Gantt kapat: modül ve sağ yığın aynı kalır
  TabletScene('gantt-close-keeps-module-and-selection', (s) async {
    await s.tapRail(TabletModule.tasks);
    await s.tapText(s.inPane(NzPaneRole.master, find.text(_hidrofor)));
    expect(s.inPane(NzPaneRole.detail, find.text(_hidrofor)), findsWidgets);
    await openTimelineFromTasks(s);
    _expectTimelineOpen(s);
    await _closeTimeline(s);
    expect(_gantt, findsNothing, reason: 'Gantt kapandı');
    expect(
      s.pane(NzPaneRole.master),
      findsOneWidget,
      reason: 'Görevler listesi geri geldi',
    );
    expect(
      s.inPane(NzPaneRole.detail, find.text(_hidrofor)),
      findsWidgets,
      reason: 'Gantt kapanışı sağ yığını değiştirmez',
    );
  }),
  // --- Ray: aynı modüle basış Gantt'ı kapatır; başka modül Gantt'ı bırakır
  TabletScene('gantt-rail-same-module-closes-other-module-leaves', (s) async {
    await s.tapRail(TabletModule.tasks);
    await openTimelineFromTasks(s);
    _expectTimelineOpen(s);
    await s.tapRail(TabletModule.tasks);
    expect(_gantt, findsNothing, reason: 'aynı modüle basış Gantt\'ı kapatır');
    expectModuleRoot(s, TabletModule.tasks);
    await openTimelineFromTasks(s);
    await s.tapRail(TabletModule.archive);
    expect(_gantt, findsNothing, reason: 'başka modül Gantt\'ı bırakır');
    expectModuleRoot(s, TabletModule.archive);
  }),
  // --- Gantt'tan görev açma: Görevler modülü + tek ayrıntı; önceki modülün derin yığını taşınmaz
  TabletScene('gantt-open-task-resets-stack-to-tasks', (s) async {
    // Koordinatörlükte derin yığın: koordinatörlük → görev (geri adımı var).
    await s.tapRail(TabletModule.coordinatorships);
    await s.tapText(
      s.inPane(NzPaneRole.master, find.text('Altyapı ve tesisat')),
    );
    await s.tapText(s.inPane(NzPaneRole.detail, find.text(_l.uiTasksTitle)));
    await s.tapText(s.inPane(NzPaneRole.detail, find.text(_hidrofor)));
    expect(s.inPane(NzPaneRole.detail, find.text(_hidrofor)), findsWidgets);
    await s.tapRail(TabletModule.tasks);
    await openTimelineFromTasks(s);
    await tapGanttBar(s, tAltLate30);
    await s.tapText(find.text(_l.uiTimelineGanttOpenTask));
    expect(_gantt, findsNothing, reason: 'Gantt kapandı');
    expect(s.pane(NzPaneRole.master), findsOneWidget);
    expect(
      s.inPane(NzPaneRole.detail, find.text(_iletim)),
      findsWidgets,
      reason: 'seçilen görev sağda; Görevler modülü',
    );
    // Tek giriş: sağ bölmenin Geri'si görevi kapatır (liste tam genişler), önceki yığına
    // (koordinatörlük → Hidrofor) dönmez.
    await s.tapText(paneBack(s));
    expect(s.inPane(NzPaneRole.detail, find.text(_hidrofor)), findsNothing);
    expectModuleRoot(s, TabletModule.tasks);
  }),
];
