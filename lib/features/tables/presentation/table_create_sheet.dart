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
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../tasks/tasks.dart'
    show
        AutoExpand,
        QuickFormLayout,
        QuickPane,
        QuickTitleField,
        TaskCheckRow,
        TaskSegmented;
import '../application/table_create_job.dart';
import '../application/tables_controller.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';

/// Liste ekranının oluşturma taslağı. Paylaşım seçilmedikçe kişisel ve özeldir.
/// Canlı kayıt adımları ve anahtarları aynı oturumda yeniden açılınca korunur.
Future<void> showCreateTableSheet(
  BuildContext context,
  WidgetRef ref, {
  required ValueChanged<String> onCreated,
  TableTemplate initialTemplate = TableTemplate.blank,
}) async {
  final l = context.l10n;
  final controller = ref.read(tablesControllerProvider.notifier);
  final lease = controller.lease;
  final repository = ref.read(tablesRepositoryProvider);
  final program = ref.read(scopeStateProvider).programId ?? '';
  var job = controller.pendingCreateJob;
  var name = job?.title ?? '';
  var template = job?.template ?? initialTemplate;
  String? unit =
      job?.proposalDepartment ??
      (job?.location.personal == false ? job!.location.departmentId : null);
  var teamAccess = job?.teamAccess ?? TableAccess.view;
  var busy = false;
  ApiError? error;
  var query = '';
  var sharingTab = 0;
  int? pane;
  final people = <TablePersonId, TableAccess>{...?job?.people};
  final changes = ValueNotifier(0);
  final expansion = ValueNotifier(false);
  final auto = AutoExpand(expansion);
  ModalRoute<dynamic>? route;
  void update(VoidCallback change) {
    change();
    changes.value++;
  }

  bool current() => ref.context.mounted && identical(lease, controller.lease);
  Future<void> submit(BuildContext sheet) async {
    if (busy || !current()) return;
    if (repository == null) {
      final id = controller.create(
        expectedLease: lease,
        title: name,
        fields: l.templateFields(template),
        area: unit == null ? TableArea.personal : TableArea.coord,
        unit: unit ?? 'DEMO-A',
        teamAccess: unit == null ? TableAccess.off : teamAccess,
        people: people,
      );
      if (id == null) return;
      Navigator.of(sheet).pop();
      onCreated(id);
      return;
    }
    FocusScope.of(sheet).unfocus();
    update(() {
      busy = true;
      error = null;
    });
    try {
      final choices = await ref.read(tableSharingChoicesProvider.future);
      if (!current() || !sheet.mounted) return;
      final needsApproval = unit != null && !choices.canPublish(unit!);
      if (needsApproval && people.isNotEmpty) {
        throw ApiError('tables.input_invalid');
      }
      job ??= TableCreateJob(
        repository: repository,
        location: TableLocation(program, needsApproval ? '' : unit ?? ''),
        title: name.trim(),
        template: template,
        fields: l.templateFields(template),
        people: people,
        teamAccess: unit == null ? TableAccess.off : teamAccess,
        proposalDepartment: needsApproval ? unit : null,
      );
      controller.pendingCreateJob = job;
      await job!.submit(isCurrent: () => current() && sheet.mounted);
      if (!current()) return;
      controller.pendingCreateJob = null;
      controller.setArea(
        needsApproval || unit == null ? TableArea.personal : TableArea.coord,
      );
      controller.setUnit(needsApproval ? null : unit);
      await controller.reloadServer();
      if (!current() || !sheet.mounted) return;
      Navigator.of(sheet).pop();
      NzToast.show(
        context,
        needsApproval
            ? 'Tablo oluşturuldu. Koordinatörlüğe açılması için onay isteği gönderildi.'
            : 'Tablo oluşturuldu ve seçtiğin paylaşımlar kaydedildi.',
        tone: NzToastTone.success,
      );
    } on Object catch (e, st) {
      final reported = toReportedApiError(e, st, source: ReportSource.ui);
      if (current()) {
        error = reported;
        if (job?.tableId == null && !isOutcomeUnknown(error!)) {
          job = null;
          controller.pendingCreateJob = null;
        }
      }
    } finally {
      if (current() && sheet.mounted) update(() => busy = false);
    }
  }

  Widget permission(TableAccess value, ValueChanged<TableAccess> onChanged) =>
      NzFormRows(
        rows: [
          NzFormRow.custom(
            label: 'Yetki',
            trailing: TaskSegmented(
              compact: true,
              labels: const ['Görüntüleme', 'Düzenleme'],
              selected: value == TableAccess.edit ? 1 : 0,
              onSelected: (i) =>
                  onChanged(i == 0 ? TableAccess.view : TableAccess.edit),
            ),
          ),
        ],
      );

  await showTableSheet(
    ref,
    context,
    title: l.uiTablesNew,
    description: 'Tablonu oluştur, istersen kişi veya koordinatörlükle paylaş.',
    expandable: true,
    expansion: expansion,
    actions: (sheet) => [
      for (var i = 0; i < 2; i++)
        ValueListenableBuilder<int>(
          valueListenable: changes,
          builder: (context, _, _) => nzSheetActions(
            sheet,
            cancel: l.uiTablesCancel,
            ok: busy
                ? 'Kaydediliyor…'
                : job != null
                ? 'Kayda devam et'
                : l.uiTablesCreate,
            onOk: busy || name.trim().isEmpty || name.trim().runes.length > 200
                ? null
                : () => submit(sheet),
          )[i],
        ),
    ],
    builder: (sheet) {
      route = ModalRoute.of(sheet);
      return Consumer(
        builder: (context, sheetRef, _) {
          final candidates = repository == null
              ? null
              : sheetRef.watch(tableSharingChoicesProvider);
          final choices = candidates?.value;
          return ValueListenableBuilder<int>(
            valueListenable: changes,
            builder: (context, _, _) {
              final selection = [
                if (people.isNotEmpty) '${people.length} kişi',
                if (unit != null)
                  choices?.departments[TableDepartmentId(unit!)] ??
                      l.tableUnit(unit!),
              ];
              final sharing = selection.isEmpty
                  ? 'Yalnızca ben'
                  : selection.join(' · ');
              return QuickFormLayout(
                fields: [
                  IgnorePointer(
                    ignoring: busy || job != null,
                    child: QuickTitleField(
                      label: l.uiTablesName,
                      hint: 'Tabloya bir ad ver',
                      value: name,
                      maxLength: 200,
                      onChanged: (v) => update(() => name = v),
                    ),
                  ),
                ],
                rows: IgnorePointer(
                  ignoring: busy || job != null,
                  child: NzFormRows(
                    expandedIndex: pane,
                    onToggle: (i) => update(() {
                      pane = pane == i ? null : i;
                      auto.onPane(opened: pane != null);
                    }),
                    rows: [
                      NzFormRow(
                        label: 'Başlangıç düzeni',
                        icon: NzIcons.sheets,
                        value: l.tableTemplate(template),
                        valueSet: true,
                        content: QuickPane(
                          child: Column(
                            children: [
                              for (final t in TableTemplate.values)
                                TaskCheckRow(
                                  label: l.tableTemplate(t),
                                  caption: l
                                      .templateFields(t)
                                      .map((f) => f.name)
                                      .join(' · '),
                                  radio: true,
                                  selected: template == t,
                                  onTap: () => update(() {
                                    template = t;
                                    pane = null;
                                    auto.onPane(opened: false);
                                  }),
                                ),
                            ],
                          ),
                        ),
                      ),
                      NzFormRow(
                        label: 'Paylaşım',
                        icon: NzIcons.personAdd,
                        value: sharing,
                        valueSet: true,
                        content: QuickPane(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Sen tablo sahibisin. Paylaşım eklemezsen yalnızca sen erişebilirsin.',
                                style: context.text.caption.copyWith(
                                  color: context.colors.textMuted,
                                ),
                              ),
                              const Gap(NizamioSpacing.space3),
                              TaskSegmented(
                                labels: const ['Kişiler', 'Koordinatörlük'],
                                selected: sharingTab,
                                onSelected: (i) => update(() {
                                  sharingTab = i;
                                  query = '';
                                }),
                              ),
                              const Gap(NizamioSpacing.space3),
                              NzTextField(
                                key: ValueKey(sharingTab),
                                label: sharingTab == 0
                                    ? l.uiTablesPersonSearch
                                    : 'Koordinatörlük ara',
                                labelAbove: false,
                                onChanged: (v) => update(
                                  () => query = v.trim().toLowerCase(),
                                ),
                              ),
                              const Gap(NizamioSpacing.space2),
                              if (candidates?.isLoading == true)
                                const CircularProgressIndicator(),
                              if (candidates?.error case final e?) ...[
                                Text(errorText(l, toApiError(e))),
                                TextButton(
                                  onPressed: () => controller.reloadServer(
                                    refreshChoices: true,
                                  ),
                                  child: const Text('Yeniden dene'),
                                ),
                              ],
                              if (sharingTab == 0) ...[
                                if (repository != null)
                                  Text(
                                    'Kişiler erişebildiğin ekip kataloğuyla sınırlıdır.',
                                    style: context.text.caption,
                                  ),
                                for (final id
                                    in (repository == null
                                        ? [
                                            'demo-1',
                                            'demo-2',
                                            'demo-3',
                                            'demo-4',
                                          ]
                                        : choices
                                                  ?.peopleIn(unit)
                                                  .keys
                                                  .map((id) => id.value)
                                                  .toList() ??
                                              <String>[]))
                                  if ((choices?.people[TablePersonId(id)] ??
                                          l.tableDemoPerson(id))
                                      .toLowerCase()
                                      .contains(query)) ...[
                                    TaskCheckRow(
                                      label:
                                          choices?.people[TablePersonId(id)] ??
                                          l.tableDemoPerson(id),
                                      selected: people.containsKey(
                                        TablePersonId(id),
                                      ),
                                      onTap: () => update(() {
                                        final key = TablePersonId(id);
                                        if (people.containsKey(key)) {
                                          people.remove(key);
                                        } else {
                                          people[key] = TableAccess.view;
                                        }
                                      }),
                                    ),
                                    if (people.containsKey(TablePersonId(id)))
                                      permission(
                                        people[TablePersonId(id)]!,
                                        (v) => update(
                                          () => people[TablePersonId(id)] = v,
                                        ),
                                      ),
                                  ],
                              ] else ...[
                                Text(
                                  'Seçtiğin koordinatörlüğün tüm güncel üyeleri erişir.',
                                  style: context.text.caption,
                                ),
                                TaskCheckRow(
                                  label: 'Koordinatörlükle paylaşma',
                                  radio: true,
                                  selected: unit == null,
                                  onTap: () => update(() => unit = null),
                                ),
                                for (final u
                                    in (repository == null
                                        ? tableDemoUnits
                                        : choices?.departments.keys
                                                  .map((id) => id.value)
                                                  .toList() ??
                                              <String>[]))
                                  if ((choices?.departments[TableDepartmentId(
                                            u,
                                          )] ??
                                          l.tableUnit(u))
                                      .toLowerCase()
                                      .contains(query)) ...[
                                    TaskCheckRow(
                                      label:
                                          choices
                                              ?.departments[TableDepartmentId(
                                            u,
                                          )] ??
                                          l.tableUnit(u),
                                      radio: true,
                                      selected: unit == u,
                                      onTap: () => update(() {
                                        unit = u;
                                        if (choices != null) {
                                          people.removeWhere(
                                            (id, _) => !choices
                                                .peopleIn(u)
                                                .containsKey(id),
                                          );
                                        }
                                      }),
                                    ),
                                    if (unit == u)
                                      permission(
                                        teamAccess,
                                        (v) => update(() => teamAccess = v),
                                      ),
                                  ],
                              ],
                              const Gap(NizamioSpacing.space2),
                              Text(
                                'Görüntüleme içeriği okumaya, düzenleme satır ve sütunları değiştirmeye izin verir.',
                                style: context.text.caption.copyWith(
                                  color: context.colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                footer: [
                  if (unit != null &&
                      choices != null &&
                      !choices.canPublish(unit!))
                    Text(
                      'Bu koordinatörlüğe açmak için onay isteği gönderilecek. Onaylanana kadar tablo yalnız sana açıktır; ayrıca kişi ekleyemezsin.',
                      style: context.text.caption,
                    ),
                  if (job != null)
                    Text(
                      job!.tableId == null
                          ? 'Kaydın sonucu henüz doğrulanamadı. Aynı kaydı güvenle yeniden deneyebilirsin.'
                          : 'Tablo oluşturuldu. Kalan kurulum ve paylaşım adımlarına devam edebilirsin.',
                      style: context.text.caption,
                    ),
                  if (job?.tableId != null && error != null && !busy)
                    NzButton.secondary(
                      label: 'Kaydedilen tabloya dön',
                      onPressed: () async {
                        controller.pendingCreateJob = null;
                        await controller.reloadServer();
                        if (!current() || !sheet.mounted) return;
                        Navigator.of(sheet).pop();
                        NzToast.show(
                          context,
                          'Tablo ve tamamlanan adımlar korundu. Kalan adımlar uygulanmadı.',
                        );
                      },
                    ),
                  if (error != null)
                    Text(
                      errorText(l, error!),
                      style: context.text.caption.copyWith(
                        color: context.colors.danger,
                      ),
                    ),
                  Text(
                    selection.isEmpty
                        ? 'Yalnızca sen erişebilirsin. Daha sonra paylaşabilirsin.'
                        : 'Paylaşım: $sharing. Tablo sahibi olarak yetkileri sen yönetirsin.',
                    style: context.text.caption.copyWith(
                      color: context.colors.textMuted,
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
  // Bildirim nesneleri kapanış animasyonu ve overlay kaldırılana kadar yaşar.
  await route?.completed;
  changes.dispose();
  expansion.dispose();
}
