// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_copy_request_mode.dart';
import 'table_copy_request_source_space.dart';

part 'table_copy_request.freezed.dart';
part 'table_copy_request.g.dart';

/// Kopyanın hedefi rotanın alanı ve kapsamıdır (TABLES-K16). `structure` yalnız sütunları alır (0 satır/hücre/ek), kaynakta okuma (viewer ve üstü) ister ve programlar arası olabilir (`source_program_id`). `full` bütün satır, hücre ve aktif ekleri yeni kimliklerle alır, editor ya da sahip ister ve yalnız aynı programdadır. Yeni sahip kopyalayandır; paylaşım, `team_role`, şablon bayrağı ve makbuzlar taşınmaz. Referans hücreleri yalnız hem kaynak hem hedef kapsamda görünen öğeleri tutar. Aktif ekler güncel tavanlara (tek dosya, aktif/tutulan sayı ve bayt) sığmazsa kopya hiç yazılmaz, 409 `tables.attachment_limit_reached`.
@Freezed()
abstract class TableCopyRequest with _$TableCopyRequest {
  const factory TableCopyRequest({
    @JsonKey(name: 'source_table_id') required String sourceTableId,
    @JsonKey(name: 'source_space')
    required TableCopyRequestSourceSpace sourceSpace,
    required TableCopyRequestMode mode,

    /// Verilmezse rotanın programı; verilmişse boş olmayan metin (null/boş 422).
    @JsonKey(name: 'source_program_id') String? sourceProgramId,

    /// Yalnız `coordinatorship` kaynağında zorunlu.
    @JsonKey(name: 'source_department_id') String? sourceDepartmentId,

    /// Verilmezse kaynağın adı; verilmişse geçerli ad (null/boş 422).
    String? name,

    /// Verilmezse kopya projesizdir; verilmişse hedef kapsamdaki silinmemiş proje (kişisel alanda kopyalayanın), null/boş 422.
    @JsonKey(name: 'project_id') String? projectId,
  }) = _TableCopyRequest;

  factory TableCopyRequest.fromJson(Map<String, Object?> json) =>
      _$TableCopyRequestFromJson(json);
}
