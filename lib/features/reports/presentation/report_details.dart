import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/feedback/nz_toast.dart';
import '../application/report_pdf_controller.dart';
import '../application/reports_providers.dart';

class ReportTaskDetails extends ConsumerWidget {
  const ReportTaskDetails({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) => NzAsyncView(
    value: ref.watch(reportTaskProvider(id)),
    skeletonOnReload: true,
    onRetry: () => ref.invalidate(reportTaskProvider(id)),
    data: (report) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(report.description),
        for (final dependency in report.dependencies)
          ListTile(
            title: Text(dependency.title),
            subtitle: Text(dependency.departmentName),
          ),
        for (final note in report.recentNotes)
          ListTile(
            title: Text(note.content),
            subtitle: Text(note.author.fullName),
          ),
        ReportPdfButton(
          label: 'Görev PDF',
          path: '/v1/reports/tasks/${Uri.encodeComponent(id)}/pdf',
        ),
      ],
    ),
  );
}

class ReportMeetingDetails extends ConsumerWidget {
  const ReportMeetingDetails({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) => NzAsyncView(
    value: ref.watch(reportMeetingProvider(id)),
    skeletonOnReload: true,
    onRetry: () => ref.invalidate(reportMeetingProvider(id)),
    data: (report) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final person in report.participants)
          ListTile(title: Text(person.fullName)),
        for (final item in report.agenda)
          ListTile(
            title: Text(item.title),
            subtitle: Text(item.isChecked ? 'Tamamlandı' : 'Bekliyor'),
          ),
        for (final note in report.notes)
          ListTile(
            title: Text(note.content),
            subtitle: Text(note.author.fullName),
          ),
        ReportPdfButton(
          label: 'Toplantı PDF',
          path: '/v1/reports/meetings/${Uri.encodeComponent(id)}/pdf',
        ),
      ],
    ),
  );
}

class ReportPdfButton extends ConsumerWidget {
  const ReportPdfButton({
    super.key,
    required this.label,
    required this.path,
    this.memberIds,
  });
  final String label;
  final String path;
  final List<String>? memberIds;
  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
    onPressed: ref.watch(reportPdfControllerProvider)
        ? null
        : () async {
            try {
              final saved = await ref
                  .read(reportPdfControllerProvider.notifier)
                  .save(path, memberIds: memberIds);
              if (saved != null && context.mounted) {
                NzToast.show(context, 'PDF kaydedildi: $saved');
              }
            } on Object catch (e) {
              if (context.mounted) {
                NzToast.error(context, toApiError(e));
              }
            }
          },
    child: Text(label),
  );
}
