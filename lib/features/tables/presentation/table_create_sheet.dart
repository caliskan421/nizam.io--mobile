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
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../tasks/tasks.dart'
    show AutoExpand, QuickFormLayout, QuickPane, QuickTitleField;
import '../application/table_create_job.dart';
import '../application/tables_controller.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import '../domain/tables_repository.dart';
import 'table_sharing_picker.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';

/// Liste ekranının oluşturma taslağı. Erişim eklenmedikçe yalnız sahibine açıktır.
/// Canlı kayıt adımları ve anahtarları aynı oturumda yeniden açılınca korunur.
Future<void> showCreateTableSheet(
  BuildContext context,
  WidgetRef ref, {
  required ValueChanged<String> onCreated,
  TableTemplate initialTemplate = TableTemplate.blank,
  String? initialDepartment,
}) async {
  final l = context.l10n;
  final controller = ref.read(tablesControllerProvider.notifier);
  final lease = controller.lease;
  final repository = ref.read(tablesRepositoryProvider);
  final program = ref.read(scopeStateProvider).programId ?? '';
  var job = controller.pendingCreateJob;
  var name = job?.title ?? '';
  final template = job?.template ?? initialTemplate;
  String? unit =
      job?.proposalDepartment ??
      (job != null
          ? (job.location.personal ? null : job.location.departmentId)
          : initialDepartment);
  var teamAccess = job?.teamAccess ?? TableAccess.view;
  var shareWholeTeam = job != null && job.teamAccess != TableAccess.off;
  var teamQuery = '';
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
  Iterable<TablePersonId> teamIds(TableSharingChoices? choices) => unit == null
      ? const <TablePersonId>[]
      : repository == null
      ? const [
          TablePersonId('demo-1'),
          TablePersonId('demo-2'),
          TablePersonId('demo-3'),
          TablePersonId('demo-4'),
        ]
      : choices?.teamPeopleIn(unit!).keys ?? <TablePersonId>[];
  void selectTeam(TableSharingChoices? choices) {
    for (final id in teamIds(choices)) {
      people[id] = teamAccess;
    }
  }

  void individualChange(TablePersonId id, TableAccess access) => update(() {
    if (shareWholeTeam) selectTeam(ref.read(tableSharingChoicesProvider).value);
    shareWholeTeam = false;
    people[id] = access;
  });
  void individualRemove(TablePersonId id) => update(() {
    if (shareWholeTeam) selectTeam(ref.read(tableSharingChoicesProvider).value);
    shareWholeTeam = false;
    people.remove(id);
  });

  Future<void> submit(BuildContext sheet) async {
    if (busy || !current()) return;
    final members = teamIds(
      repository == null ? null : ref.read(tableSharingChoicesProvider).value,
    ).toSet();
    final sharedPeople = <TablePersonId, TableAccess>{
      for (final entry in people.entries)
        if (!shareWholeTeam || unit == null || !members.contains(entry.key))
          entry.key: entry.value,
    };
    final sharedTeamAccess = unit != null && shareWholeTeam
        ? teamAccess
        : TableAccess.off;
    if (repository == null) {
      final id = controller.create(
        expectedLease: lease,
        title: name,
        fields: l.templateFields(template),
        area: unit == null ? TableArea.personal : TableArea.coord,
        unit: unit ?? 'DEMO-A',
        teamAccess: sharedTeamAccess,
        people: sharedPeople,
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
      // Yeni koordinatörlük tablosunu kapsam üyesi doğrudan açabilir.
      // Önceki sürümde başlamış bir öneri planı aynı anahtarlarla sürdürülür.
      final needsApproval = job?.proposalDepartment != null;
      if (job == null &&
          unit != null &&
          !choices.departments.containsKey(TableDepartmentId(unit!))) {
        throw ApiError('tables.reference_unavailable');
      }
      job ??= TableCreateJob(
        repository: repository,
        location: TableLocation(program, needsApproval ? '' : unit ?? ''),
        title: name.trim(),
        template: template,
        fields: l.templateFields(template),
        people: sharedPeople,
        teamAccess: sharedTeamAccess,
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
                if (people.isNotEmpty && (unit == null || !shareWholeTeam))
                  '${people.length} kişi',
                if (unit != null && shareWholeTeam) 'Tüm ekip',
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
                      pill: true,
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
                              NzPillTabs(
                                tabs: const [
                                  NzPillTab(label: 'Kişiler'),
                                  NzPillTab(label: 'Koordinatörlük'),
                                ],
                                selected: sharingTab,
                                onSelected: (i) => update(() {
                                  sharingTab = i;
                                  query = '';
                                }),
                              ),
                              const Gap(NizamioSpacing.space3),
                              if (sharingTab == 0) ...[
                                NzSearchField(
                                  key: const ValueKey('people-search'),
                                  label: 'Ad ile ara',
                                  onChanged: (v) => update(
                                    () => query = v.trim().toLowerCase(),
                                  ),
                                ),
                                const Gap(NizamioSpacing.space2),
                              ],
                              if (candidates?.isLoading == true)
                                const NzLoader(),
                              if (candidates?.error case final e?) ...[
                                Text(errorText(l, toApiError(e))),
                                NzButton.ghost(
                                  onPressed: () => controller.reloadServer(
                                    refreshChoices: true,
                                  ),
                                  label: 'Yeniden dene',
                                ),
                              ],
                              if (sharingTab == 0) ...[
                                if (unit != null && shareWholeTeam)
                                  Text(
                                    'Tüm ekip seçili. Bir kişinin yetkisini değiştirir veya kişiyi çıkarırsan paylaşım kişi bazına geçer.',
                                    style: context.text.caption,
                                  ),
                                TableSharingPeople(
                                  choices: choices,
                                  people: people,
                                  query: query,
                                  department: unit,
                                  prototype: repository == null,
                                  onChanged: individualChange,
                                  onRemove: individualRemove,
                                ),
                              ] else ...[
                                Text(
                                  'Tablonun bulunacağı koordinatörlüğü ve erişecek kişileri seç.',
                                  style: context.text.caption,
                                ),
                                NzSelect<String>(
                                  label: 'Tablonun koordinatörlüğü',
                                  value: unit ?? '',
                                  items: [
                                    const NzSelectItem(
                                      value: '',
                                      label: 'Koordinatörlükle paylaşma',
                                    ),
                                    for (final u
                                        in repository == null
                                            ? tableDemoUnits
                                            : choices?.departments.keys
                                                      .map((id) => id.value)
                                                      .toList() ??
                                                  <String>[])
                                      NzSelectItem(
                                        value: u,
                                        label:
                                            choices
                                                ?.departments[TableDepartmentId(
                                              u,
                                            )] ??
                                            l.tableUnit(u),
                                      ),
                                  ],
                                  onChanged: (value) => update(() {
                                    final next = value == null || value.isEmpty
                                        ? null
                                        : value;
                                    if (unit != next) {
                                      shareWholeTeam = false;
                                      teamQuery = '';
                                      unit = next;
                                      if (choices != null && next != null) {
                                        people.removeWhere(
                                          (id, _) => !choices
                                              .peopleIn(next)
                                              .containsKey(id),
                                        );
                                      }
                                    }
                                  }),
                                ),
                                if (unit case final u?) ...[
                                  const Gap(NizamioSpacing.space4),
                                  NzPillTabs(
                                    semanticLabel: 'Koordinatörlük erişimi',
                                    tabs: const [
                                      NzPillTab(label: 'Seçtiğim kişiler'),
                                      NzPillTab(label: 'Tüm ekip'),
                                    ],
                                    selected: shareWholeTeam ? 1 : 0,
                                    onSelected: (i) => update(() {
                                      if (shareWholeTeam || i == 1) {
                                        selectTeam(choices);
                                      }
                                      shareWholeTeam = i == 1;
                                    }),
                                  ),
                                  const Gap(NizamioSpacing.space3),
                                  if (shareWholeTeam) ...[
                                    TablePermissionControl(
                                      value: teamAccess,
                                      label: 'Koordinatörlük ekibinin erişim yetkisi',
                                      onChanged: (v) => update(() {
                                        teamAccess = v;
                                        selectTeam(choices);
                                      }),
                                    ),
                                    Text(
                                      'Koordinatörlüğe sonradan katılanlar da bu yetkiyle erişir.',
                                      style: context.text.caption,
                                    ),
                                  ],
                                  const Gap(NizamioSpacing.space3),
                                  Text(
                                    shareWholeTeam
                                        ? 'Kişiye özel değişiklik yaptığında mevcut ekip seçili kalır; sonradan katılanlar otomatik eklenmez.'
                                        : 'Seçili kişilerin yetkilerini ayrı ayrı değiştirebilir veya kişileri çıkarabilirsin.',
                                    style: context.text.caption,
                                  ),
                                  const Gap(NizamioSpacing.space3),
                                  NzSearchField(
                                    key: ValueKey('team-search:$u'),
                                    label: 'Ekipte kişi ara',
                                    onChanged: (v) => update(
                                      () => teamQuery = v.trim().toLowerCase(),
                                    ),
                                  ),
                                  const Gap(NizamioSpacing.space3),
                                  TableSharingPeople(
                                    choices: choices,
                                    people: people,
                                    query: teamQuery,
                                    department: u,
                                    prototype: repository == null,
                                    groupByDepartment: false,
                                    onChanged: individualChange,
                                    onRemove: individualRemove,
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
