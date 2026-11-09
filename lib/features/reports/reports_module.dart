import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:get_it/get_it.dart';

import '../../core/errors/api_error.dart';
import '../../core/providers.dart';
import 'application/report_pdf_controller.dart';
import 'application/reports_providers.dart';
import 'data/report_pdf_api_repository.dart';
import 'data/reports_api_repository.dart';
import 'domain/report_pdf_repository.dart';
import 'domain/reports_repository.dart';

void registerReportsModule(GetIt locator, {required Dio? Function() apiDio}) {
  locator.registerFactory<ReportsRepository>(() {
    final dio = apiDio();
    if (dio == null) throw ApiError('client.scope_missing');
    return ApiReportsRepository(dio);
  });
  locator.registerFactory<ReportPdfRepository>(() {
    final dio = apiDio();
    if (dio == null) {
      throw ApiError('client.scope_missing');
    }
    return ApiReportPdfRepository(dio);
  });
}

List<Override> reportsOverrides(GetIt locator) => [
  reportPdfRepositoryProvider.overrideWith((ref) {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return locator<ReportPdfRepository>();
  }),
  reportsRepositoryProvider.overrideWith((ref) {
    ref.watch(sessionGenerationProvider);
    ref.watch(scopeStateProvider);
    return locator<ReportsRepository>();
  }),
];
