// Arşiv dosya listesi "daha fazla": catch yalnız arayüz hatasına çeviriyordu (beklenmeyen TypeError
// kayboluyordu). Şimdi beklenmeyen hata TEK rapor üretir, beklenen hata 0; arayüz sonucu aynıdır.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/domain/page_slice.dart';
import 'package:nizamio/core/errors/api_error.dart';
import 'package:nizamio/core/i18n/generated/client_error_codes.gen.dart';
import 'package:nizamio/core/telemetry/error_report.dart';
import 'package:nizamio/core/telemetry/error_reporting.dart';
import 'package:nizamio/core/telemetry/report_source.dart';
import 'package:nizamio/features/archive/application/archive_files_controller.dart';

import '../../../support/fake_error_reporter.dart';
import '../archive_fixture.dart';

void main() {
  late FakeErrorReporter sdk;

  setUp(() {
    sdk = FakeErrorReporter();
    ErrorReporting.reset();
    ErrorReporting.attach(sdk).setEnabled(true);
  });
  tearDown(ErrorReporting.reset);

  Future<ProviderContainer> loaded(FakeArchiveRepository repo) async {
    final c = archiveContainer(repo);
    c.listen(archiveFilesControllerProvider('d1'), (_, _) {});
    await c.read(archiveFilesControllerProvider('d1').future);
    return c;
  }

  FakeArchiveRepository twoPages() => FakeArchiveRepository()
    ..pages = {
      null: PageSlice(items: [archiveFile('f1')], nextCursor: 'c2'),
    };

  test('beklenmeyen TypeError: arayüz invalid_response, TEK rapor', () async {
    final repo = twoPages();
    final c = await loaded(repo);
    repo.error = TypeError();
    await c.read(archiveFilesControllerProvider('d1').notifier).loadMore();
    final s = c.read(archiveFilesControllerProvider('d1')).value!;
    expect(s.items.single.id, 'f1', reason: 'satırlar korunur');
    expect(s.moreError?.code, ClientErrorCode.invalidResponse);
    expect(s.loadingMore, isFalse);
    expect(sdk.reports, hasLength(1));
    final r = sdk.reports.single;
    expect(r.source, ReportSource.archive);
    expect(r.kind, ReportKind.serialization);
    expect(r.errorType, ReportErrorType.typeError);
  });

  test('beklenen hata (geçersiz imleç) rapor üretmez', () async {
    final repo = twoPages();
    final c = await loaded(repo);
    repo.error = ApiError('records.invalid_cursor');
    await c.read(archiveFilesControllerProvider('d1').notifier).loadMore();
    final s = c.read(archiveFilesControllerProvider('d1')).value!;
    expect(s.moreError?.code, 'records.invalid_cursor');
    expect(sdk.reports, isEmpty);
  });
}
