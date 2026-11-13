import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/ui/widgets/overlays/nz_bottom_sheet.dart';

/// Alt sayfa; oturum nesli ya da kapsam açıldıktan sonra değişirse içerik ve eylemler
/// gizlenir (önceki hesabın/kapsamın verisi üzerinde işlem yapılmaz).
Future<void> showTableSheet(
  WidgetRef ref,
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  bool expandable = false,
  String? description,
  NzSheetActionsBuilder? actions,
}) {
  final generation = ref.read(sessionGenerationProvider);
  final scope = ref.read(scopeStateProvider);
  bool same(WidgetRef r) =>
      r.watch(sessionGenerationProvider) == generation &&
      r.watch(scopeStateProvider) == scope;
  return NzBottomSheet.show<void>(
    context,
    title: title,
    description: description,
    expandable: expandable,
    actions: actions == null
        ? null
        : (sheet) => [
            for (final action in actions(sheet))
              Consumer(
                builder: (context, ref, _) =>
                    same(ref) ? action : const SizedBox.shrink(),
              ),
          ],
    builder: (sheet) => Consumer(
      builder: (context, ref, _) =>
          same(ref) ? builder(context) : const SizedBox.shrink(),
    ),
  );
}
