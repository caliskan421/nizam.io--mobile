import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/domain/effective_role.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/navigation/navigation.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../application/program_list_controller.dart';
import '../../application/scope_selection_controller.dart';
import '../../domain/program.dart';
import '../program_badge.dart';
import 'module_menu_texts.dart';

/// Kenar çubuğunun üçlü seçicisi (program × rol × koordinatörlük; `sidebar-rol.png`): program
/// ve rol kartları yan yana, koordinatörlük kartı altında tam genişlik. Yönetici rolünde
/// koordinatörlük kartı yerine not. Üç kart da seçimi kartın altında açılan kısayol menüsünden
/// (sohbetin ek menüsüyle aynı bileşen) yapar: program [onSelectProgram] (liste yüklenmemişse
/// kapsam değiştirme akışı [onChangeScope]), rol ve koordinatörlük; geçerli seçim
/// [onViewChanged] ile yeni görünüm başlığını ("Koordinatör · Altyapı ve tesisat") bildirir. Erişim henüz
/// bilinmiyorsa yalnız program kartı çizilir.
class ScopeSwitcher extends ConsumerWidget {
  const ScopeSwitcher({
    super.key,
    required this.programName,
    this.programShortName,
    this.programColor,
    required this.onChangeScope,
    required this.onSelectProgram,
    required this.onViewChanged,
  });

  final String programName;
  final String? programShortName;
  final ProgramColor? programColor;
  final VoidCallback onChangeScope;
  final ValueChanged<String> onSelectProgram;
  final ValueChanged<String> onViewChanged;

  /// Kartın genel dikdörtgeni (menü bağlantısı).
  static Rect? _rect(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final view = ref.watch(effectiveAccessProvider);
    final programId = ref.watch(scopeStateProvider).programId;
    Future<void> pickProgram(BuildContext card) async {
      final programs = ref.read(programListControllerProvider).value?.items;
      if (programs == null || programs.isEmpty) return onChangeScope();
      await NzFlyoutMenu.show(
        context,
        semanticLabel: l.uiHomePickerProgram,
        anchor: _rect(card),
        below: true,
        entries: [
          for (final p in programs)
            NzFlyoutItem(
              label: p.name,
              dot: programColors(c, p.color).$1,
              selected: p.id == programId,
              onSelected: () {
                if (p.id != programId) onSelectProgram(p.id);
              },
            ),
        ],
      );
    }

    final program = Builder(
      builder: (card) => NzPickerCard(
        label: l.uiHomePickerProgram,
        title: programName,
        leading: ProgramBadge(
          name: programName,
          shortName: programShortName,
          color: programColor,
        ),
        onTap: () => pickProgram(card),
      ),
    );
    if (!view.known) return program;
    final roleColor = effectiveRoleColor(c, view.role);
    final codes = _codes(ref);
    final department = view.departmentId;

    void changed() =>
        onViewChanged(l.viewCaption(ref.read(effectiveAccessProvider)));

    Future<void> pickRole(BuildContext card) async {
      EffectiveRole? picked;
      await NzFlyoutMenu.show(
        context,
        semanticLabel: l.uiHomePickRole,
        anchor: _rect(card),
        below: true,
        alignEnd: true,
        entries: [
          for (final r in view.roles)
            NzFlyoutItem(
              label: l.effectiveRoleLabel(r),
              caption: l.effectiveRoleDescription(r),
              dot: effectiveRoleColor(c, r),
              selected: r == view.role,
              onSelected: () => picked = r,
            ),
        ],
      );
      final r = picked;
      if (r == null || r == view.role || !context.mounted) return;
      if (ref.read(scopeSelectionControllerProvider.notifier).selectRole(r)) {
        changed();
      }
    }

    Future<void> pickDepartment(BuildContext card) async {
      final seats = view.departmentsFor(view.role);
      String? picked;
      await NzFlyoutMenu.show(
        context,
        semanticLabel: l.uiHomePickDepartment,
        anchor: _rect(card),
        below: true,
        entries: [
          for (final s in seats)
            NzFlyoutItem(
              label: s.departmentName,
              count: _code(codes, s),
              selected: s.departmentId == department,
              onSelected: () => picked = s.departmentId,
            ),
        ],
      );
      final d = picked;
      if (d == null || d == department || !context.mounted) return;
      if (ref
          .read(scopeSelectionControllerProvider.notifier)
          .selectDepartment(d)) {
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
                child: Builder(
                  builder: (card) => NzPickerCard(
                    label: l.uiHomePickerRole,
                    title: l.effectiveRoleLabel(view.role),
                    leading: NzDot(color: roleColor),
                    highlight: roleColor,
                    onTap: () => pickRole(card),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (view.role != EffectiveRole.admin && seat != null) ...[
          const Gap(NizamioSpacing.space2),
          Builder(
            builder: (card) => NzPickerCard(
              label: l.uiHomePickerDepartment,
              title: seat.departmentName,
              leading: NzMonoTag(_code(codes, seat)),
              onTap: () => pickDepartment(card),
            ),
          ),
        ],
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
