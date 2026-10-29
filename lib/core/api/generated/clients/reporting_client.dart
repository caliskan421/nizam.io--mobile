// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/coordinatorship_stat_list.dart';
import '../models/dashboard_report.dart';
import '../models/report_meeting_detail.dart';
import '../models/report_meeting_list.dart';
import '../models/report_task_detail.dart';
import '../models/report_task_list.dart';
import '../models/season_report.dart';
import '../models/workload_pdf_request.dart';
import '../models/workload_report.dart';

part 'reporting_client.g.dart';

@RestApi()
abstract class ReportingClient {
  factory ReportingClient(Dio dio, {String? baseUrl}) = _ReportingClient;

  static const Map<String, dynamic> reportDashboardOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportDashboard",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic>
  reportDashboardCoordinatorshipsOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["reporting"],
      'operationId': "reportDashboardCoordinatorships",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> reportDashboardTasksOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportDashboardTasks",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportDashboardMeetingsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportDashboardMeetings",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportTaskDetailOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportTaskDetail",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportMeetingDetailOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportMeetingDetail",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportWorkloadOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportWorkload",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportWorkloadPdfOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportWorkloadPdf",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportTaskPdfOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportTaskPdf",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportMeetingPdfOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportMeetingPdf",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportSeasonOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportSeason",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> reportSeasonPdfOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["reporting"],
          'operationId': "reportSeasonPdf",
          'externalDocsUrl': null,
        },
      };

  /// Yönetici dashboard özeti (seçili program).
  @GET('/v1/reports/dashboard')
  Future<DashboardReport> reportDashboard({
    @Extras()
    Map<String, dynamic>? extras = ReportingClient.reportDashboardOpenapiExtras,
  });

  /// Koordinatörlük istatistikleri.
  @GET('/v1/reports/dashboard/coordinatorships')
  Future<HttpResponse<CoordinatorshipStatList>>
  reportDashboardCoordinatorships({
    @Extras()
    Map<String, dynamic>? extras =
        ReportingClient.reportDashboardCoordinatorshipsOpenapiExtras,
  });

  /// Görev dağılımı listesi.
  @GET('/v1/reports/dashboard/tasks')
  Future<HttpResponse<ReportTaskList>> reportDashboardTasks({
    @Extras()
    Map<String, dynamic>? extras =
        ReportingClient.reportDashboardTasksOpenapiExtras,
  });

  /// Toplantı özeti listesi.
  @GET('/v1/reports/dashboard/meetings')
  Future<HttpResponse<ReportMeetingList>> reportDashboardMeetings({
    @Extras()
    Map<String, dynamic>? extras =
        ReportingClient.reportDashboardMeetingsOpenapiExtras,
  });

  /// Görev detay raporu.
  @GET('/v1/reports/tasks/{id}')
  Future<ReportTaskDetail> reportTaskDetail({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        ReportingClient.reportTaskDetailOpenapiExtras,
  });

  /// Toplantı detay raporu.
  @GET('/v1/reports/meetings/{id}')
  Future<ReportMeetingDetail> reportMeetingDetail({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        ReportingClient.reportMeetingDetailOpenapiExtras,
  });

  /// İş yükü raporu (üye ve koordinatörlüğe göre).
  @GET('/v1/reports/workload')
  Future<WorkloadReport> reportWorkload({
    @Extras()
    Map<String, dynamic>? extras = ReportingClient.reportWorkloadOpenapiExtras,
  });

  /// Seçili üyelerin iş yükü PDF'i (boş liste bütün üyeler; dışa aktarım kotası).
  @POST('/v1/reports/workload')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> reportWorkloadPdf({
    @Body() required WorkloadPdfRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        ReportingClient.reportWorkloadPdfOpenapiExtras,
  });

  /// Görev PDF raporu (dışa aktarım kotası).
  @GET('/v1/reports/tasks/{id}/pdf')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> reportTaskPdf({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = ReportingClient.reportTaskPdfOpenapiExtras,
  });

  /// Toplantı PDF raporu (dışa aktarım kotası).
  @GET('/v1/reports/meetings/{id}/pdf')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> reportMeetingPdf({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        ReportingClient.reportMeetingPdfOpenapiExtras,
  });

  /// Dönem raporu (JSON).
  @GET('/v1/reports/season')
  Future<SeasonReport> reportSeason({
    @Extras()
    Map<String, dynamic>? extras = ReportingClient.reportSeasonOpenapiExtras,
  });

  /// Dönem raporu PDF'i (dışa aktarım kotası).
  @GET('/v1/reports/season/pdf')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> reportSeasonPdf({
    @Extras()
    Map<String, dynamic>? extras = ReportingClient.reportSeasonPdfOpenapiExtras,
  });
}
