// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vote_chat_poll_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoteChatPollRequest {

@JsonKey(name: 'option_indexes') List<int> get optionIndexes;
/// Create a copy of VoteChatPollRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoteChatPollRequestCopyWith<VoteChatPollRequest> get copyWith => _$VoteChatPollRequestCopyWithImpl<VoteChatPollRequest>(this as VoteChatPollRequest, _$identity);

  /// Serializes this VoteChatPollRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VoteChatPollRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoteChatPollRequest&&const DeepCollectionEquality().equals(other.optionIndexes, _this.optionIndexes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VoteChatPollRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.optionIndexes));
}

@override
String toString() {
  final _this = this as VoteChatPollRequest;
  return 'VoteChatPollRequest(optionIndexes: ${_this.optionIndexes})';
}


}

/// @nodoc
abstract mixin class $VoteChatPollRequestCopyWith<$Res>  {
  factory $VoteChatPollRequestCopyWith(VoteChatPollRequest value, $Res Function(VoteChatPollRequest) _then) = _$VoteChatPollRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'option_indexes') List<int> optionIndexes
});




}
/// @nodoc
class _$VoteChatPollRequestCopyWithImpl<$Res>
    implements $VoteChatPollRequestCopyWith<$Res> {
  _$VoteChatPollRequestCopyWithImpl(this._self, this._then);

  final VoteChatPollRequest _self;
  final $Res Function(VoteChatPollRequest) _then;

/// Create a copy of VoteChatPollRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? optionIndexes = null,}) {
  return _then(VoteChatPollRequest(
optionIndexes: null == optionIndexes ? _self.optionIndexes : optionIndexes // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [VoteChatPollRequest].
extension VoteChatPollRequestPatterns on VoteChatPollRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoteChatPollRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoteChatPollRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoteChatPollRequest value)  $default,){
final _that = this;
switch (_that) {
case _VoteChatPollRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoteChatPollRequest value)?  $default,){
final _that = this;
switch (_that) {
case _VoteChatPollRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_indexes')  List<int> optionIndexes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoteChatPollRequest() when $default != null:
return $default(_that.optionIndexes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'option_indexes')  List<int> optionIndexes)  $default,) {final _that = this;
switch (_that) {
case _VoteChatPollRequest():
return $default(_that.optionIndexes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'option_indexes')  List<int> optionIndexes)?  $default,) {final _that = this;
switch (_that) {
case _VoteChatPollRequest() when $default != null:
return $default(_that.optionIndexes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoteChatPollRequest implements VoteChatPollRequest {
  const _VoteChatPollRequest({@JsonKey(name: 'option_indexes') required  List<int> optionIndexes}): _optionIndexes = optionIndexes;
  factory _VoteChatPollRequest.fromJson(Map<String, dynamic> json) => _$VoteChatPollRequestFromJson(json);

 final  List<int> _optionIndexes;
@override@JsonKey(name: 'option_indexes') List<int> get optionIndexes {
  if (_optionIndexes is EqualUnmodifiableListView) return _optionIndexes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_optionIndexes);
}


/// Create a copy of VoteChatPollRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoteChatPollRequestCopyWith<_VoteChatPollRequest> get copyWith => __$VoteChatPollRequestCopyWithImpl<_VoteChatPollRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoteChatPollRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoteChatPollRequest&&const DeepCollectionEquality().equals(other.optionIndexes, _optionIndexes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_optionIndexes));
}

@override
String toString() {
    return 'VoteChatPollRequest(optionIndexes: $optionIndexes)';
}


}

/// @nodoc
abstract mixin class _$VoteChatPollRequestCopyWith<$Res> implements $VoteChatPollRequestCopyWith<$Res> {
  factory _$VoteChatPollRequestCopyWith(_VoteChatPollRequest value, $Res Function(_VoteChatPollRequest) _then) = __$VoteChatPollRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'option_indexes') List<int> optionIndexes
});




}
/// @nodoc
class __$VoteChatPollRequestCopyWithImpl<$Res>
    implements _$VoteChatPollRequestCopyWith<$Res> {
  __$VoteChatPollRequestCopyWithImpl(this._self, this._then);

  final _VoteChatPollRequest _self;
  final $Res Function(_VoteChatPollRequest) _then;

/// Create a copy of VoteChatPollRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? optionIndexes = null,}) {
  return _then(_VoteChatPollRequest(
optionIndexes: null == optionIndexes ? _self._optionIndexes : optionIndexes // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
