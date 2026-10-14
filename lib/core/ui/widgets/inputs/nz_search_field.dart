import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_size.dart';

/// Arama girdisi: başta arama simgesi, doluyken sonda "temizle" düğmesi, klavye eylemi
/// "ara". Yalnız geri çağrı verir: gecikme (debounce) ve arama çağrısı çağıranındır.
class NzSearchField extends StatefulWidget {
  const NzSearchField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.size = NzSize.md,
    this.focusNode,
  });

  final TextEditingController? controller;

  /// Anlamsal etiket; verilmezse "Ara" (ARB).
  final String? label;

  /// İpucu metni; verilmezse etiketle aynı.
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// "Temizle" dokunuşunda, alan boşaltıldıktan sonra çağrılır.
  final VoidCallback? onClear;
  final bool enabled;
  final NzSize size;
  final FocusNode? focusNode;

  @override
  State<NzSearchField> createState() => _NzSearchFieldState();
}

class _NzSearchFieldState extends State<NzSearchField> {
  TextEditingController? _own;

  TextEditingController get _controller =>
      widget.controller ?? (_own ??= TextEditingController());

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style = _resolveStyle(context, widget.size);
    final label = widget.label ?? l.uiInputsSearch;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) => TextField(
        controller: _controller,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        style: style.text,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        autocorrect: false,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          labelText: label,
          hintText: widget.hint,
          contentPadding: EdgeInsets.symmetric(
            horizontal: NizamioSpacing.space4,
            vertical: style.vertical,
          ),
          constraints: const BoxConstraints(minHeight: NizamioSpacing.space12),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: value.text.isEmpty || !widget.enabled
              ? null
              : IconButton(
                  tooltip: l.uiInputsSearchClear,
                  icon: const Icon(Icons.close),
                  onPressed: _clear,
                ),
        ),
      ),
    );
  }
}

/// Boyuta göre yazı rolü ve dikey iç boşluk (tek görünüm fark noktası).
({TextStyle text, double vertical}) _resolveStyle(
  BuildContext context,
  NzSize size,
) => (
  text: size.pick(
    sm: context.text.bodySm,
    md: context.text.bodyMd,
    lg: context.text.bodyLg,
  ),
  vertical: size.pick(
    sm: NizamioSpacing.space3,
    md: NizamioSpacing.space3,
    lg: NizamioSpacing.space4,
  ),
);
