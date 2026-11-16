// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/audit_entry_list.dart';

part 'audit_client.g.dart';

@RestApi()
abstract class AuditClient {
  factory AuditClient(Dio dio, {String? baseUrl}) = _AuditClient;

  static const Map<String, dynamic> listAuditEntriesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["audit"],
          'operationId': "listAuditEntries",
          'externalDocsUrl': null,
        },
      };

  /// İşlem geçmişi (yalnız şirket yöneticisi; imleçli, (occurred_at, id) azalan; AUDIT-K10). Eylem kodunun görünen adı istemci sözlüğündedir.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  ///
  /// [subjectId] - Yalnız `subject_kind` ile verilir.
  ///
  /// [from] - Dahil alt sınır (RFC 3339).
  ///
  /// [to] - Hariç üst sınır (RFC 3339).
  @GET('/v1/audit/entries')
  Future<AuditEntryList> listAuditEntries({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Query('actor_account_id') String? actorAccountId,
    @Query('subject_kind') String? subjectKind,
    @Query('subject_id') String? subjectId,
    @Query('program_id') String? programId,
    @Query('from') DateTime? from,
    @Query('to') DateTime? to,
    @Extras()
    Map<String, dynamic>? extras = AuditClient.listAuditEntriesOpenapiExtras,
  });
}
