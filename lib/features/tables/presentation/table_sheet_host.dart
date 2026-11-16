import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../application/table_detail_controller.dart';
import '../application/tables_controller.dart';

/// Açık taslağın eski hesap veya kapsam verisini göstermesini engeller.
Future<void> showTableSheet(
  WidgetRef ref,
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  String? tableId,
  bool expandable = false,
  ValueNotifier<bool>? expansion,
  String? description,
  NzSheetActionsBuilder? actions,
  Widget? headerAction,
  bool showHeader = true,
  bool actionsDivider = true,
}) {
  final lease = ref.read(tablesControllerProvider.notifier).lease;
  return NzBottomSheet.show<void>(
    context,
    title: title,
    headerAction: headerAction == null
        ? null
        : Consumer(
            builder: (context, ref, _) {
              ref.watch(tablesControllerProvider);
              if (!identical(
                lease,
                ref.read(tablesControllerProvider.notifier).lease,
              )) {
                return const SizedBox.shrink();
              }
              if (tableId != null &&
                  ref.watch(tableDetailProvider(tableId)).data == null) {
                return const SizedBox.shrink();
              }
              return headerAction;
            },
          ),
    showHeader: showHeader,
    actionsDivider: actionsDivider,
    backgroundColor: context.colors.background,
    description: description,
    expandable: expandable,
    expansion: expansion,
    actions: actions == null
        ? null
        : (sheet) => [
            for (final action in actions(sheet))
              Consumer(
                builder: (context, ref, _) {
                  ref.watch(tablesControllerProvider);
                  if (!identical(
                    lease,
                    ref.read(tablesControllerProvider.notifier).lease,
                  )) {
                    return const SizedBox.shrink();
                  }
                  if (tableId != null) {
                    final detail = ref.watch(tableDetailProvider(tableId));
                    if (detail.data == null || detail.deleted) {
                      return const SizedBox.shrink();
                    }
                  }
                  return action;
                },
              ),
          ],
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        ref.watch(tablesControllerProvider);
        if (!identical(
          lease,
          ref.read(tablesControllerProvider.notifier).lease,
        )) {
          return const SizedBox.shrink();
        }
        if (tableId != null) {
          final detail = ref.watch(tableDetailProvider(tableId));
          if (detail.data == null || detail.deleted) {
            return Text(
              detail.error == null
                  ? 'Tabloya erişim kapandı.'
                  : errorText(context.l10n, detail.error!),
            );
          }
        }
        return Material(
          type: MaterialType.transparency,
          child: builder(context),
        );
      },
    ),
  );
}
