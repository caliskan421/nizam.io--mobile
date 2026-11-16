part of 'detail_actions.dart';

extension TaskDetailFileActions on TaskDetailActions {
  // ---- dosya ------------------------------------------------------------------------------

  /// Dosya satırının işlemleri: görüntüle, indir, adı değiştir, sil.
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
            label: l.uiTasksFileView,
            leading: const NzGlyphIcon(
              NzGlyphs.view,
              size: NizamioSize.iconSizeSm,
            ),
            onTap: () {
              Navigator.of(sheet).pop();
              final task = _task;
              if (task == null) return;
              openTaskArchive(
                context,
                departmentId: task.departmentId ?? task.coordinatorship,
                workItemId: task.id,
                fileId: f.id,
                taskTitle: (id) => _catalog?.task(id)?.title,
              );
            },
          ),
        if (p.canDownloadFile)
          _ListOption(
            label: l.uiTasksFileDownload,
            leading: const NzGlyphIcon(
              NzGlyphs.download,
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
            leading: const NzGlyphIcon(
              NzGlyphs.edit,
              size: NizamioSize.iconSizeSm,
            ),
            onTap: () {
              Navigator.of(sheet).pop();
              _renameFile(f);
            },
          ),
        if (p.canDeleteFile(f))
          _ListOption(
            label: l.uiTasksFileDelete,
            color: c.danger,
            leading: NzGlyphIcon(
              NzGlyphs.delete,
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
    final result = await _ctl.deleteFile(f);
    if (result.ok && context.mounted) {
      ref
        ..invalidate(archiveFoldersControllerProvider)
        ..invalidate(personFilesControllerProvider);
    }
    _report(result, done: l.uiTasksTFileDeleted);
  }
}
