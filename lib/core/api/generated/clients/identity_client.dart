// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/change_password_request.dart';
import '../models/change_password_response.dart';
import '../models/download_ticket_request.dart';
import '../models/download_ticket_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/me_response.dart';
import '../models/refresh_request.dart';
import '../models/refresh_response.dart';

part 'identity_client.g.dart';

@RestApi()
abstract class IdentityClient {
  factory IdentityClient(Dio dio, {String? baseUrl}) = _IdentityClient;

  static const Map<String, dynamic> loginOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["identity"],
      'operationId': "login",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> refreshOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["identity"],
      'operationId': "refresh",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> logoutOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["identity"],
      'operationId': "logout",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> meOpenapiExtras = <String, dynamic>{
    'openapi': <String, dynamic>{
      'tags': <String>["identity"],
      'operationId': "me",
      'externalDocsUrl': null,
    },
  };
  static const Map<String, dynamic> changePasswordOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["identity"],
          'operationId': "changePassword",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> issueDownloadTicketOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["identity"],
          'operationId': "issueDownloadTicket",
          'externalDocsUrl': null,
        },
      };
  static const Map<String, dynamic> redeemDownloadTicketOpenapiExtras =
      <String, dynamic>{
        'openapi': <String, dynamic>{
          'tags': <String>["identity"],
          'operationId': "redeemDownloadTicket",
          'externalDocsUrl': null,
        },
      };

  /// Giriş. Web: gövdede token + HttpOnly yenileme çerezi; mobil (X-Nizamio-Client: mobile): access + refresh gövdede.
  @POST('/v1/auth/login')
  Future<LoginResponse> login({
    @Body() required LoginRequest body,
    @Extras() Map<String, dynamic>? extras = IdentityClient.loginOpenapiExtras,
  });

  /// Yenileme ve rotasyon. Mobil belirteç gövdede; web belirteci çerezde (gövde {}).
  @POST('/v1/auth/refresh')
  Future<RefreshResponse> refresh({
    @Body() required RefreshRequest body,
    @Extras()
    Map<String, dynamic>? extras = IdentityClient.refreshOpenapiExtras,
  });

  /// Oturumu (ve soyunu) kapatır; web yenileme çerezini siler.
  @POST('/v1/auth/logout')
  Future<void> logout({
    @Extras() Map<String, dynamic>? extras = IdentityClient.logoutOpenapiExtras,
  });

  /// Oturumdaki hesabın kimliği.
  @GET('/v1/me')
  Future<MeResponse> me({
    @Extras() Map<String, dynamic>? extras = IdentityClient.meOpenapiExtras,
  });

  /// Parola değiştirme; diğer oturumlar düşer.
  @POST('/v1/auth/password')
  Future<ChangePasswordResponse> changePassword({
    @Body() required ChangePasswordRequest body,
    @Extras()
    Map<String, dynamic>? extras = IdentityClient.changePasswordOpenapiExtras,
  });

  /// İndirme bileti üretir (tarayıcı/indirme yöneticisi için; ADR-0013).
  ///
  /// Yetki tüketimde, hedef ucun kendi kuralıyla verilir. Kapsam başlıkları verilirse bilete yazılır ve tüketimde hedefe taşınır. Oturum başına en çok 16 açık bilet.
  @POST('/v1/download-tickets')
  Future<DownloadTicketResponse> issueDownloadTicket({
    @Body() required DownloadTicketRequest body,
    @Extras()
    Map<String, dynamic>? extras =
        IdentityClient.issueDownloadTicketOpenapiExtras,
  });

  /// İndirme biletini tüketir ve hedef isteği bilet sahibinin kimliğiyle yürütür.
  ///
  /// Kimlik `Authorization` başlığından değil biletten gelir (gönderilen başlık yok sayılır). Başarıda gövde, Content-Type ve Content-Disposition hedef uçtandır; hedefin kendi hata kodları (403/404/422/429/503) da dönebilir. Yanıt her durumda `Referrer-Policy: no-referrer` ve `Cache-Control: no-store` taşır.
  @GET('/v1/downloads/{ticket}')
  Future<void> redeemDownloadTicket({
    @Path('ticket') required String ticket,
    @Extras()
    Map<String, dynamic>? extras =
        IdentityClient.redeemDownloadTicketOpenapiExtras,
  });
}
