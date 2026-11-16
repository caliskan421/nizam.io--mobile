/// messages özelliğinin açık yüzü: sohbet listesi ve sohbet. Başka feature'lar ve `app/` yalnız bu dosyayı
/// import eder (sınır kuralı B3).
library;

export 'application/department_group_team.dart'
    show departmentGroupTeamProvider;
export 'application/messages_nav_caption.dart'
    show
        messagesNavBadgeProvider,
        messagesNavCaptionProvider,
        refreshMessagesBadge;
export 'application/messages_providers.dart'
    show
        chatUnreadOverviewProvider,
        chatUnreadBadgesProvider,
        chatUnreadSnapshotProvider,
        chatInboxSearchProvider;
export 'domain/chat.dart'
    show ChatProgramUnread, ChatInbox, Chat, ChatMemberRole;
export 'domain/chat_extras.dart' show ChatMember, ChatMembers;
export 'presentation/chat_page.dart' show ChatPage;
export 'presentation/messages_page.dart' show MessagesPage;
export 'presentation/open_department_chat.dart' show openDepartmentChat;
export 'presentation/open_person_chat.dart' show openPersonChat;
