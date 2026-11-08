import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/errors/api_error.dart';
import '../../../core/errors/error_text.dart';
import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/layout/nz_layout.dart';
import '../../../core/ui/layout/nz_pane.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/page/nz_page.dart';
import '../../../core/ui/state/nz_async_view.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
import '../../../core/ui/widgets/feedback/feedback.dart';
import '../../../core/ui/widgets/inputs/inputs.dart';
import '../../../core/ui/widgets/lists/lists.dart';
import '../../../core/ui/widgets/navigation/navigation.dart';
import '../../../core/ui/widgets/nz_icons.dart';
import '../../../core/ui/widgets/overlays/overlays.dart';
import '../../tasks/tasks.dart';
import '../application/meeting_room_controller.dart';
import '../domain/meeting.dart';
import 'meeting_agenda.dart';
import 'meeting_hero.dart';
import 'meeting_info.dart';
import 'meeting_notes.dart';
import 'meeting_people.dart';
import 'meetings_texts.dart';

/// Toplantı ayrıntısı (prototip `mdetail`, telefon ve tablet sağ bölmesi): "toplantı" etiketli cam
/// üst çubuk + diğer işlemler, kimlik, konferans kartı, yapışkan segmentli bölümler (Gündem,
/// Notlar, Kişiler, Bilgi). Veri `getMeeting` + not sayfalarından; yazmalar sunucuya gider.
class MeetingPage extends ConsumerWidget {
  const MeetingPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final value = ref.watch(meetingRoomControllerProvider(id));
    final room = value.value;
    final view = ref.watch(meetingDetailViewControllerProvider(id));
    final actions = MeetingActions(context, ref, id);
    void retry() => ref.invalidate(meetingRoomControllerProvider(id));
    final d = room?.detail;
    final counts = d == null
        ? null
        : (
            agenda:
                '${d.agenda.where((a) => a.isChecked).length}/${d.agenda.length}',
            notes: room!.notes.length,
            people: d.participants.length,
          );
    return NzPage.feed(
      width: NzContentWidth.wide,
      paneLead: NizamioSpacing.space4,
      onRetry: retry,
      onRefresh: () =>
          ref.read(meetingRoomControllerProvider(id).notifier).refresh(),
      topBar: NzTopBar.detail(
        // Toplantının adı (yüklenene kadar boş).
        title: room?.meeting.title,
        actions: [
          if (room?.extras.chatId case final chat?)
            NzIconButton(
              icon: NzIcons.messages,
              semanticLabel: l.uiMeetingsChat,
              onPressed: () => context.appNav.openChat(chat),
            ),
          if (room != null && room.permissions.canManage)
            NzIconButton(
              icon: NzIcons.more,
              semanticLabel: l.uiMeetingsMore,
              onPressed: actions.openMore,
            ),
        ],
      ),
      pinned: counts == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 10),
              child: NzPillTabs(
                semanticLabel: l.uiMeetingsTabsLabel,
                selected: view.section.index,
                onSelected: (i) => ref
                    .read(meetingDetailViewControllerProvider(id).notifier)
                    .select(MeetingSection.values[i]),
                tabs: [
                  for (final s in MeetingSection.values)
                    NzPillTab(
                      label: l.meetingSectionLabel(s),
                      countText: switch (s) {
                        MeetingSection.agenda => counts.agenda,
                        MeetingSection.notes => '${counts.notes}',
                        MeetingSection.people => '${counts.people}',
                        MeetingSection.info => null,
                      },
                    ),
                ],
              ),
            ),
      afterKey: ValueKey(view.section),
      after: room == null
          ? const []
          : [
              const Gap(NizamioSpacing.space2),
              switch (view.section) {
                MeetingSection.agenda => MeetingAgenda(
                  room: room,
                  actions: actions,
                ),
                MeetingSection.notes => MeetingNotes(
                  room: room,
                  filter: view.noteFilter,
                  actions: actions,
                ),
                MeetingSection.people => MeetingPeople(
                  room: room,
                  actions: actions,
                ),
                MeetingSection.info => MeetingInfo(room: room),
              },
            ],
      children: [
        if (room != null) ...[
          MeetingHero(room: room),
          const Gap(18),
          MeetingConferenceCard(room: room, actions: actions),
        ] else
          NzAsyncView<MeetingRoom>(
            value: value,
            onRetry: retry,
            data: (_) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}

/// Ayrıntı eylemleri: sunucu komutları, onaylar ve sonuç bildirimleri (prototip `say`).
class MeetingActions {
  MeetingActions(this.context, this.ref, this.id);

  final BuildContext context;
  final WidgetRef ref;
  final String id;

  MeetingRoomController get _ctl =>
      ref.read(meetingRoomControllerProvider(id).notifier);

  MeetingRoom? get _room => ref.read(meetingRoomControllerProvider(id)).value;

  void say(String msg) {
    if (context.mounted) NzToast.show(context, msg);
  }

  /// Hata varsa metnini, yoksa [done]'ı bildirir (sayfa kapanmışsa hiçbiri).
  void report(Object? error, {String? done}) {
    if (!context.mounted) return;
    final l = context.l10n;
    if (error case final ApiError e) {
      say(errorText(l, e));
    } else if (done != null) {
      say(done);
    }
  }

  // ---- konferans ---------------------------------------------------------------------------

  Future<void> startConference() async {
    final done = context.l10n.uiMeetingsTConfStarted;
    report(await _ctl.startConference(), done: done);
  }

  Future<void> endConference() async {
    final done = context.l10n.uiMeetingsTConfEnded;
    report(await _ctl.endConference(), done: done);
  }

  /// Görüntülü görüşme ekranı henüz yok (ürün kararı): katılım token'ı istenmez.
  void joinConference() => say(context.l10n.uiMeetingsConfJoinSoon);

  // ---- menü ---------------------------------------------------------------------------------

  void openMore() {
    final l = context.l10n;
    NzBottomSheet.show<void>(
      context,
      title: l.uiMeetingsMore,
      showHeader: false,
      builder: (sheet) {
        NzMenuRow row(
          IconData icon,
          String label,
          VoidCallback then, {
          bool danger = false,
        }) => NzMenuRow(
          icon: icon,
          label: label,
          danger: danger,
          onTap: () {
            Navigator.of(sheet).pop();
            then();
          },
        );
        return NzMenuGroup(
          rows: [
            row(NzIcons.edit, l.uiMeetingsMenuEdit, _edit),
            row(NzIcons.delete, l.uiMeetingsMenuDelete, _delete, danger: true),
          ],
        );
      },
    );
  }

  Future<void> _edit() async {
    final m = _room?.meeting;
    if (m == null) return;
    await showMeetingSheet(
      context,
      edit: MeetingSeed(
        id: m.id,
        title: m.title,
        at: m.meetingDate.toLocal(),
        departmentIds: [for (final d in ownerFirst(m)) d.id],
        membersIncluded: m.membersIncluded,
      ),
    );
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final live = _room?.detail.conference != null;
    final yes = await NzDialog.confirm(
      context,
      title: l.uiMeetingsDeleteQ,
      message: live
          ? '${l.uiMeetingsDeleteDesc}\n\n${l.uiMeetingsDeleteLive}'
          : l.uiMeetingsDeleteDesc,
      confirmLabel: l.uiMeetingsMenuDelete,
      cancelLabel: l.uiMeetingsCancel,
      tone: NzDialogTone.destructive,
    );
    if (!yes || !context.mounted) return;
    final e = await _ctl.deleteMeeting();
    if (!context.mounted) return;
    if (e != null) return report(e);
    say(l.uiMeetingsTDeleted);
    // Silinen kayıt açık kalmaz: üst çubuktaki "Geri" ile aynı iş (bölme/yığın/gezgin).
    NzPaneScope.back(context);
  }

  // ---- gündem / notlar / kişiler ----------------------------------------------------------

  Future<void> toggleAgenda(AgendaItem a) async =>
      report(await _ctl.toggleAgenda(a));

  Future<bool> addAgenda(String title) async {
    final e = await _ctl.addAgenda(title);
    report(e);
    return e == null;
  }

  Future<void> deleteAgenda(AgendaItem a) async {
    final done = context.l10n.uiMeetingsTAgendaDeleted;
    report(await _ctl.deleteAgenda(a), done: done);
  }

  Future<bool> addNote(String text) async {
    final e = await _ctl.addNote(text);
    report(e);
    return e == null;
  }

  Future<bool> updateNote(MeetingNote n, String text) async {
    final e = await _ctl.updateNote(n, text);
    report(e);
    return e == null;
  }

  Future<void> deleteNote(MeetingNote n) async {
    final l = context.l10n;
    final yes = await NzDialog.confirm(
      context,
      title: l.uiMeetingsNoteDeleteQ,
      confirmLabel: l.uiMeetingsDelete,
      cancelLabel: l.uiMeetingsCancel,
      tone: NzDialogTone.destructive,
    );
    if (!yes) return;
    report(await _ctl.deleteNote(n), done: l.uiMeetingsTNoteDeleted);
  }

  /// Notu göreve dönüştürür: yeni görev formu nottan kipinde açılır (başlık nottan, hedef sahip
  /// departman); sunucu notu göreve bağlar, ayrıntı yeniden okunur.
  Future<void> convertNote(MeetingNote n) async {
    final m = _room?.meeting;
    if (m == null) return;
    await showNewTaskSheet(
      context,
      note: n.id,
      title: n.content,
      coordinatorship: m.ownerDepartmentId,
    );
  }

  Future<void> addParticipants(List<MeetingParticipant> people) async {
    final l = context.l10n;
    final r = await _ctl.addParticipants(people);
    if (r.added == 0 && r.error != null) return report(r.error);
    say(l.participantsAdded(r.added, r.failed));
  }

  Future<void> removeParticipant(String accountId, String name) async {
    final done = '$name ${context.l10n.uiMeetingsTRemovedTail}';
    report(await _ctl.removeParticipant(accountId), done: done);
  }
}
