import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../application/table_detail_controller.dart';
import '../application/tables_controller.dart';
import '../application/tables_server.dart';
import '../domain/table_document.dart';
import '../domain/table_edit.dart';
import '../domain/table_workspace.dart';
import '../domain/tables_repository.dart';
import 'table_destination_fields.dart';
import 'table_library_tools.dart' show showTableProjects;
import 'table_project_picker.dart';
import 'table_sharing_picker.dart';
import 'table_workspace_forms.dart';

Future<void> workspaceCopy(
  BuildContext context,
  WidgetRef ref,
  String id, {
  ValueChanged<String>? onOpenTable,
}) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  final data = ref.read(tableDetailProvider(id)).data!;
  if (!context.mounted) return;
  var target = TableLocation(controller.location.programId);
  String? project;
  var full = false;
  var name = '${data.document.title} · kopya';
  String? created;
  await workspaceForm(
    context,
    ref,
    id,
    title: 'Tabloyu kopyala',
    save: 'Kopyala',
    valid: () => name.trim().isNotEmpty,
    description:
        'Kopya sana ait olur. Paylaşım izinleri ve yorumlar kopyalanmaz.',
    fields: (context, update) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzTextField(
          pill: true,
          labelAbove: false,
          label: 'Tablo adı',
          initialValue: name,
          maxLength: 200,
          onChanged: (v) {
            name = v;
            update();
          },
        ),
        const Gap(NizamioSpacing.space3),
        TableDestinationFields(
          location: target,
          project: project,
          allowProgram: true,
          onChanged: (l, p) {
            target = l;
            project = p;
            if (l.programId != controller.location.programId) full = false;
            update();
          },
        ),
        const Gap(NizamioSpacing.space3),
        NzPillTabs(
          tabs: [
            const NzPillTab(label: 'Yalnız yapı'),
            NzPillTab(
              label: 'Tüm içerik',
              enabled: target.programId == controller.location.programId,
            ),
          ],
          selected: full ? 1 : 0,
          onSelected: (i) {
            full = i == 1;
            update();
          },
        ),
        const Gap(NizamioSpacing.space2),
        Text(
          full
              ? 'Satırlar, hücreler ve dosya ekleri bağımsız kopyalanır.'
              : 'Yalnız sütunlar kopyalanır.',
          style: context.text.caption,
        ),
      ],
    ),
    submit: () async {
      final destination = target;
      final targetProject = project;
      final copyName = name.trim();
      final copyFull = full;
      final source = controller.location;
      final repo = controller.repository;
      final r = await controller.perform((key) async {
        created = await repo.copy(
          source,
          id,
          destination,
          full: copyFull,
          project: targetProject,
          key: key,
          name: copyName,
        );
        return TableOperationReceipt(
          table: created!,
          sequence: 0,
          schema: 1,
          id: created,
        );
      });
      return r != null;
    },
  );
  if (created != null && context.mounted) {
    await ref
        .read(tablesControllerProvider.notifier)
        .reloadServer(keepPrevious: true);
    if (context.mounted) {
      if (target.programId == controller.location.programId) {
        onOpenTable?.call(created!);
      } else {
        NzToast.show(context, 'Tablo seçtiğin programa kopyalandı.');
      }
    }
  }
}

Future<void> workspaceTransfer(
  BuildContext context,
  WidgetRef ref,
  String id, {
  ValueChanged<String>? onOpenTable,
}) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  final choices = await ref.read(tableSharingChoicesProvider.future);
  if (!context.mounted) return;
  var department = controller.location.departmentId;
  String? targetProject;
  var action = TableTransferAction.move;
  bool canMoveDirectly() =>
      !controller.location.personal ||
      department.isEmpty ||
      choices.canPublish(department);
  var access = TableAccess.view;
  var done = false;
  done = await workspaceForm(
    context,
    ref,
    id,
    title: 'Taşı veya onaya gönder',
    save: 'Uygula',
    description: 'Taşıma kişisel sahipliği korur; açık paylaşımlar ve klasör bağı hedef kurallarına göre temizlenir. Hedef ekibin erişimi ayrıca belirlenir.',
    valid: () =>
        action == TableTransferAction.withdraw ||
        (department != controller.location.departmentId &&
            (action == TableTransferAction.move || department.isNotEmpty) &&
            (action != TableTransferAction.move || canMoveDirectly())),
    fields: (context, update) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzSelect<TableTransferAction>(
          label: 'İşlem',
          value: action,
          items: [
            NzSelectItem(
              value: TableTransferAction.move,
              label: 'Doğrudan taşı',
              enabled: canMoveDirectly(),
            ),
            if (controller.location.personal)
              const NzSelectItem(
                value: TableTransferAction.proposeMove,
                label: 'Taşıma onayı iste',
              ),
            if (controller.location.personal)
              const NzSelectItem(
                value: TableTransferAction.proposeCopy,
                label: 'Kopyalama onayı iste',
              ),
            if (controller.location.personal)
              const NzSelectItem(
                value: TableTransferAction.withdraw,
                label: 'Bekleyen öneriyi geri çek',
              ),
          ],
          onChanged: (v) {
            if (v != null) {
              action = v;
              update();
            }
          },
        ),
        if (action != TableTransferAction.withdraw) ...[
          const Gap(NizamioSpacing.space3),
          TableDestinationFields(
            location: TableLocation(controller.location.programId, department),
            project: targetProject,
            allowPersonal: action == TableTransferAction.move,
            onChanged: (l, p) {
              department = l.departmentId;
              targetProject = p;
              if (controller.location.personal &&
                  action == TableTransferAction.move &&
                  department.isNotEmpty &&
                  !choices.canPublish(department)) {
                action = TableTransferAction.proposeMove;
              }
              update();
            },
          ),
        ],
        if (action == TableTransferAction.proposeMove ||
            action == TableTransferAction.proposeCopy) ...[
          const Gap(NizamioSpacing.space3),
          Text('Onaylanınca ekip erişimi', style: context.text.labelMd),
          TablePermissionControl(
            value: access,
            label: 'Onay sonrası ekip yetkisi',
            onChanged: (v) {
              access = v;
              update();
            },
          ),
          const Gap(NizamioSpacing.space2),
          Text(
            'Tablonun bu sürümü için hedef koordinatörün onayı istenir. İçerik değişirse öneri bayatlar.',
            style: context.text.caption,
          ),
        ],
      ],
    ),
    submit: () async {
      done =
          await controller.send(
            TransferTable(
              action,
              TableLocation(controller.location.programId, department),
              access: access,
              project: targetProject,
            ),
          ) !=
          null;
      return done;
    },
  );
  if (done && context.mounted) {
    await ref
        .read(tablesControllerProvider.notifier)
        .reloadServer(keepPrevious: true);
    if (context.mounted) {
      NzToast.show(
        context,
        action == TableTransferAction.move
            ? 'Tablo taşındı.'
            : action == TableTransferAction.withdraw
            ? 'Öneri geri çekildi.'
            : 'Öneri onaya gönderildi.',
      );
    }
  }
}

Future<void> workspaceProject(
  BuildContext context,
  WidgetRef ref,
  String id,
) async {
  final controller = ref.read(tableDetailProvider(id).notifier);
  var selected = ref.read(tableDetailProvider(id)).data!.project;
  var revision = 0;
  await workspaceForm(
    context,
    ref,
    id,
    title: 'Klasör',
    description:
        'Klasörler tabloları gruplar. Klasör seçmek erişim izni vermez.',
    fields: (context, update) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableProjectPicker(
          key: ValueKey(revision),
          location: controller.location,
          value: selected,
          onChanged: (v) {
            selected = v;
            update();
          },
        ),
        const Gap(NizamioSpacing.space3),
        NzButton.ghost(
          onPressed: () async {
            await showTableProjects(context, ref, controller.location);
            if (context.mounted) {
              revision++;
              update();
            }
          },
          label: 'Klasörleri yönet',
        ),
      ],
    ),
    submit: () async =>
        await controller.send(SetTableProject(selected)) != null,
  );
}
