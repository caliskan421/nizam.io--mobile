import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/navigation/nz_flyout_menu.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_library_view.dart';
import '../application/tables_server.dart';
import '../domain/tables_repository.dart';
import 'table_library_tools.dart';

/// The same view/sort controls can sit in the root list or its detail heading.
class TableLibraryControls extends ConsumerWidget {
  const TableLibraryControls({
    super.key,
    required this.location,
    this.combined = false,
    this.onRecent,
  });
  final TableLocation location;
  final bool combined;
  final VoidCallback? onRecent;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tableLibraryViewProvider(location));
    final controller = ref.read(tableLibraryViewProvider(location).notifier);
    final choices = ref.watch(tableSharingChoicesProvider).value;
    void menu(BuildContext anchor, String label, List<NzFlyoutEntry> entries) {
      final box = anchor.findRenderObject()! as RenderBox;
      NzFlyoutMenu.show(
        context,
        semanticLabel: label,
        entries: entries,
        anchor: box.localToGlobal(Offset.zero) & box.size,
        alignEnd: true,
        below:
            box.localToGlobal(Offset.zero).dy <
            MediaQuery.sizeOf(context).height / 2,
      );
    }

    final views = [
      for (final view in TableLibraryLayout.values)
        NzFlyoutItem(
          label: view == TableLibraryLayout.all ? 'Tümü' : 'Klasörler',
          icon: view == TableLibraryLayout.all ? NzIcons.list : NzIcons.folder,
          selected: state.layout == view,
          onSelected: () => controller.layout(view),
        ),
    ];
    final sorts = [
      for (final sort in TableLibrarySort.values)
        NzFlyoutItem(
          label: switch (sort) {
            TableLibrarySort.original => 'Varsayılan',
            TableLibrarySort.name => 'Ad · A–Z',
            TableLibrarySort.reverseName => 'Ad · Z–A',
          },
          selected: sort == state.sort,
          onSelected: () => controller.sort(sort),
        ),
    ];
    if (combined) {
      return Builder(
        builder: (anchor) => NzIconButton.circle(
          icon: NzIcons.filter,
          semanticLabel: 'Tablo görünümü ve sıralama',
          dot:
              state.layout != TableLibraryLayout.all ||
                  state.sort != TableLibrarySort.original
              ? context.colors.accentText
              : null,
          onPressed: () => menu(anchor, 'Görünüm ve sıralama', [
            const NzFlyoutSection('Görünüm'),
            ...views,
            const NzFlyoutSection('Sıralama'),
            ...sorts,
            const NzFlyoutSection('İşlemler'),
            NzFlyoutItem(
              icon: NzIcons.folder,
              label: 'Klasörleri düzenle',
              onSelected: () => showTableProjects(
                context,
                ref,
                location,
                onSelected: controller.openFolder,
              ),
            ),
            if (!location.personal &&
                choices?.canPublish(location.departmentId) == true)
              NzFlyoutItem(
                icon: NzIcons.check,
                label: 'Onay bekleyenler',
                onSelected: () => showTableProposals(context, ref, location),
              ),
            if (onRecent != null)
              NzFlyoutItem(
                icon: NzIcons.history,
                label: 'Son açılan tablolar',
                onSelected: onRecent!,
              ),
          ]),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: (anchor) => NzIconButton.circle(
            icon: state.layout == TableLibraryLayout.folders
                ? NzIcons.folder
                : NzIcons.list,
            semanticLabel: 'Görünümü değiştir',
            onPressed: () => menu(anchor, 'Görünüm', views),
          ),
        ),
        Builder(
          builder: (anchor) => NzIconButton.circle(
            icon: NzIcons.swapVertical,
            semanticLabel: 'Tabloları sırala',
            onPressed: () => menu(anchor, 'Sıralama', sorts),
          ),
        ),
        TablesLibraryTools(
          location: location,
          onFolderSelected: controller.openFolder,
        ),
      ],
    );
  }
}
