import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../application/table_detail_controller.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import 'table_choice_row.dart';
import 'table_design.dart';
import 'table_grid_value.dart';
import 'table_sheet_host.dart';
import 'table_texts.dart';

void tableUiAction(
  BuildContext context,
  FutureOr<void> Function() action,
) async {
  if (!context.mounted) return;
  try {
    await action();
  } on Object catch (e, st) {
    final error = toReportedApiError(e, st, source: ReportSource.ui);
    if (context.mounted) NzToast.error(context, error);
  }
}

Future<bool> workspaceForm(
  BuildContext context,
  WidgetRef ref,
  String id, {
  required String title,
  String? description,
  String save = 'Kaydet',
  bool showCancel = true,
  bool saveInHeader = false,
  bool panelHeader = false,
  required Widget Function(BuildContext, VoidCallback) fields,
  required Future<bool> Function() submit,
  bool Function()? valid,
}) async {
  if (ref.read(tableDetailProvider(id)).pending) {
    if (context.mounted) {
      NzToast.show(
        context,
        'Önce bekleyen işlemi doğrula veya denemeyi bırak.',
      );
    }
    return false;
  }
  return tableActionForm(
    context,
    ref,
    title: title,
    description: description,
    save: save,
    showCancel: showCancel,
    saveInHeader: saveInHeader,
    panelHeader: panelHeader,
    tableId: id,
    fields: fields,
    submit: submit,
    valid: valid,
    pending: () => ref.read(tableDetailProvider(id)).pending,
    retry: () async =>
        await ref.read(tableDetailProvider(id).notifier).retry() != null,
    lastError: () => ref.read(tableDetailProvider(id)).error,
  );
}

Future<bool> tableActionForm(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  String? description,
  String save = 'Kaydet',
  bool showCancel = true,
  bool saveInHeader = false,
  bool panelHeader = false,
  String? tableId,
  required Widget Function(BuildContext, VoidCallback) fields,
  required Future<bool> Function() submit,
  bool Function()? valid,
  bool Function()? pending,
  Future<bool> Function()? retry,
  ApiError? Function()? lastError,
}) async {
  var busy = false;
  var saved = false;
  var active = true;
  ApiError? error;
  final revision = ValueNotifier(0);
  void update() {
    if (active) revision.value++;
  }

  Widget saveButton(BuildContext sheet) => ValueListenableBuilder(
    valueListenable: revision,
    builder: (context, _, _) => _tableFormButton(
      header: saveInHeader,
      label: busy
          ? 'Kaydediliyor…'
          : pending?.call() == true
          ? 'Kaydı yeniden dene'
          : save,
      onPressed: busy || valid?.call() == false
          ? null
          : () async {
              if (!active) return;
              busy = true;
              error = null;
              update();
              try {
                final done = pending?.call() == true
                    ? await retry!()
                    : await submit();
                if (!active || !sheet.mounted) return;
                if (done) {
                  saved = true;
                  Navigator.of(sheet).pop();
                  return;
                }
                error = lastError?.call();
              } on Object catch (e, st) {
                reportUnexpected(e, st, source: ReportSource.ui);
                error = toApiError(e);
              }
              if (active && sheet.mounted) {
                busy = false;
                update();
              }
            },
    ),
  );

  await showTableSheet(
    ref,
    context,
    title: title,
    headerAction: saveInHeader && !panelHeader
        ? Builder(builder: saveButton)
        : null,
    showHeader: !panelHeader,
    tableId: tableId,
    description: description,
    actionsDivider: false,
    actions: (sheet) => saveInHeader
        ? []
        : [
            Row(
              children: [
                if (showCancel) ...[
                  Expanded(
                    child: NzButton.secondary(
                      label: 'Vazgeç',
                      expand: true,
                      onPressed: () => Navigator.of(sheet).maybePop(),
                    ),
                  ),
                  const Gap(8),
                ],
                Expanded(child: saveButton(sheet)),
              ],
            ),
          ],
    builder: (context) => ValueListenableBuilder(
      valueListenable: revision,
      builder: (context, _, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (panelHeader) ...[
            Row(
              children: [
                NzIconButton(
                  icon: NzIcons.back,
                  semanticLabel: 'Geri',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.text.titleSm),
                      if (description != null)
                        Text(
                          description,
                          style: context.text.caption.copyWith(
                            color: context.colors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                saveButton(context),
              ],
            ),
            const Gap(16),
            Divider(height: 1, color: context.colors.border),
            const Gap(16),
          ],
          IgnorePointer(
            ignoring: busy || pending?.call() == true,
            child: fields(context, update),
          ),
          if (error != null) ...[
            const Gap(NizamioSpacing.space3),
            Text(errorText(context.l10n, error!)),
          ],
        ],
      ),
    ),
  );
  active = false;
  revision.dispose();
  return saved;
}

Widget _tableFormButton({
  required bool header,
  required String label,
  required VoidCallback? onPressed,
}) => header
    ? TableDesignButton(
        label: label,
        kind: TableButtonKind.plain,
        onPressed: onPressed,
      )
    : NzButton.primary(label: label, onPressed: onPressed);

Future<void> workspaceName(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  var name = ref.read(tableDetailProvider(id)).data!.document.title;
  await workspaceForm(
    context,
    ref,
    id,
    title: 'Tablo adı',
    valid: () => name.trim().isNotEmpty,
    fields: (context, update) => NzTextField(
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
    submit: () async => await controller.send(RenameTable(name.trim())) != null,
  );
}

Future<void> workspaceColumn(
  BuildContext context,
  WidgetRef ref,
  String id, {
  TableColumnState? column,
  TableColumnAction action = TableColumnAction.add,
}) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  final data = ref.read(tableDetailProvider(id)).data!;
  var name = column?.field.name ?? '';
  var schema = data.schema;
  var schemaAck = true;
  var schemaFresh = false;
  var columnGone = false;
  var type = column?.field.type ?? TableFieldType.text;
  var multiple = column?.multiple ?? false;
  var fileReference = column?.wireType == 'file_reference';
  final width = column?.width ?? 180;
  await workspaceForm(
    context,
    ref,
    id,
    title: switch (action) {
      TableColumnAction.convert => 'Sütun türünü değiştir',
      TableColumnAction.add => 'Sütun ekle',
      _ => 'Sütun adı',
    },
    valid: () => name.trim().isNotEmpty && schemaAck && !columnGone,
    fields: (context, update) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (ref.read(tableDetailProvider(id)).error?.code ==
            'tables.schema_conflict')
          NzButton.ghost(
            onPressed: () async {
              await controller.refresh();
              if (!context.mounted) return;
              final latest = ref.read(tableDetailProvider(id)).data;
              if (latest == null) return;
              schema = latest.schema;
              schemaAck = false;
              schemaFresh = true;
              columnGone =
                  column != null &&
                  !latest.columns.any((c) => c.field.id == column.field.id);
              update();
            },
            label: 'Güncel sütun düzenini al',
          ),
        if (schemaFresh) ...[
          Text(
            columnGone
                ? 'Bu sütun artık yok. Formu kapatıp tabloyu yeniden kontrol et.'
                : 'Tablonun sütun düzeni değişti. Taslağın korunuyor.',
            style: context.text.caption,
          ),
          if (!columnGone)
            TableChoiceRow(
              label: 'Değişikliğimi güncel sütun düzenine uygula',
              value: schemaAck,
              onChanged: (v) {
                schemaAck = v;
                update();
              },
            ),
        ],
        if (action == TableColumnAction.add ||
            action == TableColumnAction.rename)
          NzTextField(
            pill: true,
            labelAbove: false,
            label: 'Sütun adı',
            initialValue: name,
            maxLength: 200,
            onChanged: (v) {
              name = v;
              update();
            },
          ),
        if (action == TableColumnAction.add ||
            action == TableColumnAction.convert) ...[
          const Gap(NizamioSpacing.space3),
          NzSelect<TableFieldType>(
            label: 'Tür',
            value: type,
            items: [
              for (final t in TableFieldType.values)
                NzSelectItem(
                  value: t,
                  label: context.l10n.tableType(t),
                  glyph: tableFieldTypeGlyph(t),
                ),
            ],
            onChanged: (v) {
              if (v != null) {
                type = v;
                update();
              }
            },
          ),
          if (type == TableFieldType.file) ...[
            const Gap(NizamioSpacing.space3),
            NzPillTabs(
              tabs: const [
                NzPillTab(label: 'Dosya eki'),
                NzPillTab(label: 'Görev dosyası'),
              ],
              selected: fileReference ? 1 : 0,
              onSelected: (v) {
                fileReference = v == 1;
                update();
              },
            ),
          ],
          if (action == TableColumnAction.add &&
              [
                TableFieldType.person,
                TableFieldType.unit,
                TableFieldType.task,
                TableFieldType.link,
              ].contains(type))
            NzFormRows(
              rows: [
                NzFormRow.toggle(
                  label: 'Birden fazla seçim',
                  value: multiple,
                  onChanged: (v) {
                    multiple = v;
                    update();
                  },
                ),
              ],
            ),
          if (action == TableColumnAction.convert) ...[
            const Gap(NizamioSpacing.space3),
            Text(
              'Yalnız kayıpsız dönüşümler uygulanır. Mevcut içerik dönüştürülemiyorsa işlem yapılmaz.',
              style: context.text.caption,
            ),
          ],
        ],
      ],
    ),
    submit: () async =>
        await controller.send(
          EditTableColumn(
            action,
            TableField(
              id: column?.field.id ?? '',
              name: name.trim(),
              type: type,
            ),
            schema,
            width: width,
            multiple:
                multiple &&
                ([
                      TableFieldType.person,
                      TableFieldType.unit,
                      TableFieldType.task,
                      TableFieldType.link,
                    ].contains(type) ||
                    (type == TableFieldType.file && fileReference)),
            fileReference: type == TableFieldType.file && fileReference,
          ),
        ) !=
        null,
  );
}

Future<bool> workspaceConfirm(
  BuildContext context,
  WidgetRef ref,
  String id, {
  required String title,
  required String message,
  required TableEdit edit,
}) async {
  var done = false;
  done = await workspaceForm(
    context,
    ref,
    id,
    title: title,
    save: 'Uygula',
    fields: (context, _) => Text(message, style: context.text.bodyMd),
    submit: () async {
      done =
          await ref.read(tableDetailProvider(id).notifier).send(edit) != null;
      return done;
    },
  );
  return done;
}

Future<void> workspaceAbandon(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  await tableActionForm(
    context,
    ref,
    title: 'Bekleyen denemeyi bırak',
    save: 'Denemeyi bırak',
    fields: (context, _) => const Text(
      'İşlem sunucuda uygulanmış olabilir. Bekleyen denemeyi bırakmak yapılmış değişiklikleri geri almaz. Güncel tabloyu kontrol ettiğinden emin ol.',
    ),
    submit: () async {
      ref.read(tableDetailProvider(id).notifier).abandonPending();
      return true;
    },
  );
}
