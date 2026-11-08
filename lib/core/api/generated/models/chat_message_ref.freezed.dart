// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageRef {

@JsonKey(name: 'ref_id') String get refId; ChatMessageRefKind get kind;@JsonKey(name: 'target_id') String get targetId;
/// Create a copy of ChatMessageRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageRefCopyWith<ChatMessageRef> get copyWith => _$ChatMessageRefCopyWithImpl<ChatMessageRef>(this as ChatMessageRef, _$identity);

  /// Serializes this ChatMessageRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessageRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageRef&&(identical(other.refId, _this.refId) || other.refId == _this.refId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessageRef;
  return Object.hash(runtimeType,_this.refId,_this.kind,_this.targetId);
}

@override
String toString() {
  final _this = this as ChatMessageRef;
  return 'ChatMessageRef(refId: ${_this.refId}, kind: ${_this.kind}, targetId: ${_this.targetId})';
}


}

/// @nodoc
abstract mixin class $ChatMessageRefCopyWith<$Res>  {
  factory $ChatMessageRefCopyWith(ChatMessageRef value, $Res Function(ChatMessageRef) _then) = _$ChatMessageRefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ref_id') String refId, ChatMessageRefKind kind,@JsonKey(name: 'target_id') String targetId
});




}
/// @nodoc
class _$ChatMessageRefCopyWithImpl<$Res>
    implements $ChatMessageRefCopyWith<$Res> {
  _$ChatMessageRefCopyWithImpl(this._self, this._then);

  final ChatMessageRef _self;
  final $Res Function(ChatMessageRef) _then;

/// Create a copy of ChatMessageRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refId = null,Object? kind = null,Object? targetId = null,}) {
  return _then(ChatMessageRef(
refId: null == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatMessageRefKind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageRef].
extension ChatMessageRefPatterns on ChatMessageRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageRef value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageRef value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ref_id')  String refId,  ChatMessageRefKind kind, @JsonKey(name: 'target_id')  String targetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageRef() when $default != null:
return $default(_that.refId,_that.kind,_that.targetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ref_id')  String refId,  ChatMessageRefKind kind, @JsonKey(name: 'target_id')  String targetId)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageRef():
return $default(_that.refId,_that.kind,_that.targetId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ref_id')  String refId,  ChatMessageRefKind kind, @JsonKey(name: 'target_id')  String targetId)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageRef() when $default != null:
return $default(_that.refId,_that.kind,_that.targetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageRef implements ChatMessageRef {
  const _ChatMessageRef({@JsonKey(name: 'ref_id') required this.refId, required this.kind, @JsonKey(name: 'target_id') required this.targetId});
  factory _ChatMessageRef.fromJson(Map<String, dynamic> json) => _$ChatMessageRefFromJson(json);

@override@JsonKey(name: 'ref_id') final  String refId;
@override final  ChatMessageRefKind kind;
@override@JsonKey(name: 'target_id') final  String targetId;

/// Create a copy of ChatMessageRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageRefCopyWith<_ChatMessageRef> get copyWith => __$ChatMessageRefCopyWithImpl<_ChatMessageRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageRef&&(identical(other.refId, refId) || other.refId == refId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetId, targetId) || other.targetId == targetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,refId,kind,targetId);
}

@override
String toString() {
    return 'ChatMessageRef(refId: $refId, kind: $kind, targetId: $targetId)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageRefCopyWith<$Res> implements $ChatMessageRefCopyWith<$Res> {
  factory _$ChatMessageRefCopyWith(_ChatMessageRef value, $Res Function(_ChatMessageRef) _then) = __$ChatMessageRefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ref_id') String refId, ChatMessageRefKind kind,@JsonKey(name: 'target_id') String targetId
});




}
/// @nodoc
class __$ChatMessageRefCopyWithImpl<$Res>
    implements _$ChatMessageRefCopyWith<$Res> {
  __$ChatMessageRefCopyWithImpl(this._self, this._then);

  final _ChatMessageRef _self;
  final $Res Function(_ChatMessageRef) _then;

/// Create a copy of ChatMessageRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refId = null,Object? kind = null,Object? targetId = null,}) {
  return _then(_ChatMessageRef(
refId: null == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatMessageRefKind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
