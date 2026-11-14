// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableCell {

@JsonKey(name: 'row_id') String get rowId;@JsonKey(name: 'column_id') String get columnId; TableCellValue? get value;/// Hücre sürümü. Okumada hiç yazılmamış hücre yanıtta yoktur; yazımda 0 ilk yazımdır, sonraki yazım mevcut pozitif sürümü ister (TABLES-K03); eksik ya da `null` sürüm 0 sayılmaz, 422 `tables.input_invalid`. Okumada erişimi kaybolmuş tablo referansı `null` döner (TABLES-K07).
 int get version;/// Yalnız okuma yanıtında ve yalnız `true` olarak bulunur: hücredeki referansın tamamı (tekli) ya da bazı öğeleri (çoklu, aynı konumda `null`) okuyana görünmediği için gizlendi; saklanan değer ve sürüm değişmedi (TABLES-K14). İstekte `true` 422 `tables.input_invalid`: kısmi redakte okuma körlemesine geri yazılamaz; gizli öğeyi bırakmak ancak açık tam değiştirmeyle olur.
 bool? get redacted;
/// Create a copy of TableCell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableCellCopyWith<TableCell> get copyWith => _$TableCellCopyWithImpl<TableCell>(this as TableCell, _$identity);

  /// Serializes this TableCell to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableCell;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableCell&&(identical(other.rowId, _this.rowId) || other.rowId == _this.rowId)&&(identical(other.columnId, _this.columnId) || other.columnId == _this.columnId)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.redacted, _this.redacted) || other.redacted == _this.redacted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableCell;
  return Object.hash(runtimeType,_this.rowId,_this.columnId,_this.value,_this.version,_this.redacted);
}

@override
String toString() {
  final _this = this as TableCell;
  return 'TableCell(rowId: ${_this.rowId}, columnId: ${_this.columnId}, value: ${_this.value}, version: ${_this.version}, redacted: ${_this.redacted})';
}


}

/// @nodoc
abstract mixin class $TableCellCopyWith<$Res>  {
  factory $TableCellCopyWith(TableCell value, $Res Function(TableCell) _then) = _$TableCellCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String columnId, TableCellValue? value, int version, bool? redacted
});


$TableCellValueCopyWith<$Res>? get value;

}
/// @nodoc
class _$TableCellCopyWithImpl<$Res>
    implements $TableCellCopyWith<$Res> {
  _$TableCellCopyWithImpl(this._self, this._then);

  final TableCell _self;
  final $Res Function(TableCell) _then;

/// Create a copy of TableCell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowId = null,Object? columnId = null,Object? value = freezed,Object? version = null,Object? redacted = freezed,}) {
  return _then(TableCell(
rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: null == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TableCellValue?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,redacted: freezed == redacted ? _self.redacted : redacted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of TableCell
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableCellValueCopyWith<$Res>? get value {
    if (_self.value == null) {
    return null;
  }

  return $TableCellValueCopyWith<$Res>(_self.value!, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}


/// Adds pattern-matching-related methods to [TableCell].
extension TableCellPatterns on TableCell {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableCell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableCell() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableCell value)  $default,){
final _that = this;
switch (_that) {
case _TableCell():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableCell value)?  $default,){
final _that = this;
switch (_that) {
case _TableCell() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId,  TableCellValue? value,  int version,  bool? redacted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableCell() when $default != null:
return $default(_that.rowId,_that.columnId,_that.value,_that.version,_that.redacted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId,  TableCellValue? value,  int version,  bool? redacted)  $default,) {final _that = this;
switch (_that) {
case _TableCell():
return $default(_that.rowId,_that.columnId,_that.value,_that.version,_that.redacted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId,  TableCellValue? value,  int version,  bool? redacted)?  $default,) {final _that = this;
switch (_that) {
case _TableCell() when $default != null:
return $default(_that.rowId,_that.columnId,_that.value,_that.version,_that.redacted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableCell implements TableCell {
  const _TableCell({@JsonKey(name: 'row_id') required this.rowId, @JsonKey(name: 'column_id') required this.columnId, required this.value, required this.version, this.redacted});
  factory _TableCell.fromJson(Map<String, dynamic> json) => _$TableCellFromJson(json);

@override@JsonKey(name: 'row_id') final  String rowId;
@override@JsonKey(name: 'column_id') final  String columnId;
@override final  TableCellValue? value;
/// Hücre sürümü. Okumada hiç yazılmamış hücre yanıtta yoktur; yazımda 0 ilk yazımdır, sonraki yazım mevcut pozitif sürümü ister (TABLES-K03); eksik ya da `null` sürüm 0 sayılmaz, 422 `tables.input_invalid`. Okumada erişimi kaybolmuş tablo referansı `null` döner (TABLES-K07).
@override final  int version;
/// Yalnız okuma yanıtında ve yalnız `true` olarak bulunur: hücredeki referansın tamamı (tekli) ya da bazı öğeleri (çoklu, aynı konumda `null`) okuyana görünmediği için gizlendi; saklanan değer ve sürüm değişmedi (TABLES-K14). İstekte `true` 422 `tables.input_invalid`: kısmi redakte okuma körlemesine geri yazılamaz; gizli öğeyi bırakmak ancak açık tam değiştirmeyle olur.
@override final  bool? redacted;

/// Create a copy of TableCell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableCellCopyWith<_TableCell> get copyWith => __$TableCellCopyWithImpl<_TableCell>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableCellToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableCell&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.columnId, columnId) || other.columnId == columnId)&&(identical(other.value, value) || other.value == value)&&(identical(other.version, version) || other.version == version)&&(identical(other.redacted, redacted) || other.redacted == redacted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rowId,columnId,value,version,redacted);
}

@override
String toString() {
    return 'TableCell(rowId: $rowId, columnId: $columnId, value: $value, version: $version, redacted: $redacted)';
}


}

/// @nodoc
abstract mixin class _$TableCellCopyWith<$Res> implements $TableCellCopyWith<$Res> {
  factory _$TableCellCopyWith(_TableCell value, $Res Function(_TableCell) _then) = __$TableCellCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String columnId, TableCellValue? value, int version, bool? redacted
});


@override $TableCellValueCopyWith<$Res>? get value;

}
/// @nodoc
class __$TableCellCopyWithImpl<$Res>
    implements _$TableCellCopyWith<$Res> {
  __$TableCellCopyWithImpl(this._self, this._then);

  final _TableCell _self;
  final $Res Function(_TableCell) _then;

/// Create a copy of TableCell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowId = null,Object? columnId = null,Object? value = freezed,Object? version = null,Object? redacted = freezed,}) {
  return _then(_TableCell(
rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: null == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TableCellValue?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,redacted: freezed == redacted ? _self.redacted : redacted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of TableCell
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TableCellValueCopyWith<$Res>? get value {
    if (_self.value == null) {
    return null;
  }

  return $TableCellValueCopyWith<$Res>(_self.value!, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}

// dart format on
