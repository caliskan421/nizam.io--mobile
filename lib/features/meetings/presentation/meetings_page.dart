import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/motion/page_content_entrance.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/meetings_controller.dart';
import '../domain/meeting.dart';
import '../domain/meeting_board.dart';
import 'meeting_card.dart';
import 'meetings_texts.dart';

/// Toplantılar (prototip `meetings`): kök üst çubuk, başlık + ara / yeni toplantı, açılır arama,
/// Yaklaşan / Geçmiş / Silinenler (yalnız yönetici) sekmeleri, gün ya da ay gruplarında
/// toplantı kartları. Kart → toplantı ayrıntısı (tablette sağ bölme).
class MeetingsPage extends ConsumerStatefulWidget {
  const MeetingsPage({super.key});

  @override
  ConsumerState<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends ConsumerState<MeetingsPage> {
  late final _search = TextEditingController(
    text: ref.read(meetingsViewControllerProvider).query,
  );
  final _focus = FocusNode();

  MeetingsViewController get _view =>
      ref.read(meetingsViewControllerProvider.notifier);

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    if (ref.read(meetingsViewControllerProvider).searchOpen) {
      _search.clear();
      _focus.unfocus();
    }
    _view.toggleSearch();
  }

  void _retry() => ref
    ..invalidate(meetingsBoardControllerProvider)
    ..invalidate(taskCatalogControllerProvider);

  void _say(String msg) {
    if (mounted) NzToast.show(context, msg);
  }

  Future<void> _restore(Meeting m) async {
    final l = context.l10n;
    final e = await ref
        .read(meetingsBoardControllerProvider.notifier)
        .restore(m.id);
    _say(e == null ? l.uiMeetingsTRestored : errorText(l, e));
  }

  Future<void> _purge(Meeting m) async {
    final l = context.l10n;
    final yes = await NzDialog.confirm(
      context,
      title: l.uiMeetingsPurgeQ,
      message: l.uiMeetingsPurgeDesc,
      confirmLabel: l.uiMeetingsPurge,
      cancelLabel: l.uiMeetingsCancel,
      tone: NzDialogTone.destructive,
    );
    if (!yes || !mounted) return;
    final e = await ref
        .read(meetingsBoardControllerProvider.notifier)
        .purge(m.id);
    _say(e == null ? l.uiMeetingsTPurged : errorText(l, e));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final view = ref.watch(meetingsViewControllerProvider);
    ref.watch(meetingsBoardControllerProvider);
    // Başka hesabın/programın listesi görünmez (yükleniyor ya da yalnız hata).
    final board = ref.read(meetingsBoardControllerProvider.notifier).visible;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final b = board.value;
    // Tablette açık kayıt yokken liste tam genişliktir; kartlar geniş düzene geçer.
    return NzPage.feed(
      width: NzContentWidth.wide,
      onRetry: _retry,
      onRefresh: () =>
          ref.read(meetingsBoardControllerProvider.notifier).refresh(),
      onRevisit: () =>
          ref.read(meetingsBoardControllerProvider.notifier).refreshIfStale(),
      topBar: const RootTopBar(),
      children: [
        NzPageHeader(
          title: l.uiMeetingsTitle,
          actions: [
            Semantics(
              selected: view.searchOpen,
              child: NzIconButton.circle(
                icon: NzIcons.search,
                semanticLabel: l.uiMeetingsSearch,
                onPressed: _toggleSearch,
              ),
            ),
            NzIconButton.circleAccent(
              icon: NzIcons.add,
              semanticLabel: l.uiMeetingsNew,
              onPressed: () => showMeetingSheet(context),
            ),
          ],
        ),
        NzReveal(
          open: view.searchOpen,
          onOpened: _focus.requestFocus,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space4),
            child: NzSearchField(
              controller: _search,
              focusNode: _focus,
              onDismiss: () {
                if (ref.read(meetingsViewControllerProvider).searchOpen) {
                  _toggleSearch();
                }
              },
              label: l.uiMeetingsSearchLabel,
              hint: l.uiMeetingsSearchHint,
              onChanged: _view.setQuery,
              onClear: () => _view.setQuery(''),
            ),
          ),
        ),
        const Gap(NizamioSpacing.space4),
        if (b == null)
          NzAsyncView<MeetingsBoard>(
            value: board,
            onRetry: _retry,
            data: (_) => const SizedBox.shrink(),
          )
        else
          ..._content(context, b, view, catalog),
      ],
    );
  }

  List<Widget> _content(
    BuildContext context,
    MeetingsBoard board,
    MeetingsView view,
    TaskCatalog? catalog,
  ) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final nav = context.appNav;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tabs = [
      MeetingsTab.upcoming,
      MeetingsTab.past,
      if (board.deleted != null) MeetingsTab.deleted,
    ];
    final tab = tabs.contains(view.tab) ? view.tab : MeetingsTab.upcoming;
    final list = searchMeetings(
      board.of(tab, today),
      view.query,
      (d) => meetingDeptLabel(catalog, d),
    );
    final groups = groupMeetings(list, tab, today);
    final filtered = view.query.trim().isNotEmpty;
    final caption = t.caption.copyWith(color: c.textMuted);
    return [
      NzPillTabs(
        semanticLabel: l.uiMeetingsTitle,
        selected: tabs.indexOf(tab),
        onSelected: (i) => _view.selectTab(tabs[i]),
        tabs: [
          for (final x in tabs)
            NzPillTab(
              label: l.meetingsTabLabel(x),
              count: board.of(x, today).length,
            ),
        ],
      ),
      const Gap(NizamioSpacing.space4),
      Semantics(
        container: true,
        label: l.uiMeetingsListLabel,
        explicitChildNodes: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            // Sekme değişince gruplar ve kartlar kademeli girer (görev listesiyle aynı hareket);
            // aynı sekmede yenileme ya da arama yalnız yeni beliren öğeyi oynatır.
            for (final (gi, g) in groups.indexed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NizamioSpacing.space2,
                children: [
                  NzEntrance(
                    replay: (tab, l.meetingGroupLabel(g)),
                    index:
                        gi +
                        groups.take(gi).fold(0, (a, x) => a + x.items.length),
                    child: NzKicker(l.meetingGroupLabel(g)),
                  ),
                  for (final (i, m) in g.items.indexed)
                    NzEntrance(
                      key: ValueKey(m.id),
                      replay: (tab, m.id),
                      index:
                          gi +
                          1 +
                          i +
                          groups.take(gi).fold(0, (a, x) => a + x.items.length),
                      child: MeetingCard(
                        meeting: m,
                        catalog: catalog,
                        onTap: () => nav.openMeeting(m.id),
                        onRestore: tab == MeetingsTab.deleted
                            ? () => _restore(m)
                            : null,
                        onPurge: tab == MeetingsTab.deleted
                            ? () => _purge(m)
                            : null,
                      ),
                    ),
                ],
              ),
            if (groups.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: NizamioSpacing.space3,
                ),
                child: Text(
                  l.meetingsEmpty(tab, filtered: filtered),
                  textAlign: TextAlign.center,
                  style: caption.copyWith(fontSize: 14),
                ),
              ),
            if (tab == MeetingsTab.upcoming)
              Text(
                l.uiMeetingsPastNote,
                textAlign: TextAlign.center,
                style: caption.copyWith(color: c.textFaint),
              ),
            if (board.truncated)
              Text(
                l.uiMeetingsTruncated,
                textAlign: TextAlign.center,
                style: caption,
              ),
          ],
        ),
      ),
    ];
  }
}
