// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Table {

 String get id;/// Tabloyu oluşturan hesap; sahiplik devredilmez (TABLES-K02).
@JsonKey(name: 'owner_id') String get ownerId; String get name;@JsonKey(name: 'program_id') String get programId;/// Koordinatörlük alanında tablonun departmanı; kişisel alanda boş metin (TABLES-K11).
@JsonKey(name: 'department_id') String get departmentId;/// Çalışma alanı (TABLES-K11). `personal` program içi, departmansız ve `/v1/personal/tables` rotalarıyla; `coordinatorship` departmanlı ve `/v1/tables` rotalarıyla erişilir. Bir alanın tablo kimliği diğer alanın rotasında 404'tür.
 TableSpace get space;/// Sütun şeması her değiştiğinde artar; sütun komutları bunu `expected_schema` olarak gönderir (TABLES-K08).
@JsonKey(name: 'schema_version') int get schemaVersion;/// Tablonun işlem sırası; yeni sütun ve satır konumu bu sıradan gelir.
 int get sequence;/// Yalnız koordinatörlük alanında, sahibin açtığı dinamik departman ekibi paylaşımı (TABLES-K12). Yoksa paylaşım kapalıdır. Rol her istekte güncel ekip satırından türetilir; üyeler açık paylaşıma kopyalanmaz. Koordinatörlük ve şirket yöneticiliği tek başına erişim vermez.
@JsonKey(name: 'team_role') TableTeamRole? get teamRole;/// Tablonun bağlı olduğu silinmemiş proje (TABLES-K13); proje silinince alan dönmez.
@JsonKey(name: 'project_id') String? get projectId;/// Sahibin koyduğu şablon bayrağı (TABLES-K16). Erişimi genişletmez: şablon listesi (`template=true`) aynı ACL süzgecindedir. Kopyalar şablon değildir.
@JsonKey(name: 'is_template') bool? get isTemplate;
/// Create a copy of Table
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCopyWith<Table> get copyWith => _$TableCopyWithImpl<Table>(this as Table, _$identity);

  /// Serializes this Table to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Table;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Table&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.departmentId, _this.departmentId) || other.departmentId == _this.departmentId)&&(identical(other.space, _this.space) || other.space == _this.space)&&(identical(other.schemaVersion, _this.schemaVersion) || other.schemaVersion == _this.schemaVersion)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence)&&(identical(other.teamRole, _this.teamRole) || other.teamRole == _this.teamRole)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.isTemplate, _this.isTemplate) || other.isTemplate == _this.isTemplate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Table;
  return Object.hash(runtimeType,_this.id,_this.ownerId,_this.name,_this.programId,_this.departmentId,_this.space,_this.schemaVersion,_this.sequence,_this.teamRole,_this.projectId,_this.isTemplate);
}

@override
String toString() {
  final _this = this as Table;
  return 'Table(id: ${_this.id}, ownerId: ${_this.ownerId}, name: ${_this.name}, programId: ${_this.programId}, departmentId: ${_this.departmentId}, space: ${_this.space}, schemaVersion: ${_this.schemaVersion}, sequence: ${_this.sequence}, teamRole: ${_this.teamRole}, projectId: ${_this.projectId}, isTemplate: ${_this.isTemplate})';
}


}

/// @nodoc
abstract mixin class $TableCopyWith<$Res>  {
  factory $TableCopyWith(Table value, $Res Function(Table) _then) = _$TableCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, TableSpace space,@JsonKey(name: 'schema_version') int schemaVersion, int sequence,@JsonKey(name: 'team_role') TableTeamRole? teamRole,@JsonKey(name: 'project_id') String? projectId,@JsonKey(name: 'is_template') bool? isTemplate
});




}
/// @nodoc
class _$TableCopyWithImpl<$Res>
    implements $TableCopyWith<$Res> {
  _$TableCopyWithImpl(this._self, this._then);

  final Table _self;
  final $Res Function(Table) _then;

/// Create a copy of Table
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? programId = null,Object? departmentId = null,Object? space = null,Object? schemaVersion = null,Object? sequence = null,Object? teamRole = freezed,Object? projectId = freezed,Object? isTemplate = freezed,}) {
  return _then(Table(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as TableSpace,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,teamRole: freezed == teamRole ? _self.teamRole : teamRole // ignore: cast_nullable_to_non_nullable
as TableTeamRole?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,isTemplate: freezed == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Table].
extension TablePatterns on Table {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Table value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Table() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Table value)  $default,){
final _that = this;
switch (_that) {
case _Table():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Table value)?  $default,){
final _that = this;
switch (_that) {
case _Table() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  TableSpace space, @JsonKey(name: 'schema_version')  int schemaVersion,  int sequence, @JsonKey(name: 'team_role')  TableTeamRole? teamRole, @JsonKey(name: 'project_id')  String? projectId, @JsonKey(name: 'is_template')  bool? isTemplate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Table() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.programId,_that.departmentId,_that.space,_that.schemaVersion,_that.sequence,_that.teamRole,_that.projectId,_that.isTemplate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  TableSpace space, @JsonKey(name: 'schema_version')  int schemaVersion,  int sequence, @JsonKey(name: 'team_role')  TableTeamRole? teamRole, @JsonKey(name: 'project_id')  String? projectId, @JsonKey(name: 'is_template')  bool? isTemplate)  $default,) {final _that = this;
switch (_that) {
case _Table():
return $default(_that.id,_that.ownerId,_that.name,_that.programId,_that.departmentId,_that.space,_that.schemaVersion,_that.sequence,_that.teamRole,_that.projectId,_that.isTemplate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'department_id')  String departmentId,  TableSpace space, @JsonKey(name: 'schema_version')  int schemaVersion,  int sequence, @JsonKey(name: 'team_role')  TableTeamRole? teamRole, @JsonKey(name: 'project_id')  String? projectId, @JsonKey(name: 'is_template')  bool? isTemplate)?  $default,) {final _that = this;
switch (_that) {
case _Table() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.programId,_that.departmentId,_that.space,_that.schemaVersion,_that.sequence,_that.teamRole,_that.projectId,_that.isTemplate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Table implements Table {
  const _Table({required this.id, @JsonKey(name: 'owner_id') required this.ownerId, required this.name, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'department_id') required this.departmentId, required this.space, @JsonKey(name: 'schema_version') required this.schemaVersion, required this.sequence, @JsonKey(name: 'team_role') this.teamRole, @JsonKey(name: 'project_id') this.projectId, @JsonKey(name: 'is_template') this.isTemplate});
  factory _Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);

@override final  String id;
/// Tabloyu oluşturan hesap; sahiplik devredilmez (TABLES-K02).
@override@JsonKey(name: 'owner_id') final  String ownerId;
@override final  String name;
@override@JsonKey(name: 'program_id') final  String programId;
/// Koordinatörlük alanında tablonun departmanı; kişisel alanda boş metin (TABLES-K11).
@override@JsonKey(name: 'department_id') final  String departmentId;
/// Çalışma alanı (TABLES-K11). `personal` program içi, departmansız ve `/v1/personal/tables` rotalarıyla; `coordinatorship` departmanlı ve `/v1/tables` rotalarıyla erişilir. Bir alanın tablo kimliği diğer alanın rotasında 404'tür.
@override final  TableSpace space;
/// Sütun şeması her değiştiğinde artar; sütun komutları bunu `expected_schema` olarak gönderir (TABLES-K08).
@override@JsonKey(name: 'schema_version') final  int schemaVersion;
/// Tablonun işlem sırası; yeni sütun ve satır konumu bu sıradan gelir.
@override final  int sequence;
/// Yalnız koordinatörlük alanında, sahibin açtığı dinamik departman ekibi paylaşımı (TABLES-K12). Yoksa paylaşım kapalıdır. Rol her istekte güncel ekip satırından türetilir; üyeler açık paylaşıma kopyalanmaz. Koordinatörlük ve şirket yöneticiliği tek başına erişim vermez.
@override@JsonKey(name: 'team_role') final  TableTeamRole? teamRole;
/// Tablonun bağlı olduğu silinmemiş proje (TABLES-K13); proje silinince alan dönmez.
@override@JsonKey(name: 'project_id') final  String? projectId;
/// Sahibin koyduğu şablon bayrağı (TABLES-K16). Erişimi genişletmez: şablon listesi (`template=true`) aynı ACL süzgecindedir. Kopyalar şablon değildir.
@override@JsonKey(name: 'is_template') final  bool? isTemplate;

/// Create a copy of Table
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCopyWith<_Table> get copyWith => __$TableCopyWithImpl<_Table>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Table&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.departmentId, departmentId) || other.departmentId == departmentId)&&(identical(other.space, space) || other.space == space)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.teamRole, teamRole) || other.teamRole == teamRole)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,ownerId,name,programId,departmentId,space,schemaVersion,sequence,teamRole,projectId,isTemplate);
}

@override
String toString() {
    return 'Table(id: $id, ownerId: $ownerId, name: $name, programId: $programId, departmentId: $departmentId, space: $space, schemaVersion: $schemaVersion, sequence: $sequence, teamRole: $teamRole, projectId: $projectId, isTemplate: $isTemplate)';
}


}

/// @nodoc
abstract mixin class _$TableCopyWith<$Res> implements $TableCopyWith<$Res> {
  factory _$TableCopyWith(_Table value, $Res Function(_Table) _then) = __$TableCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'department_id') String departmentId, TableSpace space,@JsonKey(name: 'schema_version') int schemaVersion, int sequence,@JsonKey(name: 'team_role') TableTeamRole? teamRole,@JsonKey(name: 'project_id') String? projectId,@JsonKey(name: 'is_template') bool? isTemplate
});




}
/// @nodoc
class __$TableCopyWithImpl<$Res>
    implements _$TableCopyWith<$Res> {
  __$TableCopyWithImpl(this._self, this._then);

  final _Table _self;
  final $Res Function(_Table) _then;

/// Create a copy of Table
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? programId = null,Object? departmentId = null,Object? space = null,Object? schemaVersion = null,Object? sequence = null,Object? teamRole = freezed,Object? projectId = freezed,Object? isTemplate = freezed,}) {
  return _then(_Table(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,departmentId: null == departmentId ? _self.departmentId : departmentId // ignore: cast_nullable_to_non_nullable
as String,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as TableSpace,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,teamRole: freezed == teamRole ? _self.teamRole : teamRole // ignore: cast_nullable_to_non_nullable
as TableTeamRole?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,isTemplate: freezed == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
