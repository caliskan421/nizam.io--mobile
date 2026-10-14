import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_size.dart';
import 'catalog_entry.dart';

// Katalog geliştirici aracıdır; örnek metinler ARB'ye girmez.
const _group = 'inputs';

/// Her boyutu alt alta çizer (varyant × boyut).
Widget _sizes(Widget Function(NzSize size) build) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final size in NzSize.values) ...[
      build(size),
      const Gap(NizamioSpacing.space3),
    ],
  ],
);

CatalogEntry _entry(String name, Widget Function(NzSize size) build) =>
    CatalogEntry(group: _group, name: name, builder: (_) => _sizes(build));

final _serverError = ApiError(
  'identity.input_invalid',
  fields: const [
    ApiFieldError(
      field: 'email',
      code: 'identity.invalid_email',
      message: 'ignored',
    ),
    ApiFieldError(
      field: 'unknown_field',
      code: 'identity.weak_password',
      message: 'ignored',
    ),
  ],
);

List<CatalogEntry> get inputsCatalogEntries => [
  _entry(
    'NzTextField',
    (size) => NzTextField(
      label: 'Label (${size.name})',
      hint: 'Hint',
      helper: 'Helper',
      size: size,
    ),
  ),
  _entry(
    'NzTextField (leading · trailing)',
    (size) => NzTextField(
      label: 'Label (${size.name})',
      size: size,
      leading: const Icon(Icons.person_outline),
      trailing: const Icon(Icons.check),
    ),
  ),
  _entry(
    'NzTextField.email',
    (size) => NzTextField.email(label: 'Email (${size.name})', size: size),
  ),
  _entry(
    'NzTextField.multiline',
    (size) =>
        NzTextField.multiline(label: 'Multiline (${size.name})', size: size),
  ),
  _entry(
    'NzTextField.number',
    (size) => NzTextField.number(label: 'Number (${size.name})', size: size),
  ),
  _entry(
    'NzTextField (error · disabled)',
    (size) => Column(
      children: [
        NzTextField(
          label: 'Error (${size.name})',
          size: size,
          fieldError: const ApiFieldError(
            field: 'x',
            code: 'identity.invalid_full_name',
            message: 'ignored',
          ),
        ),
        const Gap(NizamioSpacing.space2),
        NzTextField(
          label: 'Disabled (${size.name})',
          size: size,
          enabled: false,
        ),
      ],
    ),
  ),
  _entry(
    'NzPasswordField',
    (size) => NzPasswordField(label: 'Password (${size.name})', size: size),
  ),
  _entry(
    'NzPasswordField.newPassword',
    (size) => NzPasswordField.newPassword(
      label: 'New password (${size.name})',
      size: size,
    ),
  ),
  _entry(
    'NzSearchField',
    (size) => NzSearchField(label: 'Search (${size.name})', size: size),
  ),
  _entry('NzCheckbox', (size) => _CheckboxDemo(size: size)),
  _entry('NzSwitch', (size) => _SwitchDemo(size: size)),
  _entry('NzSelect', (size) => _SelectDemo(size: size)),
  CatalogEntry(
    group: _group,
    name: 'NzForm (server field errors)',
    builder: (_) => const _FormDemo(),
  ),
];

class _CheckboxDemo extends StatefulWidget {
  const _CheckboxDemo({required this.size});

  final NzSize size;

  @override
  State<_CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) => NzCheckbox(
    label: 'Checkbox (${widget.size.name})',
    description: 'Description',
    value: _value,
    onChanged: (v) => setState(() => _value = v),
    size: widget.size,
  );
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo({required this.size});

  final NzSize size;

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _value = true;

  @override
  Widget build(BuildContext context) => NzSwitch(
    label: 'Switch (${widget.size.name})',
    description: 'Description',
    value: _value,
    onChanged: (v) => setState(() => _value = v),
    leading: const Icon(Icons.notifications_none),
    size: widget.size,
  );
}

class _SelectDemo extends StatefulWidget {
  const _SelectDemo({required this.size});

  final NzSize size;

  @override
  State<_SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<_SelectDemo> {
  String? _value;

  @override
  Widget build(BuildContext context) => NzSelect<String>(
    label: 'Select (${widget.size.name})',
    hint: 'Choose',
    items: const [
      NzSelectItem(value: 'a', label: 'Option A'),
      NzSelectItem(value: 'b', label: 'Option B'),
      NzSelectItem(value: 'c', label: 'Option C', enabled: false),
    ],
    value: _value,
    onChanged: (v) => setState(() => _value = v),
    size: widget.size,
  );
}

class _FormDemo extends StatelessWidget {
  const _FormDemo();

  @override
  Widget build(BuildContext context) => NzForm(
    serverError: _serverError,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NzTextField.email(
          label: 'Email',
          name: 'email',
          validator: NzValidators.all([
            NzValidators.requiredText,
            NzValidators.email,
          ]),
        ),
        const Gap(NizamioSpacing.space3),
        const NzPasswordField.newPassword(label: 'Password', name: 'password'),
      ],
    ),
  );
}
