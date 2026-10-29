/// messages özelliğinin açık yüzü: sohbet listesi ve sohbet. Başka feature'lar ve `app/` yalnız bu dosyayı
/// import eder (sınır kuralı B3).
library;

export 'application/messages_nav_caption.dart'
    show messagesNavBadgeProvider, messagesNavCaptionProvider;
export 'presentation/chat_page.dart' show ChatPage;
export 'presentation/messages_page.dart' show MessagesPage;
