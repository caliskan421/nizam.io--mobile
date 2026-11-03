// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_last_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatLastMessage {

@JsonKey(name: 'message_id') String get messageId; int get seq;@JsonKey(name: 'sender_account_id') String get senderAccountId;@JsonKey(name: 'sender_name') String get senderName;/// Silinmiş mesajda `null`.
 String? get body; bool get deleted;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of ChatLastMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatLastMessageCopyWith<ChatLastMessage> get copyWith => _$ChatLastMessageCopyWithImpl<ChatLastMessage>(this as ChatLastMessage, _$identity);

  /// Serializes this ChatLastMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatLastMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLastMessage&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.senderAccountId, _this.senderAccountId) || other.senderAccountId == _this.senderAccountId)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatLastMessage;
  return Object.hash(runtimeType,_this.messageId,_this.seq,_this.senderAccountId,_this.senderName,_this.body,_this.deleted,_this.createdAt);
}

@override
String toString() {
  final _this = this as ChatLastMessage;
  return 'ChatLastMessage(messageId: ${_this.messageId}, seq: ${_this.seq}, senderAccountId: ${_this.senderAccountId}, senderName: ${_this.senderName}, body: ${_this.body}, deleted: ${_this.deleted}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ChatLastMessageCopyWith<$Res>  {
  factory $ChatLastMessageCopyWith(ChatLastMessage value, $Res Function(ChatLastMessage) _then) = _$ChatLastMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') String messageId, int seq,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'sender_name') String senderName, String? body, bool deleted,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$ChatLastMessageCopyWithImpl<$Res>
    implements $ChatLastMessageCopyWith<$Res> {
  _$ChatLastMessageCopyWithImpl(this._self, this._then);

  final ChatLastMessage _self;
  final $Res Function(ChatLastMessage) _then;

/// Create a copy of ChatLastMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? seq = null,Object? senderAccountId = null,Object? senderName = null,Object? body = freezed,Object? deleted = null,Object? createdAt = null,}) {
  return _then(ChatLastMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatLastMessage].
extension ChatLastMessagePatterns on ChatLastMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatLastMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatLastMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatLastMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatLastMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatLastMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatLastMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId,  int seq, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'sender_name')  String senderName,  String? body,  bool deleted, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatLastMessage() when $default != null:
return $default(_that.messageId,_that.seq,_that.senderAccountId,_that.senderName,_that.body,_that.deleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId,  int seq, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'sender_name')  String senderName,  String? body,  bool deleted, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatLastMessage():
return $default(_that.messageId,_that.seq,_that.senderAccountId,_that.senderName,_that.body,_that.deleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  String messageId,  int seq, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'sender_name')  String senderName,  String? body,  bool deleted, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatLastMessage() when $default != null:
return $default(_that.messageId,_that.seq,_that.senderAccountId,_that.senderName,_that.body,_that.deleted,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatLastMessage implements ChatLastMessage {
  const _ChatLastMessage({@JsonKey(name: 'message_id') required this.messageId, required this.seq, @JsonKey(name: 'sender_account_id') required this.senderAccountId, @JsonKey(name: 'sender_name') required this.senderName, required this.body, required this.deleted, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ChatLastMessage.fromJson(Map<String, dynamic> json) => _$ChatLastMessageFromJson(json);

@override@JsonKey(name: 'message_id') final  String messageId;
@override final  int seq;
@override@JsonKey(name: 'sender_account_id') final  String senderAccountId;
@override@JsonKey(name: 'sender_name') final  String senderName;
/// Silinmiş mesajda `null`.
@override final  String? body;
@override final  bool deleted;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of ChatLastMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatLastMessageCopyWith<_ChatLastMessage> get copyWith => __$ChatLastMessageCopyWithImpl<_ChatLastMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatLastMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatLastMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.body, body) || other.body == body)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,seq,senderAccountId,senderName,body,deleted,createdAt);
}

@override
String toString() {
    return 'ChatLastMessage(messageId: $messageId, seq: $seq, senderAccountId: $senderAccountId, senderName: $senderName, body: $body, deleted: $deleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatLastMessageCopyWith<$Res> implements $ChatLastMessageCopyWith<$Res> {
  factory _$ChatLastMessageCopyWith(_ChatLastMessage value, $Res Function(_ChatLastMessage) _then) = __$ChatLastMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') String messageId, int seq,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'sender_name') String senderName, String? body, bool deleted,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$ChatLastMessageCopyWithImpl<$Res>
    implements _$ChatLastMessageCopyWith<$Res> {
  __$ChatLastMessageCopyWithImpl(this._self, this._then);

  final _ChatLastMessage _self;
  final $Res Function(_ChatLastMessage) _then;

/// Create a copy of ChatLastMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? seq = null,Object? senderAccountId = null,Object? senderName = null,Object? body = freezed,Object? deleted = null,Object? createdAt = null,}) {
  return _then(_ChatLastMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
