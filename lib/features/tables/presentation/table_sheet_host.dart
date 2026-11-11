import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';
import '../application/tables_controller.dart';

/// Açık taslağın eski hesap veya kapsam verisini göstermesini engeller.
Future<void> showTableSheet(
  WidgetRef ref,
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  bool expandable = false,
  String? description,
}) {
  final lease = ref.read(tablesControllerProvider.notifier).lease;
  return NzBottomSheet.show<void>(
    context,
    title: title,
    description: description,
    expandable: expandable,
    builder: (sheet) => Consumer(
      builder: (context, ref, _) {
        ref.watch(tablesControllerProvider);
        if (!identical(
          lease,
          ref.read(tablesControllerProvider.notifier).lease,
        )) {
          return const SizedBox.shrink();
        }
        return builder(context);
      },
    ),
  );
}
