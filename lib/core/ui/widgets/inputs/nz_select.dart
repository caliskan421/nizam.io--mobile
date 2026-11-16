import 'package:flutter/material.dart';

import '../../../errors/api_error.dart';
import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../navigation/nz_flyout_menu.dart';
import '../nz_glyph.dart';
import '../nz_size.dart';
import 'nz_field_errors.dart';
import 'nz_form_rows.dart';
import 'nz_validators.dart';

/// [NzSelect] seçeneği: değer ve kullanıcıya görünen etiket (çağıran ARB'den verir).
@immutable
class NzSelectItem<T> {
  const NzSelectItem({
    required this.value,
    required this.label,
    this.enabled = true,
    this.glyph,
  });

  final T value;
  final String label;
  final bool enabled;
  final NzGlyph? glyph;
}

/// Açılır liste seçimi. Denetimli bileşendir ([value] çağıranındır); `NzForm` içinde
/// [validator] (ör. `NzValidators.mustChoose`) ve sunucu alan hatası ([name]/[fieldError])
/// desteklenir. Etiket, seçili değer ve düğme rolü tek anlamsal düğümde okunur.
class NzSelect<T> extends StatefulWidget {
  const NzSelect({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.helper,
    this.leading,
    this.name,
    this.fieldError,
    this.validator,
    this.size = NzSize.md,
  });

  final String label;
  final List<NzSelectItem<T>> items;
  final T? value;

  /// `null` → devre dışı.
  final ValueChanged<T?>? onChanged;

  /// Seçim yokken gösterilir (verilmezse etiket yer tutucu olur).
  final String? hint;
  final String? helper;
  final Widget? leading;
  final String? name;
  final ApiFieldError? fieldError;
  final NzValidator<T>? validator;
  final NzSize size;

  @override
  State<NzSelect<T>> createState() => _NzSelectState<T>();
}

class _NzSelectState<T> extends State<NzSelect<T>> with NzServerFieldError {
  final _focus = FocusNode();

  // Kullanıcının az önce seçtiği değer: çağıranın yeniden kurması bir kare sonra olduğundan
  // doğrulama (didChange anında) bunu okur; bir sonraki kurmada atılır.
  ({T? value})? _latest;

  @override
  void didUpdateWidget(NzSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _latest = null;
  }

  @override
  String? get serverFieldName => widget.name;

  @override
  ApiFieldError? get explicitFieldError => widget.fieldError;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style = _resolveStyle(context, widget.size);
    final onChanged = widget.onChanged;
    final hint = widget.hint;
    return FormField<T>(
      initialValue: widget.value,
      forceErrorText: serverErrorText,
      // Değer çağıranındır; doğrulama her zaman güncel değeri okur.
      validator: (_) => widget.validator
          ?.call(_latest == null ? widget.value : _latest!.value)
          ?.text(l),
      builder: (field) {
        final selected = widget.items.where((i) => i.value == widget.value);
        void open() {
          if (onChanged == null) return;
          final box = context.findRenderObject()! as RenderBox;
          final anchor = box.localToGlobal(Offset.zero) & box.size;
          _focus.requestFocus();
          NzFlyoutMenu.show(
            context,
            semanticLabel: widget.label,
            anchor: anchor,
            below: anchor.center.dy < MediaQuery.sizeOf(context).height / 2,
            entries: [
              NzFlyoutSection(widget.label),
              for (final item in widget.items.where((i) => i.enabled))
                NzFlyoutItem(
                  label: item.label,
                  glyph: item.glyph,
                  selected: item.value == widget.value,
                  onSelected: () {
                    if (!mounted ||
                        widget.onChanged == null ||
                        !widget.items.any(
                          (i) => i.enabled && i.value == item.value,
                        )) {
                      return;
                    }
                    dismissServerError();
                    _latest = (value: item.value);
                    field.didChange(item.value);
                    widget.onChanged!(item.value);
                  },
                ),
            ],
          );
        }

        return FocusableActionDetector(
          enabled: onChanged != null,
          focusNode: _focus,
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                open();
                return null;
              },
            ),
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              NzFormRows(
                radius: NizamioRadius.pill,
                rows: [
                  NzFormRow(
                    label: widget.label,
                    leading: widget.leading,
                    value: selected.isEmpty ? hint : selected.first.label,
                    valueSet: selected.isNotEmpty,
                    onTap: onChanged == null ? null : open,
                  ),
                ],
              ),
              if (field.errorText ?? widget.helper case final message?)
                Padding(
                  padding: const EdgeInsets.only(top: NizamioSpacing.space2),
                  child: Text(
                    message,
                    style: style.text.copyWith(
                      color: field.hasError
                          ? context.colors.danger
                          : context.colors.textMuted,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
