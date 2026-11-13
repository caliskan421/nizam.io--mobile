import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/widgets/nz_icon.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../domain/meeting.dart';
import '../domain/meeting_status.dart';
import 'meetings_texts.dart';

/// Tek satırda gösterilecek çip sayısı: [widths] (sahip önde) sırayla, en çok [max] tanesi,
/// [avail] genişliğe sığdığı kadar; kalan varsa sona "+N" çipi ([plus], kalan sayısına göre
/// genişlik) de sığmalıdır. En az 1 (sahip; sığmıyorsa çağıran kısaltır).
int chipsThatFit(
  List<double> widths, {
  required double avail,
  required double gap,
  required double Function(int rest) plus,
  int max = 4,
}) {
  for (var k = widths.length < max ? widths.length : max; k > 1; k--) {
    final rest = widths.length - k;
    var need = widths.take(k).fold(0.0, (a, w) => a + w) + gap * (k - 1);
    if (rest > 0) need += gap + plus(rest);
    if (need <= avail) return k;
  }
  return 1;
}

/// Davetli koordinatörlük çipleri (sahip önde); çip içeriğe göre genişler (yatay boşluk dikeyin
/// 4 katı), uzun ad üç noktayla kısalır.
/// - [solid] (liste kartı): TEK satır, kart yüksekliği koordinatörlük sayısından bağımsız; sahip
///   `ink` dolgulu, diğerleri `bg-raised`; sığdığı kadar, en çok 4 çip, kalanlar "+N".
/// - değilse (ayrıntı kimliği): hepsi yan yana, sığmayan alt satıra akar; kenarlı, sahip kalın.
/// [trailing] çiplerin altında (ayrıntıda görünürlük hapı).
class MeetingCodeChips extends StatelessWidget {
  const MeetingCodeChips({
    super.key,
    required this.meeting,
    required this.label,
    this.solid = false,
    this.trailing,
  });

  final Meeting meeting;

  /// Departmanın ekrandaki etiketi ([meetingDeptLabel]).
  final String Function(MeetingDepartment d) label;
  final bool solid;
  final Widget? trailing;

  static const _gap = 6.0;

  /// Çip iç boşluğu: dikey [_padV], yatay 4 katı.
  static const _padV = 4.0;
  static const _padH = _padV * 4;

  TextStyle _style(
    BuildContext context, {
    required bool owner,
    bool more = false,
  }) {
    final c = context.colors;
    return context.text.monoSm.copyWith(
      fontSize: solid ? 11.5 : 11,
      fontWeight: solid || owner ? FontWeight.w600 : FontWeight.w500,
      color: solid
          ? (owner ? c.background : (more ? c.textMuted : c.text))
          : (owner ? c.text : c.textMuted),
    );
  }

  Widget _chip(
    BuildContext context,
    String text, {
    required bool owner,
    bool more = false,
  }) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _padH, vertical: _padV),
      decoration: BoxDecoration(
        color: solid ? (owner ? c.text : c.surfaceRaised) : null,
        borderRadius: BorderRadius.circular(8),
        border: solid
            ? null
            : Border.all(color: owner ? c.borderControl : c.border),
      ),
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: _style(context, owner: owner, more: more),
      ),
    );
  }

  /// Çipin doğal genişliği (yazı + iç boşluk).
  double _width(BuildContext context, String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final w = tp.width.ceilToDouble() + _padH * 2;
    tp.dispose();
    return w;
  }

  Widget _strip(
    BuildContext context,
    List<MeetingDepartment> depts,
  ) => LayoutBuilder(
    builder: (context, box) {
      final owner = meeting.ownerDepartmentId;
      final widths = [
        for (final d in depts)
          _width(context, label(d), _style(context, owner: d.id == owner)),
      ];
      double plus(int rest) =>
          _width(context, '+$rest', _style(context, owner: false, more: true));
      final k = chipsThatFit(
        widths,
        avail: box.maxWidth,
        gap: _gap,
        plus: plus,
      );
      final rest = depts.length - k;
      return Row(
        spacing: _gap,
        children: [
          for (final (i, d) in depts.take(k).indexed)
            // Tek çip sığmıyorsa (çok uzun ad) kısalır; "+N" her zaman tam görünür.
            if (i == 0)
              Flexible(child: _chip(context, label(d), owner: d.id == owner))
            else
              _chip(context, label(d), owner: d.id == owner),
          if (rest > 0) _chip(context, '+$rest', owner: false, more: true),
        ],
      );
    },
  );

  /// Ayrıntı: hepsi yan yana, sığmayan alt satıra akar; çok uzun ad satır genişliğinde kısalır.
  Widget _flow(BuildContext context, List<MeetingDepartment> depts) =>
      LayoutBuilder(
        builder: (context, box) => Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final d in depts)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: box.maxWidth),
                child: _chip(
                  context,
                  label(d),
                  owner: d.id == meeting.ownerDepartmentId,
                ),
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final depts = ownerFirst(meeting);
    final chips = solid ? _strip(context, depts) : _flow(context, depts);
    final tail = trailing;
    if (tail == null) return chips;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [chips, tail],
    );
  }
}

/// Küçük hap rozet (görünürlük, rol, "Sahip").
class MeetingPill extends StatelessWidget {
  const MeetingPill({
    super.key,
    required this.label,
    this.color,
    this.fill,
    this.bold = false,
  });

  final String label;
  final Color? color;
  final Color? fill;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: fill ?? c.surfaceOverlay,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
      ),
      child: Text(
        label,
        style: context.text.caption.copyWith(
          fontSize: 11,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
          color: color ?? c.textMuted,
        ),
      ),
    );
  }
}

/// Tarih kutusu (prototip `.rp-mc-tile`): gün, ay etiketi ya da durum ("• CANLI", "BEKLİYOR",
/// "YAPILMADI", "BİTTİ"), ayraç, saat. Canlı ve bekleyen toplantıda kutu durum tonuna boyanır.
class MeetingDateTile extends StatelessWidget {
  const MeetingDateTile({
    super.key,
    required this.at,
    required this.width,
    this.status,
  });

  final DateTime at;
  final double width;
  final MeetingStatus? status;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final local = at.toLocal();
    final phase = status?.phase;
    final tone = switch (phase) {
      MeetingPhase.live => c.primary,
      MeetingPhase.waiting => c.warning,
      _ => null,
    };
    final labelColor = switch (phase) {
      MeetingPhase.live => c.accentText,
      MeetingPhase.waiting => c.warning,
      _ => c.textFaint,
    };
    final edge = tone == null ? c.border : tone.withValues(alpha: .55);
    return Container(
      width: width,
      padding: const EdgeInsets.only(top: 8, bottom: 7),
      decoration: BoxDecoration(
        color: tone == null
            ? c.surfaceRaised
            : Color.alphaBlend(tone.withValues(alpha: .12), c.surfaceRaised),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: edge),
      ),
      child: Column(
        children: [
          Text('${local.day}', style: t.numeral.copyWith(fontSize: 24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (phase == MeetingPhase.live) ...[
                const MeetingLiveDot(size: 5),
                const Gap(4),
              ],
              Flexible(
                child: Text(
                  phase == null
                      ? l.meetingMonthTag(at)
                      : l.meetingTileLabel(phase),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: t.monoSm.copyWith(
                    fontSize: 10,
                    letterSpacing: .4,
                    fontWeight: tone == null
                        ? FontWeight.w400
                        : FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(6),
          Divider(
            height: NizamioSize.borderWidth,
            thickness: NizamioSize.borderWidth,
            color: edge,
          ),
          const Gap(6),
          Text(
            l.meetingTime(at),
            style: t.monoSm.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Canlı noktası (prototip `rpLive`): vurgu renginde, 1,6 sn'de bir solup küçülür. Hareketi
/// azalt açıkken durağandır. Görseldir (anlamı yanındaki "Canlı" taşır).
class MeetingLiveDot extends StatefulWidget {
  const MeetingLiveDot({super.key, this.size = 8});

  final double size;

  @override
  State<MeetingLiveDot> createState() => _MeetingLiveDotState();
}

class _MeetingLiveDotState extends State<MeetingLiveDot>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
      _pulse.value = 0;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: FadeTransition(
      opacity: Tween(begin: 1.0, end: .45).animate(_pulse),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: .8).animate(_pulse),
        child: NzDot(color: context.colors.primary, size: widget.size),
      ),
    ),
  );
}

/// Kart sayaçları (prototip `.rp-mc-stats`): gündem "2 / 3", not, kişi.
class MeetingStats extends StatelessWidget {
  const MeetingStats({super.key, required this.summary, this.wide = false});

  final MeetingSummary summary;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = summary;
    final style = context.text.bodySm.copyWith(
      fontSize: wide ? 13.5 : 12.5,
      color: c.textMuted,
    );
    Widget stat(IconData icon, String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NzIcon(icon, size: NizamioSize.iconSizeSm, color: c.textMuted),
        const Gap(6),
        Text(text, style: style, maxLines: 1, softWrap: false),
      ],
    );
    return Semantics(
      label: [
        '${l.uiMeetingsAgendaStat} ${s.agendaChecked}/${s.agendaTotal}',
        l.meetingNotesStat(s.noteCount),
        l.meetingPeopleStat(s.participantCount),
      ].join(', '),
      excludeSemantics: true,
      child: Wrap(
        spacing: wide ? 28 : 14,
        runSpacing: 6,
        children: [
          stat(NzIcons.listBulleted, '${s.agendaChecked} / ${s.agendaTotal}'),
          stat(NzIcons.document, l.meetingNotesStat(s.noteCount)),
          stat(NzIcons.person, l.meetingPeopleStat(s.participantCount)),
        ],
      ),
    );
  }
}

/// Bilgi satırı (prototip Bilgi bölümü: solda soluk etiket, sağda değer).
class MeetingInfoRow extends StatelessWidget {
  const MeetingInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.tapHint,
  });

  final String label;
  final String value;

  /// Verilirse değer bağlantı görünümünde çizilir ve satır dokunulabilir olur.
  final VoidCallback? onTap;
  final String? tapHint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 116,
              child: Text(label, style: t.bodySm.copyWith(color: c.textMuted)),
            ),
            const Gap(12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: onTap == null
                    ? t.bodyMd
                    : t.bodyMd.copyWith(
                        color: c.accentText,
                        decoration: TextDecoration.underline,
                        decorationColor: c.accentText,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
    return MergeSemantics(
      child: onTap == null
          ? row
          : Semantics(
              button: true,
              hint: tapHint,
              child: InkWell(onTap: onTap, child: row),
            ),
    );
  }
}
