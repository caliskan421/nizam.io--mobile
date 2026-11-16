import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_loader.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/nz_menu_group.dart';
import '../../../core/ui/widgets/navigation/nz_flyout_menu.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_library_controller.dart';
import '../application/tables_controller.dart';
import '../application/tables_server.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'table_sheet_host.dart';
import 'table_workspace_forms.dart';

class TablesLibraryTools extends ConsumerWidget {
  const TablesLibraryTools({
    super.key,
    required this.location,
    this.onFolderSelected,
  });
  final TableLocation location;
  final ValueChanged<TableProjectEntry>? onFolderSelected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choices = ref.watch(tableSharingChoicesProvider).value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (anchor) => NzIconButton.circle(
            icon: NzIcons.more,
            semanticLabel: 'Tablo işlemleri',
            onPressed: () {
              final box = anchor.findRenderObject()! as RenderBox;
              NzFlyoutMenu.show(
                context,
                semanticLabel: 'Tablo işlemleri',
                anchor: box.localToGlobal(Offset.zero) & box.size,
                alignEnd: true,
                entries: [
                  NzFlyoutItem(
                    icon: NzIcons.folder,
                    label: 'Klasörleri düzenle',
                    onSelected: () => showTableProjects(
                      context,
                      ref,
                      location,
                      onSelected: onFolderSelected,
                    ),
                  ),
                  if (!location.personal &&
                      choices?.canPublish(location.departmentId) == true)
                    NzFlyoutItem(
                      icon: NzIcons.check,
                      label: 'Onay bekleyenler',
                      onSelected: () =>
                          showTableProposals(context, ref, location),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class TableLibraryRecovery extends ConsumerWidget {
  const TableLibraryRecovery({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final write = ref.watch(tableLibraryWritesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (write.pending) ...[
          Text(
            write.error == null
                ? 'Son işlemin sonucu bekleniyor.'
                : errorText(context.l10n, write.error!),
          ),
          NzButton.ghost(
            onPressed: write.busy
                ? null
                : () => ref.read(tableLibraryWritesProvider.notifier).retry(),
            label: 'İşlemi yeniden dene',
          ),
          NzButton.ghost(
            onPressed: write.busy ? null : () => _abandonLibrary(context, ref),
            label: 'Denemeyi bırak',
          ),
        ],
      ],
    );
  }
}

Future<void> _libraryForm(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required Widget Function(BuildContext, VoidCallback) fields,
  required Future<bool> Function() submit,
  bool Function()? valid,
}) async {
  if (ref.read(tableLibraryWritesProvider).pending) {
    NzToast.show(context, 'Önce bekleyen işlemi doğrula veya denemeyi bırak.');
    return;
  }
  await tableActionForm(
    context,
    ref,
    title: title,
    fields: fields,
    submit: submit,
    valid: valid,
    pending: () => ref.read(tableLibraryWritesProvider).pending,
    lastError: () => ref.read(tableLibraryWritesProvider).error,
    retry: () => ref.read(tableLibraryWritesProvider.notifier).retry(),
  );
}

Future<void> _abandonLibrary(BuildContext context, WidgetRef ref) =>
    tableActionForm(
      context,
      ref,
      title: 'Denemeyi bırak',
      fields: (context, _) => const Text(
        'İşlem sunucuda tamamlanmış olabilir. Yeniden denemeyi bıraktığında listeyi kontrol et.',
      ),
      submit: () async {
        ref.read(tableLibraryWritesProvider.notifier).abandon();
        return true;
      },
    );

Future<void> _projectForm(
  BuildContext context,
  WidgetRef ref,
  TableLocation location, {
  TableProjectEntry? project,
  bool delete = false,
}) async {
  var name = project?.name ?? '';
  final repo = ref.read(tablesRepositoryProvider)!;
  await _libraryForm(
    context,
    ref,
    title: delete
        ? 'Klasörü sil'
        : project == null
        ? 'Klasör oluştur'
        : 'Klasör adı',
    valid: () => delete || name.trim().isNotEmpty,
    fields: (context, update) => delete
        ? const Text('Klasör kaldırılacak. Tablolar ve içerikleri korunur.')
        : NzTextField(
            pill: true,
            labelAbove: false,
            label: 'Ad',
            initialValue: name,
            maxLength: 200,
            onChanged: (v) {
              name = v;
              update();
            },
          ),
    submit: () {
      final title = name.trim();
      return ref
          .read(tableLibraryWritesProvider.notifier)
          .run(
            (key) => repo.editProject(
              location,
              project?.id,
              delete ? null : title,
              key,
            ),
          );
    },
  );
  if (context.mounted) {
    await ref
        .read(tablesControllerProvider.notifier)
        .reloadServer(keepPrevious: true);
  }
}

Future<void> showTableProjects(
  BuildContext context,
  WidgetRef ref,
  TableLocation location, {
  ValueChanged<TableProjectEntry>? onSelected,
}) async {
  final repo = ref.read(tablesRepositoryProvider)!;
  final canManage =
      location.personal ||
      ref
              .read(tableSharingChoicesProvider)
              .value
              ?.canPublish(location.departmentId) ==
          true;
  await showTableSheet(
    ref,
    context,
    title: 'Klasörler',
    description: 'Klasörler tabloları gruplar; erişim izinlerini değiştirmez.',
    builder: (sheet) => _LibraryPages<TableProjectEntry>(
      load: (cursor) => repo.projects(location, cursor: cursor),
      top: canManage
          ? (reload) => NzButton.ghost(
              label: 'Klasör oluştur',
              onPressed: () async {
                await _projectForm(context, ref, location);
                reload();
              },
            )
          : null,
      item: (p, reload) => NzMenuGroup(
        rows: [
          NzMenuRow(
            icon: NzIcons.folder,
            label: p.name,
            onTap: () {
              onSelected?.call(p);
              ref.read(tablesControllerProvider.notifier).setProject(p.id);
              Navigator.of(sheet).pop();
            },
          ),
          if (canManage)
            NzMenuRow(
              icon: NzIcons.edit,
              label: 'Adını değiştir',
              onTap: () async {
                await _projectForm(context, ref, location, project: p);
                reload();
              },
            ),
          if (canManage)
            NzMenuRow(
              icon: NzIcons.delete,
              label: 'Klasörü sil',
              danger: true,
              onTap: () async {
                await _projectForm(
                  context,
                  ref,
                  location,
                  project: p,
                  delete: true,
                );
                reload();
              },
            ),
        ],
      ),
    ),
  );
}

Future<void> showTableProposals(
  BuildContext context,
  WidgetRef ref,
  TableLocation location,
) async {
  final repo = ref.read(tablesRepositoryProvider)!;
  final generation = ref.read(sessionGenerationProvider);
  await showTableSheet(
    ref,
    context,
    title: 'Onay bekleyenler',
    builder: (context) => _LibraryPages<TableProposalEntry>(
      load: (cursor) => repo.proposals(location, cursor: cursor),
      item: (p, reload) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(p.title, style: context.text.titleSm),
          const Gap(NizamioSpacing.space2),
          Text(
            '${p.kind == 'move' ? 'Taşıma' : 'Kopyalama'} · ${p.rows} satır · ${p.columns.length} sütun',
            style: context.text.caption,
          ),
          Text(p.columns.join(' · '), style: context.text.caption),
          if (p.status == 'pending')
            Wrap(
              spacing: NizamioSpacing.space2,
              children: [
                for (final approve in [true, false])
                  NzButton.ghost(
                    label: approve ? 'Onayla' : 'Reddet',
                    onPressed: () async {
                      await _libraryForm(
                        context,
                        ref,
                        title: approve ? 'Öneriyi onayla' : 'Öneriyi reddet',
                        fields: (context, _) => Text(
                          approve
                              ? 'Tablonun bu sürümü önerilen alana alınacak ve önerideki ekip yetkisi uygulanacak.'
                              : 'Bu öneri reddedilecek. Kaynak tablo korunur.',
                        ),
                        submit: () => ref
                            .read(tableLibraryWritesProvider.notifier)
                            .run(
                              (key) => repo.decideProposal(
                                location,
                                p.id,
                                approve,
                                key,
                              ),
                            ),
                      );
                      if (context.mounted &&
                          ref.read(sessionGenerationProvider) == generation) {
                        reload();
                        await ref
                            .read(tablesControllerProvider.notifier)
                            .reloadServer(keepPrevious: true);
                      }
                    },
                  ),
              ],
            )
          else
            Text(switch (p.status) {
              'approved' => 'Onaylandı',
              'rejected' => 'Reddedildi',
              'withdrawn' => 'Geri çekildi',
              _ => 'Sonuçlandı',
            }, style: context.text.caption),
        ],
      ),
    ),
  );
}

class _LibraryPages<T> extends ConsumerStatefulWidget {
  const _LibraryPages({required this.load, required this.item, this.top});
  final Future<TablePageSlice<T>> Function(String?) load;
  final Widget Function(T, VoidCallback) item;
  final Widget Function(VoidCallback)? top;
  @override
  ConsumerState<_LibraryPages<T>> createState() => _LibraryPagesState<T>();
}

class _LibraryPagesState<T> extends ConsumerState<_LibraryPages<T>> {
  final _items = <T>[];
  String? _cursor;
  bool _loading = true;
  ApiError? _error;
  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  void _reload() {
    if (mounted) _load();
  }

  Future<void> _load({bool more = false}) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final p = await widget.load(more ? _cursor : null);
      if (mounted) {
        setState(() {
          if (!more) _items.clear();
          _items.addAll(p.items);
          _cursor = p.cursor;
          _loading = false;
        });
      }
    } on Object catch (e, st) {
      reportUnexpected(e, st, source: ReportSource.ui);
      if (mounted) {
        setState(() {
          _error = toApiError(e);
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tableLibraryWritesProvider.select((s) => s.revision), (
      previous,
      next,
    ) {
      if (previous != next) Future.microtask(_reload);
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.top != null) widget.top!(_reload),
        if (_loading) const Center(child: NzLoader()),
        if (_error != null) ...[
          Text(errorText(context.l10n, _error!)),
          NzButton.ghost(onPressed: _reload, label: 'Yeniden dene'),
        ],
        if (!_loading && _error == null && _items.isEmpty)
          const Text('Henüz kayıt yok.'),
        for (final p in _items) ...[
          const Gap(NizamioSpacing.space3),
          widget.item(p, _reload),
        ],
        if (_cursor != null)
          NzButton.ghost(
            onPressed: _loading ? null : () => _load(more: true),
            label: 'Daha fazla göster',
          ),
      ],
    );
  }
}
