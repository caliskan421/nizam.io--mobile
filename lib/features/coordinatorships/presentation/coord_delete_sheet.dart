import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../application/coordinatorship_delete_controller.dart';
import '../domain/department_delete.dart';

/// Koordinatörlük silme onayı (alt sayfa). Önce etki önizlemesi okunur (yükleniyor / hata +
/// tekrar dene); özet bütün programları kapsar. Onay için kısa kod (yoksa ad) yazılır; eşleşince
/// danger düğme açılır. [permanent]: kalıcı silme (geri alınamaz uyarısı, silinmiş görev sayısı;
/// tablo engeli varsa düğme kapalı ve engel açıklanır). [run] yazmayı yapar; hata sayfada
/// gösterilir (409 `organization.department_in_use` engel sayılarıyla), başarıda sayfa kapanır
/// ve sonuç döner (vazgeçmede `null`).
Future<T?> showDepartmentDeleteSheet<T extends Object>(
  BuildContext context, {
  required String departmentId,
  required String name,
  String? code,
  required bool permanent,
  required Future<DeleteOutcome<T>> Function() run,
}) {
  final l = context.l10n;
  final model = _DeleteModel();
  final phrase = deleteConfirmPhrase(code: code, name: name);
  return NzBottomSheet.show<T>(
    context,
    title: permanent ? l.uiCoordDeletePermanentTitle : l.uiCoordDeleteTitle,
    description: name,
    expandable: true,
    actions: (sheet) => [
      NzButton.secondary(
        label: l.uiCoordDeleteCancel,
        expand: true,
        onPressed: () => Navigator.of(sheet).maybePop(),
      ),
      Consumer(
        builder: (context, ref, _) {
          final impact = ref
              .watch(departmentDeleteImpactProvider(departmentId))
              .value;
          return ListenableBuilder(
            listenable: model,
            builder: (context, _) {
              final ready =
                  impact != null &&
                  !(permanent && impact.permanentBlocked) &&
                  deleteConfirmMatches(model.typed, code: code, name: name);
              return NzButton.danger(
                label: permanent
                    ? l.uiCoordDeletePermanentDelete
                    : l.uiCoordDeleteDelete,
                loading: model.busy,
                expand: true,
                onPressed: !ready || model.busy
                    ? null
                    : () async {
                        model.start();
                        final out = await run();
                        if (!sheet.mounted) return;
                        final result = out.result;
                        if (out.error == null && result != null) {
                          Navigator.of(sheet).pop(result);
                        } else {
                          model.fail(out.error);
                        }
                      },
              );
            },
          );
        },
      ),
    ],
    builder: (_) => _DeleteBody(
      departmentId: departmentId,
      phrase: phrase,
      permanent: permanent,
      model: model,
    ),
  );
}

/// Onay alanı ve gönderim durumu (gövde ile alt düğme arasında paylaşılır).
class _DeleteModel extends ChangeNotifier {
  String typed = '';
  bool busy = false;
  ApiError? error;

  void type(String v) {
    typed = v;
    notifyListeners();
  }

  void start() {
    busy = true;
    error = null;
    notifyListeners();
  }

  void fail(ApiError? e) {
    busy = false;
    error = e;
    notifyListeners();
  }
}

class _DeleteBody extends ConsumerWidget {
  const _DeleteBody({
    required this.departmentId,
    required this.phrase,
    required this.permanent,
    required this.model,
  });

  final String departmentId;
  final String phrase;
  final bool permanent;
  final _DeleteModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final provider = departmentDeleteImpactProvider(departmentId);
    final current = ref.watch(scopeStateProvider).programId;
    return NzAsyncView<DepartmentDeleteImpact>(
      value: ref.watch(provider),
      onRetry: () => ref.invalidate(provider),
      data: (impact) => ListenableBuilder(
        listenable: model,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: NizamioSpacing.space3,
          children: [
            if (permanent)
              NzBanner.danger(message: l.uiCoordDeletePermanentWarning)
            else
              NzBanner.warning(message: l.uiCoordDeleteSoftWarning),
            if (permanent && impact.permanentBlocked)
              NzBanner.danger(message: blockedText(l, impact.blockers)),
            NzFormRows(rows: _rows(l, impact, current)),
            NzTextField(
              label: '${l.uiCoordDeleteConfirmLabel}: $phrase',
              hint: phrase,
              helper: l.uiCoordDeleteConfirmHelper,
              enabled: !model.busy,
              textInputAction: TextInputAction.done,
              onChanged: model.type,
            ),
            if (model.error case final e?)
              NzBanner.danger(
                message: e.code == 'organization.department_in_use'
                    ? blockedText(
                        l,
                        DepartmentPermanentBlockers.fromFields(e.fields),
                      )
                    : errorText(l, e),
              ),
          ],
        ),
      ),
    );
  }

  List<NzFormRow> _rows(
    AppLocalizations l,
    DepartmentDeleteImpact impact,
    String? current,
  ) {
    String tasks(int open, int done) =>
        '$open ${l.uiCoordDeleteOpen} · $done ${l.uiCoordDeleteCompleted}';
    final here = impact.programs.where((p) => p.programId == current);
    return [
      NzFormRow(
        label: l.uiCoordDeleteRowThisProgram,
        icon: NzIcons.tasks,
        value: tasks(
          here.fold(0, (a, p) => a + p.activeItems),
          here.fold(0, (a, p) => a + p.completedItems),
        ),
      ),
      for (final p in impact.otherPrograms(current))
        NzFormRow(
          label:
              p.programName ?? p.departmentName ?? l.uiCoordDeleteOtherProgram,
          icon: NzIcons.tasks,
          value: p.linked
              ? tasks(p.activeItems, p.completedItems)
              : '${tasks(p.activeItems, p.completedItems)} · '
                    '${l.uiCoordDeleteUnlinked}',
        ),
      if (permanent)
        NzFormRow(
          label: l.uiCoordDeleteRowDeleted,
          icon: NzIcons.delete,
          value: '${impact.deletedItems} ${l.uiCoordDeleteTask}',
        ),
      NzFormRow(
        label: l.uiCoordDeleteRowFiles,
        icon: NzIcons.attach,
        value: '${impact.fileCount}',
      ),
      NzFormRow(
        label: l.uiCoordDeleteRowMembers,
        icon: NzIcons.person,
        value: '${impact.memberCount} ${l.uiCoordDeletePerson}',
      ),
      NzFormRow(
        label: l.uiCoordDeleteRowMeetings,
        icon: NzIcons.event,
        value: '${impact.meetingCount}',
      ),
    ];
  }
}

/// Kalıcı silme engelinin açıklaması: "… (2 tablo, 1 proje)".
String blockedText(AppLocalizations l, DepartmentPermanentBlockers b) {
  final parts = [
    if (b.tables > 0) '${b.tables} ${l.uiCoordDeleteBlockerTables}',
    if (b.projects > 0) '${b.projects} ${l.uiCoordDeleteBlockerProjects}',
    if (b.pendingProposals > 0)
      '${b.pendingProposals} ${l.uiCoordDeleteBlockerProposals}',
  ];
  return parts.isEmpty
      ? l.uiCoordDeleteBlocked
      : '${l.uiCoordDeleteBlocked} (${parts.join(', ')})';
}

/// "6 görev Silinenler'e taşındı" (görev yoksa "Koordinatörlük silindi").
String coordDeletedToast(AppLocalizations l, int moved) => moved > 0
    ? '$moved ${l.uiCoordDeleteToastMovedTail}'
    : l.uiCoordDeleteToastDeleted;

/// "\"Ad\" geri yüklendi · 4 görev geri geldi".
String coordRestoredToast(AppLocalizations l, String name, int restored) => [
  '"$name" ${l.uiCoordDeleteToastRestored}',
  if (restored > 0) '$restored ${l.uiCoordDeleteToastRestoredTail}',
].join(' · ');

/// "\"Ad\" kalıcı silindi · 7 görev · 2 dosya · 3 program bağı".
String coordPurgedToast(
  AppLocalizations l,
  String name, {
  required int tasks,
  required int files,
  required int links,
}) => [
  '"$name" ${l.uiCoordDeleteToastPurged}',
  if (tasks > 0) '$tasks ${l.uiCoordDeleteTask}',
  if (files > 0) '$files ${l.uiCoordDeleteToastFilesTail}',
  if (links > 0) '$links ${l.uiCoordDeleteToastLinksTail}',
].join(' · ');
