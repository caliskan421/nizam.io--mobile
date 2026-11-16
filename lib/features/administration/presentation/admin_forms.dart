import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/nz_button.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';

typedef AdminField = ({
  String label,
  String initial,
  bool secret,
  bool required,
});

/// Yönetim formu penceresi. Gizli alanlar ortak şifre alanıyla (göster/gizle) çizilir;
/// [confirmSecret] true ise her gizli alanın altına "tekrar" alanı eklenir ve eşleşmesi
/// istenir (yeni şifre belirlerken). Sonuç tekrar alanlarını içermez.
Future<List<String>?> adminForm(
  BuildContext context,
  String title,
  List<AdminField> fields, {
  bool confirmSecret = false,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final session = container.read(sessionGenerationProvider);
  final scope = container.read(scopeStateProvider);
  final values = await showDialog<List<String>>(
    context: context,
    builder: (_) =>
        _AdminForm(title: title, fields: fields, confirmSecret: confirmSecret),
  );
  if (!context.mounted ||
      session != container.read(sessionGenerationProvider) ||
      scope != container.read(scopeStateProvider)) {
    return null;
  }
  return values;
}

class _AdminForm extends StatefulWidget {
  const _AdminForm({
    required this.title,
    required this.fields,
    required this.confirmSecret,
  });
  final String title;
  final List<AdminField> fields;
  final bool confirmSecret;
  @override
  State<_AdminForm> createState() => _AdminFormState();
}

class _AdminFormState extends State<_AdminForm> {
  final _key = GlobalKey<FormState>();
  late final _controllers = [
    for (final field in widget.fields)
      field.secret
          ? NzPasswordController(text: field.initial)
          : TextEditingController(text: field.initial),
  ];
  late final _repeats = {
    if (widget.confirmSecret)
      for (final (i, field) in widget.fields.indexed)
        if (field.secret) i: NzPasswordController(),
  };
  @override
  void dispose() {
    for (final c in [..._controllers, ..._repeats.values]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.pop(context, [
      for (var i = 0; i < _controllers.length; i++)
        widget.fields[i].secret
            ? _controllers[i].text
            : _controllers[i].text.trim(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget field(int i) {
      final f = widget.fields[i];
      final required = f.required ? NzValidators.requiredText : null;
      if (!f.secret) {
        return NzTextField(
          label: f.label,
          controller: _controllers[i],
          validator: required,
        );
      }
      final repeat = _repeats[i];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: NizamioSpacing.space3,
        children: [
          if (repeat == null)
            NzPasswordField(
              label: f.label,
              controller: _controllers[i] as NzPasswordController,
              validator: required,
            )
          else ...[
            NzPasswordField.newPassword(
              label: f.label,
              controller: _controllers[i] as NzPasswordController,
              validator: required,
            ),
            NzPasswordField.newPassword(
              label: l.uiInputsPasswordRepeat,
              controller: repeat,
              textInputAction: TextInputAction.done,
              validator: (v) => (v ?? '') == _controllers[i].text
                  ? null
                  : NzValidationIssue.mismatch,
              onSubmitted: (_) => _submit(),
            ),
          ],
        ],
      );
    }

    return AlertDialog(
      scrollable: true,
      title: Text(widget.title, style: context.text.titleMd),
      content: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: NizamioSpacing.space3,
          children: [for (var i = 0; i < widget.fields.length; i++) field(i)],
        ),
      ),
      actionsOverflowAlignment: OverflowBarAlignment.end,
      actionsOverflowDirection: VerticalDirection.down,
      actionsOverflowButtonSpacing: NizamioSpacing.space2,
      actions: [
        NzButton.secondary(
          label: 'Vazgeç',
          onPressed: () => Navigator.pop(context),
        ),
        NzButton.primary(label: 'Onayla', onPressed: _submit),
      ],
    );
  }
}

Future<bool> adminConfirm(
  BuildContext context,
  String title,
  String message,
) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final session = container.read(sessionGenerationProvider);
  final scope = container.read(scopeStateProvider);
  final yes =
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Onayla'),
            ),
          ],
        ),
      ) ??
      false;
  return context.mounted &&
      session == container.read(sessionGenerationProvider) &&
      scope == container.read(scopeStateProvider) &&
      yes;
}
