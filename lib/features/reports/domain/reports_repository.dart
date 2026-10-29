import '../../../core/domain/page_slice.dart';
import 'report_download.dart';
import 'report_meeting.dart';
import 'report_task.dart';
import 'season_report.dart';
import 'workload_report.dart';

/// reporting raporlarının kaynağı (domain portu; gerçekleştirme `data/`). Bütün uçlar S2'dir
/// (`X-Nizamio-Program` ara katmandan). Yetki sunucudadır: JSON uçları yalnız şirket
/// yöneticisine açıktır; görev/toplantı PDF'i ayrıca kaynağın departmanının koordinatörüne
/// açıktır (REPORTING-K01, K07). Reddedilen çağrı `ApiError(reporting.not_authorized)`
/// fırlatır; istemci rol kuralı türetmez.
abstract interface class ReportsRepository {
  /// `GET /v1/reports/dashboard/tasks`.
  Future<ReportTaskList> dashboardTasks();

  /// `GET /v1/reports/dashboard/meetings`; en çok 200 satır, kesilme [PageSlice.truncated].
  Future<PageSlice<ReportMeeting>> dashboardMeetings();

  /// `GET /v1/reports/tasks/{id}`; kapsam dışı görev `reporting.not_found`.
  Future<ReportTaskDetail> taskDetail(String workItemId);

  /// `GET /v1/reports/meetings/{id}`.
  Future<ReportMeetingDetail> meetingDetail(String meetingId);

  /// `GET /v1/reports/workload`; eşzamanlı üretim `reporting.export_in_progress`,
  /// dolu sunucu `reporting.capacity_full`.
  Future<WorkloadReport> workload();

  /// `GET /v1/reports/season`.
  Future<SeasonReport> season();

  /// `GET /v1/reports/tasks/{id}/pdf` hedefi (bilet akışı için; ağ isteği yok).
  ReportDownloadTarget taskPdf(String workItemId);

  /// `GET /v1/reports/meetings/{id}/pdf` hedefi.
  ReportDownloadTarget meetingPdf(String meetingId);

  /// `POST /v1/reports/workload` hedefi; boş [memberIds] bütün üyeler.
  ReportDownloadTarget workloadPdf(List<String> memberIds);

  /// `GET /v1/reports/season/pdf` hedefi.
  ReportDownloadTarget seasonPdf();
}
