import 'package:flutter/material.dart';

import '../overlays/nz_bottom_sheet.dart';
import 'nz_range_calendar.dart';

/// Tek gün seçimi: alt sayfada uygulamanın ay takvimi ([NzRangeCalendar]); güne dokunuş seçip
/// kapatır. Kapatma/geri `null` döner. [firstDate]'ten önceki günler dokunulamaz.
Future<DateTime?> showNzDateSheet(
  BuildContext context, {
  required String title,
  DateTime? initial,
  DateTime? firstDate,
}) {
  final now = DateTime.now();
  var month = initial ?? firstDate ?? now;
  return NzBottomSheet.show<DateTime>(
    context,
    title: title,
    compact: true,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, setState) => NzRangeCalendar(
        month: month,
        start: initial,
        today: now,
        firstDate: firstDate,
        semanticLabel: title,
        onMonthStep: (delta) =>
            setState(() => month = DateTime(month.year, month.month + delta)),
        onDayTap: (d) => Navigator.of(sheet).pop(d),
      ),
    ),
  );
}
