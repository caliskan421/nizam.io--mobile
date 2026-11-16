import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/providers.dart';
import '../../../../core/telemetry/report_source.dart';
import '../../../../core/telemetry/unexpected_error.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/state/nz_async_view.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../meetings/meetings.dart';
import '../../../tasks/tasks.dart';
import '../../application/admin_controller.dart';
import '../../application/admin_deleted_provider.dart';
import '../../domain/deleted_records.dart';
import '../../domain/organization_admin_repository.dart';
import 'deleted_record_row.dart';

final _date = DateFormat('dd.MM.yyyy HH:mm');
String _when(DateTime? at) => at == null ? '' : _date.format(at.toLocal());

/// Görevler: `GET /v1/admin/deleted/work-items` (imleçli; "daha fazla").
class DeletedTasksTab extends ConsumerWidget {
  const DeletedTasksTab({super.key, required this.onGoTo});
  final ValueChanged<DeletedKind> onGoTo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final deletedDepts = ref.watch(deletedAdminDepartmentsProvider(null)).value;
    String? deptName(String id) =>
        catalog?.coordinatorship(id)?.name ??
        deletedDepts?.items
            .where((d) => d.departmentId == id)
            .firstOrNull
            ?.name;
    final ctrl = ref.read(deletedTasksProvider.notifier);
    Future<ApiError?> guard(Future<void> Function() op) async {
      try {
        await op();
        return null;
      } on Object catch (e, st) {
        return toReportedApiError(e, st, source: ReportSource.tasks);
      }
    }

    return NzAsyncView(
      value: ref.watch(deletedTasksProvider),
      skeletonOnReload: true,
      onRetry: () => ref.invalidate(deletedTasksProvider),
      data: (page) => DeletedList(
        note:
            'Geri yüklenen görevin bağımlılıkları geri gelmez; gerekirse '
            'yeniden eklenir.',
        empty: 'Silinmiş görev yok.',
        onMore: page.nextCursor == null
            ? null
            : () => guard(ctrl.loadMore).then((e) {
                if (e != null && context.mounted) NzToast.error(context, e);
              }),
        rows: [
          for (final task in page.items)
            DeletedRecordRow(
              title: task.title,
              subtitle: [
                ?deptName(task.departmentId),
                'Silinme ${_when(task.deletedAt)}',
                if (task.fileCount > 0) '${task.fileCount} dosya',
              ].join(' · '),
              onRestore: () => runDeletedAction(
                context,
                kind: DeletedKind.task,
                name: task.title,
                purge: false,
                departmentName: deptName(task.departmentId),
                onGoTo: onGoTo,
                onRefresh: () => ref.invalidate(deletedTasksProvider),
                run: () => guard(() => ctrl.restore(task)),
              ),
              onPurge: () => runDeletedAction(
                context,
                kind: DeletedKind.task,
                name: task.title,
                purge: true,
                onGoTo: onGoTo,
                onRefresh: () => ref.invalidate(deletedTasksProvider),
                run: () => guard(() => ctrl.purge(task)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Toplantılar: toplantı listesinin yönetici silinenleri (`adminListDeletedMeetings`).
class DeletedMeetingsTab extends ConsumerWidget {
  const DeletedMeetingsTab({super.key, required this.onGoTo});
  final ValueChanged<DeletedKind> onGoTo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(meetingsBoardControllerProvider.notifier);
    void refresh() => ref.invalidate(meetingsBoardControllerProvider);
    return NzAsyncView(
      value: ref.watch(meetingsBoardControllerProvider),
      skeletonOnReload: true,
      onRetry: refresh,
      data: (board) => DeletedList(
        empty: 'Silinmiş toplantı yok.',
        rows: [
          for (final m in board.deleted ?? const <Meeting>[])
            DeletedRecordRow(
              title: m.title,
              subtitle: [
                'Toplantı ${_when(m.meetingDate)}',
                if (m.deletedAt != null) 'Silinme ${_when(m.deletedAt)}',
                ?m.deletedByName,
              ].join(' · '),
              onRestore: () => runDeletedAction(
                context,
                kind: DeletedKind.meeting,
                name: m.title,
                purge: false,
                onGoTo: onGoTo,
                onRefresh: refresh,
                run: () => ctrl.restore(m.id),
              ),
              onPurge: () => runDeletedAction(
                context,
                kind: DeletedKind.meeting,
                name: m.title,
                purge: true,
                onGoTo: onGoTo,
                onRefresh: refresh,
                run: () => ctrl.purge(m.id),
              ),
            ),
        ],
      ),
    );
  }
}

/// Yönetici yaşam döngüsü komutu ([adminCommandProvider]); hata [ApiError] döner.
Future<ApiError?> _admin(
  WidgetRef ref,
  Future<void> Function(OrganizationAdminRepository o) call,
) async {
  try {
    await ref.read(adminCommandProvider.notifier).run((o, _) => call(o));
    return null;
  } on Object catch (e, st) {
    return toReportedApiError(e, st, source: ReportSource.administration);
  }
}

/// İmleçli yönetici listesi sekmesinin ortak iskeleti (sayfa imleci oturum/kapsamla sıfırlanır).
abstract class _PagedTabState<W extends ConsumerStatefulWidget>
    extends ConsumerState<W> {
  String? cursor;

  void resetOnScope() {
    ref.listen(
      sessionGenerationProvider,
      (_, _) => setState(() => cursor = null),
    );
    ref.listen(scopeStateProvider, (_, _) => setState(() => cursor = null));
  }

  VoidCallback? pager(String? next) => next == null && cursor == null
      ? null
      : () => setState(() => cursor = next);
}

/// Koordinatörlükler: `GET /v1/admin/deleted/departments`.
class DeletedCoordinatorshipsTab extends ConsumerStatefulWidget {
  const DeletedCoordinatorshipsTab({super.key, required this.onGoTo});
  final ValueChanged<DeletedKind> onGoTo;

  @override
  ConsumerState<DeletedCoordinatorshipsTab> createState() =>
      _DeletedCoordinatorshipsTabState();
}

class _DeletedCoordinatorshipsTabState
    extends _PagedTabState<DeletedCoordinatorshipsTab> {
  @override
  Widget build(BuildContext context) {
    resetOnScope();
    // Komut denetleyicisi (autoDispose) istek sürerken canlı kalsın.
    ref.watch(adminCommandProvider);
    final provider = deletedAdminDepartmentsProvider(cursor);
    void refresh() {
      ref
        ..invalidate(deletedAdminDepartmentsProvider)
        ..invalidate(deletedTasksProvider);
    }

    return NzAsyncView(
      value: ref.watch(provider),
      skeletonOnReload: true,
      onRetry: () => ref.invalidate(provider),
      data: (page) => DeletedList(
        empty: 'Silinmiş koordinatörlük yok.',
        onMore: pager(page.nextCursor),
        moreLabel: page.nextCursor == null ? 'İlk sayfa' : 'Sonraki sayfa',
        rows: [
          for (final d in page.items)
            DeletedRecordRow(
              title: d.name,
              subtitle: [
                ?d.code,
                if (d.deletedAt != null) 'Silinme ${_when(d.deletedAt)}',
              ].join(' · '),
              onRestore: () => runDeletedAction(
                context,
                kind: DeletedKind.coordinatorship,
                name: d.name,
                purge: false,
                onGoTo: widget.onGoTo,
                onRefresh: refresh,
                run: () => _admin(ref, (o) async {
                  await o.restoreDepartment(d.departmentId);
                  refresh();
                }),
              ),
              onPurge: () => runDeletedAction(
                context,
                kind: DeletedKind.coordinatorship,
                name: d.name,
                purge: true,
                onGoTo: widget.onGoTo,
                onRefresh: refresh,
                run: () => _admin(ref, (o) async {
                  await o.permanentDeleteDepartment(d.departmentId);
                  refresh();
                }),
              ),
            ),
        ],
      ),
    );
  }
}

/// Kullanıcılar: `GET /v1/admin/deleted/accounts`.
class DeletedUsersTab extends ConsumerStatefulWidget {
  const DeletedUsersTab({super.key, required this.onGoTo});
  final ValueChanged<DeletedKind> onGoTo;

  @override
  ConsumerState<DeletedUsersTab> createState() => _DeletedUsersTabState();
}

class _DeletedUsersTabState extends _PagedTabState<DeletedUsersTab> {
  @override
  Widget build(BuildContext context) {
    resetOnScope();
    ref.watch(adminCommandProvider);
    final provider = deletedAdminAccountsProvider(cursor);
    void refresh() => ref.invalidate(deletedAdminAccountsProvider);
    return NzAsyncView(
      value: ref.watch(provider),
      skeletonOnReload: true,
      onRetry: () => ref.invalidate(provider),
      data: (page) => DeletedList(
        note:
            'Silinmiş hesabın e-postası kullanımda sayılır; aynı e-postayla '
            'yeni hesap açmak yerine geri yükleyin.',
        empty: 'Silinmiş kullanıcı yok.',
        onMore: pager(page.nextCursor),
        moreLabel: page.nextCursor == null ? 'İlk sayfa' : 'Sonraki sayfa',
        rows: [
          for (final a in page.items)
            DeletedRecordRow(
              title: a.fullName,
              onRestore: () => runDeletedAction(
                context,
                kind: DeletedKind.user,
                name: a.fullName,
                purge: false,
                onGoTo: widget.onGoTo,
                onRefresh: refresh,
                run: () => _admin(ref, (o) async {
                  await o.restoreAccount(a.accountId);
                  refresh();
                }),
              ),
              onPurge: () => runDeletedAction(
                context,
                kind: DeletedKind.user,
                name: a.fullName,
                purge: true,
                onGoTo: widget.onGoTo,
                onRefresh: refresh,
                run: () => _admin(ref, (o) async {
                  await o.permanentDeleteAccount(a.accountId);
                  refresh();
                }),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tür etiketleri (sekme adı; yönlendirme düğmesinde).
String deletedKindLabel(DeletedKind k) => switch (k) {
  DeletedKind.task => 'Görevler',
  DeletedKind.meeting => 'Toplantılar',
  DeletedKind.coordinatorship => 'Koordinatörlükler',
  DeletedKind.user => 'Kullanıcılar',
};

/// Geri yükleme / kalıcı silme akışı: kalıcı silmede "geri alınamaz" onayı (görevde
/// bağımlılık ve dosya uyarısıyla), başarıda bildirim; açıklanabilir retlerde neden + çözüm
/// diyaloğu (çözüm başka sekmedeyse oraya geçer, değilse liste yenilenir).
Future<void> runDeletedAction(
  BuildContext context, {
  required DeletedKind kind,
  required String name,
  required bool purge,
  required Future<ApiError?> Function() run,
  required ValueChanged<DeletedKind> onGoTo,
  required VoidCallback onRefresh,
  String? departmentName,
}) async {
  if (purge) {
    final ok = await NzDialog.confirm(
      context,
      title: 'Kalıcı silinsin mi?',
      message: [
        '"$name" kalıcı silinecek. Bu işlem geri alınamaz.',
        if (kind == DeletedKind.task)
          'Görevin bağımlılıkları geri gelmez; ekli dosyaları da silinir.',
      ].join('\n\n'),
      confirmLabel: 'Kalıcı sil',
      tone: NzDialogTone.destructive,
    );
    if (!ok || !context.mounted) return;
  }
  final error = await run();
  if (!context.mounted) return;
  if (error == null) {
    NzToast.show(
      context,
      purge ? '"$name" kalıcı silindi' : '"$name" geri yüklendi',
      tone: NzToastTone.success,
    );
    return;
  }
  final block = deletedActionBlock(
    kind,
    error.code,
    departmentName: departmentName,
  );
  if (block == null) {
    NzToast.error(context, error);
    return;
  }
  final goTo = block.goTo;
  final act = await NzDialog.confirm(
    context,
    title: purge ? 'Kalıcı silinemedi' : 'Geri yüklenemedi',
    message: '${block.reason}\n\n${block.fix}',
    confirmLabel: goTo == null
        ? 'Listeyi yenile'
        : '${deletedKindLabel(goTo)} sekmesine geç',
    cancelLabel: 'Kapat',
  );
  if (!act) return;
  if (goTo == null) {
    onRefresh();
  } else {
    onGoTo(goTo);
  }
}

/// Satırların ortak listesi: üstte isteğe bağlı not, boşsa metin, sonda sayfa düğmesi.
class DeletedList extends StatelessWidget {
  const DeletedList({
    super.key,
    required this.rows,
    required this.empty,
    this.note,
    this.onMore,
    this.moreLabel = 'Daha fazla göster',
  });

  final List<Widget> rows;
  final String empty;
  final String? note;
  final VoidCallback? onMore;
  final String moreLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return ListView(
      padding: const EdgeInsets.only(bottom: NizamioSpacing.space6),
      children: [
        if (note case final n?)
          Padding(
            padding: const EdgeInsets.only(bottom: NizamioSpacing.space3),
            child: Text(n, style: t.caption.copyWith(color: c.textMuted)),
          ),
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: NizamioSpacing.space6,
            ),
            child: Text(
              empty,
              textAlign: TextAlign.center,
              style: t.bodyMd.copyWith(color: c.textMuted),
            ),
          ),
        ...rows,
        if (onMore != null)
          TextButton(onPressed: onMore, child: Text(moreLabel)),
      ],
    );
  }
}
