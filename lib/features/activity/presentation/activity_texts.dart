import 'package:intl/intl.dart';

import '../../../core/i18n/generated/app_localizations.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../domain/activity_log.dart';

/// İşlem geçmişinin sayılı / tarihli cümleleri (parçalar ARB'den; Türkçe söz dizimi burada).
extension ActivityTexts on AppLocalizations {
  String activityKindLabel(ActivityKind? k) => switch (k) {
    null => uiActivityTypeAll,
    ActivityKind.task => uiActivityTypeTask,
    ActivityKind.file => uiActivityTypeFile,
    ActivityKind.meeting => uiActivityTypeMeeting,
    ActivityKind.message => uiActivityTypeMessage,
    ActivityKind.account => uiActivityTypeAccount,
  };

  /// "bugün · 21 ekim 2026", "dün · 20 ekim 2026", "19 ekim 2026 pazartesi".
  String activityDay(DateTime day, DateTime today) {
    final d = DateTime(day.year, day.month, day.day);
    final t = DateTime(today.year, today.month, today.day);
    final diff = t.difference(d).inDays;
    final date = DateFormat('d MMMM y', 'tr').format(d);
    final text = switch (diff) {
      0 => '$uiActivityToday · $date',
      1 => '$uiActivityYesterday · $date',
      _ => '$date ${DateFormat('EEEE', 'tr').format(d)}',
    };
    return text.toLowerCase();
  }

  /// "14:27".
  String activityTime(DateTime at) => DateFormat.Hm('tr').format(at);

  /// "30 / 38 kayıt gösteriliyor".
  String activityShown(int shown, int total) =>
      '$shown / $total $uiActivityShownTail';

  /// "38 kaydı göster".
  String activityApply(int n) => '$n $uiActivityApplyTail';

  /// "Kerem Özdal filtresini kaldır".
  String activityRemove(String what) => '$what $uiActivityRemoveTail';

  /// "Tür: Görev".
  String activityTypeChip(ActivityKind k) =>
      '$uiActivityChipType ${activityKindLabel(k)}';

  /// "CSV indirme mobilde sonraki adımda eklenecek".
  String activitySoon(String what) => '$what $uiActivitySoonTail';

  String activityRole(PersonRole? r) => switch (r) {
    PersonRole.admin => uiActivityRoleAdmin,
    PersonRole.member => uiActivityRoleMember,
    PersonRole.coordinator || null => uiActivityRoleCoordinator,
  };
}

/// Kayıt türünün işaret tonu (prototip: görev violet, dosya gold, toplantı accent, mesaj üye
/// rengi, hesap ikincil).
NzTone activityTone(ActivityKind k) => switch (k) {
  ActivityKind.task => NzTone.progress,
  ActivityKind.file => NzTone.waiting,
  ActivityKind.meeting => NzTone.done,
  ActivityKind.message => NzTone.info,
  ActivityKind.account => NzTone.neutral,
};
