import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';

typedef AdminField = ({
  String label,
  String initial,
  bool secret,
  bool required,
});

Future<List<String>?> adminForm(
  BuildContext context,
  String title,
  List<AdminField> fields,
) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final session = container.read(sessionGenerationProvider);
  final scope = container.read(scopeStateProvider);
  final values = await showDialog<List<String>>(
    context: context,
    builder: (_) => _AdminForm(title: title, fields: fields),
  );
  if (!context.mounted ||
      session != container.read(sessionGenerationProvider) ||
      scope != container.read(scopeStateProvider)) {
    return null;
  }
  return values;
}

class _AdminForm extends StatefulWidget {
  const _AdminForm({required this.title, required this.fields});
  final String title;
  final List<AdminField> fields;
  @override
  State<_AdminForm> createState() => _AdminFormState();
}

class _AdminFormState extends State<_AdminForm> {
  final _key = GlobalKey<FormState>();
  late final _controllers = [
    for (final field in widget.fields)
      TextEditingController(text: field.initial),
  ];
  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SingleChildScrollView(
      child: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < widget.fields.length; i++)
              TextFormField(
                controller: _controllers[i],
                obscureText: widget.fields[i].secret,
                autocorrect: !widget.fields[i].secret,
                enableSuggestions: !widget.fields[i].secret,
                decoration: InputDecoration(labelText: widget.fields[i].label),
                validator: (value) =>
                    widget.fields[i].required && value!.trim().isEmpty
                    ? 'Bu alan gerekli.'
                    : null,
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Vazgeç'),
      ),
      TextButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            Navigator.pop(context, [
              for (var i = 0; i < _controllers.length; i++)
                widget.fields[i].secret
                    ? _controllers[i].text
                    : _controllers[i].text.trim(),
            ]);
          }
        },
        child: const Text('Onayla'),
      ),
    ],
  );
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
