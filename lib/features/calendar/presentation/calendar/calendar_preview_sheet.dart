import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/page/nz_app_nav.dart';
import '../../../../core/ui/widgets/buttons/buttons.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../domain/calendar.dart';
import 'calendar_grid.dart';
import 'calendar_texts.dart';

/// Kayıt önizleme penceresi (prototip `pk`): toplantı, talep ya da tablo kaydı. Başlıkta tür
/// noktası + mono üst etiket ve başlık; bilgi satırları (bağlantılı olanlar koordinatörlüğe ya
/// da göreve gider), toplantıda gündem; altta ikincil + birincil düğme (1:2).
///
/// Gezinme ve bildirim pencere kapandıktan sonra çalışır (prototip kapanış + 260 ms).
Future<void> showCalendarPreview(
  BuildContext context, {
  required CalendarEntry entry,
  required CalendarIndex index,
}) async {
  final l = context.l10n;
  final nav = context.appNav;
  final p = _Peek.of(entry, index, l, nav);
  final after = await NzBottomSheet.show<VoidCallback>(
    context,
    title: l.uiCalendarPreview,
    showHeader: false,
    // Kaynak önizleme eylem satırının üstünde çizgi yoktur.
    actionsDivider: false,
    actions: (sheet) => [
      NzButton.secondary(
        label: p.secondary,
        expand: true,
        onPressed: () => Navigator.of(sheet).pop(
          p.remind
              ? () {
                  if (context.mounted) {
                    NzToast.show(
                      context,
                      l.uiCalendarReminded,
                      tone: NzToastTone.success,
                    );
                  }
                }
              : null,
        ),
      ),
      NzButton.primary(
        label: p.primary,
        expand: true,
        onPressed: () => Navigator.of(sheet).pop(p.primaryGo),
      ),
    ],
    builder: (_) => _PreviewBody(peek: p, entry: entry),
  );
  after?.call();
}

typedef _Fact = ({String label, String value, VoidCallback? go});

/// Önizlemenin içeriği (prototip `pk` nesnesi).
final class _Peek {
  const _Peek({
    required this.kicker,
    required this.title,
    required this.facts,
    required this.agenda,
    required this.secondary,
    required this.primary,
    required this.primaryGo,
    this.remind = false,
  });

  factory _Peek.of(
    CalendarEntry e,
    CalendarIndex ix,
    AppLocalizations l,
    NzAppNav nav,
  ) {
    VoidCallback coord(String code) =>
        () => nav.openCoordinatorship(code);
    VoidCallback task(String code) =>
        () => nav.openTask(code);
    _Fact f(String label, String value, [VoidCallback? go]) =>
        (label: label, value: value, go: go);
    switch (e) {
      case MeetingEntry():
        return _Peek(
          kicker: l.uiCalendarKickerMeeting,
          title: e.title,
          facts: [
            f(l.uiCalendarFactTime, '${l.dayText(e.date)} · ${l.clock(e)}'),
            f(l.uiCalendarFactPlace, e.place),
            f(
              l.uiCalendarFactInvited,
              '${l.invited(e)} · ${e.participants} ${l.uiCalendarPeopleLc}',
            ),
          ],
          agenda: e.agenda,
          secondary: l.uiCalendarRemind,
          primary: l.uiCalendarWriteGroup,
          primaryGo: () => nav.openChat(e.chatId),
          remind: true,
        );
      case RequestEntry():
        final linked = e.taskCode;
        return _Peek(
          kicker: '${l.uiCalendarKickerRequest} · ${e.id}',
          title: e.title,
          facts: [
            f(l.uiCalendarFactType, l.requestType(e.type)),
            f(
              l.uiCalendarFactCoordinatorship,
              ix.coordinatorshipName(e.coordinatorship),
              coord(e.coordinatorship),
            ),
            f(
              l.uiCalendarFactAmount,
              e.amount > 0 ? l.money(e.amount) : l.uiCalendarQuotePending,
            ),
            f(l.uiCalendarFactState, l.requestState(e.state)),
            f(l.uiCalendarFactNeed, l.dayText(e.date)),
            if (linked != null) f(l.uiCalendarFactTask, linked, task(linked)),
          ],
          agenda: const [],
          secondary: l.uiCalendarClose,
          primary: linked != null
              ? l.uiCalendarGoTask
              : l.uiCalendarGoCoordinatorship,
          primaryGo: linked != null ? task(linked) : coord(e.coordinatorship),
        );
      case SheetEntry():
        return _Peek(
          kicker: l.uiCalendarKickerSheet,
          title: e.label,
          facts: [
            f(l.uiCalendarFactTable, e.table),
            f(l.uiCalendarFactDate, l.dayText(e.date)),
            f(
              l.uiCalendarFactPerson,
              ix.personName(e.person) ?? l.uiTasksUnknownPerson,
            ),
            f(
              l.uiCalendarFactCoordinatorship,
              ix.coordinatorshipName(e.coordinatorship),
              coord(e.coordinatorship),
            ),
            f(
              l.uiCalendarFactState,
              e.done ? l.uiCalendarSheetDone : l.uiCalendarSheetWaiting,
            ),
          ],
          agenda: const [],
          secondary: l.uiCalendarClose,
          primary: l.uiCalendarGoCoordinatorship,
          primaryGo: coord(e.coordinatorship),
        );
      case SeasonEntry() || TaskEntry():
        throw ArgumentError.value(e.kind, 'entry', 'önizlemesi yok');
    }
  }

  final String kicker;
  final String title;
  final List<_Fact> facts;
  final List<String> agenda;
  final String secondary;
  final String primary;
  final VoidCallback primaryGo;

  /// İkincil düğme "Hatırlat" (kapanınca bildirim).
  final bool remind;
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({required this.peek, required this.entry});

  final _Peek peek;
  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final p = peek;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Başlık satırı: solda 16, sağda 8 (kapat düğmesi); gövde dolgusu 16 olduğundan düğme
        // 8 dışarı taşınır.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        NzDot(color: c.kind(entry.kind)),
                        const Gap(7),
                        Flexible(
                          child: Text(
                            p.kicker,
                            style: t.monoSm.copyWith(
                              fontSize: 12,
                              color: c.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(6),
                    Semantics(
                      header: true,
                      child: Text(p.title, style: t.titleSm),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(NizamioSpacing.space2, 0),
              child: Semantics(
                button: true,
                label: l.uiCalendarClose,
                excludeSemantics: true,
                onTap: () => Navigator.of(context).pop(),
                child: InkResponse(
                  onTap: () => Navigator.of(context).pop(),
                  radius: NizamioSize.tap / 2,
                  child: SizedBox.square(
                    dimension: NizamioSize.tap,
                    child: Center(
                      child: NzIcon(
                        NzIcons.close,
                        size: NizamioSize.iconSize,
                        color: c.text,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(NizamioSpacing.space4),
        ClipRRect(
          borderRadius: BorderRadius.circular(NizamioRadius.row),
          child: ColoredBox(
            color: c.surfaceRaised,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, x) in p.facts.indexed)
                  _FactRow(fact: x, first: i == 0),
              ],
            ),
          ),
        ),
        if (p.agenda.isNotEmpty) ...[
          const Gap(18),
          NzKicker('${l.uiCalendarAgendaLc} · ${p.agenda.length}'),
          const Gap(NizamioSpacing.space2),
          for (final (i, a) in p.agenda.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      '${i + 1}',
                      style: t.monoSm.copyWith(
                        fontSize: 12,
                        height: 20 / 12,
                        color: c.textFaint,
                      ),
                    ),
                  ),
                  const Gap(NizamioSpacing.space2),
                  Expanded(child: Text(a, style: t.bodyMd)),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.fact, required this.first});

  final _Fact fact;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final go = fact.go;
    final value = go == null
        ? Text(
            fact.value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.bodyMd,
          )
        : Semantics(
            button: true,
            label: fact.value,
            excludeSemantics: true,
            onTap: () => Navigator.of(context).pop(go),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(go),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: NizamioSize.tap),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        fact.value,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMd.copyWith(
                          color: c.accentText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Gap(6),
                    NzIcon(
                      NzIcons.chevronRight,
                      size: NizamioSize.iconSizeSm,
                      color: c.accentText,
                    ),
                  ],
                ),
              ),
            ),
          );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: first
            ? null
            : Border(
                top: BorderSide(
                  color: c.border,
                  width: NizamioSize.borderWidth,
                ),
              ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NizamioSpacing.rowPad,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 112,
                child: Text(
                  fact.label,
                  style: t.bodySm.copyWith(fontSize: 13, color: c.textMuted),
                ),
              ),
              const Gap(NizamioSpacing.space3),
              Expanded(child: value),
            ],
          ),
        ),
      ),
    );
  }
}
