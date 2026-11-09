import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import 'admin_forms.dart';

/// Hesap bilgileri taslağını düzenler; API ya da kaydedilmiş şifre bilgisi almaz.
/// Değerler ve yazma kararı üst panelindir. Şifre daima sabit sekiz noktayla çizilir.
class AdminUserAccountInfo extends StatefulWidget {
  const AdminUserAccountInfo({
    super.key,
    required this.accountId,
    required this.fullName,
    required this.email,
    required this.onFullNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    this.enabled = true,
  });
  final String accountId;
  final String fullName;
  final String? email;
  final ValueChanged<String> onFullNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final bool enabled;

  @override
  State<AdminUserAccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AdminUserAccountInfo> {
  bool _editing = false;
  Future<void> _edit({
    required String title,
    required String label,
    required String initial,
    required ValueChanged<String> onChanged,
    bool secret = false,
  }) async {
    if (!widget.enabled || _editing) return;
    final account = widget.accountId;
    setState(() => _editing = true);
    try {
      final values = await adminForm(context, title, [
        (label: label, initial: initial, secret: secret, required: !secret),
      ]);
      // adminForm ayrıca açıldığı oturum ve programı denetler. Aynı State başka kişi
      // için kullanılırsa eski diyaloğun sonucu yeni kişinin taslağına taşınmaz.
      if (!mounted ||
          !widget.enabled ||
          account != widget.accountId ||
          values == null) {
        return;
      }
      onChanged(values.single);
    } finally {
      if (mounted) setState(() => _editing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final enabled = widget.enabled && !_editing;
    final email = widget.email;
    final rows = [
      _InfoRow(
        icon: NzIcons.person,
        label: l.uiUserAccountFieldsFullName,
        value: widget.fullName,
        enabled: enabled,
        onTap: () => _edit(
          title: l.uiUserAccountFieldsEditFullName,
          label: l.uiUserAccountFieldsFullName,
          initial: widget.fullName,
          onChanged: widget.onFullNameChanged,
        ),
      ),
      _InfoRow(
        icon: NzIcons.mail,
        label: l.uiUserAccountFieldsEmail,
        value: email == null || email.trim().isEmpty ? '—' : email,
        enabled: enabled,
        onTap: () => _edit(
          title: l.uiUserAccountFieldsEditEmail,
          label: l.uiUserAccountFieldsEmail,
          initial: email ?? '',
          onChanged: widget.onEmailChanged,
        ),
      ),
      _InfoRow(
        icon: NzIcons.key,
        label: l.uiUserAccountFieldsPassword,
        value: '••••••••',
        semanticHint: l.uiUserAccountFieldsEditPassword,
        enabled: enabled,
        onTap: () => _edit(
          title: l.uiUserAccountFieldsEditPassword,
          label: l.uiUserAccountFieldsNewPassword,
          initial: '',
          secret: true,
          onChanged: widget.onPasswordChanged,
        ),
      ),
    ];
    final radius = BorderRadius.circular(NizamioRadius.card);
    final group = DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: radius,
        border: Border.all(color: c.border),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              for (final (i, row) in rows.indexed) ...[
                if (i > 0) Divider(height: 1, thickness: 1, color: c.border),
                row,
              ],
            ],
          ),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: NizamioSpacing.space1),
          child: Text(
            l.uiUserAccountFieldsHeading,
            style: context.text.kicker.copyWith(color: c.textFaint),
          ),
        ),
        const Gap(NizamioSpacing.space2),
        group,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.enabled,
    required this.onTap,
    this.semanticHint,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool enabled;
  final VoidCallback onTap;
  final String? semanticHint;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: enabled,
    label: semanticHint == null ? '$label, $value' : label,
    hint: semanticHint,
    onTap: enabled ? onTap : null,
    excludeSemantics: true,
    child: InkWell(
      onTap: enabled ? onTap : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 53),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                NzIcon(icon, size: 18, color: context.colors.textMuted),
                const Gap(12),
                Expanded(
                  child: Text(
                    label,
                    style: context.text.bodyMd.copyWith(fontSize: 14),
                  ),
                ),
                const Gap(12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * .5,
                  ),
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: context.text.caption.copyWith(
                      fontSize: 13,
                      color: context.colors.textFaint,
                    ),
                  ),
                ),
                const Gap(8),
                NzIcon(
                  NzIcons.chevronRight,
                  size: 16,
                  color: context.colors.textFaint,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
