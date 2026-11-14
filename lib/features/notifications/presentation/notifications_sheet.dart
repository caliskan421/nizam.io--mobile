import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/nz_size.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/notifications_controller.dart';
import '../domain/app_notification.dart';
import '../domain/notification_groups.dart';
import 'notifications_texts.dart';

/// Zilin okuyucu etiketi ve okunmamış noktası (`countUnreadNotifications`); kök üst çubuk ve
/// tablet rayı aynı kaynağı okur. Sayı bilinmiyorsa (yükleniyor/hata) nokta yok.
({String label, bool dot}) watchNotificationBell(
  BuildContext context,
  WidgetRef ref,
) {
  final unread = ref.watch(
    notificationUnreadControllerProvider.select((v) => v.value),
  );
  return (
    label: context.l10n.notificationBellLabel(unread),
    dot: (unread ?? 0) > 0,
  );
}

/// Zile dokunuş: bildirim listesi alt sayfada (tablette `NzBottomSheet` ortada modal). Kapanınca
/// rozet yeniden okunur; hedefi olan bildirime dokunulduysa sayfa kapanıp kayıt açılır.
Future<void> showNotifications(BuildContext context) async {
  final nav = context.appNav;
  final container = ProviderScope.containerOf(context, listen: false);
  final target = await NzBottomSheet.show<NotificationSubject>(
    context,
    title: context.l10n.uiNotificationsTitle,
    headerAction: const _MarkAll(),
    builder: (_) => const NotificationsList(),
  );
  if (container.exists(notificationUnreadControllerProvider)) {
    unawaited(
      container.read(notificationUnreadControllerProvider.notifier).refresh(),
    );
  }
  switch (target?.link) {
    case NotificationLink.task:
      nav.openTask(target!.id);
    case NotificationLink.meeting:
      nav.openMeeting(target!.id);
    case NotificationLink.none || null:
      break;
  }
}

/// Bildirim satırları: başlıklara gruplanır (Görevler, Tarih talepleri, Toplantılar, Ekip),
/// art arda aynı olay tek satırda "×N" ([groupNotifications]). İlk yükleme, hata ve boş durumu
/// ortak bileşenlerden ([NzAsyncView]); sonraki sayfa dokunuşla, hatası satır içi.
class NotificationsList extends ConsumerWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ctl = ref.read(notificationsControllerProvider.notifier);
    return NzAsyncView<NotificationsView>(
      value: ref.watch(notificationsControllerProvider),
      onRetry: () => unawaited(ctl.refresh()),
      loading: const NzSkeleton.list(),
      isEmpty: (v) => v.items.isEmpty,
      empty: NzEmptyState(
        icon: NzIcons.bell,
        title: l.uiNotificationsEmptyTitle,
        message: l.uiNotificationsEmptyMessage,
      ),
      data: (v) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final s in groupNotifications(v.items)) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: NizamioSpacing.space3,
                bottom: NizamioSpacing.space1,
              ),
              child: NzKicker(l.notificationGroupLabel(s.group)),
            ),
            for (final b in s.bundles) _Row(b, key: ValueKey(b.latest.id)),
          ],
          if (v.moreError case final error?)
            NzErrorState.inline(
              error: error,
              onRetry: () => unawaited(ctl.loadMore()),
            )
          else if (v.hasMore)
            Padding(
              padding: const EdgeInsets.only(top: NizamioSpacing.space3),
              child: NzButton.secondary(
                label: l.uiNotificationsMore,
                loading: v.loadingMore,
                onPressed: v.loadingMore
                    ? null
                    : () => unawaited(ctl.loadMore()),
              ),
            ),
        ],
      ),
    );
  }
}

class _Row extends ConsumerWidget {
  const _Row(this.b, {super.key});

  /// Art arda aynı olaylar; satır en yenisini gösterir.
  final NotificationBundle b;

  AppNotification get n => b.latest;

  IconData get _icon => switch (n.subject.link) {
    NotificationLink.task => NzIcons.tasks,
    NotificationLink.meeting => NzIcons.video,
    NotificationLink.none => NzIcons.bell,
  };

  /// Birleşen okunmamışların hepsi okundu yapılır; hedefi varsa sayfa hedefle kapanır (okundu
  /// hatası gezinmeyi engellemez, ilki bildirilir). Rotası olmayan bildirim yalnız okundu olur.
  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final routable = n.subject.link != NotificationLink.none;
    final ctl = ref.read(notificationsControllerProvider.notifier);
    ApiError? error;
    for (final id in b.unreadIds) {
      final e = await ctl.markRead(
        id,
      ); // her biri gönderilir; yalnız ilk hata saklanır
      error ??= e;
    }
    if (!context.mounted) return;
    if (error != null) NzToast.error(context, error);
    if (routable) Navigator.of(context).pop(n.subject);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    void open() => unawaited(_open(context, ref));
    final dot = !b.hasUnread
        ? null
        : Semantics(
            label: l.uiNotificationsUnreadBadge,
            child: Container(
              width: NizamioSize.dot,
              height: NizamioSize.dot,
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
              ),
            ),
          );
    final leading = NzIconTile(
      icon: _icon,
      color: b.hasUnread ? c.primary : null,
    );
    final title = b.count > 1
        ? '${l.notificationTitle(n.type)} ×${b.count}'
        : l.notificationTitle(n.type);
    // Konu başlığı: görev bildiriminde katalogdaki "KOD · başlık" (yoksa yalnız zaman).
    final task = n.subject.link == NotificationLink.task
        ? ref
              .watch(taskCatalogControllerProvider)
              .value
              ?.tasks
              .where((t) => t.id == n.subject.id)
              .firstOrNull
        : null;
    final when = l.notificationWhen(n.createdAt);
    final subtitle = task == null
        ? when
        : '${task.code} · ${task.title} · $when';
    return n.subject.link != NotificationLink.none
        ? NzListTile.navigation(
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: dot,
            onTap: open,
          )
        : NzListTile(
            leading: leading,
            title: title,
            subtitle: subtitle,
            trailing: dot,
            onTap: b.hasUnread ? open : null,
          );
  }
}

/// Başlık satırındaki "Tümünü okundu yap": okunmamış varken etkin; başarıda kısa onay.
class _MarkAll extends ConsumerStatefulWidget {
  const _MarkAll();

  @override
  ConsumerState<_MarkAll> createState() => _MarkAllState();
}

class _MarkAllState extends ConsumerState<_MarkAll> {
  bool _busy = false;

  Future<void> _run() async {
    setState(() => _busy = true);
    final error = await ref
        .read(notificationsControllerProvider.notifier)
        .markAllRead();
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      NzToast.error(context, error);
    } else {
      NzToast.success(context, context.l10n.uiNotificationsMarkedAll);
    }
  }

  @override
  Widget build(BuildContext context) {
    final view = ref.watch(notificationsControllerProvider).value;
    final unread = ref.watch(
      notificationUnreadControllerProvider.select((v) => v.value ?? 0),
    );
    final enabled = view != null && (view.hasUnread || unread > 0);
    return NzButton.ghost(
      label: context.l10n.uiNotificationsMarkAll,
      size: NzSize.sm,
      loading: _busy,
      onPressed: enabled && !_busy ? () => unawaited(_run()) : null,
    );
  }
}
