// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_date_request2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingDateRequest2 {

/// Talep kimliği (`reviewDateChangeRequest` yolundaki `id`).
@JsonKey(name: 'request_id') String get requestId;@DateOnlyConverter()@JsonKey(name: 'new_start_on') DateTime get newStartOn;@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime get newEndOn;
/// Create a copy of PendingDateRequest2
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingDateRequest2CopyWith<PendingDateRequest2> get copyWith => _$PendingDateRequest2CopyWithImpl<PendingDateRequest2>(this as PendingDateRequest2, _$identity);

  /// Serializes this PendingDateRequest2 to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PendingDateRequest2;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingDateRequest2&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.newStartOn, _this.newStartOn) || other.newStartOn == _this.newStartOn)&&(identical(other.newEndOn, _this.newEndOn) || other.newEndOn == _this.newEndOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PendingDateRequest2;
  return Object.hash(runtimeType,_this.requestId,_this.newStartOn,_this.newEndOn);
}

@override
String toString() {
  final _this = this as PendingDateRequest2;
  return 'PendingDateRequest2(requestId: ${_this.requestId}, newStartOn: ${_this.newStartOn}, newEndOn: ${_this.newEndOn})';
}


}

/// @nodoc
abstract mixin class $PendingDateRequest2CopyWith<$Res>  {
  factory $PendingDateRequest2CopyWith(PendingDateRequest2 value, $Res Function(PendingDateRequest2) _then) = _$PendingDateRequest2CopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'request_id') String requestId,@DateOnlyConverter()@JsonKey(name: 'new_start_on') DateTime newStartOn,@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime newEndOn
});




}
/// @nodoc
class _$PendingDateRequest2CopyWithImpl<$Res>
    implements $PendingDateRequest2CopyWith<$Res> {
  _$PendingDateRequest2CopyWithImpl(this._self, this._then);

  final PendingDateRequest2 _self;
  final $Res Function(PendingDateRequest2) _then;

/// Create a copy of PendingDateRequest2
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? newStartOn = null,Object? newEndOn = null,}) {
  return _then(PendingDateRequest2(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingDateRequest2].
extension PendingDateRequest2Patterns on PendingDateRequest2 {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingDateRequest2 value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingDateRequest2() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingDateRequest2 value)  $default,){
final _that = this;
switch (_that) {
case _PendingDateRequest2():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingDateRequest2 value)?  $default,){
final _that = this;
switch (_that) {
case _PendingDateRequest2() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  String requestId, @DateOnlyConverter()@JsonKey(name: 'new_start_on')  DateTime newStartOn, @DateOnlyConverter()@JsonKey(name: 'new_end_on')  DateTime newEndOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingDateRequest2() when $default != null:
return $default(_that.requestId,_that.newStartOn,_that.newEndOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'request_id')  String requestId, @DateOnlyConverter()@JsonKey(name: 'new_start_on')  DateTime newStartOn, @DateOnlyConverter()@JsonKey(name: 'new_end_on')  DateTime newEndOn)  $default,) {final _that = this;
switch (_that) {
case _PendingDateRequest2():
return $default(_that.requestId,_that.newStartOn,_that.newEndOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'request_id')  String requestId, @DateOnlyConverter()@JsonKey(name: 'new_start_on')  DateTime newStartOn, @DateOnlyConverter()@JsonKey(name: 'new_end_on')  DateTime newEndOn)?  $default,) {final _that = this;
switch (_that) {
case _PendingDateRequest2() when $default != null:
return $default(_that.requestId,_that.newStartOn,_that.newEndOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingDateRequest2 implements PendingDateRequest2 {
  const _PendingDateRequest2({@JsonKey(name: 'request_id') required this.requestId, @DateOnlyConverter()@JsonKey(name: 'new_start_on') required this.newStartOn, @DateOnlyConverter()@JsonKey(name: 'new_end_on') required this.newEndOn});
  factory _PendingDateRequest2.fromJson(Map<String, dynamic> json) => _$PendingDateRequest2FromJson(json);

/// Talep kimliği (`reviewDateChangeRequest` yolundaki `id`).
@override@JsonKey(name: 'request_id') final  String requestId;
@override@DateOnlyConverter()@JsonKey(name: 'new_start_on') final  DateTime newStartOn;
@override@DateOnlyConverter()@JsonKey(name: 'new_end_on') final  DateTime newEndOn;

/// Create a copy of PendingDateRequest2
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingDateRequest2CopyWith<_PendingDateRequest2> get copyWith => __$PendingDateRequest2CopyWithImpl<_PendingDateRequest2>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingDateRequest2ToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingDateRequest2&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.newStartOn, newStartOn) || other.newStartOn == newStartOn)&&(identical(other.newEndOn, newEndOn) || other.newEndOn == newEndOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requestId,newStartOn,newEndOn);
}

@override
String toString() {
    return 'PendingDateRequest2(requestId: $requestId, newStartOn: $newStartOn, newEndOn: $newEndOn)';
}


}

/// @nodoc
abstract mixin class _$PendingDateRequest2CopyWith<$Res> implements $PendingDateRequest2CopyWith<$Res> {
  factory _$PendingDateRequest2CopyWith(_PendingDateRequest2 value, $Res Function(_PendingDateRequest2) _then) = __$PendingDateRequest2CopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'request_id') String requestId,@DateOnlyConverter()@JsonKey(name: 'new_start_on') DateTime newStartOn,@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime newEndOn
});




}
/// @nodoc
class __$PendingDateRequest2CopyWithImpl<$Res>
    implements _$PendingDateRequest2CopyWith<$Res> {
  __$PendingDateRequest2CopyWithImpl(this._self, this._then);

  final _PendingDateRequest2 _self;
  final $Res Function(_PendingDateRequest2) _then;

/// Create a copy of PendingDateRequest2
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? newStartOn = null,Object? newEndOn = null,}) {
  return _then(_PendingDateRequest2(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
