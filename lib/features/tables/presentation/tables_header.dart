import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/navigation/nz_page_header.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../application/tables_controller.dart';

class TablesHeader extends ConsumerStatefulWidget {
  const TablesHeader({
    super.key,
    required this.onRecent,
    required this.onCreate,
    required this.count,
  });
  final VoidCallback onRecent;
  final VoidCallback onCreate;
  final int count;

  @override
  ConsumerState<TablesHeader> createState() => _TablesHeaderState();
}

class _TablesHeaderState extends ConsumerState<TablesHeader> {
  late final _search = TextEditingController(
    text: ref.read(tablesControllerProvider).query,
  );
  final _searchFocus = FocusNode();
  late bool _searchOpen = _search.text.isNotEmpty;

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        NzPageHeader(
          title: l.uiTablesTitle,
          subtitle: '${widget.count} tablo',
          actions: [
            Semantics(
              selected: _searchOpen,
              child: NzIconButton.circle(
                icon: NzIcons.search,
                semanticLabel: l.uiTablesSearch,
                onPressed: () {
                  setState(() => _searchOpen = !_searchOpen);
                  if (!_searchOpen) {
                    _search.clear();
                    _searchFocus.unfocus();
                    ref.read(tablesControllerProvider.notifier).setQuery('');
                  }
                },
              ),
            ),
            NzIconButton.circle(
              icon: Icons.history,
              semanticLabel: l.uiTablesRecentAction,
              onPressed: widget.onRecent,
            ),
            NzIconButton.circleAccent(
              icon: Icons.add,
              semanticLabel: l.uiTablesNew,
              onPressed: widget.onCreate,
            ),
          ],
        ),
        NzReveal(
          open: _searchOpen,
          onOpened: _searchFocus.requestFocus,
          child: Padding(
            padding: const EdgeInsets.only(top: NizamioSpacing.space4),
            child: NzSearchField(
              controller: _search,
              focusNode: _searchFocus,
              onDismiss: () {
                if (_searchOpen) {
                  setState(() => _searchOpen = false);
                  _search.clear();
                  ref.read(tablesControllerProvider.notifier).setQuery('');
                }
              },
              label: l.uiTablesSearch,
              onChanged: ref.read(tablesControllerProvider.notifier).setQuery,
            ),
          ),
        ),
      ],
    );
  }
}
