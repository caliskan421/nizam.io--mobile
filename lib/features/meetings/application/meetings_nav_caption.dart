import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/providers.dart';
import '../domain/meeting_board.dart';
import 'meetings_controller.dart';

part 'meetings_nav_caption.g.dart';

/// Alt menüde Toplantılar etkinken görünen mono alt yazı ("11 yaklaşan"); liste yüklenmeden null.
@riverpod
String? meetingsNavCaption(Ref ref) {
  final board = ref.watch(meetingsBoardControllerProvider).value;
  if (board == null) return null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final l = lookupAppLocalizations(ref.watch(localeProvider));
  return '${board.of(MeetingsTab.upcoming, today).length} '
      '${l.uiMeetingsNavUpcomingTail}';
}
