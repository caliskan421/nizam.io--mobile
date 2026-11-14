import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/domain/effective_role.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/scope_selection_controller.dart';
import '../../domain/program.dart';
import '../program_badge.dart';
import '../program_unread_badge.dart';
import 'module_menu_texts.dart';

/// Kenar çubuğunun üçlü seçicisi (program × rol × koordinatörlük; `sidebar-rol.png`): program
/// ve rol kartları yan yana, koordinatörlük kartı altında tam genişlik. Yönetici rolünde
/// koordinatörlük kartı yerine not. Program kartı mevcut kapsam değiştirme akışını açar
/// ([onChangeScope]); rol ve koordinatörlük alt sayfadan seçilir, geçerli seçim [onViewChanged]
/// ile yeni görünüm başlığını ("Koordinatör · Altyapı ve tesisat") bildirir. Erişim henüz
/// bilinmiyorsa yalnız program kartı çizilir.
class ScopeSwitcher extends ConsumerWidget {
  const ScopeSwitcher({
    super.key,
    required this.programName,
    this.programShortName,
    this.programColor,
    required this.onChangeScope,
    required this.onViewChanged,
  });

  final String programName;
  final String? programShortName;
  final ProgramColor? programColor;
  final VoidCallback onChangeScope;
  final ValueChanged<String> onViewChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final view = ref.watch(effectiveAccessProvider);
    final programId = ref.watch(scopeStateProvider).programId;
    final program = NzPickerCard(
      label: l.uiHomePickerProgram,
      title: programName,
      leading: ProgramBadge(
        name: programName,
        shortName: programShortName,
        color: programColor,
      ),
      trailing: programId == null
          ? null
          : ProgramUnreadBadge(programId: programId),
      onTap: onChangeScope,
    );
    if (!view.known) return program;
    final roleColor = effectiveRoleColor(c, view.role);
    final codes = _codes(ref);
    final department = view.departmentId;

    void changed() =>
        onViewChanged(l.viewCaption(ref.read(effectiveAccessProvider)));

    Future<void> pickRole() async {
      final picked = await NzBottomSheet.show<EffectiveRole>(
        context,
        title: l.uiHomePickRole,
        compact: true,
        builder: (sheet) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final r in view.roles)
              NzListTile(
                leading: NzDot(color: effectiveRoleColor(c, r)),
                title: l.effectiveRoleLabel(r),
                subtitle: l.effectiveRoleDescription(r),
                selected: r == view.role,
                onTap: () => Navigator.of(sheet).pop(r),
              ),
          ],
        ),
      );
      if (picked == null || picked == view.role || !context.mounted) return;
      if (ref
          .read(scopeSelectionControllerProvider.notifier)
          .selectRole(picked)) {
        changed();
      }
    }

    Future<void> pickDepartment() async {
      final seats = view.departmentsFor(view.role);
      final picked = await NzBottomSheet.show<String>(
        context,
        title: l.uiHomePickDepartment,
        compact: true,
        builder: (sheet) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in seats)
              NzListTile(
                leading: NzMonoTag(_code(codes, s)),
                title: s.departmentName,
                selected: s.departmentId == department,
                onTap: () => Navigator.of(sheet).pop(s.departmentId),
              ),
          ],
        ),
      );
      if (picked == null || picked == department || !context.mounted) return;
      if (ref
          .read(scopeSelectionControllerProvider.notifier)
          .selectDepartment(picked)) {
        changed();
      }
    }

    final seat = view
        .departmentsFor(view.role)
        .where((s) => s.departmentId == department)
        .firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: program),
              const Gap(NizamioSpacing.space2),
              Expanded(
                child: NzPickerCard(
                  label: l.uiHomePickerRole,
                  title: l.effectiveRoleLabel(view.role),
                  leading: NzDot(color: roleColor),
                  highlight: roleColor,
                  onTap: pickRole,
                ),
              ),
            ],
          ),
        ),
        const Gap(NizamioSpacing.space2),
        if (view.role == EffectiveRole.admin)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space3,
            ),
            child: Text(
              l.uiHomeAdminScopeNote,
              style: context.text.caption.copyWith(color: c.textMuted),
            ),
          )
        else if (seat != null)
          NzPickerCard(
            label: l.uiHomePickerDepartment,
            title: seat.departmentName,
            leading: NzMonoTag(_code(codes, seat)),
            onTap: pickDepartment,
          ),
      ],
    );
  }

  /// Programın katalog departmanları (kod kaynağı); katalog yoksa boş.
  static List<TaskDepartment> _codes(WidgetRef ref) =>
      ref.watch(taskCatalogControllerProvider).value?.departments ??
      const <TaskDepartment>[];

  /// Kod monogramı: katalog kodu, yoksa adın ilk üç harfi (büyük).
  static String _code(List<TaskDepartment> codes, TeamSeat s) {
    final code = codes.where((d) => d.id == s.departmentId).firstOrNull?.code;
    if (code != null && code.isNotEmpty) return code;
    final name = s.departmentName.trim();
    return name.characters.take(3).toString().toUpperCase();
  }
}
