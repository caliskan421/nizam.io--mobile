import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/ui/widgets/lists/lists.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../../tasks/tasks.dart';
import '../../domain/chat.dart';

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

  String role(PersonRole r) => switch (r) {
    PersonRole.admin => uiMessagesRoleAdmin,
    PersonRole.coordinator => uiMessagesRoleCoordinator,
    PersonRole.member => uiMessagesRoleMember,
  };

  /// Üst çubuk alt satırı: grupta "18 üye", kişide "çevrimiçi" / "son görülme 09:41".
  String chatSubtitle(Chat c, DateTime today) {
    if (c.group) return '${c.members} $uiMessagesMembersLc';
    if (c.online) return uiMessagesOnline;
    final seen = c.lastSeen;
    if (seen == null) return '';
    return _sameDay(seen, today)
        ? '$uiMessagesLastSeen ${time(seen)}'
        : '$uiMessagesLastSeen $uiMessagesYesterdayLc';
  }

  String reaction(ChatReaction r) => switch (r) {
    ChatReaction.like => uiMessagesReactLike,
    ChatReaction.heart => uiMessagesReactHeart,
    ChatReaction.check => uiMessagesReactCheck,
    ChatReaction.star => uiMessagesReactStar,
  };

  /// "9 kişi oy verdi".
  String voters(int n) => '$n $uiMessagesVotedTail';
}

/// Tepkinin kit karşılığı.
NzReaction nzReaction(ChatReaction r) => NzReaction.values[r.index];

/// Kişinin sohbet rengi sırası (prototip renk eşlemesi; bilinmeyen kişi addan).
int personTone(String id, String name) => switch (id) {
  'ma' || 'my' || 'mk' => 0,
  'bk' || 'ss' => 1,
  'yc' || 'bc' => 2,
  'ko' || 'av' => 3,
  'rk' || 'aa' => 4,
  _ => NzAvatar.toneOf(name),
};

/// Atfın ikonu.
IconData refIcon(ChatRefKind k) => switch (k) {
  ChatRefKind.task => Icons.checklist_rounded,
  ChatRefKind.coordinatorship => Icons.apartment_rounded,
  ChatRefKind.file => Icons.insert_drive_file_outlined,
  ChatRefKind.photo => Icons.image_outlined,
  ChatRefKind.document => Icons.description_outlined,
};

/// Atıf etiketi: "#ALT-7", koordinatörlük adı, "Belge_1.pdf · 320 KB".
String refLabel(ChatRef r, TaskCatalog catalog) => switch (r.kind) {
  ChatRefKind.task => '#${r.id}',
  ChatRefKind.coordinatorship => catalog.coordinatorship(r.id)?.name ?? r.id,
  _ => r.size == null ? r.id : '${r.id} · ${r.size}',
};

/// Kit avatarı için baş harfler.
String chatInitials(String name) => NzChatAvatar.initialsOf(name);
