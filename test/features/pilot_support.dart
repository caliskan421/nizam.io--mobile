// Pilot dikey dilim (server · identity · scope) testlerinin ortak düzeneği (yalnız test):
// sahte backend (giriş, yenileme, çıkış, me, parola, programlar), gerçek bileşim kökü
// (Harness) ve ekran çizici. Ağa çıkmaz; "istek gönderilmedi" iddiaları Harness.backend ile.
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/app_localizations.dart';
import 'package:nizamio/core/network/connectivity_monitor.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/page/nz_app_nav.dart';
import 'package:nizamio/features/identity/identity.dart' show LoginPrefill;
import 'package:nizamio/features/scope/data/sample/sample_home_dashboard_repository.dart';
import 'package:nizamio/features/scope/domain/home_dashboard.dart';

import '../core/ui/widgets/feedback/feedback_test_support.dart';
import '../support/fake_backend.dart';
import '../support/harness.dart';
import '../support/recording_app_nav.dart';
import '../support/screen_matrix.dart';

/// Sertifika doğrulanamadı (TLS): dio `badCertificate` istisnası.
Never badCertificate(Seen r) => throw DioException(
  requestOptions: RequestOptions(path: r.path),
  type: DioExceptionType.badCertificate,
);

/// Sunucunun `message` gövdesi: HİÇBİR ekranda görünmemelidir.
const serverMessage = 'SUNUCU-METNİ';

/// Parola testlerinde kullanılan, başka hiçbir yerde geçmeyen değerler (sızıntı aramaları).
const secretCurrent = 'Mevcut-Gizli-Parola-1';
const secretNew = 'Yeni-Gizli-Parola-2';
const secretLogin = 'Giris-Gizli-Parola-3';

ResponseBody errorBody(
  int status,
  String code, {
  List<Map<String, Object?>>? fields,
  Map<String, List<String>>? headers,
}) => jsonResponse(status, {
  'code': code,
  'message': serverMessage,
  'request_id': 'req-$code',
  'fields': ?fields,
}, headers: headers);

/// Konfigürasyonlu sahte backend: değişkenler testten değiştirilir.
class PilotBackend {
  /// Girişte `force_password_change` değeri.
  bool force = false;

  /// `GET /v1/programs` satırları (`program_id`, `name`, isteğe bağlı `year`).
  List<Map<String, Object?>> programs = [
    {'program_id': 'prog-1', 'name': 'Program Bir'},
    {'program_id': 'prog-2', 'name': 'Program İki'},
  ];

  /// Doluysa `GET /v1/programs` yanıtına `X-Result-Truncated: true` başlığı eklenir.
  bool programsTruncated = false;

  /// Doluysa `GET /v1/programs` bu kodla (HTTP 403) düşer.
  String? programsError;

  /// Doluysa `POST /v1/auth/password` bu hata kodunu döner.
  String? passwordError;
  int passwordErrorStatus = 401;
  List<Map<String, Object?>>? passwordErrorFields;

  /// Doluysa `POST /v1/auth/login` bu hata kodunu döner (HTTP 401).
  String? loginError;
  List<Map<String, Object?>>? loginErrorFields;

  /// Ana sayfa özeti uçlarının (pano, görevler, tarih talepleri, okunmamış) yanıtları yola
  /// göre; [pilotHarness] [useSampleDashboard] ile doldurur (sunum testleri aynı veriyi görür).
  Map<String, Object> dashboard = const {};

  /// [dashboard] boşsa geliştirme örneğinden doldurur.
  Future<void> useSampleDashboard() async {
    if (dashboard.isNotEmpty) return;
    dashboard = dashboardWire(await SampleHomeDashboardRepository().load());
  }

  ResponseBody handle(Seen r) {
    switch ('${r.method} ${r.path}') {
      case 'POST /v1/auth/login':
        final err = loginError;
        if (err != null) {
          return errorBody(401, err, fields: loginErrorFields);
        }
        return jsonResponse(200, loginBody('1', force: force));
      case 'POST /v1/auth/refresh':
        return jsonResponse(
          200,
          loginBody('2')..remove('force_password_change'),
        );
      case 'POST /v1/auth/logout':
        return ResponseBody.fromString('', 204);
      case 'GET /v1/me':
        return jsonResponse(200, {
          'account_id': 'acc-1',
          'email': 'a@b.test',
          'full_name': 'Ayşe Yılmaz',
          'company_admin': true,
        });
      case 'GET /v1/me/departments':
        // Ekip satırı yok (şirket yöneticisi): görev kataloğu rolü türetir, liste istenmez.
        return jsonResponse(200, {'departments': <Object>[]});
      case 'POST /v1/auth/password':
        final err = passwordError;
        if (err != null) {
          return errorBody(
            passwordErrorStatus,
            err,
            fields: passwordErrorFields,
          );
        }
        return jsonResponse(200, {'revoked_sessions': 2});
      case 'GET /v1/programs':
        final err = programsError;
        if (err != null) return errorBody(403, err);
        return jsonResponse(
          200,
          {'programs': programs},
          headers: programsTruncated
              ? {
                  'X-Result-Truncated': ['true'],
                }
              : null,
        );
      case 'GET /v1/program':
        final id = r.header('X-Nizamio-Program');
        final row = programs.firstWhere(
          (p) => p['program_id'] == id,
          orElse: () => {'program_id': id, 'name': 'Bilinmeyen'},
        );
        return jsonResponse(200, {...row, 'year': 2026});
    }
    final body = r.method == 'GET' ? dashboard[r.path] : null;
    if (body != null) return jsonResponse(200, body);
    return discoveryHandler(r);
  }
}

/// Gerçek bileşim kökü + [backend]; bağ doğrulanmış (ve istenirse oturum açık).
Future<Harness> pilotHarness(
  PilotBackend backend, {
  bool verified = true,
  bool signedIn = false,
  LoginPrefill? loginPrefill,
}) async {
  await backend.useSampleDashboard();
  final h = Harness(handler: backend.handle, loginPrefill: loginPrefill);
  addTearDown(h.dispose);
  if (verified) await h.read(serverBindingProvider).verify(testUrl);
  if (signedIn) await h.identity.login(email: 'a@b.test', password: 'p');
  return h;
}

/// Pilot testlerinde taranan boyutlar: compact (telefon) ve expanded (tablet).
final pilotSizes = [screenMatrix.first, screenMatrix.last];

void useScreen(WidgetTester tester, ScreenSize screen) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = screen.size;
  addTearDown(tester.view.reset);
}

/// [page]'i gerçek bileşim kökünün portlarıyla çizer (bağlantı çevrimiçi).
Future<void> pumpScreen(
  WidgetTester tester,
  Harness h,
  Widget page, {
  bool dark = false,
  NzAppNav? nav,
}) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: h.container,
      child: ProviderScope(
        retry: (_, _) => null,
        overrides: [
          connectivityStateProvider.overrideWithValue(ConnectivityState.online),
        ],
        child: MaterialApp(
          theme: theme(dark),
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: testLocalizationDelegates,
          home: NzAppNavScope(nav: nav ?? RecordingAppNav(), child: page),
        ),
      ),
    ),
  );
  await tester.pump();
}

/// Eşzamansız işlerin (sahte ağ, durum yayını, geçişler) oturması için: gerçek zaman dilimi
/// (sahte HTTP bağdaştırıcısı akışları gerçek mikro görevlerle ilerler) + birkaç kare. Toplam
/// kare süresi en uzun rota geçişini (`NizamioMotion.durSheet`) aşar.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// `await` gerektiren kurulum işini (bağ doğrulama, giriş…) gerçek zaman diliminde koşar.
Future<T> real<T>(WidgetTester tester, Future<T> Function() body) async =>
    (await tester.runAsync(body)) as T;

Matcher apiCode(String code) =>
    isA<ApiError>().having((e) => e.code, 'code', code);

/// Ana sayfa özetini ([HomeDashboard]) sunucu biçimine çevirir: sunucu kaynağı aynı özeti
/// geri kurar. Koordinatörlük kodu `department_id`, görev kodu `work_item_id` olur; bekleyen
/// işin altyazısı (`department_name`) örnekteki gibi görev kodudur. Kaydırma gösterilmeyen
/// tarih talebinde bitiş değişmez (yalnız tarih gösterilir).
Map<String, Object> dashboardWire(HomeDashboard d) {
  String day(DateTime t) => t.toIso8601String().substring(0, 10);
  final t = d.tasks;
  final today = DateTime.now();
  Map<String, Object?> task(
    String id,
    String title,
    String status, {
    bool overdue = false,
    String? department,
  }) => {
    'work_item_id': id,
    'title': title,
    'department_id': department ?? id,
    'department_name': department ?? id,
    'status': status,
    'priority': 'orta',
    'start_on': day(today),
    'end_on': day(today),
    'planned_end_on': null,
    'completed_on': null,
    'created_by': {'account_id': 'acc-1', 'full_name': 'Ayşe Yılmaz'},
    'assignees': <Object>[],
    'is_overdue': overdue,
    'days_overdue': overdue ? 1 : 0,
    'is_completed_late': false,
    'days_late': 0,
    'is_completed_early': false,
    'days_early': 0,
    'has_pending_dependency': false,
    'dependency_count': 0,
    'note_count': 0,
    'created_at': '2026-09-01T08:00:00Z',
  };
  final dateChanges = [
    for (final p in d.pending)
      if (p.kind == PendingKind.dateChange) p,
  ];
  return {
    '/v1/reports/dashboard': {
      'program_id': 'prog-2',
      'program_name': 'Program İki',
      'total_coordinatorships': d.coordinatorships.length,
      'total_tasks': t.total,
      'active_tasks': t.open,
      'completed_tasks': t.done,
      'overdue_tasks': t.late,
      'pending_approvals': t.awaitingApproval,
      'pending_date_changes': d.counts.pendingRequests,
      'task_status_distribution': {
        'devam_ediyor': t.inProgress,
        'tamamlandi': t.done,
      },
      'priority_distribution': {'orta': t.total},
      'total_users': d.team!.users,
      'total_admins': d.team!.admins,
      'total_coordinators': d.team!.coordinators,
      'total_members': d.team!.members,
      'deleted_records': 0,
      'coordinatorship_stats': [
        for (final c in d.coordinatorships)
          {
            'department_id': c.code,
            'name': c.name,
            'kind': 'koordinatorluk',
            'coordinators': [
              for (final (i, n) in c.leads.indexed)
                {'account_id': '${c.code}-$i', 'full_name': n},
            ],
            'total_tasks': c.total,
            'completed_tasks': c.done,
            'in_progress_tasks': c.inProgress,
            'not_started_tasks': c.todo,
            'overdue_tasks': c.late,
            'completion_rate': c.donePercent.toDouble(),
            'member_count': 0,
            'meeting_count': 0,
            'last_activity_at': null,
          },
      ],
      'overdue_tasks_list': <Object>[],
      'generated_at': '2026-10-21T08:00:00Z',
    },
    '/v1/reports/dashboard/tasks': {
      'tasks': [
        // Bekleyen işlerin görevleri gecikmiş sayılır: zamanında sayısını bozmasın.
        for (final p in dateChanges)
          task(p.taskCode, p.title, 'devam_ediyor', overdue: true),
        for (final p in d.pending)
          if (p.kind == PendingKind.approval)
            task(p.taskCode, p.title, 'onaya_sunuldu'),
        for (var i = 0; i < (t.inProgressOnTime ?? 0); i++)
          task('w-$i', 'Görev $i', 'devam_ediyor', department: 'd'),
      ],
      'total': 0,
    },
    '/v1/date-change-requests': {
      'requests': [
        for (final (i, p) in dateChanges.indexed)
          {
            'request_id': 'dcr-$i',
            'work_item_id': p.taskCode,
            'status': 'pending',
            'old_start_on': day(today),
            'new_start_on': day(today),
            'old_end_on': day(
              p.requestedShiftDays == null
                  ? p.requestedDate!
                  : p.requestedDate!.subtract(
                      Duration(days: p.requestedShiftDays!),
                    ),
            ),
            'new_end_on': day(p.requestedDate!),
          },
      ],
      'total': dateChanges.length,
    },
    '/v1/messages/unread-count': {'count': d.counts.unreadMessages},
  };
}
