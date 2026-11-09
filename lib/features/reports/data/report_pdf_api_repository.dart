import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/reporting_client.dart';
import '../../../core/api/generated/models/workload_pdf_request.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/file_download.dart';
import '../../../core/http/sse.dart';
import '../domain/report_pdf_repository.dart';

/// Üretilmiş PDF imzaları metin döndürdüğü için ikili akış aynı API Dio ve üretilmiş
/// operation metaverisiyle okunur. Gövde üretilmiş DTO'dur; yetki ve S2 kapsam kapısı korunur.
class ApiReportPdfRepository implements ReportPdfRepository {
  ApiReportPdfRepository(this._dio);
  final Dio _dio;
  @override
  Future<Stream<List<int>>> open(String path, {List<String>? memberIds}) async {
    if (memberIds == null) {
      final extras = path == '/v1/reports/season/pdf'
          ? ReportingClient.reportSeasonPdfOpenapiExtras
          : path.startsWith('/v1/reports/tasks/')
          ? ReportingClient.reportTaskPdfOpenapiExtras
          : ReportingClient.reportMeetingPdfOpenapiExtras;
      return getBinaryStream(_dio, path: path, extras: extras);
    }
    try {
      final response = await _dio.post<ResponseBody>(
        '/v1/reports/workload',
        data: WorkloadPdfRequest(memberIds: memberIds).toJson(),
        options: Options(
          responseType: ResponseType.stream,
          extra: Map.of(ReportingClient.reportWorkloadPdfOpenapiExtras),
        ),
      );
      final body = response.data;
      if (body == null) {
        throw ApiError('client.invalid_response');
      }
      return _bytes(body);
    } on DioException catch (e) {
      throw await streamApiError(e);
    }
  }

  Stream<List<int>> _bytes(ResponseBody body) async* {
    try {
      yield* body.stream;
    } on Object {
      throw ApiError('client.network_error');
    }
  }
}
