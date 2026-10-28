import 'package:flutter/material.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../theme/nz_motion.dart';

/// Saat/dakika çarkı (tasarım `components/TimeWheel`; prototip toplantı "Saat" satırı):
/// iki dikey kaydırmalı sütun (saat 00–23, dakika [minuteStep] adımlı), ortada vurgulu seçim
/// bandı ve aralarında ":". Kaydırma bir öğeye oturur; öğeye dokunmak oraya kaydırır. Seçim
/// değişince [onChanged] (saat, dakika). Seçili dakika adımda değilse en yakın adıma oturur.
class NzTimeWheel extends StatefulWidget {
  const NzTimeWheel({
    super.key,
    required this.hour,
    required this.minute,
    required this.onChanged,
    this.minuteStep = 5,
  }) : assert(minuteStep > 0 && 60 % minuteStep == 0, 'adım 60’ı bölmeli');

  final int hour;
  final int minute;
  final void Function(int hour, int minute) onChanged;
  final int minuteStep;

  @override
  State<NzTimeWheel> createState() => _NzTimeWheelState();
}

class _NzTimeWheelState extends State<NzTimeWheel> {
  static const _item = 36.0;
  static const _visible = 5;

  late final FixedExtentScrollController _h;
  late final FixedExtentScrollController _m;

  int get _minuteCount => 60 ~/ widget.minuteStep;
  int _minuteIndex(int minute) =>
      (minute / widget.minuteStep).round() % _minuteCount;

  @override
  void initState() {
    super.initState();
    _h = FixedExtentScrollController(initialItem: widget.hour.clamp(0, 23));
    _m = FixedExtentScrollController(initialItem: _minuteIndex(widget.minute));
  }

  @override
  void didUpdateWidget(NzTimeWheel old) {
    super.didUpdateWidget(old);
    void sync(FixedExtentScrollController c, int i) {
      if (c.hasClients &&
          c.selectedItem != i &&
          !c.position.isScrollingNotifier.value) {
        c.jumpToItem(i);
      }
    }

    sync(_h, widget.hour);
    sync(_m, _minuteIndex(widget.minute));
  }

  @override
  void dispose() {
    _h.dispose();
    _m.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged(
    _h.selectedItem.clamp(0, 23),
    _m.selectedItem.clamp(0, _minuteCount - 1) * widget.minuteStep,
  );

  Widget _wheel(
    FixedExtentScrollController controller,
    int count,
    int selected,
    String label,
    int Function(int) value,
  ) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      label: label,
      value: value(selected).toString().padLeft(2, '0'),
      increasedValue: value((selected + 1) % count).toString().padLeft(2, '0'),
      decreasedValue: value((selected - 1 + count) % count)
          .toString()
          .padLeft(2, '0'),
      onIncrease: () => controller.animateToItem(
        (selected + 1) % count,
        duration: NzMotion.of(context, NizamioMotion.durSheet),
        curve: NizamioMotion.easeSheet,
      ),
      onDecrease: () => controller.animateToItem(
        (selected - 1 + count) % count,
        duration: NzMotion.of(context, NizamioMotion.durSheet),
        curve: NizamioMotion.easeSheet,
      ),
      child: ExcludeSemantics(
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: _item,
          physics: const FixedExtentScrollPhysics(),
          diameterRatio: 3,
          onSelectedItemChanged: (_) => _emit(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: count,
            builder: (context, i) {
              final on = i == selected;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.animateToItem(
                  i,
                  duration: NzMotion.of(context, NizamioMotion.durSheet),
                  curve: NizamioMotion.easeSheet,
                ),
                child: Center(
                  child: Text(
                    value(i).toString().padLeft(2, '0'),
                    textScaler: TextScaler.noScaling,
                    style: t.mono.copyWith(
                      color: on ? c.text : c.textMuted,
                      fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final material = MaterialLocalizations.of(context);
    final hSel = widget.hour.clamp(0, 23);
    final mSel = _minuteIndex(widget.minute);
    return SizedBox(
      height: _item * _visible,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            height: _item,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceOverlay,
                borderRadius: BorderRadius.circular(NizamioRadius.tile),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _wheel(
                  _h,
                  24,
                  hSel,
                  material.timePickerHourLabel,
                  (i) => i,
                ),
              ),
              ExcludeSemantics(
                child: Text(
                  ':',
                  textScaler: TextScaler.noScaling,
                  style: t.mono.copyWith(
                    color: c.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: _wheel(
                  _m,
                  _minuteCount,
                  mSel,
                  material.timePickerMinuteLabel,
                  (i) => i * widget.minuteStep,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
