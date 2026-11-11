import 'package:flutter/widgets.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/layout/nz_uniform_grid.dart';

/// Arşiv ve görev klasörleri: geniş alanda dört, dar alanda bir veya iki sütun.
class ArchiveFolderGrid extends StatelessWidget {
  const ArchiveFolderGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final columns = width >= 756
          ? 4
          : width >= 332
          ? 2
          : 1;
      return UniformGrid(
        columns: columns,
        gap: NizamioSpacing.space3,
        children: children,
      );
    },
  );
}
