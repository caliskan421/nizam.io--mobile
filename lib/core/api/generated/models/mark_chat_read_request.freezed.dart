// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_chat_read_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkChatReadRequest {

@JsonKey(name: 'message_id') String get messageId;
/// Create a copy of MarkChatReadRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarkChatReadRequestCopyWith<MarkChatReadRequest> get copyWith => _$MarkChatReadRequestCopyWithImpl<MarkChatReadRequest>(this as MarkChatReadRequest, _$identity);

  /// Serializes this MarkChatReadRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarkChatReadRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarkChatReadRequest&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarkChatReadRequest;
  return Object.hash(runtimeType,_this.messageId);
}

@override
String toString() {
  final _this = this as MarkChatReadRequest;
  return 'MarkChatReadRequest(messageId: ${_this.messageId})';
}


}

/// @nodoc
abstract mixin class $MarkChatReadRequestCopyWith<$Res>  {
  factory $MarkChatReadRequestCopyWith(MarkChatReadRequest value, $Res Function(MarkChatReadRequest) _then) = _$MarkChatReadRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') String messageId
});




}
/// @nodoc
class _$MarkChatReadRequestCopyWithImpl<$Res>
    implements $MarkChatReadRequestCopyWith<$Res> {
  _$MarkChatReadRequestCopyWithImpl(this._self, this._then);

  final MarkChatReadRequest _self;
  final $Res Function(MarkChatReadRequest) _then;

/// Create a copy of MarkChatReadRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,}) {
  return _then(MarkChatReadRequest(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MarkChatReadRequest].
extension MarkChatReadRequestPatterns on MarkChatReadRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarkChatReadRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarkChatReadRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarkChatReadRequest value)  $default,){
final _that = this;
switch (_that) {
case _MarkChatReadRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarkChatReadRequest value)?  $default,){
final _that = this;
switch (_that) {
case _MarkChatReadRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarkChatReadRequest() when $default != null:
return $default(_that.messageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId)  $default,) {final _that = this;
switch (_that) {
case _MarkChatReadRequest():
return $default(_that.messageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  String messageId)?  $default,) {final _that = this;
switch (_that) {
case _MarkChatReadRequest() when $default != null:
return $default(_that.messageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarkChatReadRequest implements MarkChatReadRequest {
  const _MarkChatReadRequest({@JsonKey(name: 'message_id') required this.messageId});
  factory _MarkChatReadRequest.fromJson(Map<String, dynamic> json) => _$MarkChatReadRequestFromJson(json);

@override@JsonKey(name: 'message_id') final  String messageId;

/// Create a copy of MarkChatReadRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarkChatReadRequestCopyWith<_MarkChatReadRequest> get copyWith => __$MarkChatReadRequestCopyWithImpl<_MarkChatReadRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarkChatReadRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarkChatReadRequest&&(identical(other.messageId, messageId) || other.messageId == messageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId);
}

@override
String toString() {
    return 'MarkChatReadRequest(messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class _$MarkChatReadRequestCopyWith<$Res> implements $MarkChatReadRequestCopyWith<$Res> {
  factory _$MarkChatReadRequestCopyWith(_MarkChatReadRequest value, $Res Function(_MarkChatReadRequest) _then) = __$MarkChatReadRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') String messageId
});




}
/// @nodoc
class __$MarkChatReadRequestCopyWithImpl<$Res>
    implements _$MarkChatReadRequestCopyWith<$Res> {
  __$MarkChatReadRequestCopyWithImpl(this._self, this._then);

  final _MarkChatReadRequest _self;
  final $Res Function(_MarkChatReadRequest) _then;

/// Create a copy of MarkChatReadRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,}) {
  return _then(_MarkChatReadRequest(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
