// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Message {

@JsonKey(name: 'message_id') String get messageId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'sender_account_id') String get senderAccountId;@JsonKey(name: 'sender_name') String get senderName;@JsonKey(name: 'receiver_account_id') String get receiverAccountId;@JsonKey(name: 'receiver_name') String get receiverName; String get subject; String get content;@JsonKey(name: 'is_read') bool get isRead;@JsonKey(name: 'read_at') DateTime? get readAt;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Message;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.senderAccountId, _this.senderAccountId) || other.senderAccountId == _this.senderAccountId)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.receiverAccountId, _this.receiverAccountId) || other.receiverAccountId == _this.receiverAccountId)&&(identical(other.receiverName, _this.receiverName) || other.receiverName == _this.receiverName)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.isRead, _this.isRead) || other.isRead == _this.isRead)&&(identical(other.readAt, _this.readAt) || other.readAt == _this.readAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Message;
  return Object.hash(runtimeType,_this.messageId,_this.programId,_this.senderAccountId,_this.senderName,_this.receiverAccountId,_this.receiverName,_this.subject,_this.content,_this.isRead,_this.readAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as Message;
  return 'Message(messageId: ${_this.messageId}, programId: ${_this.programId}, senderAccountId: ${_this.senderAccountId}, senderName: ${_this.senderName}, receiverAccountId: ${_this.receiverAccountId}, receiverName: ${_this.receiverName}, subject: ${_this.subject}, content: ${_this.content}, isRead: ${_this.isRead}, readAt: ${_this.readAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'sender_name') String senderName,@JsonKey(name: 'receiver_account_id') String receiverAccountId,@JsonKey(name: 'receiver_name') String receiverName, String subject, String content,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'read_at') DateTime? readAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? programId = null,Object? senderAccountId = null,Object? senderName = null,Object? receiverAccountId = null,Object? receiverName = null,Object? subject = null,Object? content = null,Object? isRead = null,Object? readAt = freezed,Object? createdAt = null,}) {
  return _then(Message(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,receiverAccountId: null == receiverAccountId ? _self.receiverAccountId : receiverAccountId // ignore: cast_nullable_to_non_nullable
as String,receiverName: null == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'sender_name')  String senderName, @JsonKey(name: 'receiver_account_id')  String receiverAccountId, @JsonKey(name: 'receiver_name')  String receiverName,  String subject,  String content, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'read_at')  DateTime? readAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.messageId,_that.programId,_that.senderAccountId,_that.senderName,_that.receiverAccountId,_that.receiverName,_that.subject,_that.content,_that.isRead,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'sender_name')  String senderName, @JsonKey(name: 'receiver_account_id')  String receiverAccountId, @JsonKey(name: 'receiver_name')  String receiverName,  String subject,  String content, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'read_at')  DateTime? readAt, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.messageId,_that.programId,_that.senderAccountId,_that.senderName,_that.receiverAccountId,_that.receiverName,_that.subject,_that.content,_that.isRead,_that.readAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'sender_account_id')  String senderAccountId, @JsonKey(name: 'sender_name')  String senderName, @JsonKey(name: 'receiver_account_id')  String receiverAccountId, @JsonKey(name: 'receiver_name')  String receiverName,  String subject,  String content, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'read_at')  DateTime? readAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.messageId,_that.programId,_that.senderAccountId,_that.senderName,_that.receiverAccountId,_that.receiverName,_that.subject,_that.content,_that.isRead,_that.readAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({@JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'sender_account_id') required this.senderAccountId, @JsonKey(name: 'sender_name') required this.senderName, @JsonKey(name: 'receiver_account_id') required this.receiverAccountId, @JsonKey(name: 'receiver_name') required this.receiverName, required this.subject, required this.content, @JsonKey(name: 'is_read') required this.isRead, @JsonKey(name: 'read_at') required this.readAt, @JsonKey(name: 'created_at') required this.createdAt});
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override@JsonKey(name: 'message_id') final  String messageId;
@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'sender_account_id') final  String senderAccountId;
@override@JsonKey(name: 'sender_name') final  String senderName;
@override@JsonKey(name: 'receiver_account_id') final  String receiverAccountId;
@override@JsonKey(name: 'receiver_name') final  String receiverName;
@override final  String subject;
@override final  String content;
@override@JsonKey(name: 'is_read') final  bool isRead;
@override@JsonKey(name: 'read_at') final  DateTime? readAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.receiverAccountId, receiverAccountId) || other.receiverAccountId == receiverAccountId)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.content, content) || other.content == content)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,programId,senderAccountId,senderName,receiverAccountId,receiverName,subject,content,isRead,readAt,createdAt);
}

@override
String toString() {
    return 'Message(messageId: $messageId, programId: $programId, senderAccountId: $senderAccountId, senderName: $senderName, receiverAccountId: $receiverAccountId, receiverName: $receiverName, subject: $subject, content: $content, isRead: $isRead, readAt: $readAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'sender_account_id') String senderAccountId,@JsonKey(name: 'sender_name') String senderName,@JsonKey(name: 'receiver_account_id') String receiverAccountId,@JsonKey(name: 'receiver_name') String receiverName, String subject, String content,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'read_at') DateTime? readAt,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? programId = null,Object? senderAccountId = null,Object? senderName = null,Object? receiverAccountId = null,Object? receiverName = null,Object? subject = null,Object? content = null,Object? isRead = null,Object? readAt = freezed,Object? createdAt = null,}) {
  return _then(_Message(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,receiverAccountId: null == receiverAccountId ? _self.receiverAccountId : receiverAccountId // ignore: cast_nullable_to_non_nullable
as String,receiverName: null == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
