import 'package:meta/meta.dart';

// YZ asistanı domain varlıkları (`/v1/assistant/*`, `v0.3.0-api`). Asistan salt okunurdur;
// kişiler akışta `Üye-N` takma adıyla görünür, [AssistantNames] yalnız o soruda görülen takma
// adların görünen adını taşır (e-posta ve hesap kimliği yok).

/// Mesajın yazarı (sunucu `kullanici`, `asistan`).
enum AssistantMessageRole { user, assistant, unknown }

/// Asistanın çağırdığı salt okunur araç (katalog v1). Sunucu adı [wire]'dadır.
enum AssistantTool {
  today('bugun'),
  myScope('kapsamim'),
  taskDistribution('gorev_dagilimi'),
  taskList('gorev_listesi'),
  workload('is_yuku'),
  meetingSummary('toplanti_ozeti'),
  seasonSummary('sezon_ozeti'),
  show('goster'),
  unknown(null);

  const AssistantTool(this.wire);

  /// Sunucu adı; [unknown] için `null`.
  final String? wire;

  /// Sunucu adından; bilinmeyen/boş → [unknown].
  static AssistantTool fromWire(String? wire) => values.firstWhere(
    (t) => t.wire != null && t.wire == wire,
    orElse: () => unknown,
  );
}

/// Sohbet (yalnız sahibine ve açıldığı programa aittir).
@immutable
final class AssistantConversation {
  const AssistantConversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Sohbetteki görünür mesaj (kullanıcı sorusu ya da asistan cevabı).
@immutable
final class AssistantMessage {
  const AssistantMessage({
    required this.order,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  /// Sohbet içi sıra (`sira`).
  final int order;
  final AssistantMessageRole role;
  final String content;
  final DateTime createdAt;
}

/// Sohbet ve görünür mesajları. Geçmişte gerçek ad eşlemesi yoktur (yalnız canlı akışta).
@immutable
final class AssistantConversationDetail {
  const AssistantConversationDetail({
    required this.conversation,
    required this.messages,
  });

  final AssistantConversation conversation;
  final List<AssistantMessage> messages;
}

/// Soru girdisi.
@immutable
final class AssistantQuestion {
  const AssistantQuestion({required this.text, this.conversationId});

  /// Soru metni (boş olamaz; uzunluk sınırı sunucu kuralıdır).
  final String text;

  /// Devam ettirilecek sohbet; `null` → yeni sohbet açılır.
  final String? conversationId;
}

/// `takma ad → görünen ad` çifti.
@immutable
final class AssistantAlias {
  const AssistantAlias({required this.alias, required this.displayName});

  /// `Üye-N`.
  final String alias;
  final String displayName;
}

/// Sohbet akışının (`text/event-stream`) bir olayı. Başarılı akış [AssistantDone] ile, akış
/// başladıktan sonra doğan hata tek [AssistantFailure] ile biter (ikisi birlikte gelmez).
/// Sıra: [AssistantTextChunk] parçaları ile [AssistantToolUse]/[AssistantViewRequest]
/// dönüşümlü; başarıda kapanış [AssistantNames] (varsa), [AssistantSources],
/// [AssistantUsage], [AssistantDone].
@immutable
sealed class AssistantEvent {
  const AssistantEvent();
}

/// `metin` — cevap metninin bir parçası (parçalar sırayla birleştirilir).
final class AssistantTextChunk extends AssistantEvent {
  const AssistantTextChunk(this.text);

  final String text;
}

/// `arac` — asistan bir aracı çağırıyor.
final class AssistantToolUse extends AssistantEvent {
  const AssistantToolUse({required this.tool, required this.label});

  final AssistantTool tool;

  /// Arayüzde gösterilecek kısa metin.
  final String label;
}

/// `gorunum` — asistan bir görünüm açılmasını öneriyor. Veri taşımaz: istemci [view]'u rotaya
/// çevirir ve veriyi normal API'den kendi belirteciyle çeker.
final class AssistantViewRequest extends AssistantEvent {
  const AssistantViewRequest({required this.view, required this.filter});

  /// Katalogdaki görünüm adı.
  final String view;

  /// Çözümlenmiş tipli süzgeç (sunucu JSON değeri olduğu gibi; şeması görünüme bağlıdır).
  final Object? filter;
}

/// `adlar` — bu soruda görülen takma adların görünen adları.
final class AssistantNames extends AssistantEvent {
  const AssistantNames(this.aliases);

  final List<AssistantAlias> aliases;
}

/// `kaynaklar` — cevabın dayandığı araçlar.
final class AssistantSources extends AssistantEvent {
  const AssistantSources(this.tools);

  /// Sunucunun verdiği araç adları (bilinmeyen ad da korunur; [AssistantTool.fromWire]).
  final List<String> tools;
}

/// `kullanim` — token kullanımı.
final class AssistantUsage extends AssistantEvent {
  const AssistantUsage({required this.inputTokens, required this.outputTokens});

  final int inputTokens;
  final int outputTokens;
}

/// `bitti` — başarılı son olay.
final class AssistantDone extends AssistantEvent {
  const AssistantDone(this.conversationId);

  /// Soru bu sohbete yazıldı (yeni sohbetse yeni kimlik).
  final String conversationId;
}

/// `hata` — akış başladıktan sonra doğan hata (HTTP 200 içinde); son olaydır.
final class AssistantFailure extends AssistantEvent {
  const AssistantFailure({required this.code, required this.message});

  /// Sunucu kodu: `assistant.limit_exceeded`, `assistant.refused`,
  /// `assistant.provider_unavailable` ya da `platform.internal`. Metin bu koddan ARB ile
  /// gelir. Sözleşmede olmayan yeni kod → `platform.internal`.
  final String code;

  /// Sunucunun Türkçe metni (iç ayrıntı taşımaz); ARB metni varken gösterilmez.
  final String message;
}

/// Asistan uçları bu kurulumda kapalı (`NIZAMIO_ASSISTANT_ENABLED` kapalı → yol tanımsız,
/// `404 platform.route_not_found`). Repository yalnız bu durum ve kod çiftinde fırlatır;
/// diğer her hata `ApiError` olarak kalır. Arayüz bunu "asistan bu kurulumda kapalı" diye
/// gösterir ve asistan girişini gizler.
@immutable
final class AssistantDisabled implements Exception {
  const AssistantDisabled({this.requestId});

  /// Sunucu yanıtının istek kimliği (destek için).
  final String? requestId;

  /// Sunucunun bu durumu bildirdiği HTTP durumu ve kod (tek kaynak; uydurma kod yok).
  static const status = 404;
  static const code = 'platform.route_not_found';

  /// [status] ve [code] çifti asistanın kapalı olduğunu mu bildiriyor?
  static bool matches({required int? status, required String code}) =>
      status == AssistantDisabled.status && code == AssistantDisabled.code;

  @override
  String toString() =>
      'AssistantDisabled(${requestId == null ? '' : 'request_id=$requestId'})';
}
