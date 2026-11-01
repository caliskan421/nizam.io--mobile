import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/layout/nz_pane.dart';
import '../../core/ui/motion/page_content_entrance.dart';
import '../../core/ui/page/nz_app_nav.dart';
import '../../features/activity/activity.dart';
import '../../features/archive/archive.dart';
import '../../features/calendar/calendar.dart';
import '../../features/coordinatorships/coordinatorships.dart';
import '../../features/messages/messages.dart';
import '../../features/scope/scope.dart';
import '../../features/tasks/tasks.dart';
import 'routes.dart';

// Tablet çift bölmesi (prototip `12-Tablet.dc.html` `Component`, satır 3796+): ray + liste
// (sol) + ayrıntı (sağ). Rota ağacı telefonla aynıdır.
//
// - Sol modül YOLDAN türer (`/coordinatorships/...` → Koordinatörlükler listesi).
// - Sağ yığın = taban + iz. Taban yolun kaydıdır (`/tasks/ALT-7` → görev ALT-7; modül kökü →
//   modülün son açılan kaydı; hiç açılmamışsa "Bir kayıt seç"). İz, modüller arası itilen kayıtlardır ve
//   yalnız KİMLİK taşıyan `trail` sorgusudur (`?trail=folder:ALT&trail=task:ALT-5`).
// - Dal kökü genişliğe göre kurulur ([SplitRoot]): tek bölmede liste, çift bölmede taban.
//   Liste sayfası iki yer arasında aynı [GlobalKey] ile taşınır (State korunur).
// - İz her genişlikte aynı çizilir ([PaneStack]); geri izi kısaltır. Böylece daralıp
//   genişlemede aynı görev/sohbet State'i ve iz korunur.
// İkinci veri yolu yoktur: iki bölme aynı controller'ları okur.

/// Tablet rayının modülleri (prototip `RAIL`, sıra birebir).
enum RailModule { home, tasks, calendar, coordinatorships, archive, messages }

/// Konumdan ray modülü (kabuk dışı konumda null).
RailModule? railModuleOf(String location) {
  bool under(String root) => location == root || location.startsWith('$root/');
  if (under(const HomeRoute().location)) return RailModule.home;
  if (under(const TasksRoute().location)) return RailModule.tasks;
  if (under(const CalendarRoute().location)) return RailModule.calendar;
  if (under(const CoordinatorshipsRoute().location)) {
    return RailModule.coordinatorships;
  }
  if (under(const ArchiveRoute().location)) return RailModule.archive;
  if (under(const MessagesRoute().location)) return RailModule.messages;
  return null;
}

/// Modül kökü (ray ve açık modül niyetleri buraya gider; prototip `rs = [TB_DEF[mod]]`).
String railModuleRoot(RailModule m) => switch (m) {
  RailModule.home => const HomeRoute().location,
  RailModule.tasks => const TasksRoute().location,
  RailModule.calendar => const CalendarRoute().location,
  RailModule.coordinatorships => const CoordinatorshipsRoute().location,
  RailModule.archive => const ArchiveRoute().location,
  RailModule.messages => const MessagesRoute().location,
};

/// Sağ bölme ekranının türü (prototip `history`, `detail`, `cdetail`, `afolder`, `chat`).
enum PaneKind { history, task, coord, folder, chat }

/// Sağ yığının bir kaydı: tür + kimlik (yalnız kimlik; nesne taşınmaz, N1).
@immutable
class PaneEntry {
  const PaneEntry(this.kind, [this.id]);

  final PaneKind kind;
  final String? id;

  /// `task:ALT-5` / `history`; tanınmayan değer null.
  static PaneEntry? parse(String code) {
    final i = code.indexOf(':');
    final name = i < 0 ? code : code.substring(0, i);
    final kind = PaneKind.values.where((k) => k.name == name).firstOrNull;
    if (kind == null) return null;
    final id = i < 0 ? null : code.substring(i + 1);
    if ((kind == PaneKind.history) != (id == null || id.isEmpty)) return null;
    return PaneEntry(kind, kind == PaneKind.history ? null : id);
  }

  String get code => id == null ? kind.name : '${kind.name}:$id';

  @override
  bool operator ==(Object other) =>
      other is PaneEntry && other.kind == kind && other.id == id;

  @override
  int get hashCode => Object.hash(kind, id);

  @override
  String toString() => code;
}

/// İz sorgusunu ayrıştırır (tanınmayan kayıtlar atlanır).
List<PaneEntry> parseTrail(Iterable<String> trail) => [
  for (final c in trail) ?PaneEntry.parse(c),
];

/// Modülün sağ bölme tabanının türü (prototip `TB_DEF`); takvimde taban "Bir kayıt seç"tir.
/// Ana sayfada işlem geçmişi yalnız açıldığında tabandır (`/home/history`); kökte sağ bölme
/// "Bir kayıt seç"tir ve son açılan hatırlanmaz (geçmiş kimliksizdir).
PaneKind? baseKindOf(RailModule m) => switch (m) {
  RailModule.home => PaneKind.history,
  RailModule.tasks => PaneKind.task,
  RailModule.calendar => null,
  RailModule.coordinatorships => PaneKind.coord,
  RailModule.archive => PaneKind.folder,
  RailModule.messages => PaneKind.chat,
};

/// Konumdaki taban kaydı (modül kökünde [lastId]; hiç açılmamışsa null). Ana sayfada yalnız
/// `/home/history` geçmiş tabanıdır; `/home` boştur.
PaneEntry? baseEntryOf(Uri uri, String? Function(PaneKind) lastId) {
  final module = railModuleOf(uri.path);
  if (module == null) return null;
  final kind = baseKindOf(module);
  if (kind == null) return null;
  final parts = uri.pathSegments;
  if (kind == PaneKind.history) {
    return parts.length > 1 ? const PaneEntry(PaneKind.history) : null;
  }
  final id = parts.length > 1 ? parts[1] : lastId(kind);
  return id == null ? null : PaneEntry(kind, id);
}

/// [uri]'nin izi [trail] olan hâli (diğer sorgu parametreleri korunur).
String withTrail(Uri uri, List<PaneEntry> trail) {
  final q = Map<String, List<String>>.of(uri.queryParametersAll)
    ..remove('trail');
  if (trail.isNotEmpty) q['trail'] = [for (final e in trail) e.code];
  return Uri(path: uri.path, queryParameters: q.isEmpty ? null : q).toString();
}

/// Modülde taban kaydı [entry] olan yol (`/tasks/ALT-7`, `/home/history`).
String baseLocation(RailModule module, PaneEntry entry) => switch (entry.kind) {
  PaneKind.history => const HistoryRoute().location,
  PaneKind.task => TaskDetailRoute(code: entry.id!).location,
  PaneKind.coord => CoordinatorshipRoute(code: entry.id!).location,
  PaneKind.folder => ArchiveFolderRoute(code: entry.id!).location,
  PaneKind.chat => MessagesChatRoute(id: entry.id!).location,
};

/// Prototip `tgo` sonucu.
sealed class SplitMove {
  const SplitMove();
}

/// Yeni konuma git ([motion] sağ bölmenin hareketi).
final class SplitGo extends SplitMove {
  const SplitGo(this.location);
  final String location;
}

/// Aynı kayıt zaten en üstte: yığın büyümez, sağ bölme solarak yeniden görünür (`rHide`);
/// türün kaynak yükleyicisi durumu sıfırlıyorsa ekran yeniden kurulur ([paneReselectReloads]).
final class SplitRefresh extends SplitMove {
  const SplitRefresh();
}

/// Prototip `tgo(to)` (modül dışı hedef): [target] yığının sonundaysa yerinde değişir (aynı
/// kimlikse yalnız yenilenir), yığında geride varsa oraya dönülür, yoksa itilir. Sol modül
/// değişmez.
SplitMove splitMove(
  Uri uri,
  PaneEntry target,
  String? Function(PaneKind) lastId,
) {
  final module = railModuleOf(uri.path);
  if (module == null) return SplitGo(baseLocation(RailModule.tasks, target));
  final base = baseEntryOf(uri, lastId);
  if (base == null && target.kind == baseKindOf(module)) {
    // Taban boş ("Bir kayıt seç"): modülün kendi kaydı tabana oturur (iz düşer).
    return SplitGo(baseLocation(module, target));
  }
  final trail = parseTrail(uri.queryParametersAll['trail'] ?? const []);
  final stack = [?base, ...trail];
  final i = stack.lastIndexWhere((e) => e.kind == target.kind);
  if (i >= 0 && i == stack.length - 1 && stack[i] == target) {
    return const SplitRefresh();
  }
  if (i < 0) return SplitGo(withTrail(uri, [...trail, target]));
  if (base != null && i == 0) {
    // Taban yer değiştirir: modülün kendi kaydı (iz düşer).
    return SplitGo(baseLocation(module, target));
  }
  final at = base == null ? i : i - 1;
  return SplitGo(withTrail(uri, [...trail.take(at), target]));
}

/// İzin bir geri adımı (prototip `tback`); iz boşsa null.
String? splitBack(Uri uri) {
  final trail = parseTrail(uri.queryParametersAll['trail'] ?? const []);
  if (trail.isEmpty) return null;
  return withTrail(uri, trail.sublist(0, trail.length - 1));
}

/// Liste sayfalarının bölme/yığın arasında taşınan kimlikleri. Genişlik ya da yön içermez;
/// her liste sayfası ağaçta en çok bir yerdedir (telefonda dal kökü, tablette sol bölme).
abstract final class MasterKeys {
  static final home = GlobalKey(debugLabel: 'master.home');
  static final tasks = GlobalKey(debugLabel: 'master.tasks');
  static final calendar = GlobalKey(debugLabel: 'master.calendar');
  static final coordinatorships = GlobalKey(
    debugLabel: 'master.coordinatorships',
  );
  static final archive = GlobalKey(debugLabel: 'master.archive');
  static final messages = GlobalKey(debugLabel: 'master.messages');
}

Widget homeMaster() => HomePage(key: MasterKeys.home);

Widget tasksMaster({NzTaskView? view, List<String> people = const []}) =>
    TasksPage(key: MasterKeys.tasks, view: view, people: people);

Widget calendarMaster(ValueChanged<DateTime> onPlanMeeting) =>
    CalendarPage(key: MasterKeys.calendar, onPlanMeeting: onPlanMeeting);

Widget coordinatorshipsMaster() =>
    CoordinatorshipsPage(key: MasterKeys.coordinatorships);

Widget archiveMaster() => ArchivePage(key: MasterKeys.archive);

Widget messagesMaster() => MessagesPage(key: MasterKeys.messages);

/// Sağ yığın kaydının ekranı (kayıt kimliğinden; veri controller'dan yüklenir).
Widget paneEntryPage(PaneEntry e) => switch (e.kind) {
  PaneKind.history => const ActivityPage(),
  PaneKind.task => TaskDetailPage(key: ValueKey(e.id), code: e.id!),
  PaneKind.coord => CoordinatorshipPage(key: ValueKey(e.id), code: e.id!),
  PaneKind.folder => ArchiveFolderPage(key: ValueKey(e.id), code: e.id!),
  PaneKind.chat => ChatPage(key: ValueKey(e.id), id: e.id!),
};

/// Kabuğun çift bölmede verdiği sağ bölme belleği: türlerin son açılan kimliği (prototipte
/// alt ekran nesneleri kalıcıdır; modüle dönünce son kayıt açılır) ve "aynı kaydı yeniden
/// seç" sayacı.
class SplitMemory extends InheritedWidget {
  const SplitMemory({
    super.key,
    required this.lastIds,
    required this.refresh,
    this.refreshReloads = false,
    required super.child,
  });

  final Map<PaneKind, String> lastIds;

  /// Her "aynı kaydı yeniden seç"te artar; en üstteki sağ ekran solarak yeniden görünür.
  final int refresh;

  /// Son yeniden seçimde ekran yeniden yüklenir mi ([paneReselectReloads]).
  final bool refreshReloads;

  static SplitMemory? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SplitMemory>();

  @override
  bool updateShouldNotify(SplitMemory old) =>
      old.refresh != refresh ||
      old.refreshReloads != refreshReloads ||
      old.lastIds != lastIds;
}

/// Aynı kaydı yeniden seçmek ekranın durumunu sıfırlar mı (kaynak alt ekran yükleyicileri):
/// sohbet (`openChat` → `S_chat.load` taslak/yanıt/düzenleme koşulsuz sıfır), koordinatörlük
/// ayrıntısı ve arşiv klasörü (`openCDetail` / `openAFolder` sekme ve sayfa durumunu sıfırlar)
/// → evet; görev ayrıntısı (`S_detail.load` aynı kimlikte döner) ve işlem geçmişi (yükleyici
/// yok) → hayır. Genişlik/yön değişimi hiçbirini yeniden yüklemez.
bool paneReselectReloads(PaneKind kind) => switch (kind) {
  PaneKind.chat || PaneKind.coord || PaneKind.folder => true,
  PaneKind.task || PaneKind.history => false,
};

/// Kabuk dalı kök rotasının sayfası: tek bölmede [master] (liste), çift bölmede [detail]
/// (sağ bölme tabanı). Kabukla aynı ölçüyü (pencere genişliği) okur; ikisi aynı karede
/// yeniden kurulur, liste sayfası anahtarıyla yer değiştirir.
class SplitRoot extends StatelessWidget {
  const SplitRoot({super.key, required this.master, required this.detail});

  final WidgetBuilder master;
  final WidgetBuilder detail;

  @override
  Widget build(BuildContext context) {
    if (!NzTabletMetrics.splitsAt(MediaQuery.sizeOf(context).width)) {
      return master(context);
    }
    // Kök, üstünde kayıt sayfası varken görünmez: varsayılan ayrıntı yalnız kök görünürken
    // kurulur (aynı kaydın ikinci kopyası ve onun açılış yan etkisi olmaz).
    final visible = ModalRoute.of(context)?.isCurrent ?? true;
    return visible ? detail(context) : const SizedBox.shrink();
  }
}

/// Modül kökünün taban kaydı: son açılan; hiç açılmamışsa null ("Bir kayıt seç").
String? splitBaseId(BuildContext context, PaneKind kind) =>
    SplitMemory.maybeOf(context)?.lastIds[kind];

/// Sağ yığın: [base] (rotanın kendi ekranı) + iz kayıtları; yalnız en üstteki görünür, alttakiler
/// State'iyle bekler (prototip alt ekranlar kalıcıdır). Geri (üst çubuk, sistem) izi kısaltır.
/// Çift bölmede en üst ekran prototip hareketiyle girer: itme / geri / solma (modül ya da
/// kayıt değişimi, aynı kaydı yeniden seçme).
class PaneStack extends StatefulWidget {
  const PaneStack({super.key, required this.trail, required this.base});

  final List<String> trail;
  final Widget base;

  @override
  State<PaneStack> createState() => _PaneStackState();
}

class _PaneStackState extends State<PaneStack> {
  late List<PaneEntry> _entries = parseTrail(widget.trail);
  var _motion = NzPaneMotion.fade;

  /// En üst ekran her değiştiğinde artar (hareket yeniden oynar).
  var _play = 0;

  int? _refresh;

  /// Katman kimliği → içerik kuşağı (yeniden yükleyen yeniden seçimde artar).
  final _generation = <String, int>{};

  List<String> get _codes => [
    'base',
    for (final (i, e) in _entries.indexed) '$i:${e.code}',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final memory = SplitMemory.maybeOf(context);
    final refresh = memory?.refresh;
    // Yalnız görünen sayfa yenilenir (diğer dalların sayfaları beklemede kalır).
    // Bölme bağlamı kalkıp gelirken (genişlik değişimi) sayaç yokluğu değişiklik değildir.
    if (_refresh != null &&
        refresh != null &&
        refresh != _refresh &&
        (ModalRoute.of(context)?.isCurrent ?? true)) {
      if (memory!.refreshReloads) {
        final top = _codes.last;
        _generation[top] = (_generation[top] ?? 0) + 1;
      } else {
        // Kaynak `rHide`: ekran durumu kalır, kaydırma başa döner (`rbox.scrollTop = 0`).
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _scrollTopToStart(),
        );
      }
      _motion = NzPaneMotion.fade;
      _play++;
    }
    _refresh = refresh ?? _refresh;
  }

  @override
  void didUpdateWidget(PaneStack old) {
    super.didUpdateWidget(old);
    final next = parseTrail(widget.trail);
    final before = _codes.last;
    final grew = next.length > _entries.length;
    final shrank = next.length < _entries.length;
    _entries = next;
    if (_codes.last != before) {
      _motion = grew
          ? NzPaneMotion.push
          : shrank
          ? NzPaneMotion.pop
          : NzPaneMotion.fade;
      _play++;
    }
  }

  /// En üst katmandaki ilk dikey kaydırmayı başa alır.
  void _scrollTopToStart() {
    if (!mounted) return;
    final top = ValueKey(_codes.last);
    Element? layer;
    void findLayer(Element e) {
      if (layer != null) return;
      if (e.widget is Offstage && e.widget.key == top) {
        layer = e;
        return;
      }
      e.visitChildElements(findLayer);
    }

    (context as Element).visitChildElements(findLayer);
    ScrollableState? scrollable;
    void findScroll(Element e) {
      if (scrollable != null) return;
      if (e is StatefulElement &&
          e.state is ScrollableState &&
          axisDirectionIsReversed((e.state as ScrollableState).axisDirection) ==
              false &&
          axisDirectionToAxis((e.state as ScrollableState).axisDirection) ==
              Axis.vertical) {
        scrollable = e.state as ScrollableState;
        return;
      }
      e.visitChildElements(findScroll);
    }

    layer?.visitChildElements(findScroll);
    final position = scrollable?.position;
    if (position != null && position.hasPixels) {
      position.jumpTo(position.minScrollExtent);
    }
  }

  void _back() {
    final location = splitBack(GoRouterState.of(context).uri);
    if (location != null) GoRouter.of(context).go(location);
  }

  @override
  Widget build(BuildContext context) {
    final outer = NzPaneScope.maybeOf(context);
    final split = outer?.role == NzPaneRole.detail;
    final codes = _codes;
    final top = codes.length - 1;
    final pages = [widget.base, for (final e in _entries) paneEntryPage(e)];
    final hasTrail = _entries.isNotEmpty;
    return PopScope(
      canPop: !hasTrail,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && hasTrail) _back();
      },
      child: NzPaneScope(
        role: outer?.role,
        canBack: hasTrail || (outer?.canBack ?? false),
        onBack: hasTrail ? _back : outer?.onBack,
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (var i = 0; i < pages.length; i++)
              Offstage(
                key: ValueKey(codes[i]),
                offstage: i != top,
                child: TickerMode(
                  enabled: i == top,
                  child: NzPaneTransition(
                    enabled: split,
                    motion: _motion,
                    play: i == top ? _play : null,
                    child: KeyedSubtree(
                      key: ValueKey(_generation[codes[i]] ?? 0),
                      child: pages[i],
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
