import '../../../core/domain/page_slice.dart';
import 'assistant.dart';

/// YZ asistanı uçlarının kaynağı (domain portu; gerçekleştirme
/// `data/assistant_api_repository.dart`). Bütün uçlar S2'dir (program başlığı seçili
/// kapsamdan). Uç bayrağı kapalıyken her metot [AssistantDisabled] fırlatır; diğer hatalar
/// `ApiError`'dır.
abstract interface class AssistantRepository {
  /// `assistantChat` — soruyu sorar, cevabı olay akışı olarak verir. Akış başlamadan doğan
  /// hata (kapsam, kota, kapasite, sohbet sahipliği, ilk model çağrısı) akışın hatası olarak
  /// (`ApiError`/[AssistantDisabled]) gelir; başladıktan sonra doğan hata tek
  /// [AssistantFailure] olayıdır. Akış [AssistantDone] ya da [AssistantFailure] sonrası
  /// kapanır; dinlemeyi bırakmak isteği iptal eder.
  Stream<AssistantEvent> chat(AssistantQuestion question);

  /// `assistantConversations` — çağıranın seçili programdaki sohbetleri (en yeni önce, en çok
  /// 200; sayfasız). Kesilme `X-Result-Truncated` başlığından [PageSlice.truncated]'a gelir.
  Future<PageSlice<AssistantConversation>> listConversations();

  /// `assistantConversation` — sohbet ve görünür mesajları.
  Future<AssistantConversationDetail> getConversation(String conversationId);

  /// `deleteAssistantConversation` — sohbeti mesajlarıyla kalıcı siler.
  Future<void> deleteConversation(String conversationId);
}
