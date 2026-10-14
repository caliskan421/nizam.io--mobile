import 'package:flutter/material.dart';

import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Açma/kapama anahtarı: satırın tamamı dokunma alanıdır (en az 48), etiket anahtarla
/// birlikte okunur. Denetimli bileşendir ([value] çağıranındır).
class NzSwitch extends StatelessWidget {
  const NzSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.leading,
    this.size = NzSize.md,
  });

  final String label;
  final bool value;

  /// `null` → devre dışı.
  final ValueChanged<bool>? onChanged;
  final String? description;

  /// Satırın başında (ör. simge).
  final Widget? leading;
  final NzSize size;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context, size);
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: style),
      subtitle: description == null
          ? null
          : Text(description!, style: context.text.bodySm),
      secondary: leading,
    );
  }
}

/// Boyuta göre etiket yazı rolü (tek görünüm fark noktası).
TextStyle _resolveStyle(BuildContext context, NzSize size) => size.pick(
  sm: context.text.bodySm,
  md: context.text.bodyMd,
  lg: context.text.bodyLg,
);
