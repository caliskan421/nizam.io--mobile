// ignore_for_file: implementation_imports, depend_on_referenced_packages
// Gerçek firebase_core + firebase_crashlytics Dart eklentileri çalışır; yalnız yerel
// (platform) kanal sahtelenir. Doğrulanan yük, native tarafa GİDEN pigeon isteğidir
// (eklentinin kendi yığın dönüşümü dahil). Gerçek cihaz/konsol provası değildir.
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/src/pigeon/messages.pigeon.dart'
    as core;
import 'package:firebase_crashlytics_platform_interface/src/pigeon/messages.pigeon.dart'
    as cl;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/telemetry/crashlytics_error_reporter.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';

const _p = 'dev.flutter.pigeon.';
const _coreApi = '${_p}firebase_core_platform_interface.FirebaseCoreHostApi.';
const _clApi =
    '${_p}firebase_crashlytics_platform_interface.FirebaseCrashlyticsHostApi.';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = binding.defaultBinaryMessenger;
  final calls = <String>[];
  final recorded = <cl.RecordErrorRequest>[];
  final collectionArgs = <bool>[];
  var failRecord = false;

  void mock(
    String channel,
    MessageCodec<Object?> codec,
    Object? Function(List<Object?> args) handler,
  ) {
    messenger.setMockMessageHandler(channel, (ByteData? message) async {
      final args =
          (codec.decodeMessage(message) as List<Object?>?) ?? <Object?>[];
      return codec.encodeMessage(<Object?>[handler(args)]);
    });
  }

  setUpAll(() async {
    mock(
      '${_coreApi}initializeCore',
      core.FirebaseCoreHostApi.pigeonChannelCodec,
      (_) => <core.CoreInitializeResponse>[
        core.CoreInitializeResponse(
          name: '[DEFAULT]',
          options: core.CoreFirebaseOptions(
            apiKey: 'k',
            appId: '1:1:ios:1',
            messagingSenderId: '1',
            projectId: 'p',
          ),
          pluginConstants: <String?, Object?>{
            'plugins.flutter.io/firebase_crashlytics': <String, Object?>{
              'isCrashlyticsCollectionEnabled': false,
            },
          },
        ),
      ],
    );
    mock(
      '${_clApi}recordError',
      cl.FirebaseCrashlyticsHostApi.pigeonChannelCodec,
      (args) {
        calls.add('recordError');
        recorded.add(args.single! as cl.RecordErrorRequest);
        if (failRecord) throw PlatformException(code: 'native', message: 'x');
        return null;
      },
    );
    mock(
      '${_clApi}setCrashlyticsCollectionEnabled',
      cl.FirebaseCrashlyticsHostApi.pigeonChannelCodec,
      (args) {
        calls.add('setCollection');
        collectionArgs.add(args.single! as bool);
        return args.single;
      },
    );
    for (final m in [
      'sendUnsentReports',
      'deleteUnsentReports',
      'setCustomKey',
      'setUserIdentifier',
      'log',
    ]) {
      mock('$_clApi$m', cl.FirebaseCrashlyticsHostApi.pigeonChannelCodec, (_) {
        calls.add(m);
        return null;
      });
    }
    await Firebase.initializeApp();
  });

  setUp(() {
    calls.clear();
    recorded.clear();
    collectionArgs.clear();
    failRecord = false;
    ErrorReporting.reset();
  });
  tearDown(ErrorReporting.reset);

  const stack = <String>[
    "build_id: 'abcdef0123456789'",
    '#00 abs 000000b4b5c3f4f3 virt 00000000003ae4f3 _kDartIsolateSnapshotInstructions+0x1e4f3',
    '#0      Foo.bar (package:nizamio/features/tasks/foo.dart:12:3)',
    '#1      Baz (file:///Users/ali.veli/Projects/maaş-bordrosu.dart:5:1)',
    '#2      Q (https://sunucu.example/x?token=abc:1:1)',
    'ali@example.com serbest metin',
  ];

  test('native kanala giden istek: etiket, güvenli yığın, boş information/reason', () async {
    ErrorReporting.attach(CrashlyticsErrorReporter());
    ErrorReporting.setEnabled(true);
    ErrorReporting.report(
      const FormatException('ali@example.com maaş.pdf'),
      StackTrace.fromString(stack.join('\n')),
      kind: ReportKind.serialization,
      operation: ReportOperation.login,
      source: ReportSource.identity,
      apiOperationId: 'login',
    );
    await Future<void>.delayed(Duration.zero);
    final r = recorded.single;
    // Etiket + SABİT Türkçe açıklama (hata iletisi ya da kişisel metin DEĞİL).
    expect(
      r.exception,
      'kind=serialization op=login src=identity api=login type=format_exception'
      ' | Yerel veri ayrıştırılırken ya da eşlenirken tür/biçim hatası oluştu. '
      'Biçim hatası.',
    );
    expect(r.information, '');
    expect(r.reason, isNull);
    expect(r.fatal, isFalse);
    expect(r.buildId, 'abcdef0123456789');
    final frames = r.stackTraceElements;
    expect(
      frames.any((f) => f.file == 'package:nizamio/features/tasks/foo.dart'),
      isTrue,
    );
    expect(
      frames.any((f) => f.method.startsWith('#00 abs 000000b4b5c3f4f3')),
      isTrue,
      reason: 'AOT çerçevesi sembolleştirme için korunur',
    );
    final wire = [
      r.exception,
      r.information,
      r.buildId,
      for (final f in frames) '${f.className} ${f.method} ${f.file} ${f.line}',
    ].join('\n');
    for (final leak in [
      'ali@',
      'ali.veli',
      'maaş',
      'sunucu',
      'abc:',
      'serbest',
      'bordro',
    ]) {
      expect(wire, isNot(contains(leak)), reason: leak);
    }
    expect(
      calls.where((c) => c != 'recordError'),
      isEmpty,
      reason: 'özel anahtar, kullanıcı kimliği, günlük çağrısı yok',
    );
  });

  // firebase_crashlytics-5.4.0/test/firebase_crashlytics_test.dart'taki GERÇEK SDK örnekleri
  // (satır başı boşlukları dahil): Android (virt var) ve iOS (virt yok).
  const sdkPrelude = <String>[
    'Warning: This VM has been configured to produce stack traces that violate the Dart standard.',
    '*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***',
    'pid: 1357, tid: 1415, name 1.ui',
    "build_id: '77d1b910140a2d66b93594aea59469cf'",
    'isolate_dso_base: 75f178181000, vm_dso_base: 75f178181000',
    'isolate_instructions: 75f17818f000, vm_instructions: 75f178183000',
  ];
  const android =
      '    #00 abs 000075f17833027b virt 00000000001af27b _kDartIsolateSnapshotInstructions+0x1a127b';
  const ios =
      '    #00 abs 000075f17833027b _kDartIsolateSnapshotInstructions+0x1a127b';

  for (final (name, frame) in [
    ('Android (virt var)', android),
    ('iOS (virt yok)', ios),
  ]) {
    test(
      'SDK örneği $name: çerçeve, build_id ve loading_unit native isteğe ulaşır',
      () async {
        ErrorReporting.attach(CrashlyticsErrorReporter());
        ErrorReporting.setEnabled(true);
        ErrorReporting.report(
          TypeError(),
          StackTrace.fromString(
            [...sdkPrelude, frame, 'loading_unit: 1'].join('\n'),
          ),
          kind: ReportKind.unexpected,
        );
        await Future<void>.delayed(Duration.zero);
        final r = recorded.single;
        expect(r.buildId, '77d1b910140a2d66b93594aea59469cf');
        expect(r.loadingUnits, ['loading_unit: 1']);
        expect(
          r.stackTraceElements.map((f) => f.method.trim()),
          contains(frame.trim()),
          reason: 'SDK normalleştirmesi sonrası AOT çerçevesi aynen iletilir',
        );
        expect(
          r.stackTraceElements.where((f) => f.method.contains('_kDartIsolate')),
          hasLength(1),
        );
      },
    );
  }

  test('SDK/native async hatası uygulamaya taşmaz', () async {
    failRecord = true;
    ErrorReporting.attach(CrashlyticsErrorReporter());
    ErrorReporting.setEnabled(true);
    expect(
      () => ErrorReporting.report(
        TypeError(),
        StackTrace.fromString('#0 f (package:a/a.dart:1:1)'),
        kind: ReportKind.unexpected,
      ),
      returnsNormally,
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(
      recorded,
      hasLength(1),
    ); // gönderildi, hata yutuldu, yakalanmamış hata yok
  });

  test('otomatik toplama yalnız KAPATILIR; true hiç gönderilmez', () async {
    final reporter = CrashlyticsErrorReporter();
    await reporter.disableCollection();
    await reporter.sendPending();
    await reporter.discardPending();
    expect(collectionArgs, [false]);
    expect(calls, [
      'setCollection',
      'sendUnsentReports',
      'deleteUnsentReports',
    ]);
  });
}
