// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableResult {

@JsonKey(name: 'table_id') String get tableId; int get sequence;@JsonKey(name: 'schema_version') int get schemaVersion;/// `true`: aynı `Idempotency-Key` + aynı istek; komut ikinci kez uygulanmadı, alanlar ilk sonucun makbuzudur (audit yazılmaz).
 bool get replayed;/// Oluşturmada yeni tablo, `add_column`/`add_row`'da yeni sütun/satır kimliği; diğer komutlarda istekteki `id`.
 String? get id;/// Yalnız `set_cells` ve `undo_cells`; her yazılan hücrenin yeni sürümü, `value` her zaman `null`.
 List<TableCell>? get cells;/// Yalnız `undo_cells`; geri alınamayan hücreler kaynak olay sırasıyla (yoksa alan yok).
 List<TableSkippedCell>? get skipped;/// Yalnız `move_table`; temizlenen açık paylaşım sayısı (sıfırsa yok).
@JsonKey(name: 'cleared_grants') int? get clearedGrants;/// Yalnız öneri komutları; `id` öneri kimliğidir.
 TableResultStatus? get status;/// Yalnız `convert_column`; sürümü artan saklı hücre sayısı (sıfırsa yok).
 int? get converted;
/// Create a copy of TableResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableResultCopyWith<TableResult> get copyWith => _$TableResultCopyWithImpl<TableResult>(this as TableResult, _$identity);

  /// Serializes this TableResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableResult&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence)&&(identical(other.schemaVersion, _this.schemaVersion) || other.schemaVersion == _this.schemaVersion)&&(identical(other.replayed, _this.replayed) || other.replayed == _this.replayed)&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.cells, _this.cells)&&const DeepCollectionEquality().equals(other.skipped, _this.skipped)&&(identical(other.clearedGrants, _this.clearedGrants) || other.clearedGrants == _this.clearedGrants)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.converted, _this.converted) || other.converted == _this.converted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableResult;
  return Object.hash(runtimeType,_this.tableId,_this.sequence,_this.schemaVersion,_this.replayed,_this.id,const DeepCollectionEquality().hash(_this.cells),const DeepCollectionEquality().hash(_this.skipped),_this.clearedGrants,_this.status,_this.converted);
}

@override
String toString() {
  final _this = this as TableResult;
  return 'TableResult(tableId: ${_this.tableId}, sequence: ${_this.sequence}, schemaVersion: ${_this.schemaVersion}, replayed: ${_this.replayed}, id: ${_this.id}, cells: ${_this.cells}, skipped: ${_this.skipped}, clearedGrants: ${_this.clearedGrants}, status: ${_this.status}, converted: ${_this.converted})';
}


}

/// @nodoc
abstract mixin class $TableResultCopyWith<$Res>  {
  factory $TableResultCopyWith(TableResult value, $Res Function(TableResult) _then) = _$TableResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, int sequence,@JsonKey(name: 'schema_version') int schemaVersion, bool replayed, String? id, List<TableCell>? cells, List<TableSkippedCell>? skipped,@JsonKey(name: 'cleared_grants') int? clearedGrants, TableResultStatus? status, int? converted
});




}
/// @nodoc
class _$TableResultCopyWithImpl<$Res>
    implements $TableResultCopyWith<$Res> {
  _$TableResultCopyWithImpl(this._self, this._then);

  final TableResult _self;
  final $Res Function(TableResult) _then;

/// Create a copy of TableResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tableId = null,Object? sequence = null,Object? schemaVersion = null,Object? replayed = null,Object? id = freezed,Object? cells = freezed,Object? skipped = freezed,Object? clearedGrants = freezed,Object? status = freezed,Object? converted = freezed,}) {
  return _then(TableResult(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,cells: freezed == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<TableCell>?,skipped: freezed == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<TableSkippedCell>?,clearedGrants: freezed == clearedGrants ? _self.clearedGrants : clearedGrants // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableResultStatus?,converted: freezed == converted ? _self.converted : converted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TableResult].
extension TableResultPatterns on TableResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableResult value)  $default,){
final _that = this;
switch (_that) {
case _TableResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableResult value)?  $default,){
final _that = this;
switch (_that) {
case _TableResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  int sequence, @JsonKey(name: 'schema_version')  int schemaVersion,  bool replayed,  String? id,  List<TableCell>? cells,  List<TableSkippedCell>? skipped, @JsonKey(name: 'cleared_grants')  int? clearedGrants,  TableResultStatus? status,  int? converted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableResult() when $default != null:
return $default(_that.tableId,_that.sequence,_that.schemaVersion,_that.replayed,_that.id,_that.cells,_that.skipped,_that.clearedGrants,_that.status,_that.converted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  int sequence, @JsonKey(name: 'schema_version')  int schemaVersion,  bool replayed,  String? id,  List<TableCell>? cells,  List<TableSkippedCell>? skipped, @JsonKey(name: 'cleared_grants')  int? clearedGrants,  TableResultStatus? status,  int? converted)  $default,) {final _that = this;
switch (_that) {
case _TableResult():
return $default(_that.tableId,_that.sequence,_that.schemaVersion,_that.replayed,_that.id,_that.cells,_that.skipped,_that.clearedGrants,_that.status,_that.converted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'table_id')  String tableId,  int sequence, @JsonKey(name: 'schema_version')  int schemaVersion,  bool replayed,  String? id,  List<TableCell>? cells,  List<TableSkippedCell>? skipped, @JsonKey(name: 'cleared_grants')  int? clearedGrants,  TableResultStatus? status,  int? converted)?  $default,) {final _that = this;
switch (_that) {
case _TableResult() when $default != null:
return $default(_that.tableId,_that.sequence,_that.schemaVersion,_that.replayed,_that.id,_that.cells,_that.skipped,_that.clearedGrants,_that.status,_that.converted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableResult implements TableResult {
  const _TableResult({@JsonKey(name: 'table_id') required this.tableId, required this.sequence, @JsonKey(name: 'schema_version') required this.schemaVersion, required this.replayed, this.id,  List<TableCell>? cells,  List<TableSkippedCell>? skipped, @JsonKey(name: 'cleared_grants') this.clearedGrants, this.status, this.converted}): _cells = cells,_skipped = skipped;
  factory _TableResult.fromJson(Map<String, dynamic> json) => _$TableResultFromJson(json);

@override@JsonKey(name: 'table_id') final  String tableId;
@override final  int sequence;
@override@JsonKey(name: 'schema_version') final  int schemaVersion;
/// `true`: aynı `Idempotency-Key` + aynı istek; komut ikinci kez uygulanmadı, alanlar ilk sonucun makbuzudur (audit yazılmaz).
@override final  bool replayed;
/// Oluşturmada yeni tablo, `add_column`/`add_row`'da yeni sütun/satır kimliği; diğer komutlarda istekteki `id`.
@override final  String? id;
/// Yalnız `set_cells` ve `undo_cells`; her yazılan hücrenin yeni sürümü, `value` her zaman `null`.
 final  List<TableCell>? _cells;
/// Yalnız `set_cells` ve `undo_cells`; her yazılan hücrenin yeni sürümü, `value` her zaman `null`.
@override List<TableCell>? get cells {
  final value = _cells;
  if (value == null) return null;
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Yalnız `undo_cells`; geri alınamayan hücreler kaynak olay sırasıyla (yoksa alan yok).
 final  List<TableSkippedCell>? _skipped;
/// Yalnız `undo_cells`; geri alınamayan hücreler kaynak olay sırasıyla (yoksa alan yok).
@override List<TableSkippedCell>? get skipped {
  final value = _skipped;
  if (value == null) return null;
  if (_skipped is EqualUnmodifiableListView) return _skipped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Yalnız `move_table`; temizlenen açık paylaşım sayısı (sıfırsa yok).
@override@JsonKey(name: 'cleared_grants') final  int? clearedGrants;
/// Yalnız öneri komutları; `id` öneri kimliğidir.
@override final  TableResultStatus? status;
/// Yalnız `convert_column`; sürümü artan saklı hücre sayısı (sıfırsa yok).
@override final  int? converted;

/// Create a copy of TableResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableResultCopyWith<_TableResult> get copyWith => __$TableResultCopyWithImpl<_TableResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableResult&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.replayed, replayed) || other.replayed == replayed)&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.cells, _cells)&&const DeepCollectionEquality().equals(other.skipped, _skipped)&&(identical(other.clearedGrants, clearedGrants) || other.clearedGrants == clearedGrants)&&(identical(other.status, status) || other.status == status)&&(identical(other.converted, converted) || other.converted == converted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tableId,sequence,schemaVersion,replayed,id,const DeepCollectionEquality().hash(_cells),const DeepCollectionEquality().hash(_skipped),clearedGrants,status,converted);
}

@override
String toString() {
    return 'TableResult(tableId: $tableId, sequence: $sequence, schemaVersion: $schemaVersion, replayed: $replayed, id: $id, cells: $cells, skipped: $skipped, clearedGrants: $clearedGrants, status: $status, converted: $converted)';
}


}

/// @nodoc
abstract mixin class _$TableResultCopyWith<$Res> implements $TableResultCopyWith<$Res> {
  factory _$TableResultCopyWith(_TableResult value, $Res Function(_TableResult) _then) = __$TableResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, int sequence,@JsonKey(name: 'schema_version') int schemaVersion, bool replayed, String? id, List<TableCell>? cells, List<TableSkippedCell>? skipped,@JsonKey(name: 'cleared_grants') int? clearedGrants, TableResultStatus? status, int? converted
});




}
/// @nodoc
class __$TableResultCopyWithImpl<$Res>
    implements _$TableResultCopyWith<$Res> {
  __$TableResultCopyWithImpl(this._self, this._then);

  final _TableResult _self;
  final $Res Function(_TableResult) _then;

/// Create a copy of TableResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tableId = null,Object? sequence = null,Object? schemaVersion = null,Object? replayed = null,Object? id = freezed,Object? cells = freezed,Object? skipped = freezed,Object? clearedGrants = freezed,Object? status = freezed,Object? converted = freezed,}) {
  return _then(_TableResult(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,replayed: null == replayed ? _self.replayed : replayed // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,cells: freezed == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<TableCell>?,skipped: freezed == skipped ? _self._skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<TableSkippedCell>?,clearedGrants: freezed == clearedGrants ? _self.clearedGrants : clearedGrants // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TableResultStatus?,converted: freezed == converted ? _self.converted : converted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
