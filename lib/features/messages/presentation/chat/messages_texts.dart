import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';

/// Mesajlar ekranlarının biçimli metinleri (parçalar ARB'den; tarih `tr`).
extension MessagesTexts on AppLocalizations {
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Gün hapı: "Bugün" / "Dün" / "19 Eki".
  String dayLabel(DateTime day, DateTime today) {
    if (_sameDay(day, today)) return uiMessagesToday;
    if (_sameDay(day, today.subtract(const Duration(days: 1)))) {
      return uiMessagesYesterday;
    }
    return DateFormat('d MMM', 'tr').format(day);
  }

  String time(DateTime at) => DateFormat.Hm('tr').format(at);

  /// Listede son mesaj zamanı: bugünse saat, değilse gün.
  String listTime(DateTime at, DateTime today) =>
      _sameDay(at, today) ? time(at) : dayLabel(at, today);

  String candidateRole(ChatCandidateRole r) => switch (r) {
    ChatCandidateRole.companyAdmin => uiMessagesRoleAdmin,
    ChatCandidateRole.coordinator => uiMessagesRoleCoordinator,
    ChatCandidateRole.member => uiMessagesRoleMember,
  };

  /// Üst çubuk alt satırı: yazıyor; grupta "Tüm kullanıcılar" / "Grup"; birebirde sunucunun
  /// verdiği çevrimiçi / son görülme (bilinmiyorsa boş).
  String chatSubtitle(ChatRoom room, DateTime today) {
    final typing = room.typing;
    if (typing != null) return '${typing.split(' ').first} $uiMessagesTyping';
    final c = room.chat;
    if (c.group) return c.general ? uiMessagesAllUsers : uiMessagesGroup;
    if (c.peerOnline ?? false) return uiMessagesOnline;
    final seen = c.peerLastSeen;
    if (seen == null) return '';
    return '$uiMessagesLastSeen ${listTime(seen, today).toLowerCase()}';
  }

  String reaction(ChatReaction r) => switch (r) {
    ChatReaction.like => uiMessagesReactLike,
    ChatReaction.heart => uiMessagesReactHeart,
    ChatReaction.check => uiMessagesReactCheck,
    ChatReaction.star => uiMessagesReactStar,
  };

  /// "9 kişi oy verdi".
  String voters(int n) => '$n $uiMessagesVotedTail';

  /// Mesajın kısa metni (alıntı, sabit şeridi, önizleme): metin, yoksa ilk ek adı.
  String summaryOf(ChatMessage m) =>
      m.text.isNotEmpty ? m.text : m.attachments.firstOrNull?.fileName ?? '';
}

/// Tepkinin kit karşılığı.
NzReaction nzReaction(ChatReaction r) => NzReaction.values[r.index];

/// Kişinin avatar/ad rengi sırası (addan; aynı kişi her yerde aynı renk).
int personTone(String name) => NzAvatar.toneOf(name);

/// Kişinin sohbet rengi.
Color personColor(BuildContext context, String name) =>
    NzChatAvatar.toneColor(context, personTone(name));

/// Kit avatarı için baş harfler.
String chatInitials(String name) => NzChatAvatar.initialsOf(name);
