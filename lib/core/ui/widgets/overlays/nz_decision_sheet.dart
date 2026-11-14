import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../buttons/nz_button.dart';
import '../inputs/nz_switch.dart';
import '../inputs/nz_text_field.dart';
import 'nz_bottom_sheet.dart';

/// Karar kaplamasındaki etiket–değer satırı (özet ya da karşılaştırma).
@immutable
class NzDecisionFact {
  const NzDecisionFact(this.label, this.value, {this.danger = false});

  final String label;
  final String value;

  /// Değer gecikme/uyarı rengiyle.
  final bool danger;
}

/// Karar kaplamasının sonucu: yazılan not (kırpılmış) ve anahtarın son durumu.
typedef NzDecisionResult = ({String note, bool toggled});

/// Karar kaplaması (prototip `dec`: Onayla / İade et): özet satırları, isteğe bağlı uyarı,
/// isteğe bağlı anahtar ([toggleLabel]; ör. "Bitişi bugüne çek") ve ona bağlı karşılaştırma
/// ([comparison]), not alanı (sayaçlı, [noteMaxLength]), bilgi notu. [noteRequired] iken ana
/// düğme not yazılana dek pasiftir. Vazgeçince null.
abstract final class NzDecisionSheet {
  static Future<NzDecisionResult?> show(
    BuildContext context, {
    required String title,
    required String noteLabel,
    required String cancelLabel,
    required String okLabel,
    String? description,
    List<NzDecisionFact> facts = const [],
    String? warning,
    String? toggleLabel,
    String? toggleDescription,
    bool toggleInitial = false,
    List<NzDecisionFact> Function(bool toggled)? comparison,
    String? noteHint,
    bool noteRequired = false,
    int noteMaxLength = 1000,
    String? info,
    bool danger = false,
  }) async {
    final note = TextEditingController();
    final toggled = ValueNotifier(toggleInitial);
    NzDecisionResult? result;
    bool valid(String v) =>
        v.trim().length <= noteMaxLength &&
        (!noteRequired || v.trim().isNotEmpty);
    try {
      await NzBottomSheet.show<void>(
        context,
        title: title,
        description: description,
        actions: (sheet) => [
          NzButton.secondary(
            label: cancelLabel,
            expand: true,
            onPressed: () => Navigator.of(sheet).maybePop(),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: note,
            builder: (_, v, _) {
              void ok() {
                result = (note: v.text.trim(), toggled: toggled.value);
                Navigator.of(sheet).pop();
              }

              final onOk = valid(v.text) ? ok : null;
              return danger
                  ? NzButton.danger(
                      label: okLabel,
                      expand: true,
                      onPressed: onOk,
                    )
                  : NzButton.primary(
                      label: okLabel,
                      expand: true,
                      onPressed: onOk,
                    );
            },
          ),
        ],
        builder: (_) => _DecisionBody(
          facts: facts,
          warning: warning,
          toggleLabel: toggleLabel,
          toggleDescription: toggleDescription,
          toggled: toggled,
          comparison: comparison,
          note: note,
          noteLabel: noteLabel,
          noteHint: noteHint,
          noteMaxLength: noteMaxLength,
          info: info,
        ),
      );
    } finally {
      // Kapanış hareketi bitmeden alan yeniden çizilebilir: bir kare sonra bırakılır.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        note.dispose();
        toggled.dispose();
      });
    }
    return result;
  }
}

class _DecisionBody extends StatelessWidget {
  const _DecisionBody({
    required this.facts,
    required this.warning,
    required this.toggleLabel,
    required this.toggleDescription,
    required this.toggled,
    required this.comparison,
    required this.note,
    required this.noteLabel,
    required this.noteHint,
    required this.noteMaxLength,
    required this.info,
  });

  final List<NzDecisionFact> facts;
  final String? warning;
  final String? toggleLabel;
  final String? toggleDescription;
  final ValueNotifier<bool> toggled;
  final List<NzDecisionFact> Function(bool toggled)? comparison;
  final TextEditingController note;
  final String noteLabel;
  final String? noteHint;
  final int noteMaxLength;
  final String? info;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final warning = this.warning;
    final toggleLabel = this.toggleLabel;
    final comparison = this.comparison;
    final info = this.info;
    Widget fact(NzDecisionFact f) => Padding(
      padding: const EdgeInsets.symmetric(vertical: NizamioSpacing.space1),
      child: Row(
        children: [
          Expanded(
            child: Text(f.label, style: t.caption.copyWith(color: c.textMuted)),
          ),
          const Gap(NizamioSpacing.space2),
          Flexible(
            child: Text(
              f.value,
              textAlign: TextAlign.end,
              style: t.bodySm.copyWith(color: f.danger ? c.danger : c.text),
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final f in facts) fact(f),
        if (warning != null) ...[
          const Gap(NizamioSpacing.space3),
          Text(warning, style: t.bodySm.copyWith(color: c.danger)),
        ],
        if (toggleLabel != null) ...[
          const Gap(NizamioSpacing.space3),
          ValueListenableBuilder<bool>(
            valueListenable: toggled,
            builder: (_, on, _) => NzSwitch(
              label: toggleLabel,
              description: toggleDescription,
              value: on,
              onChanged: (v) => toggled.value = v,
            ),
          ),
        ],
        if (comparison != null)
          ValueListenableBuilder<bool>(
            valueListenable: toggled,
            builder: (_, on, _) => Padding(
              padding: const EdgeInsets.only(top: NizamioSpacing.space2),
              child: Row(
                spacing: NizamioSpacing.space2,
                children: [
                  for (final f in comparison(on))
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.label,
                            style: t.caption.copyWith(color: c.textMuted),
                          ),
                          Text(
                            f.value,
                            style: t.bodySm.copyWith(
                              fontWeight: FontWeight.w600,
                              color: f.danger ? c.danger : c.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        const Gap(NizamioSpacing.space4),
        NzTextField.multiline(
          label: noteLabel,
          hint: noteHint,
          controller: note,
          maxLength: noteMaxLength,
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: note,
          builder: (_, v, _) => Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '${v.text.length} / $noteMaxLength',
              style: t.monoSm.copyWith(color: c.textMuted),
            ),
          ),
        ),
        if (info != null) ...[
          const Gap(NizamioSpacing.space2),
          Text(info, style: t.caption.copyWith(color: c.textMuted)),
        ],
      ],
    );
  }
}
