// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_shared_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatSharedRef {

@JsonKey(name: 'ref_id') String get refId; ChatSharedRefKind get kind;@JsonKey(name: 'target_id') String get targetId;@JsonKey(name: 'message_id') String get messageId;@JsonKey(name: 'sender_account_id') String get senderAccountId;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ChatSharedRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSharedRefCopyWith<ChatSharedRef> get copyWith => _$ChatSharedRefCopyWithImpl<ChatSharedRef>(this as ChatSharedRef, _$identity);

  /// Serializes this ChatSharedRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatSharedRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSharedRef&&(identical(other.refId, _this.refId) || other.refId == _this.refId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId)&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.senderAccountId, _this.senderAccountId) || other.senderAccountId == _this.senderAccountId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatSharedRef;
  return Object.hash(runtimeType,_this.refId,_this.kind,_this.targetId,_this.messageId,_this.senderAccountId,_this.createdAt);
}

@override
String toString() {
  final _this = this as ChatSharedRef;
  return 'ChatSharedRef(refId: ${_this.refId}, kind: ${_this.kind}, targetId: ${_this.targetId}, messageId: ${_this.messageId}, senderAccountId: ${_this.senderAccountId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ChatSharedRefCopyWith<$Res>  {
  factory $ChatSharedRefCopyWith(ChatSharedRef value, $Res Function(ChatSharedRef) _then) = _$ChatSharedRefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ref_id') String refId, ChatSharedRefKind kind,@JsonKey(name: 'target_id') String targetId,@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$ChatSharedRefCopyWithImpl<$Res>
    implements $ChatSharedRefCopyWith<$Res> {
  _$ChatSharedRefCopyWithImpl(this._self, this._then);

  final ChatSharedRef _self;
  final $Res Function(ChatSharedRef) _then;

/// Create a copy of ChatSharedRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refId = null,Object? kind = null,Object? targetId = null,Object? messageId = null,Object? senderAccountId = null,Object? createdAt = null,}) {
  return _then(ChatSharedRef(
refId: null == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatSharedRefKind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSharedRef].
extension ChatSharedRefPatterns on ChatSharedRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSharedRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSharedRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSharedRef value)  $default,){
final _that = this;
switch (_that) {
case _ChatSharedRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSharedRef value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSharedRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ref_id')  String refId,  ChatSharedRefKind kind, @JsonKey(name: 'target_id')  String targetId, @JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSharedRef() when $default != null:
return $default(_that.refId,_that.kind,_that.targetId,_that.messageId,_that.senderAccountId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ref_id')  String refId,  ChatSharedRefKind kind, @JsonKey(name: 'target_id')  String targetId, @JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatSharedRef():
return $default(_that.refId,_that.kind,_that.targetId,_that.messageId,_that.senderAccountId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ref_id')  String refId,  ChatSharedRefKind kind, @JsonKey(name: 'target_id')  String targetId, @JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatSharedRef() when $default != null:
return $default(_that.refId,_that.kind,_that.targetId,_that.messageId,_that.senderAccountId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSharedRef implements ChatSharedRef {
  const _ChatSharedRef({@JsonKey(name: 'ref_id') required this.refId, required this.kind, @JsonKey(name: 'target_id') required this.targetId, @JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'sender_account_id') required this.senderAccountId, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ChatSharedRef.fromJson(Map<String, dynamic> json) => _$ChatSharedRefFromJson(json);

@override@JsonKey(name: 'ref_id') final  String refId;
@override final  ChatSharedRefKind kind;
@override@JsonKey(name: 'target_id') final  String targetId;
@override@JsonKey(name: 'message_id') final  String messageId;
@override@JsonKey(name: 'sender_account_id') final  String senderAccountId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ChatSharedRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSharedRefCopyWith<_ChatSharedRef> get copyWith => __$ChatSharedRefCopyWithImpl<_ChatSharedRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSharedRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSharedRef&&(identical(other.refId, refId) || other.refId == refId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,refId,kind,targetId,messageId,senderAccountId,createdAt);
}

@override
String toString() {
    return 'ChatSharedRef(refId: $refId, kind: $kind, targetId: $targetId, messageId: $messageId, senderAccountId: $senderAccountId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatSharedRefCopyWith<$Res> implements $ChatSharedRefCopyWith<$Res> {
  factory _$ChatSharedRefCopyWith(_ChatSharedRef value, $Res Function(_ChatSharedRef) _then) = __$ChatSharedRefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ref_id') String refId, ChatSharedRefKind kind,@JsonKey(name: 'target_id') String targetId,@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$ChatSharedRefCopyWithImpl<$Res>
    implements _$ChatSharedRefCopyWith<$Res> {
  __$ChatSharedRefCopyWithImpl(this._self, this._then);

  final _ChatSharedRef _self;
  final $Res Function(_ChatSharedRef) _then;

/// Create a copy of ChatSharedRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refId = null,Object? kind = null,Object? targetId = null,Object? messageId = null,Object? senderAccountId = null,Object? createdAt = null,}) {
  return _then(_ChatSharedRef(
refId: null == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ChatSharedRefKind,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
