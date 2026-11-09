import 'package:flutter/material.dart';

import '../../../../core/i18n/generated/app_localizations.dart';
import '../../../../core/theme/generated/tokens.gen.dart';
import '../../domain/archive.dart';
import '../../domain/records.dart';

/// Arşiv ekranlarının sayılı/biçimli metinleri (parçalar ARB'den; sayı biçimi `tr`).
extension ArchiveTexts on AppLocalizations {
  /// 205.1 → "205,1".
  String decimal1(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

  /// Boyut: ≥ 1 MB "205,1 MB", altı "300 KB" (en az 1 KB).
  String size(int bytes) {
    final mb = bytes / (1024 * 1024);
    return mb >= 1
        ? '${decimal1(mb)} $uiArchiveMb'
        : '${(bytes / 1024).ceil().clamp(1, 1023)} $uiArchiveKb';
  }

  String files(int n) => '$n $uiArchiveFilesLc';

  /// "227 dosya · 11 klasör".
  String storageCaption(int files, int folders) =>
      '$files $uiArchiveFilesLc · $folders $uiArchiveFoldersLc';

  String sortLabel(ArchiveSort s) => switch (s) {
    ArchiveSort.recent => uiArchiveSortRecent,
    ArchiveSort.name => uiArchiveSortName,
    ArchiveSort.size => uiArchiveSortSize,
  };

  String tagLabel(RecordTag t) => switch (t) {
    RecordTag.ister => uiArchiveTagIster,
    RecordTag.plan => uiArchiveTagPlan,
    RecordTag.girdi => uiArchiveTagGirdi,
    RecordTag.analiz => uiArchiveTagAnaliz,
    RecordTag.cikti => uiArchiveTagCikti,
    RecordTag.sonuc => uiArchiveTagSonuc,
    RecordTag.unknown => uiArchiveTagUnknown,
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

  /// 34 karakterden uzun görev adı kısaltılır.
  String short(String s) => s.length > 34 ? '${s.substring(0, 32)}…' : s;
}

/// Sunucu etiketlerinin token renkleri.
extension ArchiveColors on NizamioColors {
  Color tag(RecordTag t) => switch (t) {
    RecordTag.ister => info,
    RecordTag.plan => warning,
    RecordTag.girdi => textMuted,
    RecordTag.analiz => inProgress,
    RecordTag.cikti => accentText,
    RecordTag.sonuc => success,
    RecordTag.unknown => textFaint,
  };
}

/// Etiket süzgecinde ve yükleme seçiminde sunulan etiketler (sunucunun kapalı kümesi).
const archiveTags = [
  RecordTag.ister,
  RecordTag.plan,
  RecordTag.girdi,
  RecordTag.analiz,
  RecordTag.cikti,
  RecordTag.sonuc,
];
