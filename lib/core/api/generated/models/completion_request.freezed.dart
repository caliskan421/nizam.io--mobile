// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completion_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompletionRequest {

@JsonKey(name: 'completed_on') DateTime get completedOn;
/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletionRequestCopyWith<CompletionRequest> get copyWith => _$CompletionRequestCopyWithImpl<CompletionRequest>(this as CompletionRequest, _$identity);

  /// Serializes this CompletionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CompletionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompletionRequest&&(identical(other.completedOn, _this.completedOn) || other.completedOn == _this.completedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CompletionRequest;
  return Object.hash(runtimeType,_this.completedOn);
}

@override
String toString() {
  final _this = this as CompletionRequest;
  return 'CompletionRequest(completedOn: ${_this.completedOn})';
}


}

/// @nodoc
abstract mixin class $CompletionRequestCopyWith<$Res>  {
  factory $CompletionRequestCopyWith(CompletionRequest value, $Res Function(CompletionRequest) _then) = _$CompletionRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'completed_on') DateTime completedOn
});




}
/// @nodoc
class _$CompletionRequestCopyWithImpl<$Res>
    implements $CompletionRequestCopyWith<$Res> {
  _$CompletionRequestCopyWithImpl(this._self, this._then);

  final CompletionRequest _self;
  final $Res Function(CompletionRequest) _then;

/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completedOn = null,}) {
  return _then(CompletionRequest(
completedOn: null == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CompletionRequest].
extension CompletionRequestPatterns on CompletionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompletionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompletionRequest value)  $default,){
final _that = this;
switch (_that) {
case _CompletionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompletionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'completed_on')  DateTime completedOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
return $default(_that.completedOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'completed_on')  DateTime completedOn)  $default,) {final _that = this;
switch (_that) {
case _CompletionRequest():
return $default(_that.completedOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'completed_on')  DateTime completedOn)?  $default,) {final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
return $default(_that.completedOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompletionRequest implements CompletionRequest {
  const _CompletionRequest({@JsonKey(name: 'completed_on') required this.completedOn});
  factory _CompletionRequest.fromJson(Map<String, dynamic> json) => _$CompletionRequestFromJson(json);

@override@JsonKey(name: 'completed_on') final  DateTime completedOn;

/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletionRequestCopyWith<_CompletionRequest> get copyWith => __$CompletionRequestCopyWithImpl<_CompletionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompletionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletionRequest&&(identical(other.completedOn, completedOn) || other.completedOn == completedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,completedOn);
}

@override
String toString() {
    return 'CompletionRequest(completedOn: $completedOn)';
}


}

/// @nodoc
abstract mixin class _$CompletionRequestCopyWith<$Res> implements $CompletionRequestCopyWith<$Res> {
  factory _$CompletionRequestCopyWith(_CompletionRequest value, $Res Function(_CompletionRequest) _then) = __$CompletionRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'completed_on') DateTime completedOn
});




}
/// @nodoc
class __$CompletionRequestCopyWithImpl<$Res>
    implements _$CompletionRequestCopyWith<$Res> {
  __$CompletionRequestCopyWithImpl(this._self, this._then);

  final _CompletionRequest _self;
  final $Res Function(_CompletionRequest) _then;

/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completedOn = null,}) {
  return _then(_CompletionRequest(
completedOn: null == completedOn ? _self.completedOn : completedOn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
