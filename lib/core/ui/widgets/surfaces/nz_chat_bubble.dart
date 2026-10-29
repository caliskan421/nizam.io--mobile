import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../../layout/nz_bleed.dart';
import '../../theme/nz_motion.dart';
import '../lists/nz_chat_row.dart';
import '../nz_icon.dart';

/// Mesaj tepkisi (mesaj başına bir tane; emoji yok, ikon).
enum NzReaction { like, heart, check, star }

extension NzReactionIcon on NzReaction {
  /// [selected] kalp ve yıldızda dolu ikon.
  IconData icon({bool selected = false}) => switch (this) {
    NzReaction.like => Icons.thumb_up_outlined,
    NzReaction.heart =>
      selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
    NzReaction.check => Icons.check_rounded,
    NzReaction.star =>
      selected ? Icons.star_rounded : Icons.star_border_rounded,
  };
}

/// Balonun altındaki tepki hapı.
@immutable
class NzChatReactionChip {
  const NzChatReactionChip({
    required this.kind,
    required this.count,
    required this.mine,
    required this.onTap,
    required this.semanticLabel,
  });

  final NzReaction kind;
  final int count;

  /// Bu tepki benim (vurgulu kenar + `accent` karışımı zemin).
  final bool mine;
  final VoidCallback onTap;
  final String semanticLabel;
}

/// Balon içi alıntı (`.m-quote`): sol 3 px şerit, kim + metin tek satır; dokununca akış o
/// mesaja kayar.
@immutable
class NzChatQuote {
  const NzChatQuote({
    required this.who,
    required this.text,
    required this.color,
    required this.onTap,
    required this.semanticLabel,
  });

  final String who;
  final String text;
  final Color color;
  final VoidCallback onTap;
  final String semanticLabel;
}

/// Sohbet balonu (tasarım sistemi `components/ChatBubble`, `.m-bubble`): kendi mesajın sağda
/// `bubble-mine`, diğerleri solda `bubble-other`; aynı kişinin ardışık mesajlarında iç köşeler
/// 6, son balon ([last]) 18; avatar yuvası yalnız grupta başkasının mesajında, avatar yalnız son
/// balonda görünür. Ad + rol (grupta ilk balon), alıntı, gövde ([body]: satır içi atıflı metin),
/// ek ([extra]: anket), alt bilgi (düzenlendi · sabit · saat · tik) ve tepkiler.
///
/// Dokunmak bir şey yapmaz; basılı tutmak 480 ms'de [onLongPress] çağırır, 160 ms'de balon
/// hafifçe küçülür (8 px'ten fazla kayma iptal eder). [flash] `accent-text` halka (alıntıdan
/// gelinince ve işlem sayfası açıkken).
class NzChatBubble extends StatefulWidget {
  const NzChatBubble({
    super.key,
    required this.mine,
    required this.body,
    required this.time,
    required this.semanticLabel,
    this.last = true,
    this.senderName,
    this.senderColor,
    this.senderRole,
    this.quote,
    this.extra,
    this.editedLabel,
    this.pinned = false,
    this.tick = NzChatTick.none,
    this.flash = false,
    this.reactions = const [],
    this.avatar,
    this.showAvatarSlot = false,
    this.onLongPress,
    this.longPressLabel,
  });

  final bool mine;
  final Widget body;
  final String time;
  final String semanticLabel;
  final bool last;

  /// Gönderen adı (yalnız grupta, başkasının ilk balonunda).
  final String? senderName;
  final Color? senderColor;
  final String? senderRole;
  final NzChatQuote? quote;
  final Widget? extra;

  /// "düzenlendi" (null → düzenlenmemiş).
  final String? editedLabel;
  final bool pinned;
  final NzChatTick tick;
  final bool flash;
  final List<NzChatReactionChip> reactions;

  /// Avatar (30 px); [showAvatarSlot] true iken yuva ayrılır, yalnız [last]'ta görünür.
  final Widget? avatar;
  final bool showAvatarSlot;
  final VoidCallback? onLongPress;

  /// Ekran okuyucu uzun basma eylemi adı ("Mesaj işlemleri").
  final String? longPressLabel;

  /// Basılı tutma süresi (README: 480 ms).
  static const holdDuration = Duration(milliseconds: 480);

  /// Basma geri bildirimi gecikmesi (160 ms).
  static const pressDelay = Duration(milliseconds: 160);

  @override
  State<NzChatBubble> createState() => _NzChatBubbleState();
}

class _NzChatBubbleState extends State<NzChatBubble> {
  Timer? _press;
  Timer? _hold;
  Offset? _down;
  bool _pressed = false;

  @override
  void dispose() {
    _press?.cancel();
    _hold?.cancel();
    super.dispose();
  }

  void _start(PointerDownEvent e) {
    if (widget.onLongPress == null) return;
    _cancel();
    _down = e.position;
    _press = Timer(NzChatBubble.pressDelay, () {
      if (mounted) setState(() => _pressed = true);
    });
    _hold = Timer(NzChatBubble.holdDuration, () {
      _down = null;
      if (!mounted) return;
      setState(() => _pressed = false);
      widget.onLongPress?.call();
    });
  }

  void _move(PointerMoveEvent e) {
    final d = _down;
    if (d == null) return;
    final delta = e.position - d;
    if (delta.dx.abs() > 8 || delta.dy.abs() > 8) _cancel();
  }

  void _cancel() {
    _press?.cancel();
    _hold?.cancel();
    _down = null;
    if (_pressed && mounted) setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final w = widget;
    const big = Radius.circular(NizamioRadius.row);
    const small = Radius.circular(NizamioRadius.bubbleTail);
    final radius = w.mine
        ? BorderRadius.only(
            topLeft: big,
            bottomLeft: big,
            topRight: w.last ? big : small,
            bottomRight: small,
          )
        : BorderRadius.only(
            topRight: big,
            bottomRight: big,
            topLeft: w.last ? big : small,
            bottomLeft: small,
          );
    final name = w.senderName;
    final quote = w.quote;
    final extra = w.extra;
    final edited = w.editedLabel;
    // Kaynak: saat satırı Geist 11/20 `ink-faint`, `margin-top: -2px`.
    final meta = t.monoSm.copyWith(
      color: c.textFaint,
      height: _metaLine / _metaSize,
    );
    final bubble = AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      alignment: w.mine ? Alignment.centerRight : Alignment.centerLeft,
      duration: NzMotion.of(context, NizamioMotion.durExit),
      curve: NizamioMotion.easeSheet,
      child: AnimatedContainer(
        duration: NzMotion.of(context, NizamioMotion.durPress),
        constraints: const BoxConstraints(minWidth: 64),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        decoration: BoxDecoration(
          color: w.mine ? c.bubbleMine : c.bubbleOther,
          borderRadius: radius,
          boxShadow: w.flash
              ? [BoxShadow(color: c.accentText, spreadRadius: 2)]
              : const [],
        ),
        // Balon içeriğinin doğal genişliğindedir (en çok satırın %80'i); satırlar o genişliğe
        // yayılır, saat sağ altta (kaynak `justify-content: flex-end`). Ölçüm yalnız kurulan
        // (görünen) balonlarda yapılır.
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (name != null) ...[
                // Kaynak başlık: `align-items: baseline; gap: 6px`; ad 13/20 600, rol 11/20.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.labelMd.copyWith(
                          height: _metaLine / _nameSize,
                          color: w.senderColor ?? c.text,
                        ),
                      ),
                    ),
                    if (w.senderRole case final role?)
                      // Taban çizgisi satırında `Gap` kuru ölçümü desteklemez; boşluk dolgudadır.
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: _headerGap,
                        ),
                        child: Text(
                          role,
                          maxLines: 1,
                          style: t.caption.copyWith(
                            fontSize: _metaSize,
                            height: _metaLine / _metaSize,
                            color: c.textFaint,
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(NizamioSpacing.space1),
              ],
              if (quote != null) ...[
                _Quote(quote: quote),
                const Gap(NizamioSpacing.space1),
              ],
              w.body,
              if (extra != null) ...[const Gap(NizamioSpacing.space1), extra],
              const Gap(NizamioSpacing.space1 - _metaPull),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: NizamioSpacing.space1,
                  children: [
                    if (edited != null) Text('$edited ·', style: meta),
                    if (w.pinned)
                      NzIcon(
                        Icons.push_pin_outlined,
                        size: 11,
                        color: c.textFaint,
                      ),
                    Text(w.time, style: meta),
                    if (w.tick != NzChatTick.none)
                      NzIcon(
                        w.tick == NzChatTick.sent
                            ? Icons.done_rounded
                            : Icons.done_all_rounded,
                        size: 15,
                        color: w.tick == NzChatTick.read
                            ? c.accentText
                            : c.textFaint,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final content = Semantics(
      container: true,
      label: w.semanticLabel,
      onLongPressHint: w.longPressLabel,
      onLongPress: w.onLongPress,
      child: Listener(
        onPointerDown: _start,
        onPointerMove: _move,
        onPointerUp: (_) => _cancel(),
        onPointerCancel: (_) => _cancel(),
        child: bubble,
      ),
    );
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: w.mine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      spacing: NizamioSpacing.space1,
      children: [
        content,
        if (w.reactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Wrap(
              spacing: NizamioSpacing.space1,
              runSpacing: NizamioSpacing.space1,
              children: [
                for (final r in w.reactions) _ReactionChip(reaction: r),
              ],
            ),
          ),
      ],
    );
    return LayoutBuilder(
      builder: (context, box) => Row(
        mainAxisAlignment: w.mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (w.showAvatarSlot) ...[
            SizedBox.square(
              dimension: 30,
              child: Visibility(
                visible: w.last,
                child: w.avatar ?? const SizedBox.shrink(),
              ),
            ),
            const Gap(NizamioSpacing.space2),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: box.maxWidth * 0.8),
            child: column,
          ),
        ],
      ),
    );
  }
}

class _Quote extends StatelessWidget {
  const _Quote({required this.quote});

  final NzChatQuote quote;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: true,
      label: quote.semanticLabel,
      excludeSemantics: true,
      onTap: quote.onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: quote.onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          decoration: BoxDecoration(
            color: c.quoteFill,
            borderRadius: BorderRadius.circular(NizamioRadius.bubbleTail),
            border: Border(left: BorderSide(color: quote.color, width: 3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                quote.who,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.caption.copyWith(
                  color: quote.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                quote.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.caption.copyWith(color: c.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReactionChip extends StatelessWidget {
  const _ReactionChip({required this.reaction});

  final NzChatReactionChip reaction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final r = reaction;
    final ink = r.mine ? c.accentText : c.textMuted;
    return Semantics(
      button: true,
      selected: r.mine,
      label: '${r.semanticLabel} ${r.count}',
      excludeSemantics: true,
      onTap: r.onTap,
      child: InkWell(
        onTap: r.onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
        child: Container(
          constraints: const BoxConstraints(minHeight: 24),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: r.mine ? c.refChip : c.surface,
            borderRadius: BorderRadius.circular(NizamioRadius.pill),
            border: Border.all(color: r.mine ? c.accentText : c.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: NizamioSpacing.space1,
            children: [
              NzIcon(r.kind.icon(selected: r.mine), size: 13, color: ink),
              Text('${r.count}', style: t.monoSm.copyWith(color: ink)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sohbet akışındaki gün hapı (`.m-daychip`, `day-chip` cam zemin).
class NzChatDayChip extends StatelessWidget {
  const NzChatDayChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(NizamioRadius.pill),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: ColoredBox(
              color: c.dayChip,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                // Kaynak: 12 px, akışın 20 px satır yüksekliği (hap 26).
                child: Text(
                  label,
                  style: context.text.caption.copyWith(
                    height: _metaLine / 12,
                    color: c.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "okunmamış mesajlar" ayırıcısı: kenardan kenara `accent` %8 şerit, iki yanda ince çizgi.
class NzChatNewDivider extends StatelessWidget {
  const NzChatNewDivider(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final line = Expanded(
      child: Container(height: 1, color: c.primary.withValues(alpha: 0.3)),
    );
    // Kaynak: `margin: 10px -12px 6px` (akış dolgusunu aşar), etiket mono 11 / satır 20.
    final strip = Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: c.primary.withValues(alpha: 0.08),
      child: Row(
        children: [
          line,
          const Gap(NizamioSpacing.gapMd),
          Text(
            label,
            style: context.text.monoSm.copyWith(
              height: _metaLine / _metaSize,
              color: c.accentText,
            ),
          ),
          const Gap(NizamioSpacing.gapMd),
          line,
        ],
      ),
    );
    return NzHorizontalBleed(bleed: _dividerBleed, child: strip);
  }
}

// Kaynak balon tipografisi (HTML 1180–1186).
const _nameSize = 13.0;
const _metaSize = 11.0;
const _metaLine = 20.0;
const _headerGap = 6.0;
const _metaPull = 2.0;
const _dividerBleed = 12.0;
