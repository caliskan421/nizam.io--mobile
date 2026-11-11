import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../domain/chat.dart';

/// Kaynak seçimi yerel taslaktır; seçim sayfasını kapatmak sunucuya yazmaz.
class ChatGroupSourceFields extends StatelessWidget {
  const ChatGroupSourceFields({
    super.key,
    required this.source,
    required this.departmentId,
    required this.departments,
    required this.onChanged,
    this.enabled = true,
  });

  final ChatSource source;
  final String? departmentId;
  final List<ChatDepartmentOption> departments;
  final void Function(ChatSource source, String? departmentId) onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final department = departments
        .where((d) => d.id == departmentId)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: NizamioSpacing.space2,
      children: [
        NzFormRows(
          rows: [
            NzFormRow(
              label: l.uiMessagesGroupsSource,
              icon: NzIcons.group,
              value: groupSourceLabel(context, source),
              valueSet: true,
              onTap: enabled ? () => _pickSource(context) : null,
            ),
            if (source == ChatSource.department)
              NzFormRow(
                label: l.uiMessagesGroupsDepartment,
                value: department?.name ?? l.uiMessagesGroupsPickDepartment,
                valueSet: department != null,
                onTap: enabled ? () => _pickDepartment(context) : null,
              ),
          ],
        ),
        if (source != ChatSource.none)
          Text(
            l.uiMessagesGroupsSourceHint,
            style: context.text.caption.copyWith(
              color: context.colors.textMuted,
            ),
          ),
      ],
    );
  }

  Future<void> _pickSource(BuildContext context) async {
    final picked = await NzBottomSheet.show<ChatSource>(
      context,
      title: context.l10n.uiMessagesGroupsSource,
      compact: true,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in ChatSource.values)
            NzListTile(
              title: groupSourceLabel(context, option),
              trailing: source == option ? const NzIcon(NzIcons.check) : null,
              onTap: () => Navigator.of(sheet).pop(option),
            ),
        ],
      ),
    );
    if (!context.mounted || picked == null) return;
    onChanged(picked, picked == ChatSource.department ? departmentId : null);
  }

  Future<void> _pickDepartment(BuildContext context) async {
    final picked = await NzBottomSheet.show<String>(
      context,
      title: context.l10n.uiMessagesGroupsPickDepartment,
      compact: true,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (departments.isEmpty)
            Text(
              context.l10n.uiMessagesGroupsNoDepartments,
              style: context.text.caption,
            ),
          for (final d in departments)
            NzListTile(
              title: d.name,
              trailing: departmentId == d.id
                  ? const NzIcon(NzIcons.check)
                  : null,
              onTap: () => Navigator.of(sheet).pop(d.id),
            ),
        ],
      ),
    );
    if (!context.mounted || picked == null) return;
    // Liste değişmişse artık bağlı olmayan bir seçimi taşımayız.
    if (departments.any((d) => d.id == picked)) {
      onChanged(ChatSource.department, picked);
    }
  }
}

String groupSourceLabel(BuildContext context, ChatSource source) =>
    switch (source) {
      ChatSource.none => context.l10n.uiMessagesGroupsManual,
      ChatSource.program => context.l10n.uiMessagesGroupsProgram,
      ChatSource.department => context.l10n.uiMessagesGroupsDepartment,
    };
