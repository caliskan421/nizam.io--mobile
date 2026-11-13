// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_skipped_cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableSkippedCell {

@JsonKey(name: 'row_id') String get rowId;@JsonKey(name: 'column_id') String get columnId; TableSkippedCellReason get reason;
/// Create a copy of TableSkippedCell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableSkippedCellCopyWith<TableSkippedCell> get copyWith => _$TableSkippedCellCopyWithImpl<TableSkippedCell>(this as TableSkippedCell, _$identity);

  /// Serializes this TableSkippedCell to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableSkippedCell;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableSkippedCell&&(identical(other.rowId, _this.rowId) || other.rowId == _this.rowId)&&(identical(other.columnId, _this.columnId) || other.columnId == _this.columnId)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableSkippedCell;
  return Object.hash(runtimeType,_this.rowId,_this.columnId,_this.reason);
}

@override
String toString() {
  final _this = this as TableSkippedCell;
  return 'TableSkippedCell(rowId: ${_this.rowId}, columnId: ${_this.columnId}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $TableSkippedCellCopyWith<$Res>  {
  factory $TableSkippedCellCopyWith(TableSkippedCell value, $Res Function(TableSkippedCell) _then) = _$TableSkippedCellCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String columnId, TableSkippedCellReason reason
});




}
/// @nodoc
class _$TableSkippedCellCopyWithImpl<$Res>
    implements $TableSkippedCellCopyWith<$Res> {
  _$TableSkippedCellCopyWithImpl(this._self, this._then);

  final TableSkippedCell _self;
  final $Res Function(TableSkippedCell) _then;

/// Create a copy of TableSkippedCell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowId = null,Object? columnId = null,Object? reason = null,}) {
  return _then(TableSkippedCell(
rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: null == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as TableSkippedCellReason,
  ));
}

}


/// Adds pattern-matching-related methods to [TableSkippedCell].
extension TableSkippedCellPatterns on TableSkippedCell {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableSkippedCell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableSkippedCell() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableSkippedCell value)  $default,){
final _that = this;
switch (_that) {
case _TableSkippedCell():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableSkippedCell value)?  $default,){
final _that = this;
switch (_that) {
case _TableSkippedCell() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId,  TableSkippedCellReason reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableSkippedCell() when $default != null:
return $default(_that.rowId,_that.columnId,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId,  TableSkippedCellReason reason)  $default,) {final _that = this;
switch (_that) {
case _TableSkippedCell():
return $default(_that.rowId,_that.columnId,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'row_id')  String rowId, @JsonKey(name: 'column_id')  String columnId,  TableSkippedCellReason reason)?  $default,) {final _that = this;
switch (_that) {
case _TableSkippedCell() when $default != null:
return $default(_that.rowId,_that.columnId,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableSkippedCell implements TableSkippedCell {
  const _TableSkippedCell({@JsonKey(name: 'row_id') required this.rowId, @JsonKey(name: 'column_id') required this.columnId, required this.reason});
  factory _TableSkippedCell.fromJson(Map<String, dynamic> json) => _$TableSkippedCellFromJson(json);

@override@JsonKey(name: 'row_id') final  String rowId;
@override@JsonKey(name: 'column_id') final  String columnId;
@override final  TableSkippedCellReason reason;

/// Create a copy of TableSkippedCell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableSkippedCellCopyWith<_TableSkippedCell> get copyWith => __$TableSkippedCellCopyWithImpl<_TableSkippedCell>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableSkippedCellToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableSkippedCell&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.columnId, columnId) || other.columnId == columnId)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rowId,columnId,reason);
}

@override
String toString() {
    return 'TableSkippedCell(rowId: $rowId, columnId: $columnId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$TableSkippedCellCopyWith<$Res> implements $TableSkippedCellCopyWith<$Res> {
  factory _$TableSkippedCellCopyWith(_TableSkippedCell value, $Res Function(_TableSkippedCell) _then) = __$TableSkippedCellCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'row_id') String rowId,@JsonKey(name: 'column_id') String columnId, TableSkippedCellReason reason
});




}
/// @nodoc
class __$TableSkippedCellCopyWithImpl<$Res>
    implements _$TableSkippedCellCopyWith<$Res> {
  __$TableSkippedCellCopyWithImpl(this._self, this._then);

  final _TableSkippedCell _self;
  final $Res Function(_TableSkippedCell) _then;

/// Create a copy of TableSkippedCell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowId = null,Object? columnId = null,Object? reason = null,}) {
  return _then(_TableSkippedCell(
rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String,columnId: null == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as TableSkippedCellReason,
  ));
}


}

// dart format on
