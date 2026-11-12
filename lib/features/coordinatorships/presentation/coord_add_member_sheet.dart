import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../tasks/tasks.dart';
import '../application/coord_member_controller.dart';
import '../domain/department.dart';

Future<void> showCoordAddMemberSheet(BuildContext context, String code) async {
  final l = context.l10n;
  final result = await NzBottomSheet.show<bool>(
    context,
    title: l.uiCoordAddMember,
    description: l.uiCoordAddMemberDesc,
    expandable: true,
    actions: (sheet) => [
      Consumer(
        builder: (context, ref, _) {
          final f = ref.watch(coordMemberControllerProvider(code));
          return NzButton.primary(
            label: l.uiTasksIvSend,
            expand: true,
            onPressed: f.selected == null || f.busy
                ? null
                : () async {
                    final ok = await ref
                        .read(coordMemberControllerProvider(code).notifier)
                        .submit();
                    if (ok && sheet.mounted) Navigator.of(sheet).pop(true);
                  },
          );
        },
      ),
    ],
    builder: (_) => _MemberPicker(code: code),
  );
  if (!context.mounted) return;
  if (result == false) {
    await showInviteSheet(context, coordinatorship: code);
  } else if (result == true) {
    NzToast.show(context, l.uiCoordMemberAdded, tone: NzToastTone.success);
  }
}

class _MemberPicker extends ConsumerStatefulWidget {
  const _MemberPicker({required this.code});
  final String code;

  @override
  ConsumerState<_MemberPicker> createState() => _MemberPickerState();
}

class _MemberPickerState extends ConsumerState<_MemberPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final code = widget.code;
    final pool = ref.watch(coordMemberCandidatesProvider(code));
    final state = ref.watch(coordMemberControllerProvider(code));
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final query = _search.trim().toLowerCase();
    String sources(AssignableAccount p) => [
      for (final role in p.roles)
        if (role.lastIndexOf(':') case final i when i > 0)
          catalog?.coordinatorship(role.substring(0, i))?.name,
    ].whereType<String>().toSet().join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space3,
      children: [
        NzButton.secondary(
          label: l.uiCoordCreatePerson,
          onPressed: state.busy ? null : () => Navigator.of(context).pop(false),
        ),
        NzSearchField(
          hint: l.uiCoordSearchPerson,
          enabled: !state.busy,
          onChanged: (v) => setState(() => _search = v),
        ),
        if (state.error case final error?)
          NzBanner.danger(message: errorText(l, error)),
        pool.when(
          skipLoadingOnRefresh: false,
          data: (page) {
            final people = page.items
                .where(
                  (p) =>
                      p.fullName.toLowerCase().contains(query) ||
                      sources(p).toLowerCase().contains(query),
                )
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: NizamioSpacing.space3,
              children: [
                if (page.truncated)
                  NzBanner.warning(message: l.uiListsTruncated),
                if (people.isEmpty)
                  Text(l.uiCoordNoCandidates, style: context.text.bodySm)
                else
                  NzMenuGroup(
                    rows: [
                      for (final person in people)
                        NzListTile(
                          title: person.fullName,
                          subtitle: sources(person).isEmpty
                              ? null
                              : sources(person),
                          selected: state.selected == person.accountId,
                          trailing: NzCheckCircle(
                            value: state.selected == person.accountId,
                            label: person.fullName,
                            onChanged: state.busy
                                ? null
                                : () => ref
                                      .read(
                                        coordMemberControllerProvider(code)
                                            .notifier,
                                      )
                                      .select(person.accountId),
                          ),
                          onTap: state.busy
                              ? null
                              : () => ref
                                    .read(
                                      coordMemberControllerProvider(code)
                                          .notifier,
                                    )
                                    .select(person.accountId),
                        ),
                    ],
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => NzBanner.danger(
            message: errorText(l, toApiError(error)),
            actionLabel: l.uiCommonRetry,
            onAction: () => ref.invalidate(coordMemberCandidatesProvider(code)),
          ),
        ),
      ],
    );
  }
}
