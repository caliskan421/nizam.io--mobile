import 'package:flutter/widgets.dart';

import '../nz_icons.dart';
import '../nz_size.dart';
import 'nz_badge.dart';

/// Bağımlılık kilidi rozeti: ön görev bitmeden başlatılamayan görevin işareti (satır, ayrıntı
/// bandı). [label] kısa metin ("Kilitli"); okuyucuya da odur.
class NzLockBadge extends StatelessWidget {
  const NzLockBadge({super.key, required this.label, this.size = NzSize.sm});

  final String label;
  final NzSize size;

  @override
  Widget build(BuildContext context) =>
      NzBadge.warning(label: label, leading: NzIcons.lock, size: size);
}
