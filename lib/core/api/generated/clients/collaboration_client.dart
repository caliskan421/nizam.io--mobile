// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/agenda_item.dart';
import '../models/agenda_item_request.dart';
import '../models/agenda_list.dart';
import '../models/author.dart';
import '../models/conference_empty_request.dart';
import '../models/conference_result.dart';
import '../models/conference_token.dart';
import '../models/convert_note_request.dart';
import '../models/converted.dart';
import '../models/create_meeting_request.dart';
import '../models/meeting_candidate_list.dart';
import '../models/meeting_created.dart';
import '../models/meeting_detail.dart';
import '../models/meeting_lifecycle_result.dart';
import '../models/meeting_list.dart';
import '../models/meeting_note.dart';
import '../models/meeting_note_list.dart';
import '../models/meeting_revised.dart';
import '../models/note_converted.dart';
import '../models/note_request.dart';
import '../models/participant_request.dart';
import '../models/participant_result.dart';
import '../models/revise_meeting_note_request.dart';
import '../models/sort.dart';
import '../models/update_agenda_item_request.dart';
import '../models/update_meeting_request.dart';
import '../models/when_enum.dart';

part 'collaboration_client.g.dart';

@RestApi()
abstract class CollaborationClient {
  factory CollaborationClient(Dio dio, {String? baseUrl}) =
      _CollaborationClient;

  static const Map<String, dynamic> createMeetingOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "createMeeting",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listMeetingsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "listMeetings",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listDeletedMeetingsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "listDeletedMeetings",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> adminListDeletedMeetingsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "adminListDeletedMeetings",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> restoreMeetingOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "restoreMeeting",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> permanentDeleteMeetingOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "permanentDeleteMeeting",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic>
  listMeetingParticipantCandidatesOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["collaboration"],
      'operationId': "listMeetingParticipantCandidates",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> getMeetingOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["collaboration"],
      'operationId': "getMeeting",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> updateMeetingOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "updateMeeting",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteMeetingOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "deleteMeeting",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> addMeetingParticipantOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "addMeetingParticipant",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> removeMeetingParticipantOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "removeMeetingParticipant",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> startConferenceOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "startConference",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> endConferenceOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "endConference",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> joinConferenceOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "joinConference",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> addAgendaItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "addAgendaItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listAgendaOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["collaboration"],
      'operationId': "listAgenda",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> updateAgendaItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "updateAgendaItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteAgendaItemOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "deleteAgendaItem",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> addMeetingNoteOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "addMeetingNote",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listMeetingNotesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "listMeetingNotes",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> updateMeetingNoteOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "updateMeetingNote",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteMeetingNoteOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "deleteMeetingNote",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> convertNoteToTaskOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "convertNoteToTask",
          'externalDocsUrl': null,
        },
      };

  /// Toplantı açar; ilk gündem aynı transaction, katılımcılar en iyi çabayla.
  ///
  /// İsteğe bağlı `Idempotency-Key` (COLLABORATION-K84; ADR-0027 Ek BE-F3). Verilmiş fakat sınır dışı anahtar 422 `collaboration.input_invalid` (alan `idempotency_key`, kod `collaboration.request_key_invalid`). Anahtar kararı yetki, doğrulama ve geçmiş tarih kuralından ÖNCE verilir: aynı anahtar + aynı istek 200 ile ilk toplantının bugünkü temsilini (çağıranın güncel görme yetkisiyle) döndürür; `failed_participants` istekteki katılımcılardan şu an katılımcı olmayanlardır, `side_effects` sıfırdır (koordinatör mesajı, olay, bildirim ve audit yeniden üretilmez). Aynı anahtar farklı istekle (geçersiz gövde dahil) 409 `collaboration.idempotency_key_reused`. İlk toplantı yumuşak silinmişse tekrar 404 `collaboration.meeting_not_found` (geri yüklenince yine 200); kalıcı silinmişse anahtar satırla gitmiştir ve istek yeni toplantı açar.
  ///
  /// [idempotencyKey] - İsteğe bağlı işlem anahtarı (ADR-0027 kalıbı). Verilmezse uç anahtarsız davranır (mevcut davranış). Verilirse (boş ya da yalnız boşluk dahil) kırpılmış uzunluk 22–200 bayttır, aksi 422 `<mod>.input_invalid` (alan `idempotency_key`, kod `<mod>.invalid_request_key`). Anahtar aktör + uç tablosu kapsamındadır ve kaynak satırında yaşar. Aynı anahtar + aynı normalize istek ilk kaynağın bugünkü temsilini 200 ile döndürür; farklı istek 409 `<mod>.idempotency_key_reused`; aynı anahtarlı eşzamanlı istek ilk isteğin bitişini bekler ve tekrar olarak döner.
  @POST('/v1/meetings')
  Future<MeetingCreated> createMeeting({
    @Body() required CreateMeetingRequest body,
    @Header('Idempotency-Key') String? idempotencyKey,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.createMeetingOpenapiExtras,
  });

  /// Görünür toplantılar (imleçli), satır özetiyle.
  ///
  /// Satır başına `summary` (COLLABORATION-K70) sayfa başına sabit sayıda sorguyla okunur. Süzgeçler (COLLABORATION-K71) görünürlük kuralına (COLLABORATION-K19) eklenir: yalnız daraltır, görünmeyen toplantıyı açmaz; görünmeyen ya da olmayan departman boş sayfa döner. Varsayılan sıra (parametresiz istek) `created_at`, `id` en yeni öncedir ve değişmez. `when` ve `sort` (COLLABORATION-K79) sekmeyi ve sırayı seçer; tarih sıraları `(meeting_date, id)` anahtarıyla kararlıdır. İmleç aynı süzgeç, sekme ve sırayla kullanılır; başka sıranın imleci 422 `collaboration.invalid_cursor` alır. Cevap `total` ve `tab_counts` taşır (imleçten bağımsız, her sayfada hesaplanır).
  ///
  /// [when] - Zaman sekmesi (COLLABORATION-K79). Sınır kurulum saat diliminde bugünün gece yarısıdır (COLLABORATION-K17 ile aynı an): `upcoming` toplantı anı sınırda ya da sonrası (bugün saati geçmiş toplantı dahil), `past` sınırdan önce. `from`/`to` ile birlikte yalnız daraltır. Boş ya da yalnız boşluk değer sekme yok; başka değer 422 `collaboration.input_invalid` (alan `when`).
  ///
  /// [sort] - Sıra (COLLABORATION-K79). Verilmezse `when=upcoming` için `meeting_date_asc`, `when=past` için `meeting_date_desc`, `when` yoksa `created_at_desc`. Açık değer sekmenin varsayılanını ezer. Başka değer 422 `collaboration.input_invalid` (alan `sort`).
  ///
  /// [departmentId] - Toplantının sahip ya da bağlı departmanı. Boş ya da yalnız boşluk değer süzgeç yok sayılır.
  ///
  /// [from] - Toplantı günü alt sınırı (dahil), `YYYY-MM-DD`, kurulum saat diliminin takvim günü (COLLABORATION-K17 kuralı). Başka biçim 422 `collaboration.input_invalid` (alan `from`).
  ///
  /// [to] - Toplantı günü üst sınırı (dahil), `YYYY-MM-DD`, kurulum saat dilimi. Başka biçim ya da `from`'dan önceki gün 422 `collaboration.input_invalid` (alan `to`).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/meetings')
  Future<MeetingList> listMeetings({
    @Query('when') WhenEnum? whenEnum,
    @Query('sort') Sort? sort,
    @Query('department_id') String? departmentId,
    @Query('from') DateTime? from,
    @Query('to') DateTime? to,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.listMeetingsOpenapiExtras,
  });

  /// Silinmiş toplantılar (imleçli; yalnız yönetici).
  ///
  /// Sıra silinme anı azalan (`deleted_at`, eşitlikte `meeting_id`); imleç bu sıranın anahtarıdır.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/meetings/deleted')
  Future<MeetingList> listDeletedMeetings({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.listDeletedMeetingsOpenapiExtras,
  });

  /// Silinmiş toplantılar — yönetici yaşam döngüsü yolu (aynı use-case).
  ///
  /// Sıra silinme anı azalan (`deleted_at`, eşitlikte `meeting_id`); imleç bu sıranın anahtarıdır.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/admin/deleted/meetings')
  Future<MeetingList> adminListDeletedMeetings({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.adminListDeletedMeetingsOpenapiExtras,
  });

  /// Silinmiş toplantıyı geri yükler.
  @PATCH('/v1/admin/restore/meetings/{id}')
  Future<MeetingLifecycleResult> restoreMeeting({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.restoreMeetingOpenapiExtras,
  });

  /// Silinmiş toplantıyı kalıcı siler.
  @DELETE('/v1/admin/permanent/meetings/{id}')
  Future<MeetingLifecycleResult> permanentDeleteMeeting({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.permanentDeleteMeetingOpenapiExtras,
  });

  /// Katılımcı adayları (imleçli): programda ekip satırı olan canlı hesaplar.
  ///
  /// Toplantı formunun kişi seçicisi (COLLABORATION-K83). `meeting_id` verilmişse yetki katılımcı eklemeyle aynı karardır (COLLABORATION-K21, K74): toplantıyı görmeyen 404 `collaboration.meeting_not_found` (başka programın toplantısı dahil), gören fakat katılımcı yönetemeyen 403 `collaboration.not_authorized` (`coordinatorship` kipinde koordinatör rolü olmayan yönetici dahil). `meeting_id` yoksa (kuruluş formu) yönetici ya da seçili programda koordinatörlüğü olan çağırır; yalnız üye 403. Küme seçili programda canlı departmanlı ekip satırı olan, silinmemiş hesaplardır; ekip satırı olmayan şirket yöneticisi eklenebilir olduğu hâlde listede yoktur (GAP-223). Sıra `account_id` artandır (istemci ada göre yerelde sıralar ve arar); imleç son okunan kimliktir: silinmiş hesap atlandığında sayfa `limit`'ten kısa (boş bile) dönüp `next_cursor` taşıyabilir, istemci `next_cursor` boşalana dek ilerler.
  ///
  /// [meetingId] - Var olan toplantı (katılımcı ekleme formu). Boş ya da yalnız boşluk değer yok sayılır (kuruluş formu).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/meetings/participant-candidates')
  Future<MeetingCandidateList> listMeetingParticipantCandidates({
    @Query('meeting_id') String? meetingId,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.listMeetingParticipantCandidatesOpenapiExtras,
  });

  /// Toplantı detayı: katılımcılar, gündem, notların ilk sayfası.
  @GET('/v1/meetings/{id}')
  Future<MeetingDetail> getMeeting({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = CollaborationClient.getMeetingOpenapiExtras,
  });

  /// Toplantı günceller (departman seti yalnız yönetici yolunda).
  @PATCH('/v1/meetings/{id}')
  Future<MeetingRevised> updateMeeting({
    @Path('id') required String id,
    @Body() required UpdateMeetingRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.updateMeetingOpenapiExtras,
  });

  /// Toplantıyı yumuşak siler.
  @DELETE('/v1/meetings/{id}')
  Future<void> deleteMeeting({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.deleteMeetingOpenapiExtras,
  });

  /// Katılımcı ekler.
  ///
  /// İsteğe bağlı `Idempotency-Key` (COLLABORATION-K84). Verilmiş fakat sınır dışı anahtar 422 `collaboration.input_invalid` (alan `idempotency_key`, kod `collaboration.request_key_invalid`). Anahtar katılım satırında değil ayrı makbuzdadır: aynı anahtar + aynı istek 200 ile ilk cevabı döndürür ve kişiyi YENİDEN EKLEMEZ (arada çıkarılmışsa çıkarılmış kalır); tekrar toplantıyı güncel görme yetkisi ister. Farklı istek 409 `collaboration.idempotency_key_reused`. Başka anahtarla zaten katılımcı olanı eklemek 422 `collaboration.input_invalid`'dir.
  ///
  /// [idempotencyKey] - İsteğe bağlı işlem anahtarı (ADR-0027 kalıbı). Verilmezse uç anahtarsız davranır (mevcut davranış). Verilirse (boş ya da yalnız boşluk dahil) kırpılmış uzunluk 22–200 bayttır, aksi 422 `<mod>.input_invalid` (alan `idempotency_key`, kod `<mod>.invalid_request_key`). Anahtar aktör + uç tablosu kapsamındadır ve kaynak satırında yaşar. Aynı anahtar + aynı normalize istek ilk kaynağın bugünkü temsilini 200 ile döndürür; farklı istek 409 `<mod>.idempotency_key_reused`; aynı anahtarlı eşzamanlı istek ilk isteğin bitişini bekler ve tekrar olarak döner.
  @POST('/v1/meetings/{id}/participants')
  Future<ParticipantResult> addMeetingParticipant({
    @Path('id') required String id,
    @Body() required ParticipantRequest body,
    @Header('Idempotency-Key') String? idempotencyKey,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.addMeetingParticipantOpenapiExtras,
  });

  /// Katılımcı çıkarır.
  @DELETE('/v1/meetings/{id}/participants/{userId}')
  Future<void> removeMeetingParticipant({
    @Path('id') required String id,
    @Path('userId') required String userId,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.removeMeetingParticipantOpenapiExtras,
  });

  /// Toplantıya bağlı görüntülü konferansı başlatır (yönetici; `coordinatorship` kipinde bağlı departmanın koordinatörü, `person` kipinde sahip departmanı hâlâ koordine eden oluşturan). Aktif konferans varsa yeni satır açılmaz ve 200 döner.
  @POST('/v1/meetings/{id}/conference')
  Future<ConferenceResult> startConference({
    @Path('id') required String id,
    @Body() ConferenceEmptyRequest? body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.startConferenceOpenapiExtras,
  });

  /// Konferansı bitirir. Aktif konferans yoksa ya da sağlayıcı odayı kapatamazsa da 204 döner.
  @DELETE('/v1/meetings/{id}/conference')
  Future<void> endConference({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.endConferenceOpenapiExtras,
  });

  /// Konferansa katılım token'ı üretir (toplantıyı gören her rol; hesap başına dakikada 30). Yazma izninden geçmez.
  @POST('/v1/meetings/{id}/conference/token')
  Future<ConferenceToken> joinConference({
    @Path('id') required String id,
    @Body() ConferenceEmptyRequest? body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.joinConferenceOpenapiExtras,
  });

  /// Gündem maddesi ekler (en çok 50).
  ///
  /// İsteğe bağlı `Idempotency-Key` (COLLABORATION-K84). Verilmiş fakat sınır dışı anahtar 422 `collaboration.input_invalid` (alan `idempotency_key`, kod `collaboration.request_key_invalid`). Anahtar kararı yetki ve doğrulamadan önce ve toplantı kilidi altında 50 tavanından önce verilir: aynı anahtar + aynı istek 200 ile maddenin bugünkü temsilini döndürür (çağıranın toplantıyı güncel görme yetkisiyle; dolu toplantıda da 422 değil); farklı istek 409 `collaboration.idempotency_key_reused`. Madde kalıcı silinmişse anahtar satırla gitmiştir ve istek yeni madde açar.
  ///
  /// [idempotencyKey] - İsteğe bağlı işlem anahtarı (ADR-0027 kalıbı). Verilmezse uç anahtarsız davranır (mevcut davranış). Verilirse (boş ya da yalnız boşluk dahil) kırpılmış uzunluk 22–200 bayttır, aksi 422 `<mod>.input_invalid` (alan `idempotency_key`, kod `<mod>.invalid_request_key`). Anahtar aktör + uç tablosu kapsamındadır ve kaynak satırında yaşar. Aynı anahtar + aynı normalize istek ilk kaynağın bugünkü temsilini 200 ile döndürür; farklı istek 409 `<mod>.idempotency_key_reused`; aynı anahtarlı eşzamanlı istek ilk isteğin bitişini bekler ve tekrar olarak döner.
  @POST('/v1/meetings/{id}/agenda')
  Future<AgendaItem> addAgendaItem({
    @Path('id') required String id,
    @Body() required AgendaItemRequest body,
    @Header('Idempotency-Key') String? idempotencyKey,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.addAgendaItemOpenapiExtras,
  });

  /// Gündem maddeleri (sıralı; tek sayfa).
  ///
  /// Sıra `sort_order` artan (eşitlikte ekleme anı); toplantı başına en çok 50 madde olduğundan tek sayfadır.
  @GET('/v1/meetings/{id}/agenda')
  Future<AgendaList> listAgenda({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras = CollaborationClient.listAgendaOpenapiExtras,
  });

  /// Gündem maddesinin başlığını ve/veya işaretini günceller.
  @PATCH('/v1/meeting-agenda/{itemId}')
  Future<AgendaItem> updateAgendaItem({
    @Path('itemId') required String itemId,
    @Body() required UpdateAgendaItemRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.updateAgendaItemOpenapiExtras,
  });

  /// Gündem maddesini kalıcı siler.
  @DELETE('/v1/meeting-agenda/{itemId}')
  Future<void> deleteAgendaItem({
    @Path('itemId') required String itemId,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.deleteAgendaItemOpenapiExtras,
  });

  /// Toplantı notu ekler (üye için dakikada 20 not).
  ///
  /// [idempotencyKey] - İstemcinin ürettiği opak işlem anahtarı (en az 128 bit; ör. base64url 22 karakter; ADR-0027). Uzunluk baştaki/sondaki boşluk kırpıldıktan sonra bayt olarak 22–200'dür. Eksik ya da sınır dışı anahtar 422; program aktarımında `program.transfer_input_invalid`, oluşturma uçlarında modülün `<mod>.input_invalid` zarfı (alan `idempotency_key`, kod `<mod>.request_key_required` / `<mod>.request_key_invalid`). Aynı anahtar + aynı istek ilk sonucu döndürür (oluşturmada 200 + kaynağın bugünkü temsili, güncel görme yetkisiyle); farklı istek 409 `<mod>.idempotency_key_reused`. Anahtar aktör + uç tablosu kapsamındadır; sunucu kaynağı yaşadıkça tutar (kalıcı silinen kaynakta anahtar da gider).
  @POST('/v1/meetings/{id}/notes')
  Future<MeetingNote> addMeetingNote({
    @Path('id') required String id,
    @Header('Idempotency-Key') required String idempotencyKey,
    @Body() required NoteRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.addMeetingNoteOpenapiExtras,
  });

  /// Toplantı notları (imleçli).
  ///
  /// Toplantıyı gören her rol bütün notları görür. `converted` ve `author` süzgeçleri AND ile birleşir; sıra (`created_at`, eski önce) ve imleç süzgeçten bağımsızdır. Zarf süzülmüş kümenin `total`'ını ve süzgeçten bağımsız `counts`'u taşır (COLLABORATION-K80). Eşitlikte sıra `note_id`'dir; imleç bu sıranın anahtarıdır.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder; audit de 1–200 dışını ve sayı olmayanı 422 `audit.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  ///
  /// [converted] - `true` yalnız göreve dönüşmüş, `false` yalnız dönüşmemiş notlar. Başka değer 422 `collaboration.input_invalid` (alan `converted`).
  ///
  /// [author] - `me` yalnız çağıranın yazdığı notlar. Başka değer 422 `collaboration.input_invalid` (alan `author`).
  @GET('/v1/meetings/{id}/notes')
  Future<MeetingNoteList> listMeetingNotes({
    @Path('id') required String id,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Query('converted') Converted? converted,
    @Query('author') Author? author,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.listMeetingNotesOpenapiExtras,
  });

  /// Not içeriğini günceller (sahiplik matrisi).
  @PATCH('/v1/meeting-notes/{noteId}')
  Future<MeetingNote> updateMeetingNote({
    @Path('noteId') required String noteId,
    @Body() required ReviseMeetingNoteRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.updateMeetingNoteOpenapiExtras,
  });

  /// Notu kalıcı siler (sahiplik matrisi).
  ///
  /// Satır silinir, iz audit'te kalır (COLLABORATION-K75); geri yükleme yoktur, "geri al" istemcide silme gönderilmeden önce yapılır. İkinci silme 404 `collaboration.note_not_found` alır. Notun işlem anahtarı satırla gider: aynı anahtarla tekrar ekleme yeni not açar (201; ADR-0027 Ek F63). Dönüşmüş notun görevi etkilenmez.
  @DELETE('/v1/meeting-notes/{noteId}')
  Future<void> deleteMeetingNote({
    @Path('noteId') required String noteId,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.deleteMeetingNoteOpenapiExtras,
  });

  /// Notu göreve dönüştürür (tek transaction).
  @POST('/v1/meeting-notes/{noteId}/convert-to-task')
  Future<NoteConverted> convertNoteToTask({
    @Path('noteId') required String noteId,
    @Body() required ConvertNoteRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.convertNoteToTaskOpenapiExtras,
  });
}
