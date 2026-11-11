import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/buttons/nz_pressable.dart';
import '../../../../core/ui/widgets/buttons/nz_split_button.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../application/tasks_list_controller.dart';
import '../task_texts.dart';

/// Görev listelerinde ortak filtre ve sıralama araç satırı.
class TaskListToolbar extends StatelessWidget {
  const TaskListToolbar({
    super.key,
    required this.state,
    required this.onFilter,
    required this.controller,
  });
  final TasksListState state;
  final VoidCallback onFilter;
  final TasksListController controller;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final f = state.filter;
    final active =
        f.people.length + f.coordinatorships.length + f.priorities.length;
    return Row(
      children: [
        NzPressable(
          scale: .94,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: Semantics(
            button: true,
            label: active == 0
                ? l.uiTasksFilters
                : '${l.uiTasksFilters} · $active ${l.uiTasksFilterActive}',
            excludeSemantics: true,
            child: InkWell(
              onTap: onFilter,
              customBorder: const CircleBorder(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active > 0 ? c.text : c.surface,
                      border: Border.all(
                        color: active > 0
                            ? Colors.transparent
                            : c.borderControl,
                      ),
                    ),
                    child: Center(
                      child: NzIcon(
                        NzIcons.filter,
                        size: 20,
                        color: active > 0 ? c.background : c.text,
                      ),
                    ),
                  ),
                  if (active > 0)
                    Positioned(
                      right: -3,
                      top: -3,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: c.primary,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: c.background, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '$active',
                            style: context.text.kicker.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: c.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: NzSplitButton(
              flexibleLabel: true,
              label: l.sortLabel(state.sort),
              semanticLabel:
                  '${l.uiHomeSortChange}: ${l.sortLabel(state.sort)}',
              onPressed: controller.cycleSort,
              icon: NzIcons.chevronDown,
              iconTurns: state.descending ? 0 : 0.5,
              iconSemanticLabel:
                  '${l.uiHomeSortFlip}: ${state.descending ? l.uiHomeSortDescending : l.uiHomeSortAscending}',
              onIconPressed: controller.flipDirection,
            ),
          ),
        ),
      ],
    );
  }
}
