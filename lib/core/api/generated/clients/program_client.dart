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

  /// Program (dönem) listesi.
  @GET('/v1/programs')
  Future<ProgramList> listPrograms({
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
}
