import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/nz_icon_button.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/nz_reveal.dart';
import '../../coordinatorships/coordinatorships.dart';
import '../../scope/scope.dart';
import '../../tasks/tasks.dart';
import '../application/team_controller.dart';
import '../domain/admin_user_directory.dart';
import '../domain/team_view.dart';
import 'admin_user_list_row.dart';

/// Kullanıcılar sayfasının koordinatör/üye yüzü ("Ekibim", prototip `users` koordinatör dalı):
/// başlık + "koordinatörlük · n kişi", ara, "Ekibe kişi ekle" (yalnız koordinatör), üç öğeli
/// rol bölücü (CSV ve koordinatörlük süzgeci yok), yönetici dizininin satır bileşeni
/// ([AdminUserListRow]). On satırdan sonrası "Tümünü göster (n)". Üye görünümünde liste
/// türetilmiştir ve salt okunurdur.
class TeamRosterView extends ConsumerStatefulWidget {
  const TeamRosterView({super.key, required this.onOpen});

  /// Kişi ayrıntısını açar (kullanıcı rotası ya da tablet ayrıntı bölmesi).
  final ValueChanged<String> onOpen;

  @override
  ConsumerState<TeamRosterView> createState() => _TeamRosterViewState();
}

class _TeamRosterViewState extends ConsumerState<TeamRosterView> {
  static const _collapsedRows = 10;
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  bool _searchOpen = false;
  bool _showAll = false;
  String _query = '';
  AdminUserRoleFilter _role = AdminUserRoleFilter.all;

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _closeSearch() {
    _search.clear();
    _searchFocus.unfocus();
    setState(() {
      _searchOpen = false;
      _query = '';
    });
  }

  void _retry() {
    if (ref.read(taskCatalogControllerProvider).hasError) {
      ref.invalidate(taskCatalogControllerProvider);
    }
    ref.invalidate(teamRosterProvider);
  }

  Future<void> _refresh() async {
    await ref.read(taskCatalogControllerProvider.notifier).refresh();
    ref.invalidate(teamRosterProvider);
    await ref.read(teamRosterProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final view = ref.watch(effectiveAccessProvider);
    final source = ref.watch(teamSourceProvider);
    final roster = ref.watch(teamRosterProvider);
    final catalogState = ref.watch(taskCatalogControllerProvider);
    final catalog = catalogState.value;
    final department = view.departmentId;
    final team = roster.value;
    ref.listen(scopeStateProvider, (_, _) {
      if (_searchOpen) _closeSearch();
      setState(() => _showAll = false);
    });
    final caption = [
      ?view.departmentName,
      '${team?.people.length ?? '—'} ${l.uiUsersTeamPeople}',
    ].join(' · ');

    return NzPage.feed(
      width: NzContentWidth.wide,
      topBar: const RootTopBar(),
      onRefresh: _refresh,
      onRetry: _retry,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      l.uiUsersTeamTitle,
                      style: context.text.titleLg,
                    ),
                  ),
                  const Gap(NizamioSpacing.space1 / 2),
                  Text(
                    caption,
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(NizamioSpacing.space1),
            Semantics(
              selected: _searchOpen,
              child: NzIconButton.circle(
                icon: NzIcons.search,
                semanticLabel: l.uiUsersSearch,
                onPressed: () => _searchOpen
                    ? _closeSearch()
                    : setState(() => _searchOpen = true),
              ),
            ),
            if (source.canAddMembers && department != null) ...[
              const Gap(NizamioSpacing.space1),
              NzIconButton.circleAccent(
                icon: NzIcons.personAdd,
                semanticLabel: l.uiUsersTeamAdd,
                onPressed: () => showCoordAddMemberSheet(context, department),
              ),
            ],
          ],
        ),
        NzReveal(
          open: _searchOpen,
          onOpened: _searchFocus.requestFocus,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space5),
            child: NzSearchField(
              controller: _search,
              focusNode: _searchFocus,
              onDismiss: _closeSearch,
              label: l.uiUsersSearch,
              hint: l.uiUsersTeamSearchHint,
              onChanged: (text) => setState(() => _query = text),
              onClear: () => setState(() => _query = ''),
            ),
          ),
        ),
        const Gap(NizamioSpacing.gapLg),
        NzPillTabs(
          compact: true,
          tabs: [
            for (final r in teamRoleFilters)
              NzPillTab(
                label: switch (r) {
                  AdminUserRoleFilter.coordinator => l.uiUsersCoordinator,
                  AdminUserRoleFilter.member => l.uiUsersMember,
                  _ => l.uiUsersAll,
                },
                countText: team == null ? '—' : '${team.countFor(r)}',
              ),
          ],
          selected: teamRoleFilters.indexOf(_role),
          onSelected: (i) => setState(() {
            _role = teamRoleFilters[i];
            _showAll = false;
          }),
        ),
        const Gap(NizamioSpacing.gapLg),
        if (!view.known)
          NzAsyncView<TaskCatalog>(
            value: catalogState,
            onRetry: _retry,
            data: (_) => const SizedBox.shrink(),
          )
        else if (source == TeamSource.none)
          NzEmptyState(title: l.uiUsersTeamNoDepartment)
        else if (team != null && !team.available)
          NzEmptyState(
            title: l.uiUsersTeamUnavailableTitle,
            message: l.uiUsersTeamUnavailable,
          )
        else
          NzAsyncView<TeamRoster?>(
            value: roster,
            onRetry: _retry,
            data: (team) {
              if (team == null) return const SizedBox.shrink();
              final shown = team.filter(role: _role, search: _query);
              final rows = _showAll
                  ? shown
                  : shown.take(_collapsedRows).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (source.derived) ...[
                    NzBanner.info(message: l.uiUsersTeamDerived),
                    const Gap(NizamioSpacing.space3),
                  ],
                  if (team.truncated) ...[
                    NzBanner.warning(message: l.uiUsersDirectoryPartial),
                    const Gap(NizamioSpacing.space3),
                  ],
                  if (shown.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: NizamioSpacing.gapLg,
                      ),
                      child: Text(
                        l.uiUsersTeamEmpty,
                        style: context.text.caption,
                      ),
                    ),
                  for (final (i, p) in rows.indexed)
                    _TeamRow(
                      key: ValueKey(p.accountId),
                      person: p,
                      self: p.accountId == view.access?.accountId,
                      load: source.countsLoad && catalog != null
                          ? teamLoadOf(catalog, team.departmentId, p.accountId)
                          : null,
                      first: i == 0,
                      last: i == rows.length - 1,
                      onOpen: () => widget.onOpen(p.accountId),
                    ),
                  if (!_showAll && shown.length > _collapsedRows)
                    TextButton(
                      onPressed: () => setState(() => _showAll = true),
                      child: Text('${l.uiUsersTeamShowAll} (${shown.length})'),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

/// Ekip satırı: yönetici dizininin satırı; alt yazı "rol (sen) · n açık görev · m gecikmede".
class _TeamRow extends StatelessWidget {
  const _TeamRow({
    super.key,
    required this.person,
    required this.self,
    required this.load,
    required this.first,
    required this.last,
    required this.onOpen,
  });

  final TeamPerson person;
  final bool self;
  final ({int open, int late})? load;
  final bool first;
  final bool last;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final role = person.lead ? l.uiUsersCoordinator : l.uiUsersMember;
    final load = this.load;
    return AdminUserListRow(
      name: person.name,
      roles: self ? '$role (${l.uiUsersTeamYou})' : role,
      departments: load == null
          ? ''
          : '${load.open} ${l.uiUsersTeamOpen} · '
                '${load.late} ${l.uiUsersTeamLate}',
      avatarColor: person.lead ? c.avatar1 : c.roleMember,
      avatarForeground: c.onAvatar,
      first: first,
      last: last,
      onOpen: onOpen,
      onQuick: onOpen,
    );
  }
}
