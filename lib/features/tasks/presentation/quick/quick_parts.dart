import 'package:flutter/material.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';

/// Hızlı işlem formlarının büyük başlık girişi (prototip `#tk-title`: çerçevesiz, 20 px).
/// Taslak denetleyicide durur; alan açılışta taslaktan doldurulur.
class QuickTitleField extends StatefulWidget {
  const QuickTitleField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.maxLength,
  });

  final String label;
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final int? maxLength;

  @override
  State<QuickTitleField> createState() => _QuickTitleFieldState();
}

class _QuickTitleFieldState extends State<QuickTitleField> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(QuickTitleField old) {
    super.didUpdateWidget(old);
    // Gönderimden sonra taslak sıfırlanırsa alanı da boşalt.
    if (widget.value != _controller.text) _controller.text = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      label: widget.label,
      textField: true,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        textCapitalization: TextCapitalization.sentences,
        style: t.titleSm,
        minLines: 1,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: t.titleSm.copyWith(color: c.textFaint),
          border: InputBorder.none,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            vertical: NizamioSpacing.space2,
          ),
        ),
      ),
    );
  }
}

/// Yerinde açılan satır içeriğinin iç boşluğu (prototip `padding: 0 10px 10px`).
class QuickPane extends StatelessWidget {
  const QuickPane({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      NizamioSpacing.gapMd,
      0,
      NizamioSpacing.gapMd,
      NizamioSpacing.gapMd,
    ),
    child: child,
  );
}

/// Sayfa otomatik büyütme (prototip `_autoExp`): [panes] içindeki bir satır açılınca sayfa
/// küçükse büyür; o satır kapanınca yalnız kendisi büyüttüyse küçülür.
class AutoExpand {
  AutoExpand(this.expansion);

  final ValueNotifier<bool> expansion;
  var _auto = false;

  void onPane({required bool opened}) {
    if (opened) {
      if (!expansion.value) {
        _auto = true;
        expansion.value = true;
      }
    } else if (_auto) {
      _auto = false;
      expansion.value = false;
    }
  }
}
