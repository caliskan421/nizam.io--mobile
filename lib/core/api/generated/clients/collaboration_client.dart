// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/agenda_item.dart';
import '../models/agenda_item_request.dart';
import '../models/agenda_list.dart';
import '../models/convert_note_request.dart';
import '../models/count_result.dart';
import '../models/create_meeting_request.dart';
import '../models/filter.dart';
import '../models/meeting_created.dart';
import '../models/meeting_detail.dart';
import '../models/meeting_lifecycle_result.dart';
import '../models/meeting_list.dart';
import '../models/meeting_note.dart';
import '../models/meeting_note_list.dart';
import '../models/meeting_revised.dart';
import '../models/message_list.dart';
import '../models/note_converted.dart';
import '../models/note_request.dart';
import '../models/participant_request.dart';
import '../models/participant_result.dart';
import '../models/recipient_groups.dart';
import '../models/send_message_request.dart';
import '../models/sent_message.dart';
import '../models/update_agenda_item_request.dart';
import '../models/update_meeting_request.dart';

part 'collaboration_client.g.dart';

@RestApi()
abstract class CollaborationClient {
  factory CollaborationClient(Dio dio, {String? baseUrl}) =
      _CollaborationClient;

  static const Map<String, dynamic> sendMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "sendMessage",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listMessagesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "listMessages",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> countUnreadMessagesOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "countUnreadMessages",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> listMessageRecipientsOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "listMessageRecipients",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> markMessageReadOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "markMessageRead",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> deleteMessageOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["collaboration"],
          'operationId': "deleteMessage",
          'externalDocsUrl': null,
        },
      };
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

  /// Mesaj gönderir (gönderim matrisi use-case sınırında).
  @POST('/v1/messages')
  Future<SentMessage> sendMessage({
    @Body() required SendMessageRequest body,
    @Extras()
    Map<String, dynamic>? extras = CollaborationClient.sendMessageOpenapiExtras,
  });

  /// Gelen/giden mesajlar (imleçli).
  ///
  /// [filter] - `inbox` (varsayılan) ya da `sent`; başka değer 422 `collaboration.input_invalid`.
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
  ///
  /// [cursor] - Opak imleç; önceki sayfanın `next_cursor` değeri.
  @GET('/v1/messages')
  Future<MessageList> listMessages({
    @Query('filter') Filter? filter,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.listMessagesOpenapiExtras,
  });

  /// Seçili programdaki okunmamış gelen mesaj sayısı.
  @GET('/v1/messages/unread-count')
  Future<CountResult> countUnreadMessages({
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.countUnreadMessagesOpenapiExtras,
  });

  /// Alıcı adayları (gruplu; yöneticiye kapalı).
  @GET('/v1/messages/recipients')
  Future<RecipientGroups> listMessageRecipients({
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.listMessageRecipientsOpenapiExtras,
  });

  /// Mesajı okundu işaretler (yalnız alıcı; idempotent).
  @POST('/v1/messages/{id}/read')
  Future<void> markMessageRead({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.markMessageReadOpenapiExtras,
  });

  /// Mesajı kalıcı siler (gönderen her zaman; alıcı okuduktan sonra).
  @DELETE('/v1/messages/{id}')
  Future<void> deleteMessage({
    @Path('id') required String id,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.deleteMessageOpenapiExtras,
  });

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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
  @POST('/v1/meetings/{id}/notes')
  Future<MeetingNote> addMeetingNote({
    @Path('id') required String id,
    @Body() required NoteRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        CollaborationClient.addMeetingNoteOpenapiExtras,
  });

  /// Toplantı notları (imleçli).
  ///
  /// [limit] - Sayfa boyu. Bütün imleçli listelerde varsayılan 50, üst sınır 200. Sınır dışı değer modüle göre farklı işlenir: organization (kullanıcılar, silinmiş departman/hesap), program (aktarım geçmişi) ve work (görevler, silinmiş görevler) 200 üstünü sessizce 200 yapar; organization ve program 0, negatif ya da sayı olmayan değeri 422 ile reddeder, work 0 ve negatifi varsayılana çeker, sayı olmayanı 422 ile reddeder. collaboration 0 değerini varsayılan sayar; negatif, 200 üstü ve sayı olmayan değer 422 `collaboration.input_invalid` alır. notifications 1–200 dışını ve sayı olmayan değeri 422 `notifications.input_invalid` ile reddeder.
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
    @Body() required NoteRequest body,
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
