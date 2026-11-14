// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableRow {

 String get id; int get position;
/// Create a copy of TableRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableRowCopyWith<TableRow> get copyWith => _$TableRowCopyWithImpl<TableRow>(this as TableRow, _$identity);

  /// Serializes this TableRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableRow&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.position, _this.position) || other.position == _this.position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableRow;
  return Object.hash(runtimeType,_this.id,_this.position);
}

@override
String toString() {
  final _this = this as TableRow;
  return 'TableRow(id: ${_this.id}, position: ${_this.position})';
}


}

/// @nodoc
abstract mixin class $TableRowCopyWith<$Res>  {
  factory $TableRowCopyWith(TableRow value, $Res Function(TableRow) _then) = _$TableRowCopyWithImpl;
@useResult
$Res call({
 String id, int position
});




}
/// @nodoc
class _$TableRowCopyWithImpl<$Res>
    implements $TableRowCopyWith<$Res> {
  _$TableRowCopyWithImpl(this._self, this._then);

  final TableRow _self;
  final $Res Function(TableRow) _then;

/// Create a copy of TableRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? position = null,}) {
  return _then(TableRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableRow].
extension TableRowPatterns on TableRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableRow value)  $default,){
final _that = this;
switch (_that) {
case _TableRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableRow value)?  $default,){
final _that = this;
switch (_that) {
case _TableRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableRow() when $default != null:
return $default(_that.id,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int position)  $default,) {final _that = this;
switch (_that) {
case _TableRow():
return $default(_that.id,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int position)?  $default,) {final _that = this;
switch (_that) {
case _TableRow() when $default != null:
return $default(_that.id,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableRow implements TableRow {
  const _TableRow({required this.id, required this.position});
  factory _TableRow.fromJson(Map<String, dynamic> json) => _$TableRowFromJson(json);

@override final  String id;
@override final  int position;

/// Create a copy of TableRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableRowCopyWith<_TableRow> get copyWith => __$TableRowCopyWithImpl<_TableRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableRow&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,position);
}

@override
String toString() {
    return 'TableRow(id: $id, position: $position)';
}


}

/// @nodoc
abstract mixin class _$TableRowCopyWith<$Res> implements $TableRowCopyWith<$Res> {
  factory _$TableRowCopyWith(_TableRow value, $Res Function(_TableRow) _then) = __$TableRowCopyWithImpl;
@override @useResult
$Res call({
 String id, int position
});




}
/// @nodoc
class __$TableRowCopyWithImpl<$Res>
    implements _$TableRowCopyWith<$Res> {
  __$TableRowCopyWithImpl(this._self, this._then);

  final _TableRow _self;
  final $Res Function(_TableRow) _then;

/// Create a copy of TableRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,}) {
  return _then(_TableRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
