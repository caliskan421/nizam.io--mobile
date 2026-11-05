// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_date_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingDateRequest {

/// Talep kimliği (`reviewDateChangeRequest` yolundaki `id`).
@JsonKey(name: 'request_id') String get requestId;@DateOnlyConverter()@JsonKey(name: 'new_start_on') DateTime get newStartOn;@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime get newEndOn;
/// Create a copy of PendingDateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingDateRequestCopyWith<PendingDateRequest> get copyWith => _$PendingDateRequestCopyWithImpl<PendingDateRequest>(this as PendingDateRequest, _$identity);

  /// Serializes this PendingDateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PendingDateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingDateRequest&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.newStartOn, _this.newStartOn) || other.newStartOn == _this.newStartOn)&&(identical(other.newEndOn, _this.newEndOn) || other.newEndOn == _this.newEndOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PendingDateRequest;
  return Object.hash(runtimeType,_this.requestId,_this.newStartOn,_this.newEndOn);
}

@override
String toString() {
  final _this = this as PendingDateRequest;
  return 'PendingDateRequest(requestId: ${_this.requestId}, newStartOn: ${_this.newStartOn}, newEndOn: ${_this.newEndOn})';
}


}

/// @nodoc
abstract mixin class $PendingDateRequestCopyWith<$Res>  {
  factory $PendingDateRequestCopyWith(PendingDateRequest value, $Res Function(PendingDateRequest) _then) = _$PendingDateRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'request_id') String requestId,@DateOnlyConverter()@JsonKey(name: 'new_start_on') DateTime newStartOn,@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime newEndOn
});




}
/// @nodoc
class _$PendingDateRequestCopyWithImpl<$Res>
    implements $PendingDateRequestCopyWith<$Res> {
  _$PendingDateRequestCopyWithImpl(this._self, this._then);

  final PendingDateRequest _self;
  final $Res Function(PendingDateRequest) _then;

/// Create a copy of PendingDateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestId = null,Object? newStartOn = null,Object? newEndOn = null,}) {
  return _then(PendingDateRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingDateRequest].
extension PendingDateRequestPatterns on PendingDateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingDateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingDateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingDateRequest value)  $default,){
final _that = this;
switch (_that) {
case _PendingDateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingDateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PendingDateRequest() when $default != null:
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
case _PendingDateRequest() when $default != null:
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
case _PendingDateRequest():
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
case _PendingDateRequest() when $default != null:
return $default(_that.requestId,_that.newStartOn,_that.newEndOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingDateRequest implements PendingDateRequest {
  const _PendingDateRequest({@JsonKey(name: 'request_id') required this.requestId, @DateOnlyConverter()@JsonKey(name: 'new_start_on') required this.newStartOn, @DateOnlyConverter()@JsonKey(name: 'new_end_on') required this.newEndOn});
  factory _PendingDateRequest.fromJson(Map<String, dynamic> json) => _$PendingDateRequestFromJson(json);

/// Talep kimliği (`reviewDateChangeRequest` yolundaki `id`).
@override@JsonKey(name: 'request_id') final  String requestId;
@override@DateOnlyConverter()@JsonKey(name: 'new_start_on') final  DateTime newStartOn;
@override@DateOnlyConverter()@JsonKey(name: 'new_end_on') final  DateTime newEndOn;

/// Create a copy of PendingDateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingDateRequestCopyWith<_PendingDateRequest> get copyWith => __$PendingDateRequestCopyWithImpl<_PendingDateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingDateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingDateRequest&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.newStartOn, newStartOn) || other.newStartOn == newStartOn)&&(identical(other.newEndOn, newEndOn) || other.newEndOn == newEndOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,requestId,newStartOn,newEndOn);
}

@override
String toString() {
    return 'PendingDateRequest(requestId: $requestId, newStartOn: $newStartOn, newEndOn: $newEndOn)';
}


}

/// @nodoc
abstract mixin class _$PendingDateRequestCopyWith<$Res> implements $PendingDateRequestCopyWith<$Res> {
  factory _$PendingDateRequestCopyWith(_PendingDateRequest value, $Res Function(_PendingDateRequest) _then) = __$PendingDateRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'request_id') String requestId,@DateOnlyConverter()@JsonKey(name: 'new_start_on') DateTime newStartOn,@DateOnlyConverter()@JsonKey(name: 'new_end_on') DateTime newEndOn
});




}
/// @nodoc
class __$PendingDateRequestCopyWithImpl<$Res>
    implements _$PendingDateRequestCopyWith<$Res> {
  __$PendingDateRequestCopyWithImpl(this._self, this._then);

  final _PendingDateRequest _self;
  final $Res Function(_PendingDateRequest) _then;

/// Create a copy of PendingDateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestId = null,Object? newStartOn = null,Object? newEndOn = null,}) {
  return _then(_PendingDateRequest(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,newStartOn: null == newStartOn ? _self.newStartOn : newStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,newEndOn: null == newEndOn ? _self.newEndOn : newEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
