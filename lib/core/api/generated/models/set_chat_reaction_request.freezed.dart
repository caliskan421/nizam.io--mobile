// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_chat_reaction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetChatReactionRequest {

 SetChatReactionRequestKind get kind;
/// Create a copy of SetChatReactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetChatReactionRequestCopyWith<SetChatReactionRequest> get copyWith => _$SetChatReactionRequestCopyWithImpl<SetChatReactionRequest>(this as SetChatReactionRequest, _$identity);

  /// Serializes this SetChatReactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SetChatReactionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetChatReactionRequest&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SetChatReactionRequest;
  return Object.hash(runtimeType,_this.kind);
}

@override
String toString() {
  final _this = this as SetChatReactionRequest;
  return 'SetChatReactionRequest(kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $SetChatReactionRequestCopyWith<$Res>  {
  factory $SetChatReactionRequestCopyWith(SetChatReactionRequest value, $Res Function(SetChatReactionRequest) _then) = _$SetChatReactionRequestCopyWithImpl;
@useResult
$Res call({
 SetChatReactionRequestKind kind
});




}
/// @nodoc
class _$SetChatReactionRequestCopyWithImpl<$Res>
    implements $SetChatReactionRequestCopyWith<$Res> {
  _$SetChatReactionRequestCopyWithImpl(this._self, this._then);

  final SetChatReactionRequest _self;
  final $Res Function(SetChatReactionRequest) _then;

/// Create a copy of SetChatReactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,}) {
  return _then(SetChatReactionRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SetChatReactionRequestKind,
  ));
}

}


/// Adds pattern-matching-related methods to [SetChatReactionRequest].
extension SetChatReactionRequestPatterns on SetChatReactionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetChatReactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetChatReactionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetChatReactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _SetChatReactionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetChatReactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SetChatReactionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SetChatReactionRequestKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetChatReactionRequest() when $default != null:
return $default(_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SetChatReactionRequestKind kind)  $default,) {final _that = this;
switch (_that) {
case _SetChatReactionRequest():
return $default(_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SetChatReactionRequestKind kind)?  $default,) {final _that = this;
switch (_that) {
case _SetChatReactionRequest() when $default != null:
return $default(_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetChatReactionRequest implements SetChatReactionRequest {
  const _SetChatReactionRequest({required this.kind});
  factory _SetChatReactionRequest.fromJson(Map<String, dynamic> json) => _$SetChatReactionRequestFromJson(json);

@override final  SetChatReactionRequestKind kind;

/// Create a copy of SetChatReactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetChatReactionRequestCopyWith<_SetChatReactionRequest> get copyWith => __$SetChatReactionRequestCopyWithImpl<_SetChatReactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetChatReactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetChatReactionRequest&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind);
}

@override
String toString() {
    return 'SetChatReactionRequest(kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$SetChatReactionRequestCopyWith<$Res> implements $SetChatReactionRequestCopyWith<$Res> {
  factory _$SetChatReactionRequestCopyWith(_SetChatReactionRequest value, $Res Function(_SetChatReactionRequest) _then) = __$SetChatReactionRequestCopyWithImpl;
@override @useResult
$Res call({
 SetChatReactionRequestKind kind
});




}
/// @nodoc
class __$SetChatReactionRequestCopyWithImpl<$Res>
    implements _$SetChatReactionRequestCopyWith<$Res> {
  __$SetChatReactionRequestCopyWithImpl(this._self, this._then);

  final _SetChatReactionRequest _self;
  final $Res Function(_SetChatReactionRequest) _then;

/// Create a copy of SetChatReactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,}) {
  return _then(_SetChatReactionRequest(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SetChatReactionRequestKind,
  ));
}


}

// dart format on
