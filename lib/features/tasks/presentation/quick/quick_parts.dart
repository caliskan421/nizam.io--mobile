import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';

/// Hızlı işlem formlarının ortak iskeleti (Yeni görev, Toplantı, Davet tek tasarım standardı):
/// üstte yazı yazılan alanlar ([fields]: projenin çerçeveli metin alanı `NzTextField`), altında
/// seçim satırı kartı (`NzFormRows`: etiket solda, değer sağda), en altta notlar/hatalar.
/// Boşluk tek yerden gelir; formlar kendi aralığını yazmaz.
class QuickFormLayout extends StatelessWidget {
  const QuickFormLayout({
    super.key,
    required this.fields,
    required this.rows,
    this.footer = const [],
  });

  /// Metin alanları (ad, e-posta…; çoğunlukla [QuickTitleField] / `NzTextField`).
  final List<Widget> fields;

  /// Satır kartı (çoğunlukla `NzFormRows`).
  final Widget rows;

  /// Kartın altındaki öğeler (açıklama, hata); her birinin üstünde aynı boşluk.
  final List<Widget> footer;

  static const _gap = Gap(NizamioSpacing.space3);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final w in fields) ...[w, _gap],
      rows,
      for (final w in footer) ...[_gap, w],
    ],
  );
}

/// Hızlı işlem formlarının ad/başlık girişi: projenin çerçeveli metin alanı ([NzTextField]).
/// Taslak denetleyicide durur; alan açılışta taslaktan doldurulur.
class QuickTitleField extends StatefulWidget {
  const QuickTitleField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.maxLength,
    this.autofillHints,
  });

  final String label;
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final int? maxLength;
  final Iterable<String>? autofillHints;

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
  Widget build(BuildContext context) => NzTextField(
    label: widget.label,
    hint: widget.hint,
    controller: _controller,
    onChanged: widget.onChanged,
    maxLength: widget.maxLength,
    autofillHints: widget.autofillHints,
  );
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
