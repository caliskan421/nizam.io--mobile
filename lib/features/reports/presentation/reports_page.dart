import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../application/reports_providers.dart';
import 'report_details.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => NzPage(
    title: 'Raporlar',
    onRetry: () => ref.invalidate(reportsProvider),
    body: NzAsyncView(
      value: ref.watch(reportsProvider),
      skeletonOnReload: true,
      onRetry: () => ref.invalidate(reportsProvider),
      data: (report) => ListView(
        children: [
          Text(report.season.programName),
          const ReportPdfButton(
            label: 'Dönem PDF',
            path: '/v1/reports/season/pdf',
          ),
          const ReportPdfButton(
            label: 'İş yükü PDF',
            path: '/v1/reports/workload',
            memberIds: [],
          ),
          const Gap(16),
          Text('Dönem özeti', style: context.text.labelLg),
          Text(
            '${report.season.stats.completedTasks} / ${report.season.stats.totalTasks} görev tamamlandı',
          ),
          Text('${report.season.stats.overdueTasks} geciken görev'),
          Text(
            '${report.season.stats.totalMeetings} toplantı · ${report.season.stats.totalNotes} not',
          ),
          const Gap(16),
          Text('İş yükü', style: context.text.labelLg),
          if (report.workload.members.isEmpty) const Text('İş yükü kaydı yok.'),
          for (final member in report.workload.members)
            ExpansionTile(
              title: Text(member.fullName),
              subtitle: Text('${member.tasks.length} görev'),
              children: [
                for (final task in member.tasks)
                  ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                      '${task.departmentName}${task.isOverdue ? ' · ${task.daysOverdue} gün gecikti' : ''}',
                    ),
                    onTap: () => context.appNav.openTask(task.workItemId),
                  ),
              ],
            ),
          const Gap(16),
          Text('Dönem görevleri', style: context.text.labelLg),
          if (report.tasks.truncated)
            const Text('Görev listesi kesildi. İlk kayıtlar gösteriliyor.'),
          for (final task in report.tasks.tasks)
            ExpansionTile(
              title: Text(task.title),
              subtitle: Text(task.departmentName),
              children: [ReportTaskDetails(id: task.workItemId)],
            ),
          const Text('Toplantı raporları'),
          if (report.meetings.truncated)
            const Text('Toplantı listesi kesildi. İlk kayıtlar gösteriliyor.'),
          for (final meeting in report.meetings.items)
            ExpansionTile(
              title: Text(meeting.title),
              subtitle: Text(
                '${meeting.participantCount} katılımcı · ${meeting.noteCount} not',
              ),
              children: [ReportMeetingDetails(id: meeting.meetingId)],
            ),
          for (final task in report.season.tasks)
            ListTile(
              title: Text(task.title),
              subtitle: Text(task.departmentName),
              onTap: () => context.appNav.openTask(task.workItemId),
            ),
        ],
      ),
    ),
  );
}
