import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icons.dart';

/// Ortak takvim/saat çarkıyla yerel seçim; üst form yalnız UTC anını gönderir.
class ChatComposeDeadline extends StatefulWidget {
  const ChatComposeDeadline({super.key, required this.onChanged});

  final ValueChanged<DateTime?> onChanged;

  @override
  State<ChatComposeDeadline> createState() => _ChatComposeDeadlineState();
}

class _ChatComposeDeadlineState extends State<ChatComposeDeadline> {
  DateTime _date = DateTime.now().add(const Duration(hours: 1));
  late DateTime _month = DateTime(_date.year, _date.month);
  var _enabled = false;
  int? _pane;

  void _change(DateTime date) {
    setState(() => _date = date);
    widget.onChanged(_enabled ? date.toUtc() : null);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space2,
      children: [
        NzSwitch(
          label: l.uiMessagesComposeClosesAt,
          value: _enabled,
          onChanged: (v) {
            setState(() => _enabled = v);
            widget.onChanged(v ? _date.toUtc() : null);
          },
        ),
        if (!_enabled)
          Text(l.uiMessagesComposeNoDeadline, style: context.text.caption)
        else ...[
          NzFormRows(
            expandedIndex: _pane,
            onToggle: (i) => setState(() => _pane = _pane == i ? null : i),
            rows: [
              NzFormRow(
                icon: NzIcons.calendar,
                label: l.uiMessagesComposeCloseDate,
                value: DateFormat.yMMMd('tr').format(_date),
                valueSet: true,
                content: NzRangeCalendar(
                  month: _month,
                  start: _date,
                  today: now,
                  firstDate: now,
                  onMonthStep: (step) => setState(
                    () => _month = DateTime(_month.year, _month.month + step),
                  ),
                  onDayTap: (d) => _change(
                    DateTime(d.year, d.month, d.day, _date.hour, _date.minute),
                  ),
                ),
              ),
              NzFormRow(
                icon: NzIcons.clock,
                label: l.uiMessagesComposeCloseTime,
                value: DateFormat.Hm('tr').format(_date),
                valueSet: true,
                content: NzTimeWheel(
                  hour: _date.hour,
                  minute: _date.minute,
                  minuteStep: 1,
                  onChanged: (h, m) => _change(
                    DateTime(_date.year, _date.month, _date.day, h, m),
                  ),
                ),
              ),
            ],
          ),
          Text(l.uiMessagesComposeLocalTime, style: context.text.caption),
          if (!_date.isAfter(now))
            NzBanner.warning(message: l.uiMessagesComposeDeadlineInvalid),
        ],
      ],
    );
  }
}
