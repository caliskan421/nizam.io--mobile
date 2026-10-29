# Servis katmanı envanteri — reporting

Kaynak: `lib/core/api/generated/clients/reporting_client.dart` (pin `v0.2.0-api`), spec
`nizam.io--backend` `v0.2.0-api:docs/api/openapi.yaml`, modül README
`internal/modules/reporting/README.md`. İstemcide **12 işlem** vardır (görev tanımındaki "8"
dashboard alt listeleri ve PDF uçları ayrı sayılmadan verilmiş; hepsi aşağıda).

Bütün uçlar **S2**'dir (`X-Nizamio-Program`, ara katmandan). Yetki sunucudadır; istemci rol
kuralı türetmez, `ApiError(reporting.not_authorized)` olduğu gibi yukarı çıkar.

## İşlemler

| operationId | yöntem yol | kapsam | Flutter karşılığı | domain tipi | not |
|---|---|---|---|---|---|
| reportDashboard | GET `/v1/reports/dashboard` | S2 | `DashboardReportRepository.load` (`ApiDashboardReportRepository`) | `DashboardReport` (scope) | **Yalnız ŞY** (REPORTING-K01). `TaskTotals`, `TeamTotals`, `CoordinatorshipSummary` yeniden kullanıldı. `TaskTotals.inProgress` ← `task_status_distribution['devam_ediyor']` (spec dağılım anahtarlarını tanımlamaz; backend `WorkItem.status` değerleri varsayıldı). `active_tasks` (= total − completed) ayrı alan `activeTasks`. `total_admins` şirket geneli (K02). `pending_approvals`/`pending_date_changes`/`deleted_records` sınanmıyor (GAP-075). |
| reportDashboardCoordinatorships | GET `/v1/reports/dashboard/coordinatorships` | S2 | `DashboardReportRepository.coordinatorships` → `PageSlice<CoordinatorshipSummary>`; ayrıca `CoordinatorshipStatsRepository.load` (`ApiCoordinatorshipStatsRepository`) → `PageSlice<CoordinatorshipStats>` | `CoordinatorshipSummary` (scope), `CoordinatorshipStats` (coordinatorships) | Yalnız ŞY. İmleçsiz, ≤200 satır, `X-Result-Truncated` → `truncated`. Sıra sunucuda ada göre bayt sırası (Türkçe değil). İki karşılık bilinçli: ana sayfa paneli ve koordinatörlük listesi farklı domain tiplerini kullanıyor; entegrasyonda biri seçilebilir. |
| reportDashboardTasks | GET `/v1/reports/dashboard/tasks` | S2 | `ReportsRepository.dashboardTasks` (`ApiReportsRepository`) | `ReportTaskList` (tasks, total, truncated) | Yalnız ŞY. Sayfasız; spec `total` alanı domain'e taşındı + kesilme başlığı. |
| reportDashboardMeetings | GET `/v1/reports/dashboard/meetings` | S2 | `ReportsRepository.dashboardMeetings` | `PageSlice<ReportMeeting>` | Yalnız ŞY. ≤200 satır, `X-Result-Truncated`. |
| reportTaskDetail | GET `/v1/reports/tasks/{id}` | S2 | `ReportsRepository.taskDetail(workItemId)` | `ReportTaskDetail` | Yalnız ŞY. Kapsam dışı → `reporting.not_found`. Son 20 not (K04). |
| reportMeetingDetail | GET `/v1/reports/meetings/{id}` | S2 | `ReportsRepository.meetingDetail(meetingId)` | `ReportMeetingDetail` | Yalnız ŞY. `author_role` boş dizge → `null` (rol kaydı yok), tanınmayan → `unknown`. `ReportParticipant.role` spec'te serbest dizge (backend `admin/coordinator/member`). |
| reportWorkload | GET `/v1/reports/workload` | S2 | `ReportsRepository.workload` | `WorkloadReport` | Yalnız ŞY. Eşzamanlılık koruması altında: 429 `reporting.export_in_progress`, 503 `reporting.capacity_full` (K10). `total` alanının anlamı spec'te açıklanmamış. |
| reportWorkloadPdf | POST `/v1/reports/workload` | S2 | `ReportsRepository.workloadPdf(memberIds)` → hedef | `ReportDownloadTarget` (POST, gövde `WorkloadPdfRequest.toJson()`) | Yalnız ŞY. Ağ isteği yok; bilet akışına (identity) verilir. CSRF (`X-Requested-With`) ister. Geçersiz üye 422 `reporting.input_invalid`. Dışa aktarım kotası (K09). |
| reportTaskPdf | GET `/v1/reports/tasks/{id}/pdf` | S2 | `ReportsRepository.taskPdf(workItemId)` → hedef | `ReportDownloadTarget` (GET) | **ŞY + kaynağın departmanının K'sı** (K07). Kimlik `Uri.encodeComponent` ile yola yazılır. |
| reportMeetingPdf | GET `/v1/reports/meetings/{id}/pdf` | S2 | `ReportsRepository.meetingPdf(meetingId)` → hedef | `ReportDownloadTarget` (GET) | ŞY + kendi departmanının K'sı (K07). |
| reportSeason | GET `/v1/reports/season` | S2 | `ReportsRepository.season` | `SeasonReport` | Yalnız ŞY. Silinmiş kayıtlar girmez (K08). K10 koruması. `monthly_activity.month` dizge olarak bırakıldı (spec biçim tanımlamaz; backend `YYYY-MM`). |
| reportSeasonPdf | GET `/v1/reports/season/pdf` | S2 | `ReportsRepository.seasonPdf` → hedef | `ReportDownloadTarget` (GET) | Yalnız ŞY. |

Karşılanan: 12/12 (4 PDF işlemi hedef üretici olarak; doğrudan çağrı yok).

**PDF notu.** Üretilmiş istemci PDF uçlarını `Stream<String>` olarak üretiyor ve ikili gövdeyi
`utf8.decoder` ile çözüyor (`reporting_client.g.dart`); bu imza PDF baytları için kullanılamaz.
Bu yüzden repository PDF'i indirmez, yalnız bilet akışının (`POST /v1/download-tickets` →
`GET /v1/downloads/{ticket}`) hedefini (`method`, `path`, `body`) üretir. Bilet isteğinde
`X-Nizamio-Program` verilmelidir (hedef S2; bilete yazılır). Üretici imzası bir backend/üretim
yapılandırması sorunudur (ikili yanıt türü); envantere aday olarak yazıldı.

## Yetki notları (spec/README'den; istemcide türetilmez)

- REPORTING-K01: dashboard, alt listeler, detaylar, iş yükü (JSON + PDF) ve dönem raporu (JSON +
  PDF) **yalnız şirket yöneticisine** açık; diğer roller 403 `reporting.not_authorized`.
- REPORTING-K07: görev ve toplantı PDF'i ŞY'ye ve kaynağın departmanının koordinatörüne açık;
  başka departmanın K'sı görevi görebiliyorsa 403, göremiyorsa 404 `reporting.not_found`.
- K ve Ü için ana sayfa paneline karşılık gelen reporting ucu yok (boşluk analizi §1.4).

## Domain değişiklikleri

- `lib/features/scope/domain/home_dashboard.dart`
  - `TaskTotals.inProgressOnTime`: `required int` → isteğe bağlı `int?` (sunucuda yok —
    entegrasyonda karar; UI bu alanı kullanmıyor, örnek fikstür değer vermeye devam ediyor).
    Sınıf yorumu sunucu eşlemesini anlatır.
  - `CoordinatorshipSummary`: isteğe bağlı spec alanları eklendi — `leadAccountIds`, `kind`
    (yeni enum `CoordinatorshipKind { coordinatorship, workingGroup, unknown }`), `serverTotal`
    (`total` getter'ı varsa bunu döner), `completionRate` (yüzde), `memberCount`,
    `meetingCount`, `lastActivityAt`, `description`. `code` sunucu kaynağında `department_id`.
    `inReview` sunucuda yok: kalan sayı (`total − completed − in_progress − not_started`, alt
    sınır 0). Var olan alanlar silinmedi.
- `lib/features/scope/domain/home_dashboard_report.dart` (yeni): `DashboardReport`,
  `OverdueTaskSummary`, `DashboardPerson`, `DashboardTaskStatus`, `DashboardTaskPriority`.
- `lib/features/scope/domain/home_dashboard_report_repository.dart` (yeni):
  `DashboardReportRepository` (mevcut `HomeDashboardRepository` değişmedi).
- `lib/features/coordinatorships/domain/coordinatorship_stats_repository.dart` (yeni):
  `CoordinatorshipStatsRepository`. `coordinatorship_overview.dart` değişmedi.
  Örtüşme: `CoordinatorshipStats.code` ← `department_id`, `name`, `done` ← `completed_tasks`,
  `total` ← `total_tasks`, `late` ← `overdue_tasks`, `leads` ← `coordinators`
  (`Person(role: coordinator)`). Örtüşmeyen: `members` (sunucu yalnız `member_count` verir →
  boş liste; entegrasyonda karar), `in_progress_tasks`, `not_started_tasks`,
  `completion_rate`, `meeting_count`, `last_activity_at`, `description`, `kind`
  (`CoordinatorshipStats`'ta karşılığı yok; o dosyaya dokunulmadığı için eklenmedi).
  Ayrıca `CoordinatorshipProfile.reported` ve `CoordinatorshipDetail` istemcide türetilen
  alanlar (attention, feed, seasonRatio) bu uçla karşılanmaz.
- `lib/features/reports/domain/` (yeni feature, yalnız domain + data; barrel/modül yok):
  `report_common.dart` (`ReportTaskStatus`, `ReportPriority`, `ReportRole`,
  `ReportDepartmentKind`, `ReportPerson`, `ReportDepartment`, `ReportCoordinatorshipStat`),
  `report_task.dart`, `report_meeting.dart`, `workload_report.dart`, `season_report.dart`,
  `report_download.dart` (`ReportDownloadTarget`, `ReportDownloadMethod`),
  `reports_repository.dart` (`ReportsRepository`).
- Uygulamalar: `lib/features/scope/data/dashboard_report_api_repository.dart`,
  `lib/features/coordinatorships/data/coordinatorship_stats_api_repository.dart`,
  `lib/features/reports/data/reports_api_repository.dart`.

## Ortaklaştırma adayları

- **Kesilme başlığı okuyucu** (`X-Result-Truncated`, `HttpResponse` → `bool`): üç repository'de
  özel kopya (+ `program_repository.dart`). `lib/core/` adayı.
- **Görev durumu / öncelik enum'u ve wire eşlemesi** (`baslanmadi`… / `dusuk`…):
  `DashboardTaskStatus`/`DashboardTaskPriority` (scope) ve `ReportTaskStatus`/`ReportPriority`
  (reports) ikiz; tasks feature'ının `TaskStatus`/`TaskPriority`'si `unknown` üyesi taşımıyor ve
  `acil` karşılığı yok. Feature'lar arası import yalnız barrel üzerinden olduğundan (B3) ve
  reports barrel'sız açıldığından ayrı tutuldu; ortak domain (core ya da tasks barrel) adayı.
- **Rapor kişisi** (`ReportPerson` / `DashboardPerson`) ve **departman türü**
  (`CoordinatorshipKind` / `ReportDepartmentKind`): aynı gerekçeyle ikiz.
- **`CoordinatorshipStat` eşlemesi** üç yerde (scope `CoordinatorshipSummary`, coordinatorships
  `CoordinatorshipStats`, reports `ReportCoordinatorshipStat`): A2 kuralı DTO'yu açık API'de
  taşımayı yasakladığından eşleyiciler her repository'de özel. Tek domain tipine birleşme
  entegrasyon adımında.
- **Wire → enum eşlemesi** `switch` ifadesiyle yapıldı: sınır kuralı D2 `features/**` içinde dize anahtarlı `Map` literali ve `Map<String, …>` tipini yasaklıyor (dağılım haritaları `.entries` ile okunur). Aynı nedenle `ReportDownloadTarget.body` `Object?` (üretilmiş `WorkloadPdfRequest.toJson()` çıktısı).
- **İndirme hedefi** (`ReportDownloadTarget`): identity parçasının bilet isteği domain tipiyle
  birleşmeli (records/dosya indirme de aynı yapıyı kullanacak).

## Spec belirsizlikleri

- `task_status_distribution` / `priority_distribution` anahtarları spec'te tanımsız
  (`additionalProperties: integer`); backend durum/öncelik değerleri varsayıldı, tanınmayan
  anahtarlar `unknown` altında toplanır.
- `ReportTask.status`, `ReportTaskRef.status`, `WorkloadTask.status`, `ReportParticipant.role`,
  `CoordinatorshipStat.kind` spec'te enum değil serbest dizge.
- `WorkloadReport.total` anlamı açıklanmamış.
- `CoordinatorshipStat.last_activity_at` `format: date-time` değil düz dizge; `DateTime.tryParse`
  ile okunur, ayrıştırılamazsa `null`.
- PDF uçlarının üretilmiş imzası ikili gövde için uygun değil (yukarıda).
