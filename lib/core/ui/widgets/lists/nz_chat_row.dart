import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/generated/tokens.gen.dart';
import '../../extensions/context_ext.dart';
import '../buttons/nz_pressable.dart';
import '../surfaces/nz_avatar.dart';

/// Son mesajın okundu durumu (yalnız kendi son mesajında çift tik).
enum NzChatTick { none, sent, delivered, read }

/// 52 px sohbet avatarı: kişi için daire (`avatar-1…5`, [tone]), grup için `m-r-group` köşeli
/// `bg-overlay` kutu; isteğe bağlı çevrimiçi noktası. Sohbet üst çubuğu ve bilgi sayfası da
/// aynı biçimi farklı boyda kullanır.
class NzChatAvatar extends StatelessWidget {
  const NzChatAvatar({
    super.key,
    required this.initials,
    this.group = false,
    this.tone = 0,
    this.extent = 52,
    this.online = false,
  });

  final String initials;
  final bool group;

  /// `avatar-1…5` sırası (0–4); grupta yok sayılır.
  final int tone;
  final double extent;
  final bool online;

  /// Kişi ya da grup adından en çok iki baş harf (ilk iki sözcük; Türkçe büyük harf). Tek
  /// sözcüklü grup adı tek harf.
  static String initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    String up(String s) =>
        s.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
    return words
        .take(2)
        .map((w) => up(String.fromCharCode(w.runes.first)))
        .join();
  }

  /// [tone] sırasının dolgu rengi.
  static Color toneColor(BuildContext context, int tone) {
    final c = context.colors;
    final fills = [c.avatar1, c.avatar2, c.avatar3, c.avatar4, c.avatar5];
    return fills[tone % NzAvatar.toneCount];
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final fill = group ? c.surfaceOverlay : toneColor(context, tone);
    final ink = group ? c.text : c.onAvatar;
    final radius = group
        ? BorderRadius.circular(extent * NizamioRadius.group / 52)
        : BorderRadius.circular(extent / 2);
    final dot = extent * 12 / 52;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: extent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(color: fill, borderRadius: radius),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(NizamioSpacing.space1),
                      child: Text(
                        initials,
                        maxLines: 1,
                        style: (extent >= 52 ? t.list : t.caption).copyWith(
                          color: ink,
                          fontWeight: group ? FontWeight.w600 : FontWeight.w700,
                          fontSize: extent * 15 / 52,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (online)
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: dot,
                  height: dot,
                  decoration: BoxDecoration(
                    color: c.accentText,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.background, width: 2.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Mesajlar listesindeki sohbet satırı (tasarım sistemi `components/ChatRow`, `.m-chatrow`):
/// 52 px avatar, ad (kalın, tek satır) + saat (mono; okunmamışta `accent-text`), son mesaj
/// (okunmamışta `ink`, değilse `ink-muted`) ve kendi son mesajında çift tik (okunduysa
/// `accent-text`), `@` bahsetme rozeti, okunmamış sayısı (`m-unread`, lime). Satırın alt
/// çizgisi metin sütunundadır. Ekran okuyucuya tek düğme: ad, son mesaj, saat, okunmamış.
class NzChatRow extends StatelessWidget {
  const NzChatRow({
    super.key,
    required this.name,
    required this.initials,
    required this.preview,
    required this.time,
    required this.onTap,
    this.group = false,
    this.tone = 0,
    this.online = false,
    this.unread = 0,
    this.mention = false,
    this.muted = false,
    this.tick = NzChatTick.none,
    this.semanticHint,
  });

  final String name;
  final String initials;
  final String preview;
  final String time;
  final VoidCallback onTap;
  final bool group;
  final int tone;
  final bool online;
  final int unread;
  final bool mention;

  /// Sessize alınmış: okunmamış rozeti gri (`m-unread--muted`).
  final bool muted;
  final NzChatTick tick;

  /// Ekran okuyucu ek açıklaması (ör. "2 okunmamış").
  final String? semanticHint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final hasUnread = unread > 0;
    final badgeFill = muted ? c.surfaceOverlay : c.primary;
    final badgeInk = muted ? c.text : c.onPrimary;
    Widget badge(String label) => Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: badgeFill,
        borderRadius: BorderRadius.circular(NizamioRadius.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: t.monoSm.copyWith(color: badgeInk, fontWeight: FontWeight.w600),
      ),
    );
    return Semantics(
      button: true,
      label: [name, preview, time, ?semanticHint].join(', '),
      excludeSemantics: true,
      child: NzPressable(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(NizamioRadius.row),
          child: Padding(
            padding: const EdgeInsets.all(NizamioSpacing.space2),
            child: Row(
              children: [
                NzChatAvatar(
                  initials: initials,
                  group: group,
                  tone: tone,
                  online: online,
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: c.border)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.list.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Gap(NizamioSpacing.space2),
                              Text(
                                time,
                                maxLines: 1,
                                style: t.monoSm.copyWith(
                                  color: hasUnread ? c.accentText : c.textFaint,
                                ),
                              ),
                            ],
                          ),
                          const Gap(3),
                          Row(
                            children: [
                              if (tick != NzChatTick.none) ...[
                                Icon(
                                  tick == NzChatTick.sent
                                      ? Icons.done_rounded
                                      : Icons.done_all_rounded,
                                  size: NizamioSize.iconSizeSm,
                                  color: tick == NzChatTick.read
                                      ? c.accentText
                                      : c.textFaint,
                                ),
                                const Gap(NizamioSpacing.space1),
                              ],
                              Expanded(
                                child: Text(
                                  preview,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.bodyMd.copyWith(
                                    color: hasUnread ? c.text : c.textMuted,
                                  ),
                                ),
                              ),
                              if (mention) ...[
                                const Gap(NizamioSpacing.space2),
                                Container(
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: c.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '@',
                                    style: t.caption.copyWith(
                                      color: c.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                              if (hasUnread) ...[
                                const Gap(NizamioSpacing.space2),
                                badge('$unread'),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
