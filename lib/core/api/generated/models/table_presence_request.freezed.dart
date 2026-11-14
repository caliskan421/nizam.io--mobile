// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_presence_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TablePresenceRequest {

@JsonKey(name: 'row_id') String? get rowId;@JsonKey(name: 'column_id') String? get columnId;
/// Create a copy of TablePresenceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TablePresenceRequestCopyWith<TablePresenceRequest> get copyWith => _$TablePresenceRequestCopyWithImpl<TablePresenceRequest>(this as TablePresenceRequest, _$identity);

  /// Serializes this TablePresenceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TablePresenceRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TablePresenceRequest&&(identical(other.rowId, _this.rowId) || other.rowId == _this.rowId)&&(identical(other.columnId, _this.columnId) || other.columnId == _this.columnId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TablePresenceRequest;
  return Object.hash(runtimeType,_this.rowId,_this.columnId);
}

@override
String toString() {
  final _this = this as TablePresenceRequest;
  return 'TablePresenceRequest(rowId: ${_this.rowId}, columnId: ${_this.columnId})';
}


}

/// @nodoc
abstract mixin class $TablePresenceRequestCopyWith<$Res>  {
  factory $TablePresenceRequestCopyWith(TablePresenceRequest value, $Res Function(TablePresenceRequest) _then) = _$TablePresenceRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'row_id') String? rowId,@JsonKey(name: 'column_id') String? columnId
});




}
/// @nodoc
class _$TablePresenceRequestCopyWithImpl<$Res>
    implements $TablePresenceRequestCopyWith<$Res> {
  _$TablePresenceRequestCopyWithImpl(this._self, this._then);

  final TablePresenceRequest _self;
  final $Res Function(TablePresenceRequest) _then;

/// Create a copy of TablePresenceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowId = freezed,Object? columnId = freezed,}) {
  return _then(TablePresenceRequest(
rowId: freezed == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String?,columnId: freezed == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TablePresenceRequest].
extension TablePresenceRequestPatterns on TablePresenceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TablePresenceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TablePresenceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TablePresenceRequest value)  $default,){
final _that = this;
switch (_that) {
case _TablePresenceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TablePresenceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TablePresenceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_id')  String? rowId, @JsonKey(name: 'column_id')  String? columnId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TablePresenceRequest() when $default != null:
return $default(_that.rowId,_that.columnId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'row_id')  String? rowId, @JsonKey(name: 'column_id')  String? columnId)  $default,) {final _that = this;
switch (_that) {
case _TablePresenceRequest():
return $default(_that.rowId,_that.columnId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'row_id')  String? rowId, @JsonKey(name: 'column_id')  String? columnId)?  $default,) {final _that = this;
switch (_that) {
case _TablePresenceRequest() when $default != null:
return $default(_that.rowId,_that.columnId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TablePresenceRequest implements TablePresenceRequest {
  const _TablePresenceRequest({@JsonKey(name: 'row_id') this.rowId, @JsonKey(name: 'column_id') this.columnId});
  factory _TablePresenceRequest.fromJson(Map<String, dynamic> json) => _$TablePresenceRequestFromJson(json);

@override@JsonKey(name: 'row_id') final  String? rowId;
@override@JsonKey(name: 'column_id') final  String? columnId;

/// Create a copy of TablePresenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TablePresenceRequestCopyWith<_TablePresenceRequest> get copyWith => __$TablePresenceRequestCopyWithImpl<_TablePresenceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TablePresenceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TablePresenceRequest&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.columnId, columnId) || other.columnId == columnId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rowId,columnId);
}

@override
String toString() {
    return 'TablePresenceRequest(rowId: $rowId, columnId: $columnId)';
}


}

/// @nodoc
abstract mixin class _$TablePresenceRequestCopyWith<$Res> implements $TablePresenceRequestCopyWith<$Res> {
  factory _$TablePresenceRequestCopyWith(_TablePresenceRequest value, $Res Function(_TablePresenceRequest) _then) = __$TablePresenceRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'row_id') String? rowId,@JsonKey(name: 'column_id') String? columnId
});




}
/// @nodoc
class __$TablePresenceRequestCopyWithImpl<$Res>
    implements _$TablePresenceRequestCopyWith<$Res> {
  __$TablePresenceRequestCopyWithImpl(this._self, this._then);

  final _TablePresenceRequest _self;
  final $Res Function(_TablePresenceRequest) _then;

/// Create a copy of TablePresenceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowId = freezed,Object? columnId = freezed,}) {
  return _then(_TablePresenceRequest(
rowId: freezed == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as String?,columnId: freezed == columnId ? _self.columnId : columnId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
