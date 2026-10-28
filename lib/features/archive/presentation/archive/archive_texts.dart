import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../domain/archive.dart';

/// Arşiv ekranlarının sayılı/biçimli metinleri (parçalar ARB'den; sayı biçimi `tr`).
extension ArchiveTexts on AppLocalizations {
  /// 205.1 → "205,1".
  String decimal1(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

  /// Boyut: ≥ 1 MB "205,1 MB", altı "300 KB" (en az [minKb]).
  String size(double mb, {int minKb = 1}) => mb >= 1
      ? '${decimal1(mb)} $uiArchiveMb'
      : '${(mb * 1000).round().clamp(minKb, 999)} $uiArchiveKb';

  String files(int n) => '$n $uiArchiveFilesLc';

  /// "227 dosya · 11 klasör".
  String storageCaption(int files, int folders) =>
      '$files $uiArchiveFilesLc · $folders $uiArchiveFoldersLc';

  String sortLabel(ArchiveSort s) => switch (s) {
    ArchiveSort.recent => uiArchiveSortRecent,
    ArchiveSort.name => uiArchiveSortName,
    ArchiveSort.size => uiArchiveSortSize,
  };

  String tagLabel(ArchiveTag t) => switch (t) {
    ArchiveTag.field => uiArchiveTagField,
    ArchiveTag.result => uiArchiveTagResult,
    ArchiveTag.data => uiArchiveTagData,
  };

  String tagShort(ArchiveTag t) => switch (t) {
    ArchiveTag.field => uiArchiveTagFieldShort,
    ArchiveTag.result => uiArchiveTagResultShort,
    ArchiveTag.data => uiArchiveTagDataShort,
  };

  String colorLabel(ArchiveTagColor c) => switch (c) {
    ArchiveTagColor.violet => uiArchiveColorViolet,
    ArchiveTagColor.gold => uiArchiveColorGold,
    ArchiveTagColor.green => uiArchiveColorGreen,
    ArchiveTagColor.red => uiArchiveColorRed,
    ArchiveTagColor.gray => uiArchiveColorGray,
  };

  String kindLabel(ArchiveFileKind k) => switch (k) {
    ArchiveFileKind.image => uiArchiveKindImage,
    ArchiveFileKind.document => uiArchiveKindDocument,
    ArchiveFileKind.pdf => uiArchiveKindPdf,
  };

  String kindShort(ArchiveFileKind k) => switch (k) {
    ArchiveFileKind.image => uiArchiveKindImageShort,
    ArchiveFileKind.document => uiArchiveKindDocumentShort,
    ArchiveFileKind.pdf => uiArchiveKindPdfShort,
  };

  /// "21.10.2026 · 14:05".
  String uploadedAt(DateTime d) =>
      '${DateFormat('dd.MM.y', 'tr').format(d)} · ${DateFormat.Hm('tr').format(d)}';

  /// 34 karakterden uzun görev adı kısaltılır.
  String short(String s) => s.length > 34 ? '${s.substring(0, 32)}…' : s;
}

/// Etiket ve renk seçeneklerinin token renkleri.
extension ArchiveColors on NizamioColors {
  Color tag(ArchiveTag t) => switch (t) {
    ArchiveTag.field => inProgress,
    ArchiveTag.result => accentText,
    ArchiveTag.data => textMuted,
  };

  Color custom(ArchiveTagColor c) => switch (c) {
    ArchiveTagColor.violet => inProgress,
    ArchiveTagColor.gold => warning,
    ArchiveTagColor.green => accentText,
    ArchiveTagColor.red => danger,
    ArchiveTagColor.gray => textMuted,
  };
}
