// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sent_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SentMessage {

@JsonKey(name: 'message_id') String get messageId;@JsonKey(name: 'program_id') String get programId;@JsonKey(name: 'receiver_account_id') String get receiverAccountId; String get subject;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of SentMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SentMessageCopyWith<SentMessage> get copyWith => _$SentMessageCopyWithImpl<SentMessage>(this as SentMessage, _$identity);

  /// Serializes this SentMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SentMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SentMessage&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.programId, _this.programId) || other.programId == _this.programId)&&(identical(other.receiverAccountId, _this.receiverAccountId) || other.receiverAccountId == _this.receiverAccountId)&&(identical(other.subject, _this.subject) || other.subject == _this.subject)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SentMessage;
  return Object.hash(runtimeType,_this.messageId,_this.programId,_this.receiverAccountId,_this.subject,_this.createdAt);
}

@override
String toString() {
  final _this = this as SentMessage;
  return 'SentMessage(messageId: ${_this.messageId}, programId: ${_this.programId}, receiverAccountId: ${_this.receiverAccountId}, subject: ${_this.subject}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SentMessageCopyWith<$Res>  {
  factory $SentMessageCopyWith(SentMessage value, $Res Function(SentMessage) _then) = _$SentMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'receiver_account_id') String receiverAccountId, String subject,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$SentMessageCopyWithImpl<$Res>
    implements $SentMessageCopyWith<$Res> {
  _$SentMessageCopyWithImpl(this._self, this._then);

  final SentMessage _self;
  final $Res Function(SentMessage) _then;

/// Create a copy of SentMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? programId = null,Object? receiverAccountId = null,Object? subject = null,Object? createdAt = null,}) {
  return _then(SentMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,receiverAccountId: null == receiverAccountId ? _self.receiverAccountId : receiverAccountId // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SentMessage].
extension SentMessagePatterns on SentMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SentMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SentMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SentMessage value)  $default,){
final _that = this;
switch (_that) {
case _SentMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SentMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SentMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'receiver_account_id')  String receiverAccountId,  String subject, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SentMessage() when $default != null:
return $default(_that.messageId,_that.programId,_that.receiverAccountId,_that.subject,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'receiver_account_id')  String receiverAccountId,  String subject, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SentMessage():
return $default(_that.messageId,_that.programId,_that.receiverAccountId,_that.subject,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'program_id')  String programId, @JsonKey(name: 'receiver_account_id')  String receiverAccountId,  String subject, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SentMessage() when $default != null:
return $default(_that.messageId,_that.programId,_that.receiverAccountId,_that.subject,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SentMessage implements SentMessage {
  const _SentMessage({@JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'program_id') required this.programId, @JsonKey(name: 'receiver_account_id') required this.receiverAccountId, required this.subject, @JsonKey(name: 'created_at') required this.createdAt});
  factory _SentMessage.fromJson(Map<String, dynamic> json) => _$SentMessageFromJson(json);

@override@JsonKey(name: 'message_id') final  String messageId;
@override@JsonKey(name: 'program_id') final  String programId;
@override@JsonKey(name: 'receiver_account_id') final  String receiverAccountId;
@override final  String subject;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of SentMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentMessageCopyWith<_SentMessage> get copyWith => __$SentMessageCopyWithImpl<_SentMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SentMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentMessage&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.programId, programId) || other.programId == programId)&&(identical(other.receiverAccountId, receiverAccountId) || other.receiverAccountId == receiverAccountId)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,programId,receiverAccountId,subject,createdAt);
}

@override
String toString() {
    return 'SentMessage(messageId: $messageId, programId: $programId, receiverAccountId: $receiverAccountId, subject: $subject, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SentMessageCopyWith<$Res> implements $SentMessageCopyWith<$Res> {
  factory _$SentMessageCopyWith(_SentMessage value, $Res Function(_SentMessage) _then) = __$SentMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'program_id') String programId,@JsonKey(name: 'receiver_account_id') String receiverAccountId, String subject,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$SentMessageCopyWithImpl<$Res>
    implements _$SentMessageCopyWith<$Res> {
  __$SentMessageCopyWithImpl(this._self, this._then);

  final _SentMessage _self;
  final $Res Function(_SentMessage) _then;

/// Create a copy of SentMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? programId = null,Object? receiverAccountId = null,Object? subject = null,Object? createdAt = null,}) {
  return _then(_SentMessage(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,programId: null == programId ? _self.programId : programId // ignore: cast_nullable_to_non_nullable
as String,receiverAccountId: null == receiverAccountId ? _self.receiverAccountId : receiverAccountId // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
