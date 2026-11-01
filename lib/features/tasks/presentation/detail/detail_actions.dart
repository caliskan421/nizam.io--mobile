import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/errors/error_text.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../../../core/ui/extensions/context_ext.dart';
import '../../../../core/ui/widgets/feedback/feedback.dart';
import '../../../../core/ui/widgets/inputs/inputs.dart';
import '../../../../core/ui/widgets/nz_icon.dart';
import '../../../../core/ui/widgets/nz_icons.dart';
import '../../../../core/ui/widgets/overlays/overlays.dart';
import '../../../../core/ui/widgets/surfaces/surfaces.dart';
import '../../application/task_catalog_controller.dart';
import '../../application/task_detail_controller.dart';
import '../../application/tasks_providers.dart';
import '../../domain/task_catalog.dart';
import '../../domain/task_permissions.dart';
import '../../domain/task_query.dart';
import '../task_texts.dart';
import '../task_widgets.dart';
import 'detail_forms.dart';

/// Ayrıntı ekranının eylemleri: denetleyici komutu + prototipteki sonuç bildirimi ve alt
/// sayfalar. Sayfa her çizimde kurar; geri çağrılar sayfa bağlamıyla çalışır. Sunucu yazması
/// sonucu [_report] ile bildirilir (hata metni hata kodundan).
class TaskDetailActions {
  TaskDetailActions(this.context, this.ref, this.code);

  final BuildContext context;
  final WidgetRef ref;
  final String code;

  TaskDetailControllerProvider get _p => taskDetailControllerProvider(code);
  TaskDetailController get _ctl => ref.read(_p.notifier);
  TaskCatalog? get _catalog => ref.read(taskCatalogControllerProvider).value;
  TaskItem? get _task => _catalog?.task(code);

  String _name(String id) =>
      _catalog?.nameOf(id) ?? context.l10n.uiTasksUnknownPerson;

  void _say(String msg) {
    if (context.mounted) NzToast.show(context, msg);
  }

  // ---- durum / öncelik / menü -------------------------------------------------------------

  TaskPermissions get _perms => _ctl.permissions;

  /// Görev düzenle/öncelik/kopyala/sil (yönetici ya da koordinatör).
  bool get canManageTask => _perms.canManageTask;

  /// Tarih talebi aç (yalnız kapsam koordinatörü).
  bool get canRequestDate => _perms.canRequestDate;

  /// Tarih talebi kararı (yalnız şirket yöneticisi).
  bool get canReviewDate => _perms.canReviewDate;

  /// Kanıt yükle (koordinatör ya da atanmış üye; yöneticilik reddeder).
  bool get canUpload => _perms.canUpload;

  /// Silmeyi geri al yalnız örnekte.
  bool get canUndoDelete => _perms.local;

  /// Durum seçicisi açılabilir mi (aktörün geçerli durumdan en az bir hedefi var).
  bool get canChangeStatus {
    final t = _task;
    return t != null && _ctl.permissions.statusTargets(t.status).isNotEmpty;
  }

  /// Durum seçici: geçerli durum + aktörün matristeki hedefleri (örnekte her durum).
  void openStatus() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    final c = context.colors;
    final targets = _ctl.permissions.statusTargets(t.status);
    final open = t.subtasks.where((u) => !u.done).length;
    _listSheet(
      title: l.uiTasksSheetStatus,
      builder: (sheet) => [
        for (final s in TaskStatus.known)
          if (s == t.status || targets.contains(s))
            _ListOption(
              label: l.statusLabel(s),
              leading: NzDot(color: statusTone(s).color(c)),
              hint: s == TaskStatus.done && open > 0 && !t.isDone
                  ? '$open ${l.uiTasksOpenSubsTail}'
                  : null,
              selected: s == t.status,
              onTap: () {
                Navigator.of(sheet).pop();
                _setStatus(s);
              },
            ),
      ],
    );
  }

  Future<void> _setStatus(
    TaskStatus s, {
    String? reason,
    bool closeSubtasks = false,
  }) async {
    final t = _task;
    if (t == null) return;
    final key = t.displayCode;
    final r = await _ctl.setStatus(
      s,
      reason: reason,
      closeSubtasks: closeSubtasks,
    );
    if (!context.mounted) return;
    final l = context.l10n;
    switch (r.kind) {
      case WriteKind.reasonRequired:
        await _askRevertReason(s);
      case WriteKind.subtasksOpen:
        // Kullanıcı kararı: onaylarsa aynı geçiş close_subtasks ile yeniden gönderilir.
        final yes = await _confirm(
          title: l.uiTasksCloseSubsTitle,
          description: l.uiTasksCloseSubsDesc,
          ok: l.uiTasksCloseSubsOk,
        );
        if (yes && context.mounted) {
          await _setStatus(s, reason: reason, closeSubtasks: true);
        }
      case WriteKind.blockedBySubtasks:
        _say(
          '${l.uiTasksTSubsBlock} · ${t.subtasksDone}/${t.subtasks.length} '
          '${l.uiTasksTFinishedLc}',
        );
      case WriteKind.blockedByEvidence:
        _say(l.uiTasksTEvidenceBlock);
      case WriteKind.done:
        _say('$key · ${l.statusLabel(s)}');
      case _:
        _report(r);
    }
  }

  /// `tamamlandi`'dan çıkış gerekçesi (en az [revertReasonMinLength] karakter).
  Future<void> _askRevertReason(TaskStatus s) async {
    final l = context.l10n;
    final reason = await _askText(
      title: l.uiTasksRevertTitle,
      description: l.uiTasksRevertDesc,
      label: l.uiTasksReason,
      hint: l.uiTasksRevertHint,
      helper: l.uiTasksRevertMin,
      ok: l.uiTasksRevertOk,
      valid: (v) => v.trim().length >= revertReasonMinLength,
    );
    if (reason != null && context.mounted) {
      await _setStatus(s, reason: reason);
    }
  }

  /// Yazma sonucunun ortak bildirimi: hata → hata kodunun metni; başarı → [done] (varsa);
  /// [WriteKind.invalid] → kısa "yapılamıyor" iletisi.
  void _report(WriteOutcome r, {String? done}) {
    if (!context.mounted) return;
    switch (r.kind) {
      case WriteKind.failed || WriteKind.subtasksOpen:
        final e = r.error;
        if (e != null) _say(errorText(context.l10n, e));
      case WriteKind.done:
        if (done != null) _say(done);
      case WriteKind.invalid:
        // İstek gönderilmedi (eylem açık değil / girdi geçersiz): sessiz kalınmaz.
        _say(context.l10n.uiTasksTUnavailable);
      case _:
        break;
    }
  }

  /// Onay alt sayfası; onaylanırsa true.
  Future<bool> _confirm({
    required String title,
    required String description,
    required String ok,
    bool danger = false,
  }) async {
    final l = context.l10n;
    var yes = false;
    await NzBottomSheet.show<void>(
      context,
      title: title,
      description: description,
      actions: (sheet) => sheetActions(
        sheet,
        cancel: l.uiTasksCancel,
        ok: ok,
        danger: danger,
        onOk: () {
          yes = true;
          Navigator.of(sheet).pop();
        },
      ),
      builder: (_) => const SizedBox.shrink(),
    );
    return yes;
  }

  /// Tek metin alanlı alt sayfa; onaylanırsa kırpılmış metin, vazgeçilirse null. [valid]
  /// sağlanmadan sayfa kapanmaz.
  Future<String?> _askText({
    required String title,
    required String description,
    required String label,
    required String ok,
    String? hint,
    String? helper,
    String initial = '',
    bool Function(String)? valid,
  }) async {
    final l = context.l10n;
    final controller = TextEditingController(text: initial);
    String? result;
    try {
      await NzBottomSheet.show<void>(
        context,
        title: title,
        description: description,
        actions: (sheet) => sheetActions(
          sheet,
          cancel: l.uiTasksCancel,
          ok: ok,
          onOk: () {
            final v = controller.text.trim();
            if (v.isEmpty || !(valid?.call(v) ?? true)) return;
            result = v;
            Navigator.of(sheet).pop();
          },
        ),
        builder: (_) => NzTextField(
          label: label,
          hint: hint,
          helper: helper,
          controller: controller,
          textInputAction: TextInputAction.done,
        ),
      );
    } finally {
      controller.dispose();
    }
    return result;
  }

  void openPriority() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    _listSheet(
      title: l.uiTasksSheetPriority,
      builder: (sheet) => [
        for (final p in TaskPriority.pickable.reversed)
          _ListOption(
            label: l.priorityLabel(p),
            leading: NzPriorityBars(level: priorityLevel(p)),
            selected: p == t.priority,
            onTap: () async {
              Navigator.of(sheet).pop();
              _report(
                await _ctl.setPriority(p),
                done: '${l.uiTasksPriority}: ${l.priorityLabel(p)}',
              );
            },
          ),
      ],
    );
  }

  void openMenu() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    final c = context.colors;
    final p = _perms;
    _listSheet(
      // Türkçe küçük harf (İDA-2 → ida-2; `toLowerCase` noktalı i üretir).
      title: trLower(code),
      builder: (sheet) => [
        if (p.canClaim(t))
          _ListOption(
            label: l.uiTasksClaim,
            leading: const NzIcon(NzIcons.person, size: NizamioSize.iconSizeSm),
            onTap: () async {
              Navigator.of(sheet).pop();
              _report(await _ctl.claim(), done: l.uiTasksTClaimed);
            },
          ),
        if (p.canUnclaim(t))
          _ListOption(
            label: l.uiTasksUnclaim,
            leading: const NzIcon(NzIcons.person, size: NizamioSize.iconSizeSm),
            onTap: () async {
              Navigator.of(sheet).pop();
              _report(await _ctl.unclaim(), done: l.uiTasksTUnclaimed);
            },
          ),
        if (p.canManageTask) ...[
          _ListOption(
            label: l.uiTasksEditTask,
            leading: const NzIcon(NzIcons.edit, size: NizamioSize.iconSizeSm),
            onTap: () {
              Navigator.of(sheet).pop();
              openEdit();
            },
          ),
          _ListOption(
            label: l.uiTasksCopy,
            leading: const NzIcon(NzIcons.copy, size: NizamioSize.iconSizeSm),
            onTap: () async {
              Navigator.of(sheet).pop();
              final (r, newCode) = await _ctl.copy(l.uiTasksCopySuffix);
              final key = newCode == null
                  ? ''
                  : _catalog?.task(newCode)?.displayCode ?? newCode;
              _report(
                r,
                done:
                    '$key ${l.uiTasksTCreatedTail} · ${t.title} '
                    '${l.uiTasksCopySuffix}',
              );
            },
          ),
          _ListOption(
            label: l.uiTasksDeleteTask,
            color: c.danger,
            leading: NzIcon(
              NzIcons.delete,
              size: NizamioSize.iconSizeSm,
              color: c.danger,
            ),
            onTap: () {
              Navigator.of(sheet).pop();
              openDelete();
            },
          ),
        ],
      ],
    );
  }

  Future<void> _listSheet({
    required String title,
    required List<Widget> Function(BuildContext sheet) builder,
  }) => NzBottomSheet.show<void>(
    context,
    title: title,
    compact: true,
    builder: (sheet) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: builder(sheet),
    ),
  );

  // ---- formlar ----------------------------------------------------------------------------

  /// Form alt sayfası: [submit] başarıda ([WriteKind.done]/[WriteKind.unchanged]) sayfayı
  /// kapatır ve [success] bildirilir; doğrulama hatasında sayfa açık kalır (hatalar formda);
  /// sunucu hatasında metin hata kodundan, sayfa açık kalır (karar kullanıcının; 409'da görev
  /// zaten yeniden okunmuştur). Uçuştaki istekte ikinci dokunuş istek göndermez.
  Future<void> _form({
    required String title,
    required String description,
    required String ok,
    required Future<WriteOutcome> Function() submit,
    required String Function() success,
    required Widget body,
    bool danger = false,
  }) async {
    final l = context.l10n;
    String? msg;
    await NzBottomSheet.show<void>(
      context,
      title: title,
      description: description,
      actions: (sheet) => sheetActions(
        sheet,
        cancel: l.uiTasksCancel,
        ok: ok,
        danger: danger,
        onOk: () async {
          final text = success();
          final r = await submit();
          switch (r.kind) {
            case WriteKind.done || WriteKind.unchanged:
              if (r.ok) msg = text;
              if (sheet.mounted) Navigator.of(sheet).pop();
            case WriteKind.failed:
              final e = r.error;
              if (e != null && context.mounted) {
                _say(errorText(context.l10n, e));
              }
            case _:
              break;
          }
        },
      ),
      builder: (_) => body,
    );
    if (!context.mounted) return;
    _ctl.closeForms();
    final m = msg;
    if (m != null) _say(m);
  }

  /// Sunucu görevinde form, görev taze okunduktan sonra açılır; okuma hatası → form açılmaz,
  /// hata iletisi gösterilir.
  Future<void> openEdit() async {
    if (_task == null || !canManageTask) return;
    final r = await _ctl.openEdit();
    if (!context.mounted) return;
    if (!r.ok) {
      _report(r);
      return;
    }
    final l = context.l10n;
    await _form(
      title: l.uiTasksEditTask,
      description: '${_task?.displayCode ?? code} · ${l.uiTasksEditDescTail}',
      ok: l.uiTasksSave,
      submit: _ctl.submitEdit,
      success: () => '${_task?.displayCode ?? code} ${l.uiTasksTUpdatedTail}',
      body: EditTaskForm(code: code),
    );
  }

  void openDateRequest() {
    final l = context.l10n;
    if (!_ctl.openDateRequest()) {
      _say(l.uiTasksTPendingExists);
      return;
    }
    _form(
      title: l.uiTasksRequestDate,
      description: l.uiTasksDateDesc,
      ok: l.uiTasksSendRequest,
      submit: _ctl.submitDateRequest,
      success: () => l.uiTasksTRequestSent,
      body: DateRequestForm(code: code),
    );
  }

  void openUpload() {
    if (_task == null) return;
    final l = context.l10n;
    if (!_ctl.openUpload()) return;
    _form(
      title: l.uiTasksUploadTitle,
      description: l.uiTasksUploadDesc,
      ok: l.uiTasksUploadOk,
      submit: _ctl.submitUpload,
      success: () => l.uiTasksTUploaded,
      body: UploadForm(code: code, onPick: pickUploadFile),
    );
  }

  /// Sistem seçicisinden dosya (sunucu yükleme formu); seçici yoksa bildirilir.
  Future<void> pickUploadFile() async {
    if (!ref.read(uploadPickerProvider).available) {
      _say(context.l10n.uiTasksPickerMissing);
      return;
    }
    await _ctl.pickUploadFile();
  }

  void openDelete() {
    final t = _task;
    if (t == null) return;
    final l = context.l10n;
    final key = t.displayCode;
    _form(
      title: '$key ${l.uiTasksDeleteQTail}',
      description: l.uiTasksDeleteDesc,
      ok: l.uiTasksDeleteOk,
      danger: true,
      submit: _ctl.delete,
      success: () => l.uiTasksTDeleted,
      body: Text(
        '“${t.title}” ${l.uiTasksDeleteBodyTail}',
        style: context.text.bodyMd,
      ),
    );
  }

  // ---- dosya ------------------------------------------------------------------------------

  /// Dosya satırının işlemleri (yetkiye göre): indir, adı değiştir, sil.
  void openFile(TaskFile f) {
    final l = context.l10n;
    final c = context.colors;
    final p = _perms;
    if (!p.canDownloadFile && !p.canRenameFile(f) && !p.canDeleteFile(f)) {
      return;
    }
    _listSheet(
      title: f.name,
      builder: (sheet) => [
        if (p.canDownloadFile)
          _ListOption(
            label: l.uiTasksFileDownload,
            leading: const NzIcon(
              NzIcons.uploadFile,
              size: NizamioSize.iconSizeSm,
            ),
            onTap: () async {
              Navigator.of(sheet).pop();
              final (r, _) = await _ctl.downloadFile(f);
              _report(r, done: '${l.uiTasksTFileSaved} · ${f.name}');
            },
          ),
        if (p.canRenameFile(f))
          _ListOption(
            label: l.uiTasksFileRename,
            leading: const NzIcon(NzIcons.edit, size: NizamioSize.iconSizeSm),
            onTap: () {
              Navigator.of(sheet).pop();
              _renameFile(f);
            },
          ),
        if (p.canDeleteFile(f))
          _ListOption(
            label: l.uiTasksFileDelete,
            color: c.danger,
            leading: NzIcon(
              NzIcons.delete,
              size: NizamioSize.iconSizeSm,
              color: c.danger,
            ),
            onTap: () {
              Navigator.of(sheet).pop();
              _deleteFile(f);
            },
          ),
      ],
    );
  }

  Future<void> _renameFile(TaskFile f) async {
    final l = context.l10n;
    final name = await _askText(
      title: l.uiTasksFileRename,
      description: f.name,
      label: l.uiTasksFileNameLabel,
      ok: l.uiTasksSave,
      initial: f.name,
    );
    if (name == null || !context.mounted) return;
    _report(await _ctl.renameFile(f, name), done: l.uiTasksTFileRenamed);
  }

  Future<void> _deleteFile(TaskFile f) async {
    final l = context.l10n;
    final yes = await _confirm(
      title: l.uiTasksFileDeleteQ,
      description: l.uiTasksFileDeleteDesc,
      ok: l.uiTasksDeleteOk,
      danger: true,
    );
    if (!yes || !context.mounted) return;
    _report(await _ctl.deleteFile(f), done: l.uiTasksTFileDeleted);
  }

  // ---- talep, hatırlatma, silme ------------------------------------------------------------

  Future<void> approveRequest() async {
    final r = _task?.dateRequest;
    if (r == null) return;
    final l = context.l10n;
    _report(
      await _ctl.approveRequest(),
      done:
          '${l.uiTasksTApproved} · ${_task?.displayCode ?? code} '
          '${l.uiTasksTNewDue} ${TaskDates.full(r.due)}',
    );
  }

  Future<void> rejectRequest() async {
    final r = _task?.dateRequest;
    if (r == null) return;
    final l = context.l10n;
    _report(
      await _ctl.rejectRequest(),
      done:
          '${l.uiTasksTRejected} · '
          '${r.by == null ? '' : _name(r.by!)} ${l.uiTasksTInformed}',
    );
  }

  void remind() {
    final t = _task;
    if (t == null) return;
    _say(
      '${context.l10n.uiTasksTReminded} · '
      '${t.assignees.map(_name).join(', ')}',
    );
  }

  void undoDelete() {
    _ctl.undoDelete();
    _say('$code ${context.l10n.uiTasksTRestoredTail}');
  }

  // ---- alt görev, not ---------------------------------------------------------------------

  Future<void> toggleSubtask(String id) async =>
      _report(await _ctl.toggleSubtask(id));

  /// Alt görev ekle: örnek katalogda satır içi; sunucuda başlık alt sayfası → oluştur.
  Future<void> addSubtask() async {
    if (_ctl.permissions.local) {
      _ctl.addSubtask();
      return;
    }
    final l = context.l10n;
    final title = await _askText(
      title: l.uiTasksSubAdd,
      description: l.uiTasksSubsHint,
      label: l.uiTasksSubName,
      ok: l.uiTasksCreate,
    );
    if (title == null || !context.mounted) return;
    _report(await _ctl.createSubtask(title), done: l.uiTasksTSubAdded);
  }

  Future<void> renameSubtask(Subtask u) async {
    final l = context.l10n;
    final title = await _askText(
      title: l.uiTasksSubRename,
      description: l.uiTasksSubName,
      label: l.uiTasksSubName,
      ok: l.uiTasksSave,
      initial: u.title,
    );
    if (title == null || !context.mounted) return;
    _report(await _ctl.renameSubtask(u.id, title));
  }

  Future<void> setSubtaskAssignee(String id, String? person) async =>
      _report(await _ctl.setSubtaskAssignee(id, person));

  Future<void> setSubtaskStart(String id, DateTime? d) async =>
      _report(await _ctl.setSubtaskStart(id, d));

  Future<void> setSubtaskEnd(String id, DateTime? d) async =>
      _report(await _ctl.setSubtaskEnd(id, d));

  Future<void> clearSubtaskDates(String id) async =>
      _report(await _ctl.clearSubtaskDates(id));

  Future<void> removeSubtask(String id) async {
    final key = _task?.displayCode ?? code;
    final (r, u) = await _ctl.removeSubtask(id);
    if (!context.mounted) return;
    final l = context.l10n;
    _report(
      r,
      done: u == null
          ? null
          : '“${u.title.isEmpty ? l.uiTasksSubUntitled : u.title}” $key '
                '${l.uiTasksTSubRemovedTail}'
                '${u.evidence != null ? ' · ${l.uiTasksTSubFileKept}' : ''}',
    );
  }

  Future<void> sendNote() async {
    final r = await _ctl.sendNote();
    if (context.mounted) _report(r);
  }

  Future<void> editNote(TaskNote note) async {
    final l = context.l10n;
    final text = await _askText(
      title: l.uiTasksNoteEditTitle,
      description: note.text.length > 40
          ? '${note.text.substring(0, 40)}…'
          : note.text,
      label: l.uiTasksNoteHint,
      ok: l.uiTasksSave,
      initial: note.text,
    );
    if (text == null || !context.mounted) return;
    final r = await _ctl.editNote(note, text);
    if (context.mounted) _report(r, done: l.uiTasksTNoteSaved);
  }

  Future<void> deleteNote(TaskNote note) async {
    final l = context.l10n;
    final yes = await _confirm(
      title: l.uiTasksNoteDeleteQ,
      description: l.uiTasksNoteDeleteDesc,
      ok: l.uiTasksDeleteOk,
      danger: true,
    );
    if (!yes || !context.mounted) return;
    final r = await _ctl.deleteNote(note);
    if (context.mounted) _report(r, done: l.uiTasksTNoteDeleted);
  }

  void addNoteToMemory(int i) {
    if (_ctl.addNoteToMemory(i)) _say(context.l10n.uiTasksTNoteMemory);
  }
}

/// Liste tipi alt sayfa satırı (prototip `.rp-menuitem`).
class _ListOption extends StatelessWidget {
  const _ListOption({
    required this.label,
    required this.leading,
    required this.onTap,
    this.hint,
    this.selected = false,
    this.color,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;
  final String? hint;
  final bool selected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final hint = this.hint;
    return Semantics(
      button: true,
      selected: selected,
      label: [label, ?hint].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NizamioRadius.tile),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: NizamioSize.row),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NizamioSpacing.space2,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: NizamioSize.iconSize,
                  child: Center(child: leading),
                ),
                const Gap(NizamioSpacing.space3),
                Expanded(
                  child: Text(
                    label,
                    style: t.list.copyWith(
                      color: color ?? c.text,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (hint != null) ...[
                  const Gap(NizamioSpacing.space2),
                  Text(hint, style: t.caption.copyWith(color: c.textMuted)),
                ],
                if (selected) ...[
                  const Gap(NizamioSpacing.space2),
                  NzIcon(
                    NzIcons.check,
                    size: NizamioSize.iconSizeSm,
                    color: c.accentText,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
