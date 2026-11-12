import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/telemetry/report_source.dart';
import '../../../core/telemetry/unexpected_error.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../application/admin_controller.dart';
import '../application/admin_deleted_provider.dart';

class AdminDeletedRecords extends ConsumerStatefulWidget {
  const AdminDeletedRecords({super.key});
  @override
  ConsumerState<AdminDeletedRecords> createState() =>
      _AdminDeletedRecordsState();
}

class _AdminDeletedRecordsState extends ConsumerState<AdminDeletedRecords> {
  String? _accountsCursor;
  String? _departmentsCursor;
  @override
  Widget build(BuildContext context) {
    ref.listen(
      sessionGenerationProvider,
      (_, _) => setState(() {
        _accountsCursor = null;
        _departmentsCursor = null;
      }),
    );
    ref.listen(
      scopeStateProvider,
      (_, _) => setState(() {
        _accountsCursor = null;
        _departmentsCursor = null;
      }),
    );
    final accounts = deletedAdminAccountsProvider(_accountsCursor);
    final departments = deletedAdminDepartmentsProvider(_departmentsCursor);
    Future<void> restore({String? account, String? department}) async {
      try {
        await ref.read(adminCommandProvider.notifier).run((o, p) async {
          if (account != null) {
            await o.restoreAccount(account);
          }
          if (department != null) {
            await o.restoreDepartment(department);
          }
        });
        if (!mounted) {
          return;
        }
        ref.invalidate(accounts);
        ref.invalidate(departments);
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

    return Column(
      children: [
        ExpansionTile(
          title: const Text('Silinen hesaplar'),
          children: [
            NzAsyncView(
              value: ref.watch(accounts),
              skeletonOnReload: true,
              onRetry: () => ref.invalidate(accounts),
              data: (page) => Column(
                children: [
                  if (page.items.isEmpty) const Text('Silinmiş hesap yok.'),
                  for (final account in page.items)
                    ListTile(
                      title: Text(account.fullName),
                      trailing: TextButton(
                        onPressed: () => restore(account: account.accountId),
                        child: const Text('Geri yükle'),
                      ),
                    ),
                  if (_accountsCursor != null)
                    TextButton(
                      onPressed: () => setState(() => _accountsCursor = null),
                      child: const Text('İlk sayfa'),
                    ),
                  if (page.nextCursor != null)
                    TextButton(
                      onPressed: () =>
                          setState(() => _accountsCursor = page.nextCursor),
                      child: const Text('Sonraki sayfa'),
                    ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Silinen koordinatörlükler'),
          children: [
            NzAsyncView(
              value: ref.watch(departments),
              skeletonOnReload: true,
              onRetry: () => ref.invalidate(departments),
              data: (page) => Column(
                children: [
                  if (page.items.isEmpty)
                    const Text('Silinmiş koordinatörlük yok.'),
                  for (final department in page.items)
                    ListTile(
                      title: Text(department.name),
                      trailing: TextButton(
                        onPressed: () =>
                            restore(department: department.departmentId),
                        child: const Text('Geri yükle'),
                      ),
                    ),
                  if (_departmentsCursor != null)
                    TextButton(
                      onPressed: () =>
                          setState(() => _departmentsCursor = null),
                      child: const Text('İlk sayfa'),
                    ),
                  if (page.nextCursor != null)
                    TextButton(
                      onPressed: () =>
                          setState(() => _departmentsCursor = page.nextCursor),
                      child: const Text('Sonraki sayfa'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
