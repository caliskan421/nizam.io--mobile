// HAM DIO İSTİSNASI (yalnız `chat`): üretilmiş `AssistantClient.assistantChat` imzası
// `Future<String>`'dir — `text/event-stream` gövdesinin tamamını bekler, olayları akış
// sırasında veremez ve iptal edilemez. Bu yüzden sohbet ucu aynı Dio (aynı kapı/kimlik/hata
// halkaları) üzerinden `ResponseType.stream` ile çağrılır. Kapı halkası işlemi gerçek yöntem +
// yoldan çözüp taşınan operationId ile karşılaştırdığı için üretilmiş
// `AssistantClient.assistantChatOpenapiExtras` metaverisi aynen taşınır (S2 program başlığı ve
// CSRF başlığı böylece eklenir); istek gövdesi üretilmiş `AssistantChatRequest`'ten gelir.
// Diğer üç uç üretilmiş istemciyle çağrılır. Ayrıntı:
// docs/yurutme/servis-katmani/envanter-v030.md.
import 'package:dio/dio.dart';

import '../../../core/api/generated/clients/assistant_client.dart';
import '../../../core/api/generated/models/assistant_chat_request.dart';
import '../../../core/api/generated/models/assistant_conversation.dart' as api;
import '../../../core/api/generated/models/assistant_event_done.dart';
import '../../../core/api/generated/models/assistant_event_error.dart';
import '../../../core/api/generated/models/assistant_event_names.dart';
import '../../../core/api/generated/models/assistant_event_sources.dart';
import '../../../core/api/generated/models/assistant_event_text.dart';
import '../../../core/api/generated/models/assistant_event_tool.dart';
import '../../../core/api/generated/models/assistant_event_usage.dart';
import '../../../core/api/generated/models/assistant_event_view.dart';
import '../../../core/api/generated/models/assistant_message.dart' as api;
import '../../../core/domain/page_slice.dart';
import '../../../core/errors/api_error.dart';
import '../../../core/http/sse.dart';
import '../../../core/i18n/generated/client_error_codes.gen.dart';
import '../domain/assistant.dart';
import '../domain/assistant_repository.dart';

/// [AssistantRepository]'nin `/v1/assistant/*` uçlarıyla gerçekleştirmesi. DTO'lar bu katmanda
/// kalır (A1/A2). Hatalar [ApiError]; uç bayrağı kapalıyken (`404 platform.route_not_found`)
/// [AssistantDisabled].
class ApiAssistantRepository implements AssistantRepository {
  /// [dio]: doğrulanmış bağın API istemcisi (program başlığını ara katman ekler).
  ApiAssistantRepository(Dio dio) : _dio = dio, _client = AssistantClient(dio);

  /// Sözleşmedeki sohbet yolu (üretilmiş istemcideki `@POST` ile aynı).
  static const chatPath = '/v1/assistant/chat';

  /// Sözleşmedeki kesilme başlığı.
  static const truncationHeader = 'X-Result-Truncated';

  /// Akışta iki parça arası en uzun bekleme. Sunucu döngüsü en çok 30 sn sürer; ortak
  /// 20 sn'lik okuma süresi model turları arasında erken kesebileceği için akışa özgüdür.
  static const streamIdleTimeout = Duration(seconds: 45);

  final Dio _dio;
  final AssistantClient _client;

  @override
  Stream<AssistantEvent> chat(AssistantQuestion question) async* {
    final cancel = CancelToken();
    try {
      final Response<ResponseBody> response;
      try {
        response = await _dio.post<ResponseBody>(
          chatPath,
          data: AssistantChatRequest(
            soru: question.text,
            sohbetId: question.conversationId,
          ).toJson(),
          cancelToken: cancel,
          options: Options(
            responseType: ResponseType.stream,
            receiveTimeout: streamIdleTimeout,
            headers: {Headers.acceptHeader: 'text/event-stream'},
            // Kapı halkası `extra`'ya yazar; sabit harita kopyalanır.
            extra: Map.of(AssistantClient.assistantChatOpenapiExtras),
          ),
        );
      } on Object catch (e) {
        throw _disabledOr(await streamApiError(e));
      }
      final body = response.data;
      if (body == null) throw ApiError(ClientErrorCode.invalidResponse);
      try {
        await for (final raw in decodeSse(body.stream)) {
          final event = _event(raw);
          if (event == null) continue;
          yield event;
          if (event is AssistantDone || event is AssistantFailure) return;
        }
      } on ApiError {
        rethrow;
      } on DioException catch (e) {
        throw toApiError(e);
      } on FormatException {
        throw ApiError(ClientErrorCode.invalidResponse);
      } on Object {
        throw ApiError(ClientErrorCode.networkError);
      }
      // Akış `bitti`/`hata` olmadan kapandı: sözleşme ihlali (cevap yarım).
      throw ApiError(ClientErrorCode.invalidResponse);
    } finally {
      // Dinleyici bıraktıysa ya da akış bittiyse bağlantı kapatılır (tamamlanmış istekte etkisiz).
      cancel.cancel();
    }
  }

  @override
  Future<PageSlice<AssistantConversation>> listConversations() async {
    final r = await _call(_client.assistantConversations);
    final values = r.response.headers[truncationHeader];
    return PageSlice(
      items: r.data.conversations.map(_conversation).toList(),
      truncated: values != null && values.length == 1 && values[0] == 'true',
    );
  }

  @override
  Future<AssistantConversationDetail> getConversation(
    String conversationId,
  ) async {
    final r = await _call(
      () => _client.assistantConversation(id: conversationId),
    );
    return AssistantConversationDetail(
      conversation: _conversation(r.conversation),
      messages: List.unmodifiable(r.messages.map(_message)),
    );
  }

  @override
  Future<void> deleteConversation(String conversationId) =>
      _call(() => _client.deleteAssistantConversation(id: conversationId));

  static Future<T> _call<T>(Future<T> Function() call) async {
    try {
      return await apiCall(call);
    } on ApiError catch (e) {
      throw _disabledOr(e);
    }
  }

  static Exception _disabledOr(ApiError e) =>
      AssistantDisabled.matches(status: e.status, code: e.code)
      ? AssistantDisabled(requestId: e.requestId)
      : e;

  /// SSE olayını domain olayına çevirir; bilinmeyen olay adı `null` (yok sayılır — yeni
  /// sunucu olayı istemciyi düşürmez). Bilinen olayın gövdesi şemaya uymazsa
  /// `client.invalid_response`.
  static AssistantEvent? _event(SseEvent e) {
    try {
      return switch (e.event) {
        'metin' => AssistantTextChunk(
          AssistantEventText.fromJson(sseJsonObject(e.data)).metin,
        ),
        'arac' => _tool(AssistantEventTool.fromJson(sseJsonObject(e.data))),
        'gorunum' => _view(AssistantEventView.fromJson(sseJsonObject(e.data))),
        'adlar' => _names(AssistantEventNames.fromJson(sseJsonObject(e.data))),
        'kaynaklar' => AssistantSources(
          List.unmodifiable(
            AssistantEventSources.fromJson(sseJsonObject(e.data)).kaynaklar,
          ),
        ),
        'kullanim' => _usage(
          AssistantEventUsage.fromJson(sseJsonObject(e.data)),
        ),
        'bitti' => AssistantDone(
          AssistantEventDone.fromJson(sseJsonObject(e.data)).sohbetId,
        ),
        'hata' => _failure(AssistantEventError.fromJson(sseJsonObject(e.data))),
        _ => null,
      };
    } on ApiError {
      rethrow;
    } on Object {
      throw ApiError(ClientErrorCode.invalidResponse);
    }
  }

  static AssistantToolUse _tool(AssistantEventTool t) => AssistantToolUse(
    tool: AssistantTool.fromWire(t.arac.json),
    label: t.etiket,
  );

  static AssistantViewRequest _view(AssistantEventView v) =>
      AssistantViewRequest(view: v.gorunum, filter: v.filtre as Object?);

  static AssistantNames _names(AssistantEventNames n) => AssistantNames(
    List.unmodifiable(
      n.adlar.entries.map(
        (a) => AssistantAlias(alias: a.key, displayName: a.value),
      ),
    ),
  );

  static AssistantUsage _usage(AssistantEventUsage u) =>
      AssistantUsage(inputTokens: u.girisToken, outputTokens: u.cikisToken);

  /// Sözleşmedeki dört kod dışında bir değer (yeni sunucu kodu) `platform.internal`'a düşer.
  static AssistantFailure _failure(AssistantEventError e) => AssistantFailure(
    code: e.kod.json ?? 'platform.internal',
    message: e.mesaj,
  );

  static AssistantConversation _conversation(api.AssistantConversation c) =>
      AssistantConversation(
        id: c.id,
        title: c.baslik,
        createdAt: c.createdAt,
        updatedAt: c.updatedAt,
      );

  static AssistantMessage _message(api.AssistantMessage m) => AssistantMessage(
    order: m.sira,
    role: switch (m.rol.json) {
      'kullanici' => AssistantMessageRole.user,
      'asistan' => AssistantMessageRole.assistant,
      _ => AssistantMessageRole.unknown,
    },
    content: m.icerik,
    createdAt: m.createdAt,
  );
}
