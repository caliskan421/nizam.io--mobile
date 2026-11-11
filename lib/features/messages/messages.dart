/// messages özelliğinin açık yüzü: sohbet listesi ve sohbet. Başka feature'lar ve `app/` yalnız bu dosyayı
/// import eder (sınır kuralı B3).
library;

export 'application/company_admin_index.dart' show companyAdminIndexProvider;
export 'application/messages_nav_caption.dart'
    show
        messagesNavBadgeProvider,
        messagesNavCaptionProvider,
        refreshMessagesBadge;
export 'application/messages_providers.dart'
    show chatUnreadOverviewProvider, chatInboxSearchProvider;
export 'domain/chat.dart' show ChatProgramUnread, ChatInbox, Chat;
export 'domain/company_admin_index.dart' show CompanyAdminIndex;
export 'presentation/chat_page.dart' show ChatPage;
export 'presentation/messages_page.dart' show MessagesPage;
export 'presentation/open_person_chat.dart' show openPersonChat;
