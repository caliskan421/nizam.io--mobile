import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../tasks/tasks.dart';
import '../application/active_conference.dart';
import '../application/conference_controller.dart';
import '../application/meeting_room_controller.dart';
import '../domain/conference.dart';
import 'conference_stage.dart';
import 'conference_tiles.dart';

/// Görüntülü görüşme ekranı (kabuk dışı tam ekran, `/conference/:id`): üstte canlı rozeti,
/// kişi sayısı, başlık ve süre; katılımcı ızgarası; alt çubuk (mikrofon, kamera, çevir, panel,
/// ayrıl). Panel (Gündem/Notlar/Kişiler) tablette sağ sütun, telefonda alt sayfadır. Ekran
/// kapanınca (geri ya da küçült) görüşme sürer ve mini pencere görünür; oda yalnız "Ayrıl" ile
/// kapanır.
class ConferencePage extends ConsumerStatefulWidget {
  const ConferencePage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ConferencePage> createState() => _ConferencePageState();
}

class _ConferencePageState extends ConsumerState<ConferencePage> {
  /// Açık panel bölümü (null → kapalı).
  MeetingSection? _panel;
  Timer? _tick;
  late final ActiveConferenceController _active = ref.read(
    activeConferenceControllerProvider.notifier,
  );

  ConferenceController get _ctl =>
      ref.read(conferenceControllerProvider(widget.id).notifier);

  @override
  void initState() {
    super.initState();
    // Süre satırı dakikada bir yenilenir.
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _active.screen(widget.id, open: true);
      final phase = ref.read(conferenceControllerProvider(widget.id)).phase;
      if (phase != ConferencePhase.connected &&
          phase != ConferencePhase.reconnecting) {
        _ctl.join();
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    final active = _active;
    final id = widget.id;
    // Ağaç kurulurken sağlayıcı yazılmaz: kapanış bir sonraki mikro görevde.
    scheduleMicrotask(() => active.screen(id, open: false));
    super.dispose();
  }

  void _close() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      context.appNav.openMeeting(widget.id);
    }
  }

  Future<void> _leave() async {
    final view = ref.read(conferenceControllerProvider(widget.id));
    if (!view.canEnd) {
      await _ctl.leave();
      if (mounted) _close();
      return;
    }
    // Yetkili: yalnız ayrıl ya da herkes için bitir.
    final l = context.l10n;
    final choice = await NzBottomSheet.show<ConferenceEnd>(
      context,
      title: l.uiMeetingsCallLeave,
      showHeader: false,
      builder: (sheet) => NzMenuGroup(
        rows: [
          NzMenuRow(
            icon: NzIcons.callEnd,
            label: l.uiMeetingsCallLeave,
            onTap: () => Navigator.of(sheet).pop(ConferenceEnd.left),
          ),
          NzMenuRow(
            icon: NzIcons.close,
            label: l.uiMeetingsCallEnd,
            danger: true,
            onTap: () => Navigator.of(sheet).pop(ConferenceEnd.endedForAll),
          ),
        ],
      ),
    );
    if (!mounted || choice == null) return;
    if (choice == ConferenceEnd.left) {
      await _ctl.leave();
      if (mounted) _close();
      return;
    }
    final yes = await NzDialog.confirm(
      context,
      title: l.uiMeetingsCallEndQ,
      message: l.uiMeetingsCallEndDesc,
      confirmLabel: l.uiMeetingsCallEnd,
      cancelLabel: l.uiMeetingsCancel,
      tone: NzDialogTone.destructive,
    );
    if (!yes || !mounted) return;
    final e = await _ctl.endForAll();
    if (!mounted) return;
    if (e != null) return NzToast.show(context, errorText(l, e));
    _close();
  }

  void _togglePanel([MeetingSection section = MeetingSection.people]) =>
      setState(() => _panel = _panel == null ? section : null);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final view = ref.watch(conferenceControllerProvider(widget.id));
    final room = ref.watch(meetingRoomControllerProvider(widget.id)).value;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final names = ConferenceNames(l, room, catalog);
    final title = room?.meeting.title ?? l.uiMeetingsCallLabel;
    final Widget body = switch (view.phase) {
      ConferencePhase.connected ||
      ConferencePhase.reconnecting => ConferenceStage(
        id: widget.id,
        view: view,
        title: title,
        startedAt: room?.detail.conference?.startedAt,
        names: names,
        panel: _panel,
        onPanel: (s) => setState(() => _panel = s),
        commands: (
          mic: _ctl.toggleMic,
          camera: _ctl.toggleCamera,
          flip: _ctl.flipCamera,
          share: _ctl.toggleScreenShare,
          panel: _togglePanel,
          notes: () => setState(
            () => _panel = _panel == MeetingSection.notes
                ? null
                : MeetingSection.notes,
          ),
          minimize: _close,
          leave: _leave,
          dismiss: _ctl.dismissIssues,
        ),
      ),
      ConferencePhase.failed => _Notice(
        message: view.error == null
            ? l.uiMeetingsCallLost
            : errorText(l, view.error!),
        retry: _ctl.join,
        back: _close,
      ),
      ConferencePhase.ended => _Notice(
        message: switch (view.end) {
          ConferenceEnd.endedForAll => l.uiMeetingsCallEndedForAll,
          ConferenceEnd.closed => l.uiMeetingsCallClosed,
          ConferenceEnd.removed => l.uiMeetingsCallRemoved,
          ConferenceEnd.replaced => l.uiMeetingsCallReplaced,
          ConferenceEnd.lost => l.uiMeetingsCallLost,
          ConferenceEnd.left || null => l.uiMeetingsCallLeft,
        },
        retry: switch (view.end) {
          ConferenceEnd.left ||
          ConferenceEnd.lost ||
          ConferenceEnd.replaced => _ctl.join,
          _ => null,
        },
        back: _close,
      ),
      ConferencePhase.idle || ConferencePhase.connecting => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NzLoader(),
            const Gap(NizamioSpacing.space3),
            Text(
              l.uiMeetingsCallConnecting,
              style: context.text.bodyMd.copyWith(color: c.textMuted),
            ),
          ],
        ),
      ),
    };
    return NzPage.bare(
      body: ColoredBox(
        color: c.background,
        child: SafeArea(child: body),
      ),
    );
  }
}

/// Bağlanamadı / bitti görünümü: açıklama, (uygunsa) yeniden katıl, toplantıya dön.
class _Notice extends StatelessWidget {
  const _Notice({required this.message, required this.back, this.retry});

  final String message;
  final VoidCallback back;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NizamioSpacing.space6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NzIconTile(icon: NzIcons.video),
              const Gap(NizamioSpacing.space4),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.text.bodyLg,
              ),
              const Gap(NizamioSpacing.space6),
              if (retry != null) ...[
                NzButton.primary(
                  label: l.uiMeetingsCallRejoin,
                  icon: NzIcons.video,
                  expand: true,
                  onPressed: retry,
                ),
                const Gap(NizamioSpacing.space2),
              ],
              NzButton.secondary(
                label: l.uiMeetingsCallBack,
                expand: true,
                onPressed: back,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
