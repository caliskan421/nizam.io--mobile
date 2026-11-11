import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/domain/person_name.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/motion/nz_check_motion.dart';
import '../../../core/ui/theme/nz_motion.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_room_controller.dart';
import '../domain/meeting.dart';
import '../domain/meeting_board.dart';
import 'meeting_page.dart';
import 'meetings_texts.dart';

/// Toplantı başına gündem tavanı (COLLABORATION-K24).
const agendaLimit = 50;

/// Gündem maddesi başlığı tavanı (COLLABORATION-K24).
const agendaTitleMax = 300;

/// Gündem (prototip `.ag-card`): başlık + ilerleme, maddeler (açıklar sırayla, işaretliler
/// işaretlenme anına göre altta; işaretleyen ve saat), yöneticiye/bağlı koordinatöre işaret,
/// sil ve ekle (COLLABORATION-K26). Üye salt okur.
class MeetingAgenda extends ConsumerStatefulWidget {
  const MeetingAgenda({super.key, required this.room, required this.actions});

  final MeetingRoom room;
  final MeetingActions actions;

  @override
  ConsumerState<MeetingAgenda> createState() => _MeetingAgendaState();
}

class _MeetingAgendaState extends ConsumerState<MeetingAgenda> {
  final _draft = TextEditingController();
  var _busy = false;

  /// İşaret sırası: yeni işaretlenen yerinde tutulur, sonra kayar (ortak hareket).
  late final _hold = NzCheckHold(() {
    if (mounted) setState(() {});
  });

  /// FLIP ölçüm kabı (satırların ortak üst öğesi).
  final _area = GlobalKey();

  @override
  void initState() {
    super.initState();
    _draft.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _hold.dispose();
    _draft.dispose();
    super.dispose();
  }

  /// İşaret: açık madde hemen işaretlenir (kim, saat) ama [nzCheckHold] boyunca yerinde kalır,
  /// sonra tamamlananların arasına kayar; işaret kaldırma beklemesiz ([NzCheckHold]).
  void _toggle(AgendaItem a) {
    setState(
      () => _hold.toggle(
        a.id,
        wasDone: a.isChecked,
        reduced: NzMotion.reduced(context),
      ),
    );
    widget.actions.toggleAgenda(a);
  }

  Future<void> _add() async {
    final text = _draft.text.trim();
    if (text.isEmpty || _busy) return;
    if (widget.room.detail.agenda.length >= agendaLimit) {
      widget.actions.say(context.l10n.uiMeetingsAgendaLimit);
      return;
    }
    setState(() => _busy = true);
    final ok = await widget.actions.addAgenda(text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) _draft.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final d = widget.room.detail;
    final manage = widget.room.permissions.canManage;
    final items = orderAgenda(d.agenda, held: _hold.held);
    final done = items.where((a) => a.isChecked).length;
    final names = {for (final p in d.participants) p.accountId: p.fullName};
    String who(String id) =>
        names[id] ?? catalog?.nameOf(id) ?? l.uiMeetingsUnknownPerson;
    final canAdd = _draft.text.trim().isNotEmpty && !_busy;
    return NzCard.outlined(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 6),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l.uiMeetingsAgendaTitle,
                      style: t.labelLg.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 72,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: items.isEmpty ? 0 : done / items.length),
                    duration: NzMotion.of(
                      context,
                      const Duration(milliseconds: 350),
                    ),
                    curve: Curves.ease,
                    builder: (_, v, _) =>
                        NzProgressBar(value: v, color: c.primary),
                  ),
                ),
                const Gap(NizamioSpacing.space3),
                Semantics(
                  label: l.agendaProgress(done, items.length),
                  excludeSemantics: true,
                  child: Text(
                    '$done / ${items.length}',
                    style: t.monoSm.copyWith(
                      fontSize: 12.5,
                      color: c.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            key: _area,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final a in items)
                NzFlipSlot(
                  key: ValueKey(a.id),
                  order: _hold.order,
                  area: _area,
                  child: _AgendaRow(
                    item: a,
                    by: a.isChecked && a.checkedByAccountId != null
                        ? who(a.checkedByAccountId!)
                        : null,
                    onToggle: manage ? () => _toggle(a) : null,
                    onDelete: manage
                        ? () => widget.actions.deleteAgenda(a)
                        : null,
                  ),
                ),
            ],
          ),
          if (items.isEmpty && !manage)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                l.uiMeetingsAgendaEmpty,
                style: t.caption.copyWith(color: c.textMuted),
              ),
            ),
          if (manage)
            _Divided(
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: NzIcon(
                      NzIcons.add,
                      size: NizamioSize.iconSizeSm,
                      color: c.textMuted,
                    ),
                  ),
                  const Gap(NizamioSpacing.space2),
                  Expanded(
                    child: TextField(
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      controller: _draft,
                      maxLength: agendaTitleMax,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _add(),
                      style: t.bodyLg,
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        // Prototip `.ag-in`: çerçevesiz, zeminsiz (tema dolgu ve kenar verir).
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        hintText: l.uiMeetingsAgendaAdd,
                        hintStyle: t.bodyLg.copyWith(color: c.textFaint),
                        semanticCounterText: '',
                      ),
                    ),
                  ),
                  Text(
                    '${_draft.text.length} / $agendaTitleMax',
                    style: t.monoSm.copyWith(fontSize: 11, color: c.textFaint),
                  ),
                  const Gap(NizamioSpacing.space2),
                  NzButton.primary(
                    label: l.uiMeetingsAdd,
                    size: NzSize.sm,
                    loading: _busy,
                    onPressed: canAdd ? _add : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Üstte ince çizgili satır kabı (prototip `.ag-row`).
class _Divided extends StatelessWidget {
  const _Divided({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: context.colors.border)),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: child,
      ),
    ),
  );
}

/// Gündem satırı: yuvarlak işaret, başlık (işaretliyse üstü çizili, soluk), işaretleyen ve saat,
/// sil düğmesi. [onToggle]/[onDelete] null → salt okunur.
class _AgendaRow extends StatelessWidget {
  const _AgendaRow({
    required this.item,
    required this.by,
    required this.onToggle,
    required this.onDelete,
  });

  final AgendaItem item;
  final String? by;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final a = item;
    final done = a.isChecked;
    final at = a.checkedAt;
    return AnimatedOpacity(
      opacity: done ? .62 : 1,
      duration: NzMotion.of(context, nzCheckFade),
      child: _Divided(
        child: Row(
          children: [
            NzCheckCircle(
              value: done,
              label: a.title,
              onChanged: onToggle,
              onBlocked: () =>
                  NzToast.show(context, l.uiMeetingsAgendaCheckBlocked),
            ),
            const Gap(NizamioSpacing.space2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: NzStrikeText(
                  text: a.title,
                  done: done,
                  color: done ? c.textMuted : c.text,
                  style: t.bodyLg.copyWith(fontSize: 15, height: 22 / 15),
                ),
              ),
            ),
            // İşaretleyen ve saat: işaretlenince solarak gelir, kaldırılınca hemen kalkar.
            AnimatedSwitcher(
              duration: NzMotion.of(context, nzCheckFade),
              reverseDuration: Duration.zero,
              child: by == null
                  ? const SizedBox.shrink()
                  : Padding(
                      key: ValueKey('by-${a.id}'),
                      padding: const EdgeInsets.only(
                        left: NizamioSpacing.space2,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 112),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              shortPersonName(by!),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.caption.copyWith(color: c.textMuted),
                            ),
                            if (at != null)
                              Text(
                                l.meetingTime(at),
                                style: t.monoSm.copyWith(
                                  fontSize: 11,
                                  color: c.textFaint,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
            if (onDelete case final delete?) ...[
              const Gap(NizamioSpacing.space2),
              Semantics(
                button: true,
                label: l.agendaDeleteLabel(a.title),
                excludeSemantics: true,
                child: Material(
                  color: c.surfaceRaised,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(NizamioRadius.tile),
                    side: BorderSide(color: c.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: delete,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: NzIcon(
                          NzIcons.delete,
                          size: NizamioSize.iconSizeSm,
                          color: c.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
