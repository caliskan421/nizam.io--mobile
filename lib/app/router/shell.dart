import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/generated/app_localizations.dart';
import '../../core/theme/generated/tokens.gen.dart';
import '../../core/ui/extensions/context_ext.dart';
import '../../core/ui/layout/layout.dart';
import '../../core/ui/motion/page_content_entrance.dart';
import '../../core/ui/page/nz_app_nav.dart';
import '../../core/ui/page/nz_shell_events.dart';
import '../../core/ui/widgets/feedback/nz_toast.dart';
import '../../core/ui/widgets/navigation/nz_floating_nav.dart';
import '../../core/ui/widgets/navigation/nz_tablet_rail.dart';
import '../../core/ui/widgets/nz_icons.dart';
import '../../features/activity/activity.dart';
import '../../features/archive/archive.dart';
import '../../features/coordinatorships/coordinatorships.dart';
import '../../features/meetings/meetings.dart';
import '../../features/messages/messages.dart';
import '../../features/tasks/tasks.dart';
import 'app_tablet_rail.dart';
import 'routes.dart';
import 'split.dart';

/// Alt menünün üçüncü öğesi: son girilen modül (README "Gezinme"). Üçü aynı kabuk dalındadır.
enum ShellModule { coordinatorships, archive, messages, calendar, meetings }

/// Alt menü öğesinin görünümü (simge, etiket, etkinken alt yazı).
@immutable
class NzShellTab {
  const NzShellTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.caption,
    this.wide = false,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String? caption;

  /// Uzun etiket (Koordinatörlükler): etkinken kapsül öğesi genişler.
  final bool wide;
}

/// Konumdan modül (modül dalı dışında null).
ShellModule? moduleOf(String location) {
  if (location.startsWith(const CoordinatorshipsRoute().location)) {
    return ShellModule.coordinatorships;
  }
  if (location.startsWith(const ArchiveRoute().location)) {
    return ShellModule.archive;
  }
  if (location.startsWith(const MessagesRoute().location)) {
    return ShellModule.messages;
  }
  if (location.startsWith(const CalendarRoute().location)) {
    return ShellModule.calendar;
  }
  if (location.startsWith(const MeetingsRoute().location)) {
    return ShellModule.meetings;
  }
  return null;
}

/// Kabuk sekmeleri (sıra `routes.dart` dal sırasıyla birebir). Etiket ve alt yazı konuma ve
/// modüllerin özet sağlayıcılarına göre.
List<NzShellTab> shellTabsFor(
  AppLocalizations l, {
  required String location,
  required ShellModule module,
  required WidgetRef ref,
}) {
  final inHistory = location.startsWith(const HistoryRoute().location);
  // Her zaman izlenir: işlem geçmişi kayıtları kabukla birlikte yüklenir (keepAlive), sayfaya
  // ilk girişte liste ilk karede dolu gelir (yükleniyor karesi/titreme yok).
  final historyCaption = ref.watch(activityNavCaptionProvider);
  return [
    NzShellTab(
      icon: NzIcons.home,
      selectedIcon: NzIcons.homeFilled,
      label: inHistory ? l.uiRouterTabHistory : l.uiRouterTabHome,
      caption: inHistory ? historyCaption : l.uiRouterTabHomeCaption,
    ),
    NzShellTab(
      icon: NzIcons.tasks,
      selectedIcon: NzIcons.tasks,
      label: l.uiRouterTabTasks,
      caption: ref.watch(tasksNavCaptionProvider),
    ),
    switch (module) {
      ShellModule.coordinatorships => NzShellTab(
        icon: NzIcons.coordinatorships,
        selectedIcon: NzIcons.coordinatorships,
        label: l.uiRouterTabCoordinatorships,
        caption: ref.watch(coordinatorshipsNavCaptionProvider),
        wide: true,
      ),
      ShellModule.archive => NzShellTab(
        icon: NzIcons.folder,
        selectedIcon: NzIcons.folderFilled,
        label: l.uiRouterTabArchive,
        caption: ref.watch(archiveNavCaptionProvider),
      ),
      ShellModule.messages => NzShellTab(
        icon: NzIcons.messages,
        selectedIcon: NzIcons.messagesFilled,
        label: l.uiRouterTabMessages,
        caption: ref.watch(messagesNavCaptionProvider),
      ),
      ShellModule.calendar => NzShellTab(
        icon: NzIcons.calendar,
        selectedIcon: NzIcons.calendarFilled,
        label: l.uiHomeModuleCalendar,
      ),
      ShellModule.meetings => NzShellTab(
        icon: NzIcons.event,
        selectedIcon: NzIcons.event,
        label: l.uiHomeModuleMeetings,
        caption: ref.watch(meetingsNavCaptionProvider),
      ),
    },
  ];
}

/// Yalnız `scoped` fazında kurulan kabuk. Pencere genişliğine göre (A2, ADR-0003 karar 25–26):
/// compact → yüzen cam alt menü ([NzFloatingNav], üç öğe, içerik altından geçer); medium →
/// tablet rayı ([NzTabletRail], altı modül) + tek bölme; expanded → tablet rayı + liste (390) +
/// ayrıntı bölmesi (prototip `12-Tablet`). Her dalın yığını korunur
/// (`StatefulShellRoute.indexedStack`). Kabuk core/app'te durur; features'ta Scaffold yasaktır
/// (U6).
class NzAdaptiveShell extends ConsumerStatefulWidget {
  const NzAdaptiveShell({
    super.key,
    required this.navigationShell,
    this.location,
    this.query = const {},
  });

  final StatefulNavigationShell navigationShell;

  /// Geçerli konum (modül öğesi ve etiket seçimi).
  final String? location;

  /// Geçerli konumun sorgu parametreleri (Görevler kökünün açılış süzgeci, sağ yığın izi).
  final Map<String, List<String>> query;

  @override
  ConsumerState<NzAdaptiveShell> createState() => _NzAdaptiveShellState();
}

class _NzAdaptiveShellState extends ConsumerState<NzAdaptiveShell> {
  /// Son girilen modül (başlangıçta Koordinatörlükler, prototip varsayılanı).
  var _module = ShellModule.coordinatorships;

  /// Görevler kökünün son açılış süzgeci (sol bölmedeki liste, alt rotada da aynı kalır).
  var _tasksRoot = const TasksRoute();

  /// Sağ bölme türlerinin son açılan kimliği (prototip alt ekranları kalıcıdır).
  var _lastIds = <PaneKind, String>{};

  /// "Aynı kaydı yeniden seç" sayacı (sağ bölme solup yeniden açılır).
  var _refresh = 0;
  var _refreshReloads = false;

  StatefulNavigationShell get _shell => widget.navigationShell;

  String get _location => widget.location ?? '';

  Uri get _uri => Uri(
    path: _location,
    queryParameters: widget.query.isEmpty ? null : widget.query,
  );

  @override
  void didUpdateWidget(NzAdaptiveShell old) {
    super.didUpdateWidget(old);
    _remember();
  }

  @override
  void initState() {
    super.initState();
    _remember();
  }

  void _remember() {
    final m = moduleOf(_location);
    if (m != null) _module = m;
    if (_location == const TasksRoute().location) {
      final view = widget.query['view'];
      _tasksRoot = TasksRoute(
        view: view == null || view.isEmpty ? null : view.first,
        people: widget.query['people'] ?? const [],
      );
    }
    final shown = [
      ?baseEntryOf(_uri, (k) => _lastIds[k]),
      ...parseTrail(widget.query['trail'] ?? const []),
    ];
    final next = {..._lastIds, for (final e in shown) e.kind: ?e.id};
    if (!_sameIds(next, _lastIds)) _lastIds = next;
  }

  static bool _sameIds(Map<PaneKind, String> a, Map<PaneKind, String> b) =>
      a.length == b.length && a.entries.every((e) => b[e.key] == e.value);

  /// Başka sekme → o sekmenin son konumu. Etkin sekmeye yeniden dokunma → o sayfanın kısayol
  /// menüsü ([ShellReselectEvents]; sayfa kendisi görünürse açar).
  void _select(int index) {
    if (index == _shell.currentIndex) {
      ref.read(shellReselectEventsProvider.notifier).fire(index);
      return;
    }
    _shell.goBranch(index);
  }

  /// Ray seçimi (prototip `tgo`): başka modül → modül kökü (liste başa, sağ bölme modülün
  /// tabanı); aynı modül → çift bölmede sağ yığın derinse tabana döner, değilse bir şey olmaz;
  /// tek bölmede telefondaki gibi kısayol olayı.
  void _selectRail(RailModule target, {required bool split}) {
    final router = GoRouter.of(context);
    if (target == railModuleOf(_location)) {
      if (!split) {
        ref
            .read(shellReselectEventsProvider.notifier)
            .fire(_shell.currentIndex);
      } else if (widget.query['trail']?.isNotEmpty ?? false) {
        router.go(withTrail(_uri, const []));
      }
      return;
    }
    router.go(split ? _moduleEntry(target) : railModuleRoot(target));
  }

  /// Çift bölmede modüle giriş: son açılan kayıt rotada kimlikle durur (`/messages/koord`);
  /// tek bölmeye daralınca aynı kayıt sayfası (aynı State) görünür, geri listeye döner. Kayıt
  /// hiç açılmamışsa, ana sayfada (geçmiş yalnız dokunuşla açılır), takvimde ve görevlerde (liste
  /// tam genişlik açılır, [restoresLastRecord]) modül kökü açılır.
  String _moduleEntry(RailModule m) {
    final kind = baseKindOf(m);
    final id = kind == null ? null : _lastIds[kind];
    if (kind == null || !restoresLastRecord(kind) || id == null) {
      return railModuleRoot(m);
    }
    return baseLocation(m, PaneEntry(kind, id));
  }

  void _goModule(RailModule m) => GoRouter.of(context).go(_moduleEntry(m));

  /// Kaydı kapatır (Ana sayfa, Görevler, Koordinatörlükler): modül köküne döner (görev süzgeci korunur),
  /// liste tam genişler.
  void _closeRecord() {
    final m = railModuleOf(_location);
    if (m == null) return;
    GoRouter.of(context)
        .go(m == RailModule.tasks ? _tasksRoot.location : railModuleRoot(m));
  }

  /// Çift bölmede modül dışı hedef (prototip `tgo`): sol liste kalır, sağ yığın değişir.
  void _paneGo(PaneEntry target) {
    switch (splitMove(_uri, target, (k) => _lastIds[k])) {
      case SplitGo(:final location):
        GoRouter.of(context).go(location);
      case SplitRefresh():
        setState(() {
          _refresh++;
          _refreshReloads = paneReselectReloads(target.kind);
        });
    }
  }

  void _planMeeting(DateTime day) => showMeetingSheet(context, date: day);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (NzTabletMetrics.railAt(width)) {
      return _tablet(context, split: NzTabletMetrics.splitsAt(width));
    }
    final tabs = shellTabsFor(
      context.l10n,
      location: _location,
      module: _module,
      ref: ref,
    );
    // Tabletten daralınca sağ bölmedeki sohbet (`/messages/:id`) tam ekran kalır.
    final chat = _location.startsWith('${const MessagesRoute().location}/');
    return Scaffold(
      extendBody: true,
      body: _shell,
      bottomNavigationBar: chat
          ? null
          : NzFloatingNav(
              currentIndex: _shell.currentIndex,
              onSelect: _select,
              semanticLabel: context.l10n.uiRouterNavLabel,
              items: [
                for (final tab in tabs)
                  NzNavItem(
                    icon: tab.icon,
                    label: tab.label,
                    caption: tab.caption,
                    wide: tab.wide,
                  ),
              ],
              action: NzNavAction(
                icon: NzIcons.assistant,
                semanticLabel: context.l10n.uiRouterAssistant,
                onPressed: () =>
                    NzToast.show(context, context.l10n.uiRouterAssistantSoon),
              ),
            ),
    );
  }

  Widget _tablet(BuildContext context, {required bool split}) {
    final c = context.colors;
    final current = railModuleOf(_location);
    final rail = AppTabletRail(
      key: const ValueKey('rail'),
      current: current,
      onSelect: (m) => _selectRail(m, split: split),
    );
    if (!split) {
      return Scaffold(
        body: Row(
          children: [
            rail,
            Expanded(key: const ValueKey('body'), child: _shell),
          ],
        ),
      );
    }
    final master = switch (current) {
      RailModule.home => homeMaster(),
      RailModule.tasks => tasksMaster(
        view: _tasksRoot.initialView,
        people: _tasksRoot.people,
      ),
      RailModule.calendar => calendarMaster(_planMeeting),
      RailModule.coordinatorships => coordinatorshipsMaster(),
      RailModule.archive => archiveMaster(),
      RailModule.messages => messagesMaster(),
      RailModule.meetings => meetingsMaster(),
      null => const SizedBox.shrink(),
    };
    // Ana sayfa/Görevler/Koordinatörlükler kökünde açık kayıt yoksa liste sağ bölmenin yerini de alır; kayıt açılınca 390'a
    // daralır. Ağaç iki durumda aynıdır (yalnız genişlik değişir): kabuk ve liste State'i kalır.
    final full = splitListFull(_uri);
    final closes = listGoesFull(current);
    return NzAppNavScope(
      nav: _SplitAppNav(NzAppNavScope.of(context), _paneGo, _goModule),
      child: Scaffold(
        body: Row(
          children: [
            rail,
            DecoratedBox(
              key: const ValueKey('master'),
              decoration: BoxDecoration(
                border: full
                    ? const Border()
                    : Border(right: BorderSide(color: c.border)),
              ),
              // Prototip bölmesi `box-sizing` içermez: 390 içerik + 1 px kenar (sağ 689).
              child: Padding(
                padding: EdgeInsets.only(
                  right: full ? 0 : NizamioSize.borderWidth,
                ),
                child: SizedBox(
                  width: full
                      ? MediaQuery.sizeOf(context).width -
                            NzTabletMetrics.railWidth
                      : NzTabletMetrics.masterWidth,
                  child: NzPaneScope(
                    role: NzPaneRole.master,
                    // Modül değişiminde ve liste genişleyip daralınca telefondaki sayfa
                    // girişiyle aynı yükselir.
                    child: NzPaneTransition(
                      key: ValueKey((current, full)),
                      motion: NzPaneMotion.rise,
                      child: master,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              key: const ValueKey('detail'),
              // Tam genişlikte sağ bölme sıfır genişlikte bekler (çizilmez, saati durur).
              child: Offstage(
                offstage: full,
                child: TickerMode(
                  enabled: !full,
                  child: NzPaneScope(
                    role: NzPaneRole.detail,
                    // Bu modüllerde kaydın "Geri"si kaydı kapatır (liste genişler).
                    canBack: closes,
                    onBack: closes ? _closeRecord : null,
                    child: SplitMemory(
                      lastIds: _lastIds,
                      refresh: _refresh,
                      refreshReloads: _refreshReloads,
                      child: _shell,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Zaman çizelgesi barındırıcısı: ray genişliğinde ray + tam genişlik yatay çizelge (liste ve
/// ayrıntı gizli, prototip `full`), telefonda dikey çizelge. Raydaki etkin modül, çizelgenin
/// açıldığı modüldür (doğrudan bağlantıda Görevler); aynı modüle dokunmak çizelgeyi kapatır,
/// başka modül o modülün köküne gider.
class TimelineHost extends StatelessWidget {
  const TimelineHost({super.key, required this.phone, required this.tablet});

  final WidgetBuilder phone;
  final WidgetBuilder tablet;

  @override
  Widget build(BuildContext context) {
    if (!NzTabletMetrics.railAt(MediaQuery.sizeOf(context).width)) {
      return phone(context);
    }
    final from = _openedFrom(context);
    return Scaffold(
      body: Row(
        children: [
          AppTabletRail(
            current: from,
            onSelect: (m) => m == from
                ? closeTimeline(context)
                : GoRouter.of(context).go(railModuleRoot(m)),
          ),
          Expanded(child: tablet(context)),
        ],
      ),
    );
  }

  /// Çizelgenin altında kalan kabuk konumunun modülü.
  static RailModule _openedFrom(BuildContext context) {
    final matches = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches;
    for (final m in matches.reversed) {
      if (m is ShellRouteMatch) {
        return railModuleOf(m.matches.last.matchedLocation) ?? RailModule.tasks;
      }
    }
    return RailModule.tasks;
  }
}

/// Çizelgeyi kapatır (prototip `closeGantt`): açıldığı konuma döner; doğrudan bağlantıda
/// Görevler.
void closeTimeline(BuildContext context) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
  } else {
    router.go(const TasksRoute().location);
  }
}

/// Çift bölmede gezinme niyetleri (prototip `tgo`): kayıt açan niyetler (görev, koordinatörlük,
/// arşiv klasörü, sohbet, işlem geçmişi) sol listeyi bırakıp yalnız sağ yığını değiştirir;
/// modül niyetleri, zaman çizelgesi, profil ve menü uygulama gerçeklemesine gider.
class _SplitAppNav implements NzAppNav {
  _SplitAppNav(this._base, this._pane, this._module);

  final NzAppNav _base;
  final ValueChanged<PaneEntry> _pane;
  final ValueChanged<RailModule> _module;

  @override
  void openHistory() => _pane(const PaneEntry(PaneKind.history));

  @override
  void openTask(String code) => _pane(PaneEntry(PaneKind.task, code));

  @override
  void openCoordinatorship(String code) =>
      _pane(PaneEntry(PaneKind.coord, code));

  @override
  void openArchiveFolder(String code) =>
      _pane(PaneEntry(PaneKind.folder, code));

  @override
  void openChat(String id) => _pane(PaneEntry(PaneKind.chat, id));

  @override
  void openMeeting(String id) => _pane(PaneEntry(PaneKind.meeting, id));

  @override
  void openMeetings() => _module(RailModule.meetings);

  @override
  void openHome() => _module(RailModule.home);

  /// Süzgeçli açılış kökte kalır (süzgeç kök rotanın sorgusudur).
  @override
  void openTasks({NzTaskView? view, List<String> people = const []}) =>
      view == null && people.isEmpty
      ? _module(RailModule.tasks)
      : _base.openTasks(view: view, people: people);

  @override
  void openCalendar() => _module(RailModule.calendar);

  @override
  void openTimeline({String? coordinatorship}) =>
      _base.openTimeline(coordinatorship: coordinatorship);

  @override
  void openCoordinatorships() => _module(RailModule.coordinatorships);

  @override
  void openArchive() => _module(RailModule.archive);

  @override
  void openMessages() => _module(RailModule.messages);

  @override
  void openProfile() => _base.openProfile();

  @override
  void openMenu(BuildContext context) => _base.openMenu(context);
}
