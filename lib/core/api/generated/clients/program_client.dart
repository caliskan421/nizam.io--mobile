// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_program_request.dart';
import '../models/delete_program_request.dart';
import '../models/link_department_request.dart';
import '../models/program.dart';
import '../models/program_department_link.dart';
import '../models/program_list.dart';
import '../models/program_reset_result.dart';
import '../models/reset_program_request.dart';
import '../models/transfer_history.dart';
import '../models/transfer_history_item.dart';
import '../models/transfer_preview.dart';
import '../models/transfer_preview_request.dart';
import '../models/transfer_request.dart';
import '../models/transfer_result.dart';
import '../models/update_program_request.dart';

part 'program_client.g.dart';

@RestApi()
abstract class ProgramClient {
  factory ProgramClient(Dio dio, {String? baseUrl}) = _ProgramClient;

  static const Map<String, dynamic> listProgramsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "listPrograms",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> createProgramOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "createProgram",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateProgramOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "updateProgram",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteProgramOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "deleteProgram",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> readProgramOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "readProgram",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> linkDepartmentOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "linkDepartment",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> resetProgramOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "resetProgram",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> previewTransferOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "previewTransfer",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> transferWorkItemsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "transferWorkItems",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listTransfersOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "listTransfers",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> readTransferOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["program"],
          'operationId': "readTransfer",
          'externalDocsUrl': null,
        },
      };

  /// Program (dönem) listesi.
  @GET('/v1/programs')
  Future<HttpResponse<ProgramList>> listPrograms({
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.listProgramsOpenapiExtras,
  });

  /// Program oluşturur; aynı ad varsa mevcut döner (200).
  @POST('/v1/programs')
  Future<Program> createProgram({
    @Body() required CreateProgramRequest body,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.createProgramOpenapiExtras,
  });

  /// Program günceller.
  @PATCH('/v1/programs/{id}')
  Future<Program> updateProgram({
    @Path('id') required String id,
    @Body() required UpdateProgramRequest body,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.updateProgramOpenapiExtras,
  });

  /// Programı siler; parola yeniden doğrulanır.
  @DELETE('/v1/programs/{id}')
  Future<void> deleteProgram({
    @Path('id') required String id,
    @Body() required DeleteProgramRequest body,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.deleteProgramOpenapiExtras,
  });

  /// Kapsamdaki program.
  @GET('/v1/program')
  Future<Program> readProgram({
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.readProgramOpenapiExtras,
  });

  /// Departmanı kapsamdaki programa bağlar.
  @POST('/v1/program/departments')
  Future<ProgramDepartmentLink> linkDepartment({
    @Body() required LinkDepartmentRequest body,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.linkDepartmentOpenapiExtras,
  });

  /// Dönem sıfırlama: program ve katılım bağları kalır, dönem içeriği silinir (parola yeniden doğrulanır).
  @POST('/v1/programs/{id}/reset')
  Future<ProgramResetResult> resetProgram({
    @Path('id') required String id,
    @Body() required ResetProgramRequest body,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.resetProgramOpenapiExtras,
  });

  /// Aktarım ön izlemesi (salt okunur; hız sınırlı).
  @POST('/v1/program-transfers/preview')
  Future<TransferPreview> previewTransfer({
    @Body() required TransferPreviewRequest body,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.previewTransferOpenapiExtras,
  });

  /// Programlar arası görev aktarımı ya da ters aktarım (hep ya da hiç; hız sınırlı). Aynı anahtar + aynı gövde ilk sonucu 200 ile tekrarlar.
  ///
  /// [idempotencyKey] - İstemcinin ürettiği tekrar anahtarı; aynı anahtar + aynı gövde ilk sonucu döndürür, farklı gövde 409 program.idempotency_key_reused.
  @POST('/v1/program-transfers')
  Future<TransferResult> transferWorkItems({
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required TransferRequest body,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.transferWorkItemsOpenapiExtras,
  });

  /// Aktarım geçmişi (imleçli).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/program-transfers')
  Future<TransferHistory> listTransfers({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.listTransfersOpenapiExtras,
  });

  /// Tek aktarım kaydı.
  @GET('/v1/program-transfers/{id}')
  Future<TransferHistoryItem> readTransfer({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = ProgramClient.readTransferOpenapiExtras,
  });
}
