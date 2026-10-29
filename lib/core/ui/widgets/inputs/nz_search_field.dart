import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../nz_icon.dart';
import '../nz_size.dart';

/// Arama girdisi (bundle.css `.m-search`; prototip hap biçimi): `bg-surface` dolgu, 1 px
/// `border-control` kenar, köşe hap, görsel yükseklik 44 (dokunma 48). Etiket ipucu metni olarak
/// görünür ve okuyucu etiketidir. Başta arama simgesi, doluyken sonda "temizle" düğmesi, klavye eylemi
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
    final c = context.colors;
    final style = _resolveStyle(context, widget.size);
    final label = widget.label ?? l.uiInputsSearch;
    OutlineInputBorder pill(Color color, [double? width]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(NizamioRadius.pill),
      borderSide: BorderSide(
        color: color,
        width: width ?? NizamioSize.borderWidth,
      ),
    );
    // Görsel yükseklik `m-tap` 44 (hap); dokunma alanı dış kutuyla 48.
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: NizamioSpacing.space12),
      child: Center(
        heightFactor: 1,
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => _labelled(
            widget.hint == null || widget.hint == label ? null : label,
            TextField(
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
                hintText: widget.hint ?? label,
                filled: true,
                fillColor: c.surface,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: NizamioSpacing.space4,
                  vertical: _vertical(style),
                ),
                constraints: const BoxConstraints(
                  minHeight: NizamioSize.controlMd,
                ),
                border: pill(c.borderControl),
                enabledBorder: pill(c.borderControl),
                disabledBorder: pill(c.border),
                focusedBorder: pill(c.focusRing, NizamioSize.focusRingWidth),
                prefixIcon: NzIcon(
                  Icons.search,
                  size: NizamioSize.iconSizeSm,
                  color: c.textFaint,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: NizamioSize.tap,
                  minHeight: NizamioSize.controlMd,
                ),
                suffixIcon: value.text.isEmpty || !widget.enabled
                    ? null
                    : IconButton(
                        tooltip: l.uiInputsSearchClear,
                        icon: const NzIcon(
                          Icons.close,
                          size: NizamioSize.iconSizeSm,
                        ),
                        onPressed: _clear,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// İpucu etiketten farklıysa etiket ayrıca okuyucuya bağlanır (ipucu zaten okunur).
Widget _labelled(String? label, Widget child) =>
    label == null ? child : Semantics(label: label, child: child);

/// Görsel yüksekliği 44'e oturtan dikey dolgu (metin satırı ölçeksiz yüksekliğinden).
double _vertical(({TextStyle text, double vertical}) style) {
  final t = style.text;
  final line = (t.fontSize ?? 0) * (t.height ?? 1);
  final fit = (NizamioSize.controlMd - line) / 2;
  return fit > 0 ? fit : style.vertical;
}

/// Boyuta göre yazı rolü ve dikey iç boşluk (tek görünüm fark noktası).
({TextStyle text, double vertical}) _resolveStyle(
  BuildContext context,
  NzSize size,
) => (
  // `.m-search input` 16/21 (`m-input`); sm daha küçük rol.
  text: size.pick(
    sm: context.text.bodyMd,
    md: context.text.bodyLg,
    lg: context.text.bodyLg,
  ),
  // Hap içi dikey dolgu: 44 yükseklikte metin ortalanır (sm/md 14 + 16 satır, lg 12 + 21).
  vertical: size.pick(
    sm: NizamioSpacing.rowPad,
    md: NizamioSpacing.space3,
    lg: NizamioSpacing.space3,
  ),
);
