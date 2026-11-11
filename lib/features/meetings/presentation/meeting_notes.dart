import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/generated/tokens.gen.dart';
import '../../../core/ui/extensions/context_ext.dart';
import '../../../core/ui/page/nz_app_nav.dart';
import '../../../core/ui/widgets/buttons/buttons.dart';
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

/// Not içeriği tavanı (prototip sayacı; sunucu da karakterle ölçer, COLLABORATION-K27).
const noteMax = 2000;

/// Notlar (prototip Notlar bölümü): süzgeç (Tümü / Göreve dönüşen / Benim), yazma kutusu
/// (toplantıyı gören herkes), not kartları (yazar, rol, saat; düzenle/sil yetkiye göre,
/// COLLABORATION-K28/K29; yöneticiye/bağlı koordinatöre "Göreve dönüştür", K32).
class MeetingNotes extends ConsumerStatefulWidget {
  const MeetingNotes({
    super.key,
    required this.room,
    required this.filter,
    required this.actions,
  });

  final MeetingRoom room;
  final NoteFilter filter;
  final MeetingActions actions;

  @override
  ConsumerState<MeetingNotes> createState() => _MeetingNotesState();
}

class _MeetingNotesState extends ConsumerState<MeetingNotes> {
  final _draft = TextEditingController();

  @override
  void initState() {
    super.initState();
    _draft.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    // Uçuş kilidi denetleyicide (sekme değişince sıfırlanmaz).
    if (_draft.text.trim().isEmpty || widget.room.noteSubmitting) return;
    final sent = _draft.text;
    final ok = await widget.actions.addNote(sent);
    if (!mounted) return;
    if (ok) {
      // Alan uçuşta düzenlenebilir: yalnız gönderilen metin hâlâ duruyorsa temizlenir.
      if (_draft.text == sent) _draft.clear();
      ref
          .read(
            meetingDetailViewControllerProvider(widget.room.meeting.id)
                .notifier,
          )
          .filterNotes(NoteFilter.all);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final room = widget.room;
    final perms = room.permissions;
    final all = room.notes;
    final notes = filterNotes(all, widget.filter, room.me);
    int count(NoteFilter f) => filterNotes(all, f, room.me).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: NizamioSpacing.space3,
      children: [
        NzFilterRail(
          semanticLabel: l.uiMeetingsNfLabel,
          selected: widget.filter.index,
          onSelected: (i) => ref
              .read(
                meetingDetailViewControllerProvider(room.meeting.id).notifier,
              )
              .filterNotes(NoteFilter.values[i]),
          options: [
            for (final f in NoteFilter.values)
              NzFilterOption(label: l.noteFilterLabel(f, count(f))),
          ],
        ),
        if (perms.canAddNote)
          DecoratedBox(
            decoration: BoxDecoration(
              color: c.surfaceRaised,
              borderRadius: BorderRadius.circular(NizamioRadius.row),
            ),
            child: Padding(
              padding: const EdgeInsets.all(NizamioSpacing.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: NizamioSpacing.space2,
                children: [
                  TextField(
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: _draft,
                    minLines: 2,
                    maxLines: 6,
                    maxLength: noteMax,
                    keyboardType: TextInputType.multiline,
                    style: t.bodyLg,
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: '',
                      semanticCounterText: '',
                      border: InputBorder.none,
                      hintText: l.uiMeetingsNoteHint,
                      hintStyle: t.bodyLg.copyWith(color: c.textFaint),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l.uiMeetingsNoteFooter} · '
                          '${_draft.text.length} / $noteMax',
                          style: t.caption.copyWith(
                            fontSize: 11,
                            color: c.textMuted,
                          ),
                        ),
                      ),
                      NzButton.primary(
                        label: l.uiMeetingsAdd,
                        size: NzSize.sm,
                        loading: room.noteSubmitting,
                        onPressed:
                            _draft.text.trim().isEmpty || room.noteSubmitting
                            ? null
                            : _add,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        for (final n in notes)
          _NoteCard(
            key: ValueKey(n.id),
            note: n,
            room: room,
            actions: widget.actions,
          ),
        if (notes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Text(
              widget.filter == NoteFilter.all
                  ? l.uiMeetingsNotesEmpty
                  : l.uiMeetingsNotesEmptyFilter,
              textAlign: TextAlign.center,
              style: t.caption.copyWith(color: c.textMuted),
            ),
          ),
      ],
    );
  }
}

/// Not kartı: avatar, yazar, "rol · saat (· düzenlendi)", düzenle/sil, metin ya da düzenleme
/// alanı, görev hapı.
class _NoteCard extends ConsumerStatefulWidget {
  const _NoteCard({
    super.key,
    required this.note,
    required this.room,
    required this.actions,
  });

  final MeetingNote note;
  final MeetingRoom room;
  final MeetingActions actions;

  @override
  ConsumerState<_NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends ConsumerState<_NoteCard> {
  TextEditingController? _edit;
  var _busy = false;

  @override
  void dispose() {
    _edit?.dispose();
    super.dispose();
  }

  void _startEdit() =>
      setState(() => _edit = TextEditingController(text: widget.note.content));

  void _cancelEdit() {
    final e = _edit;
    setState(() => _edit = null);
    e?.dispose();
  }

  Future<void> _save() async {
    final e = _edit;
    if (e == null || _busy) return;
    setState(() => _busy = true);
    final ok = await widget.actions.updateNote(widget.note, e.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) _cancelEdit();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final t = context.text;
    final n = widget.note;
    final perms = widget.room.permissions;
    final catalog = ref.watch(taskCatalogControllerProvider).value;
    final day = meetingDay(widget.room.meeting);
    final created = n.createdAt.toLocal();
    final sameDay =
        dayDiff(DateTime(created.year, created.month, created.day), day) == 0;
    final edited = n.updatedAt.difference(n.createdAt).inSeconds > 1;
    final meta = [
      l.meetingRole(n.authorRole),
      if (sameDay)
        l.meetingTime(n.createdAt)
      else
        '${l.meetingDayMonth(n.createdAt)} ${l.meetingTime(n.createdAt)}',
      if (edited) l.uiMeetingsEdited,
    ].join(' · ');
    final task = n.convertedToWorkItemId;
    final edit = _edit;
    return NzCard.outlined(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Row(
            children: [
              NzAvatar.initials(
                name: n.authorName,
                tone: NzAvatar.toneOf(n.authorName),
                extent: NzAvatarSize.md,
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySm.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      meta,
                      style: t.monoSm.copyWith(
                        fontSize: 11,
                        color: c.textFaint,
                      ),
                    ),
                  ],
                ),
              ),
              if (edit == null && perms.canEditNote(n))
                NzIconButton(
                  icon: NzIcons.edit,
                  semanticLabel: l.uiMeetingsNoteEdit,
                  onPressed: _startEdit,
                ),
              if (perms.canDeleteNote(n))
                NzIconButton(
                  icon: NzIcons.delete,
                  semanticLabel: l.uiMeetingsNoteDelete,
                  onPressed: () => widget.actions.deleteNote(n),
                ),
            ],
          ),
          if (edit == null)
            Text(n.content, style: t.bodyMd.copyWith(height: 21 / 14))
          else ...[
            NzTextField.multiline(
              label: l.uiMeetingsNoteEdit,
              controller: edit,
              maxLength: noteMax,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: NizamioSpacing.space2,
              children: [
                NzButton.secondary(
                  label: l.uiMeetingsCancel,
                  size: NzSize.sm,
                  onPressed: _cancelEdit,
                ),
                NzButton.primary(
                  label: l.uiMeetingsSave,
                  size: NzSize.sm,
                  loading: _busy,
                  onPressed: _save,
                ),
              ],
            ),
          ],
          if (task != null)
            Align(
              alignment: Alignment.centerLeft,
              child: _NoteChip(
                icon: NzIcons.check,
                label: [
                  l.uiMeetingsConverted,
                  ?catalog?.task(task)?.displayCode,
                ].join(' · '),
                accent: true,
                onTap: () => context.appNav.openTask(task),
              ),
            )
          else if (perms.canConvertNote(n))
            Align(
              alignment: Alignment.centerLeft,
              child: _NoteChip(
                icon: NzIcons.tasks,
                label: l.uiMeetingsToTask,
                onTap: () => widget.actions.convertNote(n),
              ),
            ),
        ],
      ),
    );
  }
}

/// Not altındaki hap düğme (prototip "Göreve dönüştür" / "Göreve dönüştü · ALT-7").
class _NoteChip extends StatelessWidget {
  const _NoteChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.accent = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = accent ? c.accentText : c.text;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: accent ? c.primary.withValues(alpha: .14) : c.surfaceRaised,
        shape: StadiumBorder(
          side: accent ? BorderSide.none : BorderSide(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NzIcon(icon, size: 14, color: fg),
                  const Gap(6),
                  Text(
                    label,
                    style: context.text.caption.copyWith(
                      fontSize: 12,
                      color: fg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
