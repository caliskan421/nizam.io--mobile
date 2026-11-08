// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/agenda_item.dart';
import '../models/agenda_item_request.dart';
import '../models/agenda_list.dart';
import '../models/conference_empty_request.dart';
import '../models/conference_result.dart';
import '../models/conference_token.dart';
import '../models/convert_note_request.dart';
import '../models/create_meeting_request.dart';
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
import '../models/update_agenda_item_request.dart';
import '../models/update_meeting_request.dart';

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
  @POST('/v1/meetings')
  Future<MeetingCreated> createMeeting({
    @Body() required CreateMeetingRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.createMeetingOpenapiExtras,
  });

  /// Görünür toplantılar (imleçli).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/meetings')
  Future<MeetingList> listMeetings({
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.listMeetingsOpenapiExtras,
  });

  /// Silinmiş toplantılar (imleçli; yalnız yönetici).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
  @POST('/v1/meetings/{id}/participants')
  Future<ParticipantResult> addMeetingParticipant({
    @Path('id') required String id,
    @Body() required ParticipantRequest body,
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

  /// Toplantıya bağlı görüntülü konferansı başlatır (yönetici ve bağlı departmanın koordinatörü). Aktif konferans varsa yeni satır açılmaz ve 200 döner.
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
  @POST('/v1/meetings/{id}/agenda')
  Future<AgendaItem> addAgendaItem({
    @Path('id') required String id,
    @Body() required AgendaItemRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.addAgendaItemOpenapiExtras,
  });

  /// Gündem maddeleri (sıralı; tek sayfa).
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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration ve messaging 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` / `messaging.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/meetings/{id}/notes')
  Future<MeetingNoteList> listMeetingNotes({
    @Path('id') required String id,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
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

  /// Notu yumuşak siler (sahiplik matrisi).
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
