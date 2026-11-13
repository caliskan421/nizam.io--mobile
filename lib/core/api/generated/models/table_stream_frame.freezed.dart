// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_stream_frame.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableStreamFrame {

@JsonKey(name: 'table_id') String get tableId; int get sequence;
/// Create a copy of TableStreamFrame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableStreamFrameCopyWith<TableStreamFrame> get copyWith => _$TableStreamFrameCopyWithImpl<TableStreamFrame>(this as TableStreamFrame, _$identity);

  /// Serializes this TableStreamFrame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TableStreamFrame;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableStreamFrame&&(identical(other.tableId, _this.tableId) || other.tableId == _this.tableId)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TableStreamFrame;
  return Object.hash(runtimeType,_this.tableId,_this.sequence);
}

@override
String toString() {
  final _this = this as TableStreamFrame;
  return 'TableStreamFrame(tableId: ${_this.tableId}, sequence: ${_this.sequence})';
}


}

/// @nodoc
abstract mixin class $TableStreamFrameCopyWith<$Res>  {
  factory $TableStreamFrameCopyWith(TableStreamFrame value, $Res Function(TableStreamFrame) _then) = _$TableStreamFrameCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, int sequence
});




}
/// @nodoc
class _$TableStreamFrameCopyWithImpl<$Res>
    implements $TableStreamFrameCopyWith<$Res> {
  _$TableStreamFrameCopyWithImpl(this._self, this._then);

  final TableStreamFrame _self;
  final $Res Function(TableStreamFrame) _then;

/// Create a copy of TableStreamFrame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tableId = null,Object? sequence = null,}) {
  return _then(TableStreamFrame(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TableStreamFrame].
extension TableStreamFramePatterns on TableStreamFrame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableStreamFrame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableStreamFrame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableStreamFrame value)  $default,){
final _that = this;
switch (_that) {
case _TableStreamFrame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableStreamFrame value)?  $default,){
final _that = this;
switch (_that) {
case _TableStreamFrame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  int sequence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableStreamFrame() when $default != null:
return $default(_that.tableId,_that.sequence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'table_id')  String tableId,  int sequence)  $default,) {final _that = this;
switch (_that) {
case _TableStreamFrame():
return $default(_that.tableId,_that.sequence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'table_id')  String tableId,  int sequence)?  $default,) {final _that = this;
switch (_that) {
case _TableStreamFrame() when $default != null:
return $default(_that.tableId,_that.sequence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableStreamFrame implements TableStreamFrame {
  const _TableStreamFrame({@JsonKey(name: 'table_id') required this.tableId, required this.sequence});
  factory _TableStreamFrame.fromJson(Map<String, dynamic> json) => _$TableStreamFrameFromJson(json);

@override@JsonKey(name: 'table_id') final  String tableId;
@override final  int sequence;

/// Create a copy of TableStreamFrame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableStreamFrameCopyWith<_TableStreamFrame> get copyWith => __$TableStreamFrameCopyWithImpl<_TableStreamFrame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableStreamFrameToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableStreamFrame&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.sequence, sequence) || other.sequence == sequence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tableId,sequence);
}

@override
String toString() {
    return 'TableStreamFrame(tableId: $tableId, sequence: $sequence)';
}


}

/// @nodoc
abstract mixin class _$TableStreamFrameCopyWith<$Res> implements $TableStreamFrameCopyWith<$Res> {
  factory _$TableStreamFrameCopyWith(_TableStreamFrame value, $Res Function(_TableStreamFrame) _then) = __$TableStreamFrameCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'table_id') String tableId, int sequence
});




}
/// @nodoc
class __$TableStreamFrameCopyWithImpl<$Res>
    implements _$TableStreamFrameCopyWith<$Res> {
  __$TableStreamFrameCopyWithImpl(this._self, this._then);

  final _TableStreamFrame _self;
  final $Res Function(_TableStreamFrame) _then;

/// Create a copy of TableStreamFrame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tableId = null,Object? sequence = null,}) {
  return _then(_TableStreamFrame(
tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
