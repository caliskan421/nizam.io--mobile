import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../../../core/ui/widgets/overlays/nz_dialog.dart';
import '../../tasks/tasks.dart' show effectiveAccessProvider;
import '../application/team_controller.dart';
import '../domain/team_view.dart';

/// "Ekipten çıkar" (prototip `kRm` → kaplama `krm`): yalnız koordinatör görünümünde, yalnız
/// üyede ve kişinin kendisinde değil ([canRemoveFromTeam]). Koordinatör satırında yerine
/// "koordinatör ataması yönetici işidir" notu. Görev etkisi varsa sunucunun onay isteği
/// (`organization.confirmation_required`) ikinci bir onayla yeniden gönderilir. Başarıda
/// kişi ayrıntısından çıkılır (artık ekipte değil).
class TeamRemoveAction extends ConsumerWidget {
  const TeamRemoveAction({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final source = ref.watch(teamSourceProvider);
    if (source != TeamSource.departmentMembers) return const SizedBox.shrink();
    final person = ref.watch(teamRosterProvider).value?.person(accountId);
    final me = ref.watch(effectiveAccessProvider).access?.accountId;
    if (person == null) return const SizedBox.shrink();
    final busy = ref.watch(teamCommandProvider);
    if (!canRemoveFromTeam(source, person, me: me)) {
      return !person.lead
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(top: NizamioSpacing.space3),
              child: Text(
                l.uiUsersTeamLeadNote,
                style: context.text.caption.copyWith(
                  color: context.colors.textMuted,
                ),
              ),
            );
    }
    return Padding(
      padding: const EdgeInsets.only(top: NizamioSpacing.space3),
      child: NzButton.danger(
        label: l.uiUsersTeamRemove,
        expand: true,
        loading: busy,
        onPressed: busy ? null : () => _remove(context, ref),
      ),
    );
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final scope = ref.read(scopeStateProvider);
    final session = ref.read(sessionGenerationProvider);
    bool current() =>
        context.mounted &&
        scope == ref.read(scopeStateProvider) &&
        session == ref.read(sessionGenerationProvider);
    final name = ref.read(teamRosterProvider).value?.person(accountId)?.name;
    final yes = await NzDialog.confirm(
      context,
      title: name == null
          ? l.uiUsersTeamRemove
          : '$name · ${l.uiUsersTeamRemove}',
      message: l.uiUsersTeamRemoveConfirm,
      confirmLabel: l.uiUsersTeamRemove,
      tone: NzDialogTone.destructive,
    );
    if (!yes || !current()) return;
    final commands = ref.read(teamCommandProvider.notifier);
    try {
      try {
        await commands.remove(accountId);
      } on ApiError catch (e) {
        if (e.code != 'organization.confirmation_required' || !current()) {
          rethrow;
        }
        if (!context.mounted) return;
        final again = await NzDialog.confirm(
          context,
          title: l.uiUsersTeamRemove,
          message: l.uiUsersTeamRemoveEffects,
          confirmLabel: l.uiUsersTeamRemove,
          tone: NzDialogTone.destructive,
        );
        if (!again || !current()) return;
        await commands.remove(accountId, confirm: true);
      }
      if (!context.mounted) return;
      NzToast.success(context, l.uiUsersTeamRemoved);
      final navigator = Navigator.of(context);
      if (navigator.canPop()) navigator.pop();
    } on Object catch (e, st) {
      // Rapor, bağlam korumasından ÖNCE.
      final api = toReportedApiError(
        e,
        st,
        source: ReportSource.administration,
      );
      if (context.mounted) NzToast.error(context, api);
    }
  }
}
