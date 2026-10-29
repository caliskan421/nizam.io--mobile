import 'package:meta/meta.dart';

import '../../scope/scope.dart' show Program;

/// Program oluşturma sonucu: aynı ad varsa sunucu mevcut programı döner ([created] `false`).
@immutable
final class ProgramCreation {
  const ProgramCreation({required this.program, required this.created});

  final Program program;

  /// Yeni kayıt açıldı mı (yanıtta yoksa `false`).
  final bool created;

  @override
  bool operator ==(Object other) =>
      other is ProgramCreation &&
      other.program == program &&
      other.created == created;

  @override
  int get hashCode => Object.hash(program, created);
}

/// Dönem sıfırlama sonucu (`ProgramResetResult`): silinen içerik sayıları.
@immutable
final class ProgramReset {
  const ProgramReset({
    required this.programId,
    required this.tasks,
    required this.files,
    required this.messages,
    required this.meetings,
  });

  final String programId;
  final int tasks;
  final int files;
  final int messages;
  final int meetings;

  @override
  bool operator ==(Object other) =>
      other is ProgramReset &&
      other.programId == programId &&
      other.tasks == tasks &&
      other.files == files &&
      other.messages == messages &&
      other.meetings == meetings;

  @override
  int get hashCode => Object.hash(programId, tasks, files, messages, meetings);
}

/// Programlar arası aktarım ön izlemesi (`TransferPreview`, salt okunur). [blockers] ve
/// [warnings] sunucu kodlarıdır (olduğu gibi). Yürütmede [fingerprint] geri gönderilir.
@immutable
final class TransferPreview {
  TransferPreview({
    required List<String> resolvedWorkItemIds,
    required this.fileCount,
    required this.fileTotalBytes,
    required this.preservedDependencyCount,
    required this.missingAccess,
    required List<String> blockers,
    required List<String> warnings,
    required this.canExecute,
    required this.fingerprint,
    List<String> unresolvedWorkItemIds = const [],
    List<String> missingFileIds = const [],
    List<String> cutDependencyIds = const [],
    List<String> cycleWorkItemIds = const [],
  }) : resolvedWorkItemIds = List.unmodifiable(resolvedWorkItemIds),
       blockers = List.unmodifiable(blockers),
       warnings = List.unmodifiable(warnings),
       unresolvedWorkItemIds = List.unmodifiable(unresolvedWorkItemIds),
       missingFileIds = List.unmodifiable(missingFileIds),
       cutDependencyIds = List.unmodifiable(cutDependencyIds),
       cycleWorkItemIds = List.unmodifiable(cycleWorkItemIds);

  final List<String> resolvedWorkItemIds;
  final int fileCount;
  final int fileTotalBytes;
  final int preservedDependencyCount;

  /// Hedef programda departman bağı eksik mi (yürütmede `addMissingAccess` ile eklenebilir).
  final bool missingAccess;
  final List<String> blockers;
  final List<String> warnings;
  final bool canExecute;

  /// `preview_fingerprint`: yürütme isteğine aynen geri verilir.
  final String fingerprint;
  final List<String> unresolvedWorkItemIds;
  final List<String> missingFileIds;
  final List<String> cutDependencyIds;
  final List<String> cycleWorkItemIds;
}

/// Aktarım (ya da ters aktarım) yürütme sonucu (`TransferResult`).
@immutable
final class TransferOutcome {
  TransferOutcome({
    required this.transferId,
    required List<String> movedWorkItemIds,
    required this.movedFileCount,
    required this.cutDependencyCount,
    required this.restoredDependencyCount,
    required List<String> grantedLinks,
    required List<String> revokedLinks,
    required List<String> retainedLinks,
    required this.replayed,
    List<String> skippedWorkItemIds = const [],
  }) : movedWorkItemIds = List.unmodifiable(movedWorkItemIds),
       grantedLinks = List.unmodifiable(grantedLinks),
       revokedLinks = List.unmodifiable(revokedLinks),
       retainedLinks = List.unmodifiable(retainedLinks),
       skippedWorkItemIds = List.unmodifiable(skippedWorkItemIds);

  final String transferId;
  final List<String> movedWorkItemIds;
  final int movedFileCount;
  final int cutDependencyCount;
  final int restoredDependencyCount;
  final List<String> grantedLinks;
  final List<String> revokedLinks;
  final List<String> retainedLinks;

  /// Aynı tekrar anahtarı + aynı gövdeyle ilk sonuç yeniden döndü mü.
  final bool replayed;
  final List<String> skippedWorkItemIds;
}

/// Aktarım geçmişi kaydı (`TransferHistoryItem`).
@immutable
final class TransferRecord {
  TransferRecord({
    required this.transferId,
    required this.sourceProgramId,
    required this.targetProgramId,
    required this.departmentId,
    required List<String> workItemIds,
    required this.movedItemCount,
    required this.movedFileCount,
    required this.cutDependencyCount,
    required this.restoredDependencyCount,
    required this.createdAt,
    List<String> skippedWorkItemIds = const [],
    this.reversesTransferId,
  }) : workItemIds = List.unmodifiable(workItemIds),
       skippedWorkItemIds = List.unmodifiable(skippedWorkItemIds);

  final String transferId;
  final String sourceProgramId;
  final String targetProgramId;
  final String departmentId;
  final List<String> workItemIds;
  final int movedItemCount;
  final int movedFileCount;
  final int cutDependencyCount;
  final int restoredDependencyCount;
  final DateTime createdAt;
  final List<String> skippedWorkItemIds;

  /// Doluysa bu kayıt o aktarımın tersidir.
  final String? reversesTransferId;
}
