import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/api_error.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';
import '../../domain/chat_send_failure.dart';

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

  String refKind(ChatRefKind k) => switch (k) {
    ChatRefKind.task => uiMessagesRefTask,
    ChatRefKind.department => uiMessagesRefDepartment,
    ChatRefKind.file => uiMessagesRefFile,
  };

  /// Kartın alt satırı: görevde koordinatörlük ve tarih aralığı, dosyada boyut.
  String refSubtitle(ChatRefCard c) => switch (c.kind) {
    ChatRefKind.task => [
      c.department ?? uiMessagesRefTask,
      if (c.start != null && c.end != null)
        '${DateFormat('d MMM', 'tr').format(c.start!)} – '
            '${DateFormat('d MMM', 'tr').format(c.end!)}',
    ].join(' · '),
    ChatRefKind.file =>
      c.sizeBytes == null ? uiMessagesRefFile : fileSize(c.sizeBytes!),
    ChatRefKind.department => uiMessagesRefDepartment,
  };

  /// "Gönderilemedi" nedeni (not 33); sınıflanmayan kod hata metniyle.
  String sendFailure(String? code) => switch (chatSendFailure(code)) {
    ChatSendFailure.size => uiMessagesFailSize,
    ChatSendFailure.type => uiMessagesFailType,
    ChatSendFailure.unreadable => uiMessagesFailUnreadable,
    ChatSendFailure.network => uiMessagesFailNetwork,
    ChatSendFailure.permission => uiMessagesFailPermission,
    ChatSendFailure.other =>
      code == null ? uiMessagesSendFailed : errorText(this, ApiError(code)),
  };

  /// Boyut: ≥ 1 MB "2,4 MB", altı "300 KB".
  String fileSize(int bytes) {
    final mb = bytes / 1000000;
    return mb >= 1
        ? '${mb.toStringAsFixed(1).replaceAll('.', ',')} $uiArchiveMb'
        : '${(bytes / 1000).round().clamp(1, 999)} $uiArchiveKb';
  }

  /// Üyenin gruptaki rolü (üye için boş).
  String memberRole(ChatMember m) => [
    if (m.role == ChatMemberRole.admin) uiMessagesRoleGroupAdmin,
    if (m.role == ChatMemberRole.founder) uiMessagesRoleFounder,
    if (m.fromSource) uiMessagesFromSource,
  ].join(' · ');
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
