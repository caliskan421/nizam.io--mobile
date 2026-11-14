// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'table_space.dart';
import 'table_team_role.dart';

part 'table.freezed.dart';
part 'table.g.dart';

@Freezed()
abstract class Table with _$Table {
  const factory Table({
    required String id,

    /// Tabloyu oluşturan hesap; sahiplik devredilmez (TABLES-K02).
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    @JsonKey(name: 'program_id') required String programId,

    /// Koordinatörlük alanında tablonun departmanı; kişisel alanda boş metin (TABLES-K11).
    @JsonKey(name: 'department_id') required String departmentId,

    /// Çalışma alanı (TABLES-K11). `personal` program içi, departmansız ve `/v1/personal/tables` rotalarıyla; `coordinatorship` departmanlı ve `/v1/tables` rotalarıyla erişilir. Bir alanın tablo kimliği diğer alanın rotasında 404'tür.
    required TableSpace space,

    /// Sütun şeması her değiştiğinde artar; sütun komutları bunu `expected_schema` olarak gönderir (TABLES-K08).
    @JsonKey(name: 'schema_version') required int schemaVersion,

    /// Tablonun işlem sırası; yeni sütun ve satır konumu bu sıradan gelir.
    required int sequence,

    /// Yalnız koordinatörlük alanında, sahibin açtığı dinamik departman ekibi paylaşımı (TABLES-K12). Yoksa paylaşım kapalıdır. Rol her istekte güncel ekip satırından türetilir; üyeler açık paylaşıma kopyalanmaz. Koordinatörlük ve şirket yöneticiliği tek başına erişim vermez.
    @JsonKey(name: 'team_role') TableTeamRole? teamRole,

    /// Tablonun bağlı olduğu silinmemiş proje (TABLES-K13); proje silinince alan dönmez.
    @JsonKey(name: 'project_id') String? projectId,

    /// Sahibin koyduğu şablon bayrağı (TABLES-K16). Erişimi genişletmez: şablon listesi (`template=true`) aynı ACL süzgecindedir. Kopyalar şablon değildir.
    @JsonKey(name: 'is_template') bool? isTemplate,
  }) = _Table;

  factory Table.fromJson(Map<String, Object?> json) => _$TableFromJson(json);
}
