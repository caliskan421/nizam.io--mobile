// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageQuote {

@JsonKey(name: 'message_id') String get messageId;@JsonKey(name: 'sender_account_id') String? get senderAccountId;@JsonKey(name: 'sender_name') String? get senderName; String? get body;/// `true` ise alıntılanan mesaj silinmiştir; diğer alanlar `null`.
 bool get deleted;
/// Create a copy of ChatMessageQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageQuoteCopyWith<ChatMessageQuote> get copyWith => _$ChatMessageQuoteCopyWithImpl<ChatMessageQuote>(this as ChatMessageQuote, _$identity);

  /// Serializes this ChatMessageQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessageQuote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageQuote&&(identical(other.messageId, _this.messageId) || other.messageId == _this.messageId)&&(identical(other.senderAccountId, _this.senderAccountId) || other.senderAccountId == _this.senderAccountId)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.deleted, _this.deleted) || other.deleted == _this.deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessageQuote;
  return Object.hash(runtimeType,_this.messageId,_this.senderAccountId,_this.senderName,_this.body,_this.deleted);
}

@override
String toString() {
  final _this = this as ChatMessageQuote;
  return 'ChatMessageQuote(messageId: ${_this.messageId}, senderAccountId: ${_this.senderAccountId}, senderName: ${_this.senderName}, body: ${_this.body}, deleted: ${_this.deleted})';
}


}

/// @nodoc
abstract mixin class $ChatMessageQuoteCopyWith<$Res>  {
  factory $ChatMessageQuoteCopyWith(ChatMessageQuote value, $Res Function(ChatMessageQuote) _then) = _$ChatMessageQuoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'sender_account_id') String? senderAccountId,@JsonKey(name: 'sender_name') String? senderName, String? body, bool deleted
});




}
/// @nodoc
class _$ChatMessageQuoteCopyWithImpl<$Res>
    implements $ChatMessageQuoteCopyWith<$Res> {
  _$ChatMessageQuoteCopyWithImpl(this._self, this._then);

  final ChatMessageQuote _self;
  final $Res Function(ChatMessageQuote) _then;

/// Create a copy of ChatMessageQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageId = null,Object? senderAccountId = freezed,Object? senderName = freezed,Object? body = freezed,Object? deleted = null,}) {
  return _then(ChatMessageQuote(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: freezed == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageQuote].
extension ChatMessageQuotePatterns on ChatMessageQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageQuote value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageQuote value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'sender_account_id')  String? senderAccountId, @JsonKey(name: 'sender_name')  String? senderName,  String? body,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageQuote() when $default != null:
return $default(_that.messageId,_that.senderAccountId,_that.senderName,_that.body,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'sender_account_id')  String? senderAccountId, @JsonKey(name: 'sender_name')  String? senderName,  String? body,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageQuote():
return $default(_that.messageId,_that.senderAccountId,_that.senderName,_that.body,_that.deleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message_id')  String messageId, @JsonKey(name: 'sender_account_id')  String? senderAccountId, @JsonKey(name: 'sender_name')  String? senderName,  String? body,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageQuote() when $default != null:
return $default(_that.messageId,_that.senderAccountId,_that.senderName,_that.body,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageQuote implements ChatMessageQuote {
  const _ChatMessageQuote({@JsonKey(name: 'message_id') required this.messageId, @JsonKey(name: 'sender_account_id') required this.senderAccountId, @JsonKey(name: 'sender_name') required this.senderName, required this.body, required this.deleted});
  factory _ChatMessageQuote.fromJson(Map<String, dynamic> json) => _$ChatMessageQuoteFromJson(json);

@override@JsonKey(name: 'message_id') final  String messageId;
@override@JsonKey(name: 'sender_account_id') final  String? senderAccountId;
@override@JsonKey(name: 'sender_name') final  String? senderName;
@override final  String? body;
/// `true` ise alıntılanan mesaj silinmiştir; diğer alanlar `null`.
@override final  bool deleted;

/// Create a copy of ChatMessageQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageQuoteCopyWith<_ChatMessageQuote> get copyWith => __$ChatMessageQuoteCopyWithImpl<_ChatMessageQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageQuote&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.body, body) || other.body == body)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,messageId,senderAccountId,senderName,body,deleted);
}

@override
String toString() {
    return 'ChatMessageQuote(messageId: $messageId, senderAccountId: $senderAccountId, senderName: $senderName, body: $body, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageQuoteCopyWith<$Res> implements $ChatMessageQuoteCopyWith<$Res> {
  factory _$ChatMessageQuoteCopyWith(_ChatMessageQuote value, $Res Function(_ChatMessageQuote) _then) = __$ChatMessageQuoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message_id') String messageId,@JsonKey(name: 'sender_account_id') String? senderAccountId,@JsonKey(name: 'sender_name') String? senderName, String? body, bool deleted
});




}
/// @nodoc
class __$ChatMessageQuoteCopyWithImpl<$Res>
    implements _$ChatMessageQuoteCopyWith<$Res> {
  __$ChatMessageQuoteCopyWithImpl(this._self, this._then);

  final _ChatMessageQuote _self;
  final $Res Function(_ChatMessageQuote) _then;

/// Create a copy of ChatMessageQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageId = null,Object? senderAccountId = freezed,Object? senderName = freezed,Object? body = freezed,Object? deleted = null,}) {
  return _then(_ChatMessageQuote(
messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: freezed == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
