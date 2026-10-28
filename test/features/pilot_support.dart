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
        return jsonResponse(200, {'account_id': 'acc-1', 'email': 'a@b.test'});
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
    return discoveryHandler(r);
  }
}

/// Gerçek bileşim kökü + [backend]; bağ doğrulanmış (ve istenirse oturum açık).
Future<Harness> pilotHarness(
  PilotBackend backend, {
  bool verified = true,
  bool signedIn = false,
}) async {
  final h = Harness(handler: backend.handle);
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
